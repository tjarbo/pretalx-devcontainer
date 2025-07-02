# pretalx Plugin Devcontainer

A ready-to-use devcontainer image and scripts to streamline plugin development for the open source conference platform [pretalx](https://pretalx.org/). It includes all necessary tools and scripts to simplify setup and daily development tasks.

## ⚡ Prerequisites
- A container runtime: [Docker](https://www.docker.com/) or [Podman](https://podman.io/).
- An IDE or editor with [devcontainer](https://containers.dev/) support (e.g., VS Code) or you can use online services like [GitHub Codespaces](https://github.com/features/codespaces).

## 🚦 Quick Start for your own plugin
1. **Copy the `.devcontainer` folder**
   - Copy the `.devcontainer` folder from this repository to the root of your pretalx plugin development repository.
2. **Open in VS Code**
   - Open your plugin repository in VS Code.
   - When prompted, click **"Reopen in Container"**. If not prompted, open the Command Palette (`Ctrl+Shift+P`), search for `Dev Containers: Reopen in Container`, and select it.
   - VS Code will build and start the devcontainer automatically.
3. **Start developing!** ✨ Do not forget to initialize pretalx as per its original development guide.
   1. `python manage.py init` to create an admin user, organiser and team
   2. `python manage.py create_test_event` to create a test event.

## 🧩 Example Projects
_Example plugin projects and usage guides will be added soon._

## 🤝 Contributing
Contributions are welcome! Please open an issue to discuss feature requests or problems before submitting a pull request.

## ❓ FAQ
### What is the benefit of using a devcontainer?
A devcontainer provides a consistent, reproducible development environment with all dependencies pre-installed, reducing setup time and avoiding "works on my machine" issues.

### How do I know if my IDE or editor supports devcontainers?
Check the [official list of supporting editors](https://containers.dev/supporting). Popular options include VS Code and GitHub Codespaces.

### What can I do if my IDE or editor does not support devcontainers?
You can still use the provided container image and scripts by running container runtime commands manually. Refer to your container runtime's documentation for running containers and mounting your project directory.

## 📄 License
Checkout the [LICENSE](./LICENSE) file for details.

