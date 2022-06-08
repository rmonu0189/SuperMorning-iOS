import Foundation

extension URLRequest {
    mutating func prepareHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            addValue(value, forHTTPHeaderField: key)
        }
    }
}

extension URLRequest {
    mutating func prepareBody(_ requestBody: DPRequestBody, service: DPRequestProtocol) {
        switch requestBody.bodyEncodeType {
        case .json:
            prepareJSONBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        case .formData:
            prepareFormDataBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        case .formUrlEncoded:
            prepareFormURLEncodedBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        case .binary:
            httpBody = requestBody.data
        default:
            if httpMethod == "GET" {
                prepareGETBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
            } else {
                prepareJSONBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
            }
        }
    }

    private mutating func prepareGETBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        // Prepare query items
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            if let item = value as? String {
                queryItems.append(URLQueryItem(name: key, value: item))
            } else {
                queryItems.append(URLQueryItem(name: key, value: (value as AnyObject).description))
            }
        }
        // Assign query items
        var components = URLComponents(string: url?.absoluteString ?? "")
        components?.queryItems = queryItems
        url = components?.url
    }

    private mutating func prepareJSONBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            httpBody = data
            addValue("application/json", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
        } catch let parseError {
            DPLogger.log(parseError)
        }
    }

    private mutating func prepareFormDataBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        var data = [String]()
        for (key, value) in params {
            data.append(key + "=\(value)")
        }
        let formDataBody = data.map { String($0) }.joined(separator: "&")
        httpBody = formDataBody.data(using: .utf8)
    }

    private mutating func prepareFormURLEncodedBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""

        // Append parameters body
        for (key, value) in params {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(key)\""
            body += "\r\n\r\n\(value)\r\n"
        }

        // Append Files
        for (name, file) in requestBody.files ?? [:] {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(name)\""
            body += "; filename=\"\(name)\"\r\n"
            let fileData = String(data: file, encoding: .utf8) ?? ""
            body += "Content-Type: \"content-type header\"\r\n\r\n\(fileData)\r\n"
        }

        // Close boundary
        body += "--\(boundary)--\r\n"

        let postData = body.data(using: .utf8)
        httpBody = postData
        addValue(postData?.count.description ?? "", forHTTPHeaderField: "Content-Length")
        addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }

    private mutating func prepareTextBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        var data = [String]()
        for (key, value) in params {
            data.append(key + ":\(value)")
        }
    }
}

private extension DPRequestBody {
    func getBodyDictionary(_ dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) -> [String: Any] {
        if let body = model {
            return body.toJSONRequest(keyEncodingStrategy, dateEncodingStrategy: dateEncodingStrategy)
        } else if let body = bodyInKeyValuePair {
            return body
        }
        return [:]
    }
}

private extension Encodable {
    func toJSONRequest(_ keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy?, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) -> [String: Any] {
        do {
            let encoder = JSONEncoder()
            if let strategy = keyEncodingStrategy { encoder.keyEncodingStrategy = strategy }
            if let strategy = dateEncodingStrategy { encoder.dateEncodingStrategy = strategy }
            let jsonData = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
            return json as? [String: Any] ?? [:]
        } catch {
            DPLogger.log(error)
            return [:]
        }
    }
}
