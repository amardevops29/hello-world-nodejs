### Hello World Node.js Project
```
## Overview

This is a **Hello World Node.js** application, which is containerized using Docker, pushed to Docker Hub, and deployed on a **Kubernetes cluster**. The application is exposed via a **Kubernetes service** with the type set to **NodePort** to allow external access.

This project demonstrates the entire process:
- **Creating a Dockerfile** to containerize the application
- **Building a Docker image** and tagging it with your Docker Hub username
- **Pushing the image to Docker Hub** for storage
- **Deploying the container** on Kubernetes
- **Exposing the service via NodePort** to make it accessible externally

## Steps

### 1. **Dockerize the Application**

To containerize the Node.js application, create a `Dockerfile` in your project directory. Here’s an example:

```Dockerfile
# Use the official Node.js image as a base
FROM node:14

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the application files
COPY package*.json ./
RUN npm install
COPY . .

# Expose the application on port 8080
EXPOSE 8080

# Define the command to run the app
CMD ["node", "app.js"]
```

### 2. **Build the Docker Image**

Once the `Dockerfile` is created, build the Docker image on your local machine:

```bash
docker build -t hw-app:v1.0 .
```

### 3. **Check if the Image was Built Successfully**

After building the image, you can verify it with:

```bash
docker images
```

### 4. **Tag the Image with Your Docker Hub Username**

Tag the built image with your Docker Hub username so it can be pushed to your Docker Hub repository:

```bash
docker tag hw-app:v1.0 amardevops29/hw-app:v1.0
```

### 5. **Push the Image to Docker Hub**

Push the tagged image to your Docker Hub repository:

```bash
docker push amardevops29/hw-app:v1.0
```

Once the image is pushed, you should see output similar to the following, indicating the layers of the image being pushed:

```
The push refers to repository [docker.io/amardevops29/hw-app]
510e4517a76b: Pushed
df4e55036e8c: Pushed
b0aaa84cfafd: Pushed
e7ae04d3f37c: Pushed
e29ab5067804: Pushed
ae4ceb8dc557: Pushed
f1b5933fe4b5: Pushed
v1.0: digest: sha256:512f87b0821cf7419574b2e74c604909eeb69e0a33e5c6472a776b47a4c27381 size: 1785
```

### 6. **Deploy the Application to Kubernetes**

Once the image is pushed to Docker Hub, you can deploy it to your Kubernetes cluster. Use **Kustomize** to deploy your application:

```bash
kubectl apply -k k8s/overlays/dev
```

This command applies the Kubernetes resources defined in your Kustomization template (located in `k8s/overlays/dev`).

### 7. **Check the Kubernetes Resources**

To verify that the deployment was successful, use the following command to check all the pods and services deployed in your Kubernetes cluster:

```bash
kubectl get all -n dev-namespace
```

### 8. **Scale Down All Pods (If Necessary)**

If you want to scale down the pods (e.g., for maintenance or testing purposes), use the following command:

```bash
kubectl scale deployment --all --replicas=0 -n dev-namespace
```

This will scale down all deployments and stop the pods.

### 9. **Expose the Application via NodePort**

To expose your app externally, a Kubernetes service of type **NodePort** is used. The service is configured to map the application’s internal port (8080) to an external port (e.g., 32533).

Once the service is set up, you can access the app externally using the `localhost` or `Node IP` along with the assigned port. Here's how to check and test it:

```bash
curl http://localhost:32533
```

The response should be:

```json
{"message":"Hello World JavaScript v2"}
```

### How the Service is Exposed

The Kubernetes service is configured with `type: NodePort`, which exposes the application to external traffic on a specified port (32533 in this case). Here’s the key section of the service definition:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hw-app-service
spec:
  selector:
    app: hw-app  # Matches the labels in the deployment
  ports:
    - protocol: TCP
      port: 80           # Port on which the service is exposed
      targetPort: 8080   # Port inside the container
      nodePort: 32533    # Exposed port on the node
  type: NodePort        # Expose the app on a NodePort
```

- **`type: NodePort`**: Exposes the application to external traffic on a random high port (or a specified `nodePort`).
- **`nodePort: 32533`**: External port that allows you to access the service. You can access it via `http://localhost:32533` if you're using `localhost`.

### Conclusion

This project demonstrates the full flow of:
- Dockerizing a Node.js application
- Pushing the image to Docker Hub
- Deploying it to Kubernetes
- Exposing the service via NodePort for external access

Now, your app is running on Kubernetes and can be accessed externally via the assigned NodePort.
```

