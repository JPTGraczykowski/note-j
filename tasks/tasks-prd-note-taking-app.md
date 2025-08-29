# Task List: Note-J - Personal Note-Taking Web App

Based on PRD: `prd-note-taking-app.md`

## Current State Assessment

**Existing Infrastructure:**
- Rails 8 application with Hotwire (Turbo + Stimulus) already configured
- SQLite database setup for development, test, and production
- Basic Rails structure with minimal controllers/models
- Propshaft for assets, importmap for JavaScript
- No authentication system currently in place
- No Tailwind CSS configured yet
- Active Storage gem commented out in Gemfile

**Gaps Identified:**
- Need to add Google OAuth authentication
- Need to configure Tailwind CSS
- Need to create all data models (User, Note, Folder, Tag, Todo)
- Need to set up Active Storage for image uploads
- Need to build complete UI with responsive design
- Need to implement search functionality

## Relevant Files

- `Gemfile` - Add required gems for OAuth, Tailwind, image processing, and markdown
- `config/routes.rb` - Define all application routes for notes, folders, tags, todos
- `config/initializers/omniauth.rb` - OAuth configuration for Google authentication
- `app/models/user.rb` - User model with OAuth integration and associations
- `app/models/note.rb` - Note model with markdown content and associations
- `app/models/folder.rb` - Folder model with hierarchical structure
- `app/models/tag.rb` - Tag model for note categorization
- `app/models/todo.rb` - Todo model for task management
- `app/controllers/application_controller.rb` - Base authentication and security
- `app/controllers/sessions_controller.rb` - OAuth login/logout handling
- `app/controllers/notes_controller.rb` - CRUD operations for notes
- `app/controllers/folders_controller.rb` - Folder management operations
- `app/controllers/tags_controller.rb` - Tag management operations
- `app/controllers/todos_controller.rb` - Todo CRUD operations
- `app/controllers/search_controller.rb` - Search functionality across notes
- `app/views/layouts/application.html.erb` - Main layout with navigation and responsive design
- `app/views/notes/index.html.erb` - Notes listing page with search and filters
- `app/views/notes/show.html.erb` - Individual note display with markdown rendering
- `app/views/notes/new.html.erb` - Note creation form with markdown editor
- `app/views/notes/edit.html.erb` - Note editing form
- `app/views/notes/_form.html.erb` - Shared note form partial
- `app/views/folders/index.html.erb` - Folder management interface
- `app/views/todos/index.html.erb` - Todo list interface
- `app/views/search/index.html.erb` - Search results page
- `app/javascript/controllers/markdown_editor_controller.js` - Stimulus controller for markdown editing
- `app/javascript/controllers/image_upload_controller.js` - Stimulus controller for image uploads
- `app/javascript/controllers/folder_tree_controller.js` - Stimulus controller for folder navigation
- `app/javascript/controllers/search_controller.js` - Stimulus controller for search functionality
- `app/assets/stylesheets/application.tailwind.css` - Tailwind CSS configuration and custom styles
- `db/migrate/001_create_users.rb` - User table migration
- `db/migrate/002_create_folders.rb` - Folders table migration with hierarchy
- `db/migrate/003_create_tags.rb` - Tags table migration
- `db/migrate/004_create_notes.rb` - Notes table migration with associations
- `db/migrate/005_create_todos.rb` - Todos table migration
- `db/migrate/006_create_note_tags.rb` - Many-to-many relationship for note tags
- `db/migrate/007_create_todo_tags.rb` - Many-to-many relationship for todo tags
- `spec/models/user_spec.rb` - User model tests
- `spec/models/note_spec.rb` - Note model tests
- `spec/models/folder_spec.rb` - Folder model tests
- `spec/models/tag_spec.rb` - Tag model tests
- `spec/models/todo_spec.rb` - Todo model tests
- `spec/controllers/notes_controller_spec.rb` - Notes controller tests
- `spec/controllers/folders_controller_spec.rb` - Folders controller tests
- `spec/controllers/todos_controller_spec.rb` - Todos controller tests
- `spec/system/authentication_spec.rb` - OAuth authentication system tests
- `spec/system/note_management_spec.rb` - Note CRUD system tests
- `spec/system/search_spec.rb` - Search functionality system tests

### Notes

- RSpec will be used for testing instead of default Minitest, following user preferences
- Tests should define all necessary variables in "it" blocks using factories instead of let/let!
- Tests should be scoped to "context" instead of "describe" blocks
- No before/after callbacks, subject, or let statements per user rules
- Use `bundle exec rspec [optional/path/to/test/file]` to run tests
- Factory Bot will be used for test data generation

## Tasks

- [x] 1.0 Setup Authentication and Dependencies
  - [x] 1.1 Add required gems to Gemfile (omniauth-google-oauth2, omniauth-rails_csrf_protection, tailwindcss-rails, image_processing, redcarpet, rspec-rails, factory_bot_rails)
  - [x] 1.2 Run bundle install to install new dependencies
  - [x] 1.3 Configure OmniAuth for Google OAuth with initializer
  - [x] 1.4 Set up Active Storage for image uploads
  - [x] 1.5 Install and configure RSpec for testing
  - [x] 1.6 Install and configure Factory Bot for test data

- [ ] 2.0 Create Database Models and Relationships  
  - [x] 2.1 Generate User model with OAuth fields (provider, uid, email, name)
  - [x] 2.2 Generate Folder model with hierarchical structure (name, parent_id, user_id)
  - [ ] 2.3 Generate Tag model (name, user_id)
  - [ ] 2.4 Generate Note model (title, content, folder_id, user_id)
  - [ ] 2.5 Generate Todo model (description, completed, user_id)
  - [ ] 2.6 Create join table for note-tag many-to-many relationship
  - [ ] 2.7 Create join table for todo-tag many-to-many relationship
  - [ ] 2.8 Add model associations and validations
  - [ ] 2.9 Run migrations and verify database schema

- [ ] 3.0 Setup Styling with Tailwind CSS
  - [ ] 3.1 Install Tailwind CSS via tailwindcss-rails gem
  - [ ] 3.2 Configure Tailwind with custom colors (dark purple accent)
  - [ ] 3.3 Create base application layout with navigation structure
  - [ ] 3.4 Design responsive navigation with mobile menu
  - [ ] 3.5 Set up typography and spacing utilities
  - [ ] 3.6 Create component classes for buttons, forms, and cards

- [ ] 4.0 Build Core Note Management Features
  - [ ] 4.1 Create notes controller with CRUD actions
  - [ ] 4.2 Build note listing page with folder navigation
  - [ ] 4.3 Create note creation form with markdown editor
  - [ ] 4.4 Implement note editing functionality
  - [ ] 4.5 Add markdown rendering for note display
  - [ ] 4.6 Add note deletion with confirmation
  - [ ] 4.7 Create Stimulus controller for markdown preview

- [ ] 5.0 Implement Organization System (Folders and Tags)
  - [ ] 5.1 Create folders controller for CRUD operations
  - [ ] 5.2 Build hierarchical folder tree interface
  - [ ] 5.3 Implement folder-based note filtering
  - [ ] 5.4 Create tags controller for tag management
  - [ ] 5.5 Build tag assignment interface for notes and todos
  - [ ] 5.6 Implement tag-based filtering for notes and todos
  - [ ] 5.7 Create Stimulus controller for folder tree navigation
  - [ ] 5.8 Add drag-and-drop for moving notes between folders

- [ ] 6.0 Build Todo Management System
  - [ ] 6.1 Create todos controller with CRUD operations
  - [ ] 6.2 Build todo list interface with checkboxes
  - [ ] 6.3 Implement todo creation and editing
  - [ ] 6.4 Add toggle functionality for completion status
  - [ ] 6.5 Style completed todos with strikethrough
  - [ ] 6.6 Add todo deletion functionality
  - [ ] 6.7 Create Stimulus controller for todo interactions

- [ ] 7.0 Add Search and Navigation Features
  - [ ] 7.1 Create search controller for handling queries
  - [ ] 7.2 Implement text-based search across note content
  - [ ] 7.3 Add tag-based filtering functionality for notes and todos
  - [ ] 7.4 Build search results display page
  - [ ] 7.5 Implement search highlighting in results
  - [ ] 7.6 Create Stimulus controller for live search
  - [ ] 7.7 Add search filters and sorting options

- [ ] 8.0 Implement Image Upload and Display
  - [ ] 8.1 Configure Active Storage for image handling
  - [ ] 8.2 Create image upload interface in note editor
  - [ ] 8.3 Implement image validation (type, size limits)
  - [ ] 8.4 Add image preview functionality
  - [ ] 8.5 Integrate images with markdown rendering
  - [ ] 8.6 Create Stimulus controller for image uploads
  - [ ] 8.7 Add image deletion and replacement features

- [ ] 9.0 Build Responsive UI and Mobile Optimization
  - [ ] 9.1 Implement responsive grid layouts for all pages
  - [ ] 9.2 Create mobile-friendly navigation menu
  - [ ] 9.3 Optimize touch targets for mobile devices
  - [ ] 9.4 Implement responsive markdown editor
  - [ ] 9.5 Add mobile-specific gestures and interactions
  - [ ] 9.6 Test and refine mobile user experience
  - [ ] 9.7 Optimize loading performance for mobile

- [ ] 10.0 Add Security and User Data Isolation
  - [ ] 10.1 Implement authentication filters in controllers
  - [ ] 10.2 Add user-specific data scoping to all models
  - [ ] 10.3 Implement authorization checks for all actions
  - [ ] 10.4 Add CSRF protection for forms
  - [ ] 10.5 Implement secure file upload validation
  - [ ] 10.6 Add rate limiting for API endpoints
  - [ ] 10.7 Create comprehensive security tests
