# ProtonMail Bridge Helm Chart

This Helm chart deploys ProtonMail Bridge on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Default storage class configured (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-protonmail-bridge`:

```bash
helm install my-protonmail-bridge ./protonmail-bridge-helm
```

The command deploys ProtonMail Bridge on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-protonmail-bridge` deployment:

```bash
helm delete my-protonmail-bridge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `nameOverride`      | String to partially override protonmail-bridge.fullname | `""` |
| `fullnameOverride`  | String to fully override protonmail-bridge.fullname | `""` |

### Image parameters

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `image.repository`  | ProtonMail Bridge image repository | `shenxn/protonmail-bridge` |
| `image.tag`         | ProtonMail Bridge image tag | `3.19.0-build` |
| `image.pullPolicy`  | ProtonMail Bridge image pull policy | `IfNotPresent` |

### Service parameters

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `service.enabled`   | Enable service             | `true` |
| `service.type`      | Service type               | `ClusterIP` |
| `service.annotations` | Service annotations      | `{}` |
| `service.ports.imap.port` | IMAP service port    | `143` |
| `service.ports.imap.targetPort` | IMAP target port | `143` |
| `service.ports.smtp.port` | SMTP service port    | `25` |
| `service.ports.smtp.targetPort` | SMTP target port | `25` |

### Environment variables

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `env.TZ`            | Timezone                   | `UTC` |

### Health checks

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `probes.liveness.enabled` | Enable liveness probe | `true` |
| `probes.readiness.enabled` | Enable readiness probe | `true` |
| `probes.startup.enabled` | Enable startup probe   | `true` |

### Resource management

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `resources.requests.cpu` | CPU resource requests | `0.1` |
| `resources.requests.memory` | Memory resource requests | `256Mi` |
| `resources.limits.cpu` | CPU resource limits    | `1` |
| `resources.limits.memory` | Memory resource limits | `1.5Gi` |

### Persistence

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `persistence.enabled` | Enable persistence       | `true` |
| `persistence.storageClass` | Storage class name    | `""` (uses default) |
| `persistence.accessModes` | Access modes           | `["ReadWriteOnce"]` |
| `persistence.size`  | Storage size               | `5Gi` |
| `persistence.mountPath` | Mount path in container | `/root` |
| `persistence.hostPath` | Host path for PV (optional) | `""` |
| `persistence.reclaimPolicy` | PV reclaim policy   | `Retain` |

### Strategy

| Name                | Description                | Value |
| ------------------- | -------------------------- | ----- |
| `strategy.type`     | Deployment strategy type   | `Recreate` |

## Configuration and Installation Details

### Setting up ProtonMail Bridge

After deployment, you'll need to configure ProtonMail Bridge:

1. Exec into the pod:
```bash
kubectl exec -it deployment/my-protonmail-bridge -- /bin/bash
```

2. Run the bridge configuration:
```bash
protonmail-bridge --cli
```

3. Follow the prompts to add your ProtonMail account.

### Persistence

By default, this chart creates a PersistentVolumeClaim that uses the default storage class. If you want to use a specific storage class or create a PersistentVolume with hostPath, you can configure the persistence settings in values.yaml.

### Networking

The chart exposes both IMAP (port 143) and SMTP (port 25) services. You can access these services within the cluster or expose them externally by changing the service type to `NodePort` or `LoadBalancer`.

### Security Considerations

- ProtonMail Bridge requires configuration with your ProtonMail credentials
- Consider using proper RBAC and network policies
- Store sensitive configuration in Kubernetes secrets if needed

## Troubleshooting

### Common Issues

1. **Pod not starting**: Check if the storage class is available and properly configured
2. **Authentication issues**: Ensure you've properly configured ProtonMail Bridge with your credentials
3. **Port conflicts**: Make sure the IMAP/SMTP ports are not conflicting with other services

### Debugging

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=protonmail-bridge

# Check pod logs
kubectl logs deployment/my-protonmail-bridge

# Describe the deployment
kubectl describe deployment my-protonmail-bridge
```




  GNU nano 8.4                                                                                        expect.txt                                                                                                  
#!/usr/bin/expect -f
set timeout -1


set email $env(PROTONMAIL_EMAIL)
set password $env(PROTONMAIL_PASSWORD)
set otp $env(PROTONMAIL_2FA)

spawn /protonmail/proton-bridge --cli  init

expect ">>>"
send -- "login\r"
sleep 1

expect "Username:"
send "$email\r"

expect "Password:"
send "$password\r"

# Exit CLI immediately after login
expect ">"   ;# wait for CLI prompt
send "exit\r"

expect eof
