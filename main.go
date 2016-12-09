package main

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/hashicorp/terraform/config"
)

// VariableMetadata represents information about a Terraform variable.
type VariableMetadata struct {
	Type        string `json:"type"`
	Description string `json:"description,omitempty"`
}

func main() {
	requiredOnly := len(os.Args) == 2 && os.Args[1] == "--required"

	configPath, err := os.Getwd()
	if err != nil {
		panic(err)
	}

	configuration, err := config.LoadDir(configPath)
	if err != nil {
		panic(err)
	}

	err = configuration.Validate()
	if err != nil {
		fmt.Printf("Invalid configuration: %s\n", err)

		os.Exit(2)
	}

	variables := make(map[string]VariableMetadata)
	for _, variable := range configuration.Variables {
		if !requiredOnly || variable.Required() {
			variables[variable.Name] = VariableMetadata{
				Type:        variable.Type().Printable(),
				Description: variable.Description,
			}
		}
	}

	variableJSON, err := json.MarshalIndent(variables, "", "\t")
	if err != nil {
		panic(err)
	}

	fmt.Println(string(variableJSON))
}
