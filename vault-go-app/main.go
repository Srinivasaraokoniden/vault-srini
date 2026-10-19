package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

const (
	serviceAccountTokenPath = "/var/run/secrets/kubernetes.io/serviceaccount/token"
	vaultAuthRole           = "srinivas-app"
	vaultLoginPath          = "/v1/auth/kubernetes/login"
	vaultSecretPath         = "/v1/kv/data/srinivas"
)

type VaultLoginResponse struct {
	Auth struct {
		ClientToken string `json:"client_token"`
	} `json:"auth"`
}

type VaultSecretResponse struct {
	Data struct {
		Data map[string]interface{} `json:"data"`
	} `json:"data"`
}

func main() {
	log.Println("Starting Vault Kubernetes authentication example")

	vaultAddr := strings.TrimRight(os.Getenv("VAULT_ADDR"), "/")
	if vaultAddr == "" {
		log.Fatal("VAULT_ADDR environment variable is not set")
	}

	httpClient := &http.Client{
		Timeout: 15 * time.Second,
	}

	// Step 1: Read the Kubernetes ServiceAccount JWT.
	jwtBytes, err := os.ReadFile(serviceAccountTokenPath)
	if err != nil {
		log.Fatalf("Unable to read ServiceAccount JWT: %v", err)
	}
	jwt := strings.TrimSpace(string(jwtBytes))

	// Step 2: Exchange the JWT for a Vault client token.
	loginPayload, err := json.Marshal(map[string]string{
		"role": vaultAuthRole,
		"jwt":  jwt,
	})
	if err != nil {
		log.Fatalf("Unable to prepare login request: %v", err)
	}

	loginURL := vaultAddr + vaultLoginPath
	loginReq, err := http.NewRequest(
		http.MethodPost,
		loginURL,
		bytes.NewReader(loginPayload),
	)
	if err != nil {
		log.Fatalf("Unable to create login request: %v", err)
	}
	loginReq.Header.Set("Content-Type", "application/json")

	loginResp, err := httpClient.Do(loginReq)
	if err != nil {
		log.Fatalf("Vault login request failed: %v", err)
	}
	defer loginResp.Body.Close()

	if loginResp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(loginResp.Body)
		log.Fatalf(
			"Vault login failed: HTTP %d: %s",
			loginResp.StatusCode,
			string(body),
		)
	}

	var login VaultLoginResponse
	if err := json.NewDecoder(loginResp.Body).Decode(&login); err != nil {
		log.Fatalf("Unable to parse Vault login response: %v", err)
	}

	vaultToken := login.Auth.ClientToken
	if vaultToken == "" {
		log.Fatal("Vault login succeeded but returned no client token")
	}

	log.Println("Successfully authenticated to Vault using Kubernetes auth")

	// Step 3: Read the KV v2 secret.
	secretURL := vaultAddr + vaultSecretPath
	secretReq, err := http.NewRequest(http.MethodGet, secretURL, nil)
	if err != nil {
		log.Fatalf("Unable to create secret request: %v", err)
	}
	secretReq.Header.Set("X-Vault-Token", vaultToken)

	secretResp, err := httpClient.Do(secretReq)
	if err != nil {
		log.Fatalf("Vault secret request failed: %v", err)
	}
	defer secretResp.Body.Close()

	if secretResp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(secretResp.Body)
		log.Fatalf(
			"Reading secret failed: HTTP %d: %s",
			secretResp.StatusCode,
			string(body),
		)
	}

	var secret VaultSecretResponse
	if err := json.NewDecoder(secretResp.Body).Decode(&secret); err != nil {
		log.Fatalf("Unable to parse secret response: %v", err)
	}

	// Step 4: Extract username and password.
	username, ok := secret.Data.Data["username"].(string)
	if !ok || username == "" {
		log.Fatal("Secret does not contain a valid username")
	}

	password, ok := secret.Data.Data["password"].(string)
	if !ok || password == "" {
		log.Fatal("Secret does not contain a valid password")
	}

	// Step 5: Pass the credentials to your application logic.
	if err := useCredentials(username, password); err != nil {
		log.Fatalf("Application operation failed: %v", err)
	}

	log.Println("Successfully retrieved and used credentials from Vault")
}

func useCredentials(username, password string) error {
	if username == "" || password == "" {
		return fmt.Errorf("username or password is empty")
	}

	// Replace this with your actual database connection,
	// API client initialization, or other application logic.
	log.Printf("Credentials loaded for username %q", username)
	log.Println("Password loaded successfully; value not logged")

	return nil
}
