# 🔗 Container SSH Bridge

This project demonstrates how to **connect from one Docker container to another** using **SSH**, without any host-level interaction. It helps understand basic container networking, SSH configuration, and inter-container communication.

---

##  Project Structure

- `container1`: Acts as an **SSH Server**
- `container2`: Acts as an **SSH Client**

---

##  Steps to Reproduce

###  1. Run two Ubuntu containers

```bash
docker run -dit --name container1 ubuntu
docker run -dit --name container2 ubuntu
```

---

### 2. Install SSH server in container1 (Server)

```bash
docker exec -it container1 bash
apt update
apt install openssh-server -y
```

---

###  3. Update SSH config to allow root login

Open the config file:
```bash
nano /etc/ssh/sshd_config
```

Find this line:
```text
#PermitRootLogin prohibit-password
```

Replace with:
```text
PermitRootLogin yes
```

Then set a root password:
```bash
passwd
# Enter a new password when prompted
```

Start the SSH server:
```bash
service ssh start
```

Exit container1:
```bash
exit
```

---

###  4. Get container1's IP address

On your host system, run:
```bash
docker inspect container1 | grep IPAddress
```

Note the `IPAddress` (e.g., `172.17.0.2`)

---

###  5. Install SSH client in container2 (Client)

```bash
docker exec -it container2 bash
apt update
apt install openssh-client -y
```

---

###  6. SSH from container2 to container1

Now run:
```bash
ssh root@<container1_ip>
```

Example:
```bash
ssh root@172.17.0.2
```

Accept the fingerprint, enter the root password you set in container1, and you're in!

---

##  Success

You’ve now successfully connected from one Docker container to another using SSH! This setup is a great beginner DevOps exercise for understanding networking and container interaction.

---

## 📂 Folder Structure

```
container-ssh-bridge/
├── README.md
└── (your custom files like Dockerfile or setup scripts if needed)
```

---

## Notes

- This works only if both containers share the **default Docker bridge network**.
- No additional tools or network drivers are needed.
- For production setups, consider using key-based auth and secure networking.



