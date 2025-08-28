# Product Requirements Document: Note-J - Personal Note-Taking Web App

## Introduction/Overview

Note-J is a personal note-taking web application designed for organizing thoughts, planning actions, and managing todos. The app serves as a central hub for capturing insights from books, planning processes, and maintaining task lists. Built with a clean, minimalistic design featuring a dark purple accent color, Note-J prioritizes simplicity and ease of use while providing powerful organization capabilities through folders and tags.

**Problem Statement:** Current note-taking solutions are either too complex with unnecessary features or too simple without proper organization capabilities. Users need a focused, personal workspace that combines structured note organization with simple task management.

**Goal:** Create a streamlined, personal note-taking application that seamlessly integrates note organization, basic task management, and media support in a clean, mobile-responsive interface.

## Goals

1. **Simplify Note Organization**: Provide an intuitive combination of folder hierarchy and tagging system for flexible note categorization
2. **Enhance Reading Experience**: Enable users to efficiently capture and organize insights from books with proper referencing
3. **Streamline Task Management**: Offer a dedicated todo section with basic check/uncheck functionality separate from regular notes
4. **Support Visual Content**: Allow inline image integration within notes for screenshots and visual references
5. **Ensure Accessibility**: Deliver a fully responsive experience that works seamlessly across desktop and mobile devices
6. **Maintain Security**: Implement secure Google OAuth authentication for effortless single sign-on

## User Stories

### Note Management
- **As a reader**, I want to create notes with book title references so that I can organize my reading insights by source
- **As a user**, I want to organize my notes in folders so that I can group related content logically
- **As a user**, I want to tag my notes so that I can find content across different folders using multiple categorization methods
- **As a user**, I want to write notes in Markdown with live preview so that I can format my content effectively
- **As a user**, I want to add images inline within my notes so that I can include screenshots and visual references

### Todo Management
- **As a planner**, I want a dedicated todo section so that my tasks don't clutter my note-taking space
- **As a user**, I want to check/uncheck todo items so that I can track completion status
- **As a user**, I want to create and edit todo items so that I can manage my action items

### Search and Discovery
- **As a user**, I want to search through my notes by text content so that I can quickly find specific information
- **As a user**, I want to filter notes by tags so that I can view all content related to specific topics
- **As a user**, I want to browse my folder structure so that I can navigate my organized content

### Authentication and Access
- **As a user**, I want to sign in with my Google account so that I can access my notes securely without managing another password
- **As a mobile user**, I want the app to work well on my phone so that I can capture notes on the go

## Functional Requirements

### Authentication (FR-AUTH)
1. **FR-AUTH-001**: The system must implement Google OAuth authentication for user login
2. **FR-AUTH-002**: The system must maintain user sessions securely
3. **FR-AUTH-003**: The system must provide a logout functionality
4. **FR-AUTH-004**: The system must restrict access to authenticated users only

### Note Management (FR-NOTE)
5. **FR-NOTE-001**: The system must allow users to create new notes with title and content
6. **FR-NOTE-002**: The system must support Markdown editing with live preview
7. **FR-NOTE-003**: The system must allow users to add book title references to notes
8. **FR-NOTE-004**: The system must support inline image upload and display within note content
9. **FR-NOTE-005**: The system must allow users to save notes manually (no auto-save)
10. **FR-NOTE-006**: The system must allow users to edit existing notes
11. **FR-NOTE-007**: The system must allow users to delete notes with confirmation
12. **FR-NOTE-008**: The system must display notes in a readable format with proper Markdown rendering

### Organization System (FR-ORG)
13. **FR-ORG-001**: The system must allow users to create, edit, and delete folders
14. **FR-ORG-002**: The system must allow users to organize notes within folders
15. **FR-ORG-003**: The system must allow users to move notes between folders
16. **FR-ORG-004**: The system must support hierarchical folder structure (folders within folders)
17. **FR-ORG-005**: The system must allow users to create, edit, and delete tags
18. **FR-ORG-006**: The system must allow users to assign multiple tags to notes
19. **FR-ORG-007**: The system must allow users to remove tags from notes

### Todo Management (FR-TODO)
20. **FR-TODO-001**: The system must provide a dedicated todo section separate from notes
21. **FR-TODO-002**: The system must allow users to create new todo items with text description
22. **FR-TODO-003**: The system must allow users to mark todo items as complete/incomplete
23. **FR-TODO-004**: The system must allow users to edit todo item descriptions
24. **FR-TODO-005**: The system must allow users to delete todo items
25. **FR-TODO-006**: The system must display todo items with clear visual indicators for completion status

### Search and Navigation (FR-SEARCH)
26. **FR-SEARCH-001**: The system must provide text-based search across all note content
27. **FR-SEARCH-002**: The system must allow filtering notes by tags
28. **FR-SEARCH-003**: The system must provide folder-based navigation
29. **FR-SEARCH-004**: The system must display search results with relevant context
30. **FR-SEARCH-005**: The system must allow users to clear search filters

### Responsive Design (FR-UI)
31. **FR-UI-001**: The system must be fully responsive and functional on mobile devices
32. **FR-UI-002**: The system must implement a clean, minimalistic design
33. **FR-UI-003**: The system must use dark purple as the primary accent color
34. **FR-UI-004**: The system must provide intuitive navigation between sections
35. **FR-UI-005**: The system must ensure readable typography across all device sizes

## Non-Goals (Out of Scope)

### Version 1.0 Exclusions
- **Real-time collaboration** - Single user application only
- **Auto-save functionality** - Manual save to maintain user control
- **Advanced todo features** - No due dates, priorities, or notifications
- **File attachments** - Only inline images, no document uploads
- **Export functionality** - Focus on web-based access
- **Rich text editing** - Markdown-only for content formatting
- **Advanced search** - No full-text search or AI features
- **Version history** - No note versioning or revision tracking
- **Public sharing** - All notes remain private to the user
- **Third-party integrations** - No external service connections
- **Offline capabilities** - Web-based application requiring internet connection

## Design Considerations

### Visual Design
- **Color Scheme**: Light background with dark purple (#6B46C1 or similar) accent color
- **Typography**: Clean, readable font with proper hierarchy
- **Layout**: Minimalistic design with plenty of white space
- **Navigation**: Simple sidebar or tab-based navigation

### User Interface Components
- **Markdown Editor**: Split-pane or toggle view between edit and preview modes
- **Folder Tree**: Collapsible tree structure for folder navigation
- **Tag System**: Tag badges with easy add/remove functionality
- **Todo List**: Clean checkbox-based interface with strikethrough for completed items
- **Search Bar**: Prominent search functionality with filter options

### Mobile Responsiveness
- **Adaptive Layout**: Sidebar navigation transforms to mobile-friendly menu
- **Touch Optimization**: Appropriate button sizes and touch targets
- **Content Priority**: Essential content prioritized on smaller screens

## Technical Considerations

### Technology Stack
- **Backend**: Ruby on Rails 8
- **Frontend**: Hotwire (Stimulus + Turbo)
- **Styling**: Tailwind CSS
- **Database**: SQLite for development and production
- **Authentication**: Google OAuth via OmniAuth gem
- **Image Storage**: Active Storage for image uploads

### Performance Requirements
- **Page Load**: Initial page load under 2 seconds
- **Search Response**: Search results displayed within 1 second
- **Image Upload**: Support for images up to 5MB
- **Database**: Efficient queries for note and tag relationships

### Security Considerations
- **Authentication**: Secure OAuth implementation
- **Authorization**: User-specific data isolation
- **File Upload**: Image validation and security
- **Session Management**: Secure session handling

## Success Metrics

### User Engagement
- **Note Creation Rate**: Average notes created per user per week
- **Search Usage**: Percentage of sessions including search functionality
- **Tag Adoption**: Average number of tags per note
- **Mobile Usage**: Percentage of sessions from mobile devices

### Feature Utilization
- **Folder Organization**: Percentage of notes organized in folders
- **Todo Completion**: Average todo completion rate
- **Image Integration**: Percentage of notes containing images
- **Return Usage**: User retention rate over time

### Performance Metrics
- **Page Load Time**: Average time to fully load note list
- **Search Performance**: Average search response time
- **Uptime**: Application availability percentage
- **Error Rate**: Percentage of requests resulting in errors

## Open Questions

1. **Image Storage**: Should we implement image compression for better performance?
2. **Search Scope**: Should search include todo items or only notes?
3. **Folder Depth**: Should we limit the number of nested folder levels?
4. **Tag Suggestions**: Should the system suggest existing tags when creating new ones?
5. **Export Needs**: Will users eventually need to export their data?
6. **Backup Strategy**: How should we handle data backup and recovery?
7. **Analytics**: What user behavior should we track for product improvement?
8. **Rate Limiting**: Should we implement limits on note creation or image uploads?

---

**Document Version**: 1.0  
**Last Updated**: [Current Date]  
**Next Review**: [30 days from creation]
