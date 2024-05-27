import Foundation
import AWSCognitoIdentityProvider

final class AWSManager {
    private let userPoolID: String = "eu-central-1_OW0g61kEk"
    private let clientID: String = "34fbjieukpdaq7m6q35ge10ei"
    private let clientSecret: String? = nil
    
    private init(){}
    public static let shared = AWSManager()

    private var pool: AWSCognitoIdentityUserPool {
        let serviceConfiguration = AWSServiceConfiguration(
            region: .EUCentral1,
            credentialsProvider: nil
        )

        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(
            clientId: clientID,
            clientSecret: clientSecret,
            poolId: userPoolID
        )

        AWSCognitoIdentityUserPool.register(
            with: serviceConfiguration,
            userPoolConfiguration: poolConfiguration,
            forKey: "UserPool"
        )

        return AWSCognitoIdentityUserPool(forKey: "UserPool") ?? AWSCognitoIdentityUserPool.default()
    }

    func login(username: String, password: String, callback: @escaping (Result<AWSCognitoIdentityUserSession, Error>) -> Void) {
        let user = pool.getUser(username)
        user.getSession(username, password: password, validationData: nil).continueWith { task in
            if let error = task.error {
                callback(.failure(error))
            } else if let session = task.result {
                callback(.success(session))
            }
            return nil
        }
    }
}

