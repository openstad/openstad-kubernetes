
const DOMAIN = process.env.APP_HOST;
const PORT = process.env.APP_PORT;
// url port stuff is made up, do not know if this is how is should be...
const protocol = PORT === "443" ? "https://" : "http://";
const urlPort = PORT !== "80" && PORT !== "443" ? ":" + PORT : "";
const URL = protocol + DOMAIN + urlPort;

const DB_USER = process.env.DB_USER;
const DB_PASSWORD = process.env.DB_PWD;
const DB_NAME = process.env.DB_DATABASE;
const DB_HOST = process.env.DB_HOST;
const EXPRESS_PORT = process.env.APP_PORT;
const DB_DIALECT = process.env.DB_TYPE;
const EMAIL_ADDRESS = process.env.MAIL_FROM;
const SMTP_PORT = process.env.MAIL_PORT;
const SMTP_HOST = process.env.MAIL_HOST;
const SMTP_USERNAME = process.env.MAIL_USER;
const SMTP_PASSWORD = process.env.MAIL_PWD;

const COOKIE_SECRET = process.env.COOKIE_SECRET;
const MIJNOPENSTAD_JWT_SECRET = process.env.JWT_SECRET;

const AUTH_HOST = process.env.AUTH_HOST;
const AUTH_PORT = process.env.AUTH_PORT;

// url port stuff is made up, do not know if this is how is should be...
const authProtocol = AUTH_PORT === "443" ? "https://" : "http://";
const authUrlPort = AUTH_PORT !== "80" && AUTH_PORT !== "443" ? ":" + AUTH_PORT : "";
const MIJNOPENSTAD_URL = authProtocol + AUTH_HOST + authUrlPort;
const MIJNOPENSTAD_DEFAULT_CLIENT_ID = process.env.AUTH_CLIENT_ID;
const MIJNOPENSTAD_CLIENT_PASSWORD = process.env.AUTH_CLIENT_SECRET;
const AUTH_FIXED_TOKEN = process.env.AUTH_FIXED_TOKEN;
const AUTH_FIXED_USER_ID =  process.env.AUTH_FIXED_USER_ID;

console.log('environment: ', JSON.stringify(process.env));
const configObj = {

    "url": URL,
    "hostname": DOMAIN,

    "database": {
        "user": DB_USER,
        "password": DB_PASSWORD,
        "database": DB_NAME,
        "host": DB_HOST,
        "dialect": DB_DIALECT,
        "multipleStatements": true
    },

    "express": {
        "port": EXPRESS_PORT
    },

    "mail": {
        "from": EMAIL_ADDRESS,
        "transport": {
            "smtp": {
                "port": SMTP_PORT,
                "host": SMTP_HOST,
                "auth": {
                    "user": SMTP_USERNAME,
                    "pass": SMTP_PASSWORD
                }
            }
        }
    },

    "security": {
        "sessions": {
            "secret": COOKIE_SECRET,
            "onlySecure": true
        }
    },

    "authorization": {
        "jwt-secret": MIJNOPENSTAD_JWT_SECRET,
        "auth-server-url": MIJNOPENSTAD_URL,
        "auth-client-id": MIJNOPENSTAD_DEFAULT_CLIENT_ID,
        "auth-client-secret": MIJNOPENSTAD_CLIENT_PASSWORD,
        "auth-server-login-path": "/dialog/authorize?redirect_uri=[[redirectUrl]]&response_type=code&client_id=[[clientId]]&scope=offline",
        "auth-server-exchange-code-path": "/oauth/token",
        "auth-server-get-user-path": "/api/userinfo?client_id=[[clientId]]",
        "auth-server-logout-path": "/logout?clientId=[[clientId]]",
        "after-login-redirect-uri": "/?jwt=[[jwt]]",
        "fixed-auth-tokens": [
            {
                "token": AUTH_FIXED_TOKEN,
                "userId": AUTH_FIXED_USER_ID
            }
        ]
    }
}
// should not be logged, cause of secrets.....
console.log('configuration: ', JSON.stringify(configObj));
module.exports = configObj;
