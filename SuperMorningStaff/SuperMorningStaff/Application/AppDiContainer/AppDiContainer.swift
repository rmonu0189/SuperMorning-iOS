import CommonUI
import CommonDomain
import CommonData

let diContainer = AppDiContainer()

struct AppDiContainer {
    let viewControllerFactory = ViewControllerFactory()
    let useCaseExecutor: UseCaseExecutor = .init()

    var dataSourceFactory: DataSourcesFactory {
        .init(networkClient: .init(url: "https://us-central1-supermorning-dev-ff22a.cloudfunctions.net/api"))
    }

    var useCaseFactory: UseCaseFactory {
        .init(
            repositoryFactory: RepositoryFactory(dataSourceFactory: dataSourceFactory)
        )
    }
}
