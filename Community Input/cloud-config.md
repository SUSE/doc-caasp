# How to generate cloud-config for VMX images
1. Generate cloud-config for admin node
2. Start VM with cc-admin.img attached as secondary disk / usb
3. Generate cloud-config for worker node (modify admin_node via step 1)
4. Start VM with cc-worker.img attached as secondary disk / usb
5. Access admin dashboard on admin node and bootstrap cluster

```bash
# To generate cloud-config ISO (attach them as USB disk to KVM VMs before first boot)
sudo genisoimage -output cc-worker.img -volid cidata -joliet -rock cc-worker
sudo genisoimage -output cc-admin.img -volid cidata -joliet -rock cc-admin
```

```
./cloud-config] → tree
├── cc-admin
│   ├── meta-data
│   └── user-data
├── cc-admin.img
├── cc-worker
│   ├── meta-data
│   └── user-data
├── cc-worker.img
```

```yaml
# File: cloud-config/cc-*/meta-data (same for admin and cluster nodes)
instance-id: iid-CASP01
network-interfaces: |
  auto eth0
  iface eth0 inet dhcp
```
```yaml
# File: cloud-config/cc-admin/user-data (admin node)
#cloud-config
debug: True
disable_root: False
ssh_pwauth: True
chpasswd:
  list: |
    root:root
  expire: False
ntp:
  servers:
    - ntp1.suse.cz
    - ntp2.suse.cz
runcmd:
  - /usr/bin/systemctl enable --now ntpd
suse_caasp:
  role: admin
```
```yaml
# File cloud-config/cc-worker/user-data (worker nodes)
#cloud-config
debug: True
disable_root: False
ssh_pwauth: True
chpasswd:
  list: |
    root:root
  expire: False
suse_caasp:
  role: cluster
  admin_node: dhcp14.qa.suse.cz
```
