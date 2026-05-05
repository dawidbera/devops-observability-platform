# DevOps Observability Platform

A platform for automating deployment and monitoring of microservices on Kubernetes.

## Architecture & Process Flow

```mermaid
graph TD
    subgraph "Developer Zone"
        Code[Java/Spring Boot Code] --> Commit[Git Push]
    end

    subgraph "CI/CD Pipeline (Jenkins)"
        Commit --> Build[Maven Build & Test]
        Build --> Scan[SonarQube: Static Analysis]
        Scan --> Docker[Build Image & Scanning]
        Docker --> Nexus[Nexus: Artifact/Docker Registry]
        Secrets[K8s Secrets] -.-> Scan
        Secrets -.-> Docker
    end

    subgraph "Kubernetes Cluster (k3d)"
        Nexus --> Deploy[Helm Deploy]
        
        subgraph "Namespace: staging"
            Deploy --> Pods[Application: Pods]
            SA[ServiceAccount / RBAC] --- Pods
        end
        
        subgraph "Monitoring & Observability"
            Pods --> Prometheus[Prometheus: Metrics]
            Prometheus --> Grafana[Grafana: Dashboards]
            Prometheus --> Alerts[Alertmanager: Alerting]
        end
        
        Ingress[Traefik Ingress] --> Pods
    end

    User[End User] --> Ingress
```

### Request & Artifact Flow Description
1.  **Coding:** The developer pushes code to the repository.
2.  **CI/CD Orchestration:** Jenkins detects changes, builds the artifact (JAR), runs unit tests.
3.  **Security & Quality:** Jenkins retrieves credentials from **Kubernetes Secrets** to perform a SonarQube scan and push images.
4.  **Artifact Management:** The Docker image is tagged and pushed to the private registry in Nexus.
5.  **Deployment (CD):** Jenkins updates the deployment on Kubernetes using Helm in the `staging` namespace.
6.  **Access Control:** The application runs with a dedicated **ServiceAccount** and restricted **RBAC** roles.

### Observability & Alerting
Prometheus automatically discovers new Pods and scrapes metrics (JVM, latency). Grafana visualizes this data, and Alertmanager monitors critical thresholds.
*   **Alert Rules:** Defined in `monitoring/prometheus/alert_rules.yml`.

## Pipeline Features
The project includes a multi-stage `Jenkinsfile` that automates:
1.  **Checkout:** Retrieves the latest code.
2.  **Build & Test:** Executes Maven build and JUnit tests.
3.  **SonarQube Scan:** Performs static code analysis using secure credentials.
4.  **Dockerization:** Builds and tags Docker images with vulnerability scanning (Trivy).
5.  **Deployment:** Deploys to the `staging` namespace using Helm with Ingress and RBAC support.

## Security & Compliance
*   **Secrets Management:** No hardcoded passwords. Credentials for SonarQube and Nexus are managed via Kubernetes Secrets and injected at runtime.
*   **RBAC (Role-Based Access Control):** Least privilege principle applied to the application namespace.
*   **Image Scanning:** All images are scanned for vulnerabilities before deployment.

## Testing
Unit tests are located in `app/src/test`. Run them locally using:
```bash
cd app && mvn test
```
### Requirements
- Docker
- k3d (installed via `make install-deps`)
- Helm
- kubectl

### Infrastructure Setup
```bash
make install-deps
make cluster-up
make tools-init
make tools-up
```

## Service Access

### Application (Staging)
- **URL:** [http://localhost/api/hello](http://localhost/api/hello)
- **Note:** Access via port 80 (standard HTTP) mapped by k3d.

### Jenkins
- **URL:** http://localhost:8080 (requires port-forward)
- **Command:** `kubectl port-forward svc/jenkins 8080:8080 -n jenkins`
- **Password:** `kubectl exec -it svc/jenkins -n jenkins -c jenkins -- cat /run/secrets/additional/chart-admin-password`

### SonarQube
- **URL:** http://localhost:9000 (requires port-forward)
- **Command:** `kubectl port-forward svc/sonarqube-sonarqube 9000:9000 -n sonarqube`
- **Credentials:** Managed via K8s Secrets (`sonarqube-creds`)

### Nexus
- **URL:** http://localhost:8081 (requires port-forward)
- **Command:** `kubectl port-forward svc/nexus-sonatype-nexus 8081:8081 -n nexus`
- **Credentials:** Managed via K8s Secrets (`nexus-creds`)

### Prometheus & Grafana
- **Prometheus:** `kubectl port-forward svc/prometheus-server 9090:80 -n monitoring`
- **Grafana:** [http://localhost:3000](http://localhost:3000) (admin / admin)
