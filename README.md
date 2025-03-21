# 🚀 Zsh Tools for EasyPark Platform Team

This **Oh My Zsh plugin** provides custom functions for **Kubernetes, Istio, and platform automation**.

## 📥 Installation

### **Option 1: Manual Installation**
1. Clone the `pet-tools` repo and link it to Oh My Zsh:
   ```sh
   git clone git@github.com:easyparkgroup/pet-tools.git ~/pet-tools
   ln -s ~/pet-tools/zsh-tools ~/.oh-my-zsh/custom/plugins/zsh-tools
   ```

2. Enable the plugin in your `~/.zshrc`:
   ```sh
   plugins=(git kubectl zsh-tools)
   ```

3. Restart Zsh:
   ```sh
   exec zsh
   ```

---

### **Option 2: Automated Installation**
Run:
```sh
curl -fsSL https://raw.githubusercontent.com/easyparkgroup/pet-tools/main/zsh-tools/install.sh | bash
```
This will:
- Clone `pet-tools` into `~/pet-tools`
- Add `zsh-tools` to Oh My Zsh
- Enable it in `.zshrc`
- Restart your shell

---

## 🔄 Updating the Plugin
To pull the latest updates:
```sh
cd ~/pet-tools && git pull
exec zsh
```

Or use an alias:
```sh
alias update-zsh-tools='cd ~/pet-tools && git pull && exec zsh'
```
Then, run:
```sh
update-zsh-tools
```

---

## 🚀 Available Functions
| Function | Description |
|----------|------------|
| `waypoint_label <ns\|svc> <name> -w <waypoint>` | Label a namespace or service with an Istio waypoint |
| `pod_node <pod-name>` | Get the node where a pod is running |
| `disable_mtls_namespace <namespace>` | Disable mTLS for a given namespace |
| `label_ambient <namespace>` | Enable Istio Ambient mode for a namespace |
| `unlabel_ambient <namespace>` | Remove the Istio Ambient mode label from a namespace |
| `deploy_sleep_pod [--name pod-name] [--sa service-account] [-n namespace]` | Deploy a sleep pod for debugging |
| `exec_sleep_pod [--name pod-name] [shell]` | Execute into a sleep pod |

## **istio-label Command**

`istio-label` is a Zsh function that allows you to **enable or disable Istio Ambient Mesh mode** for namespaces, deployments, statefulsets, and daemonsets. It applies or removes the `istio.io/dataplane-mode=ambient` label at both the namespace and workload levels.

## **Usage**
```sh
istio-label ambient <ns|deploy|ds|statefulset> <resourceName> --enable|--disable
```

## **Arguments**
| Argument      | Description |
|--------------|-------------|
| `ambient`    | Required mode (only "ambient" is supported). |
| `<resourceType>` | The Kubernetes resource type (`ns`, `deploy`, `ds`, or `statefulset`). |
| `<resourceName>` | The name of the Kubernetes resource to modify. |
| `--enable`   | Adds the `istio.io/dataplane-mode=ambient` label to the resource. |
| `--disable`  | Removes the `istio.io/dataplane-mode` label from the resource. |

---

## 🐛 Troubleshooting
### **1. Instant Prompt Warning in Powerlevel10k**
If you see:
```
[WARNING]: Console output during zsh initialization detected.
```
This is caused by functions loading before **instant prompt**. To fix:
```sh
update-zsh-tools
```
Then, restart your terminal.

### **2. Plugin Not Found**
If `zsh-tools` isn’t loading:
- Make sure you added `zsh-tools` to `plugins=(...)` in `~/.zshrc`
- Run `exec zsh` or restart your shell.

---

## 📖 Contributing
To add more functions:
1. Create a new `.zsh` file in `zsh-tools/functions/`
2. Submit a pull request to the `pet-tools` repo

---

## ✅ Summary
- Clone `pet-tools`
- Enable `zsh-tools` in Oh My Zsh
- Run `exec zsh`
- Use `update-zsh-tools` to get updates

🎉 Enjoy faster CLI workflows with `zsh-tools`! 🚀


