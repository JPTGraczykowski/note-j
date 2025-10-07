# CLAUDE.md

This is a Ruby on Rails application. It follows rails-way and rails conventions.

## Project Overview

**note-j** is a Rails 8 note-taking application with hierarchical folder organization, tagging, todos, and image attachments.

## Tech Stack

- **Ruby**: 3.3.4
- **Rails**: 8.0.2
- **Database**: SQLite3
- **Frontend**: Hotwire (Turbo, Stimulus), TailwindCSS, Importmap
- **Testing**: RSpec with FactoryBot
- **Authentication**: OmniAuth (Google OAuth) + bcrypt (password auth)
- **Markdown**: Redcarpet
- **Image Processing**: Active Storage with image_processing gem

## Development Commands

### Server & Development
```bash
bin/dev                      # Start server + TailwindCSS watch (uses Procfile.dev)
bin/rails server             # Start Rails server only
bin/rails tailwindcss:watch  # Watch TailwindCSS changes
```

### Database
```bash
bin/rails db:create          # Create database
bin/rails db:migrate         # Run migrations
bin/rails db:seed            # Seed database
bin/rails db:reset           # Drop, create, migrate, and seed
bin/rails db:rollback        # Rollback last migration
```

### Testing
```bash
bundle exec rspec                    # Run all specs
bundle exec rspec spec/models        # Run model specs
bundle exec rspec spec/models/user_spec.rb  # Run specific spec file
bundle exec rspec spec/models/user_spec.rb:42  # Run spec at specific line
```

### Linting & Security
```bash
bundle exec rubocop              # Run RuboCop linter
bundle exec rubocop -a           # Auto-fix violations
bundle exec brakeman             # Security vulnerability scan
```

### Rails Utilities
```bash
bin/rails console                # Rails console
bin/rails routes                 # View all routes
bin/rails db:schema:dump         # Update schema.rb
```

## Architecture

### Data Model

The application has a multi-tenant architecture where all resources belong to a User:

- **User**: Supports both OAuth (Google) and password authentication
  - Has many: notes, folders, tags, todos
  - Located at: `app/models/user.rb`

- **Note**: Core content entity with title, markdown content, and optional images
  - Belongs to: user, folder (optional)
  - Has many: images (Active Storage), tags (through notes_tags)
  - Includes: `ImageUploadable` concern
  - Located at: `app/models/note.rb`

- **Folder**: Hierarchical folder structure with self-referential parent/child relationships
  - Belongs to: user, parent (optional)
  - Has many: notes, children (sub-folders)
  - Key methods: `full_path`, `ancestors`, `descendants`, `depth`
  - Validates against circular references
  - Located at: `app/models/folder.rb`

- **Tag**: User-scoped tags for organizing notes and todos
  - Belongs to: user
  - Has many: notes (through notes_tags), todos (through todos_tags)
  - Enforces uniqueness per user
  - Located at: `app/models/tag.rb`

- **Todo**: Task list items
  - Belongs to: user
  - Has many: tags (through todos_tags)
  - Located at: `app/models/todo.rb`

- **Join Tables**: `notes_tags`, `todos_tags` (both include user_id for data integrity)

### Authentication Pattern

The app supports dual authentication:
- **OAuth**: Google OAuth via OmniAuth (provider + uid)
- **Password**: bcrypt with `has_secure_password`

User model validates that users have either OAuth credentials OR password, never neither. The `ApplicationController` currently uses a placeholder `current_user` method that auto-creates a demo user (see `app/controllers/application_controller.rb:7-14`).

### Services

- Services are organized under `app/services/[entity]_services/`
- Service object names MUST end with Service and start with an understandable action (Create, Fetch, Migrate, NOT Check)
- Service objects have ONE public method: call which returns boolean (true/false)
- Use call! method only when you want to return true on success or raise Error on failure (consult before using)
- All other methods must be private
- Use attr_reader to expose internal objects
- Arguments use symbols (e.g., initialize(user:, post_params:))
- Do NOT call service objects inside other service objects - do this in controllers
- Service objects should be independent from request - callable via Console or Job
- Use ActiveRecord::Base.transaction for database transactions
- Return boolean values consistently
- Write tests for all service objects

### Query Objects:
- Query object names MUST end with Query and start with an understandable action
- Query objects have ONE public method: results which returns ActiveRecord::Relation
- All other methods must be private
- Always return ActiveRecord::Relation, never arrays
- Don't write raw SQL if ActiveRecord can achieve the same result
- One query object per controller action or business logic
- Write comprehensive tests including positive and negative cases

### Frontend Architecture

- **Turbo**: Handles navigation and form submissions without full page reloads
- **Stimulus**: JavaScript controllers for interactive features
- **TailwindCSS**: Utility-first styling (watch mode required for changes)
- **Markdown**: Notes content rendered with Redcarpet

### Active Storage Setup

Images are stored using Active Storage with local disk storage. Configuration is in:
- `config/storage.yml` - Storage backends
- `config/active_storage_setup.md` - Setup documentation
- Attachments processed via `image_processing` gem for variants/transformations

## Testing Conventions

- **Framework**: RSpec with FactoryBot
- **Structure**: `spec/models/`, `spec/controllers/`, etc.
- **Factories**: Located in `spec/factories/`
- **Configuration**: `.rspec` sets format to documentation with color output
- **Helpers**: `spec/rails_helper.rb` for Rails integration, `spec/spec_helper.rb` for RSpec config

### Prohibited Patterns
- DO NOT use let or let! - creates unreadable test suites
- DO NOT use subject or other RSpec DSL methods
- DO NOT use context blocks - they make tests harder to read
- DO NOT add pending examples
- DO NOT test implementation details
- DO NOT duplicate tests between unit and feature tests
- DO NOT test Rake tasks directly - test business logic classes instead
- DO NOT test private methods, test behavior instead

### Required Patterns
- Create test data inline within each test
- Use meaningful, real-life data in tests (avoid random data)
- Comment hardcoded values and time travel explanations
- Test business logic and behavior, not implementation
- Each test should be self-contained and readable

### Test examples
```
# GOOD
it "query returns active users" do
  create(:user, name: "John Active", active: true)
  create(:user, name: "Bill Inactive", active: false)

  expect(ActiveUsersQuery.new.results.map(&:name)).to eq(["John Active"])
end

# BAD
let(:user) { create(:user, active: true) }
it "query returns active users" do
  expect(ActiveUsersQuery.new.results).to eq([user])
end
```

## Project Planning Workflow

This repository uses Cursor rules for structured feature planning (stored in `.cursor/rules/`):

1. **PRD Generation** (`.cursor/rules/create-prd.md`):
   - AI asks clarifying questions about the feature
   - Generates detailed Product Requirements Document
   - Saves to `/tasks/prd-[feature-name].md`
   - Target audience: junior developers

2. **Task Generation** (`.cursor/rules/generate-tasks.md`):
   - Reads PRD and analyzes current codebase
   - Phase 1: Generates high-level parent tasks
   - Phase 2: After user says "Go", breaks down into sub-tasks
   - Identifies relevant files to create/modify
   - Saves to `/tasks/tasks-[prd-file-name].md`

3. **Task Processing** (`.cursor/rules/process-task-list.mdc`):
   - Workflow for implementing tasks from task list

Existing planning documents are in `/tasks/` directory.
