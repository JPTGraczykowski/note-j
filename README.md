# note-j

A modern note-taking application built with Rails 8, featuring hierarchical folder organization, tagging, todos, and rich markdown support with image attachments.

## Features

- **Rich Note Taking**: Write notes in markdown with live preview and image attachments
- **Hierarchical Folders**: Organize notes in nested folders with unlimited depth
- **Flexible Tagging**: Tag notes and todos for quick filtering and organization
- **Todo Management**: Create and track tasks with tag-based organization
- **Image Attachments**: Upload and embed images directly in your notes
- **Dual Authentication**: Sign in with Google OAuth or traditional password authentication
- **Multi-tenant Architecture**: Secure, user-scoped data isolation

## Development Workflow

This project is developed using **AI-driven development** methodology. Initially built with Cursor AI, it now uses Claude Code for continued development.

### AI-Assisted Feature Development

AI agents work with structured planning documents to implement features:

1. **PRD Creation**: AI generates Product Requirements Documents in `/tasks/prd-[feature].md`
2. **Task Generation**: AI breaks down features into actionable tasks in `/tasks/tasks-[feature].md`
3. **Implementation**: AI agents follow task lists for systematic, step-by-step development

All planning documents and task lists are stored in the `/tasks/` directory for transparency and tracking.

See `CLAUDE.md` for detailed development conventions and patterns that guide AI agents.

## Tech Stack

### Backend
- **Ruby**: 3.3.4
- **Rails**: 8.0.2
- **Database**: SQLite3
- **Authentication**: OmniAuth (Google OAuth) + bcrypt

### Frontend
- **Hotwire**: Turbo & Stimulus for reactive interfaces
- **TailwindCSS**: Utility-first CSS framework
- **Importmap**: JavaScript module management
- **Markdown**: Redcarpet for rendering

### Testing & Quality
- **RSpec**: Behavior-driven testing framework
- **FactoryBot**: Test data generation
- **RuboCop**: Ruby style guide enforcement
- **Brakeman**: Security vulnerability scanning

### Additional Tools
- **Active Storage**: File uploads with image processing
- **image_processing**: Image transformations and variants

## Prerequisites

- Ruby 3.3.4
- Rails 8.0.2
- SQLite3
- Node.js (for asset pipeline)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/JPTGraczykowski/note-j.git
cd note-j
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install
```

### 3. Database Setup

```bash
# Create database
bin/rails db:create

# Run migrations
bin/rails db:migrate
```

### 4. Configure Authentication (Optional)

For Google OAuth authentication, set up your OAuth credentials:

1. Create a Google Cloud project and OAuth 2.0 credentials
2. Create a `.env` file in the project root:
   ```bash
   cp .env.example .env
   ```
3. Add your Google OAuth credentials to `.env`:
   ```
   GOOGLE_CLIENT_ID=your_client_id_here
   GOOGLE_CLIENT_SECRET=your_client_secret_here
   ```

## Running the Application

### Development Server

Start the development server with TailwindCSS watch mode:

```bash
bin/dev
```

This runs both:
- Rails server on `http://localhost:3000`
- TailwindCSS watcher for live CSS updates

Alternatively, run services separately:

```bash
# Terminal 1: Rails server
bin/rails server

# Terminal 2: TailwindCSS watcher
bin/rails tailwindcss:watch
```

## Testing

### Run All Tests

```bash
bundle exec rspec
```
