# Google OAuth Setup Instructions

## Required Environment Variables

Add these environment variables to your `.env` file or environment configuration:

```bash
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here
```

## Google Cloud Console Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API (or Google People API)
4. Go to "Credentials" > "Create Credentials" > "OAuth 2.0 Client ID"
5. Choose "Web application" as the application type
6. Set authorized redirect URIs to:
   - Development: `http://localhost:3000/auth/google/callback`
   - Production: `https://yourdomain.com/auth/google/callback`
7. Copy the Client ID and Client Secret to your environment variables

## Development Setup

The `dotenv-rails` gem is already configured, so you can simply create a `.env` file in the project root:

**Create `.env` file in project root:**
```bash
# Create the .env file
touch .env
```

**Add your Google OAuth credentials to `.env`:**
```
GOOGLE_CLIENT_ID=123456789-abcdefghijklmnop.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-your_secret_here
```

**Note:** The `.env` file is automatically loaded by the `dotenv-rails` gem in development and test environments. Make sure `.env` is in your `.gitignore` file to keep credentials secure.

## Testing the Configuration

Once configured, you can test OAuth by visiting:
`http://localhost:3000/auth/google`
