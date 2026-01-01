Based on your `API.md` and the current state of the `frontend` directory (which seems to be missing some core configuration and utility files), I have designed a comprehensive plan to generate the necessary frontend pages and restore the missing infrastructure to make the project runnable.

I will implement the **Create Post** page and **Post Detail** page as per your API documentation, and also set up the routing and missing utilities.

### 1. Restore Missing Core Files

These files are referenced by existing code but are missing from the disk.

* **`frontend/src/types.ts`**: Define TypeScript interfaces (`User`, `Post`, `Community`, etc.) based on `API.md`.

* **`frontend/src/utils/auth.ts`**: Implement authentication utilities (`setToken`, `getToken`, `isAuthenticated`, etc.).

* **`frontend/src/utils/format.ts`**: Implement time formatting utility (`formatTime`).

### 2. Generate New Frontend Pages

* **`frontend/src/pages/CreatePost.tsx`**:

  * A form to create a new post (`POST /post`).

  * Includes community selection and title/content inputs.

  * Requires authentication.

* **`frontend/src/pages/PostDetail.tsx`**:

  * A page to view post details (`GET /post/:id`).

  * Displays post content, author info, community info, and voting status.

  * Includes the `VoteButton` component.

### 3. Setup Routing and Entry Point

* **`frontend/src/App.tsx`**: Create the main application component with `react-router-dom` to route between Login, Signup, PostList, CreatePost, and PostDetail.

* **`frontend/src/main.tsx`**: Create the entry point to render the App.

* **`frontend/index.html`**: Create the HTML entry file.

* **`frontend/package.json`** **&** **`frontend/vite.config.ts`**: Create basic configuration files to ensure the project can be installed and run.

### 4. Verification

* I will verify the implementation by ensuring all files are created correctly and cross-referenced properly.

* Since I cannot run the backend to test the API, I will ensure the code logic strictly follows `API.md`.

