package main

import (
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/mypurecloud/platform-client-sdk-go/v66/platformclientv2"
)

var (
	config = platformclientv2.GetDefaultConfiguration()
	api    = platformclientv2.NewArchitectApi()
)

type LambdaResponse struct {
	Status string `json:"Status"`
}

type LambdaRequest struct {
	ClientID             string `json:"ClientID"`
	ClientSecret         string `json:"ClientSecret"`
	GroupID              string `json:"GroupID"`
	EnableEmergencyGroup bool   `json:"EnableEmergencyGroup"`
}

func main() {
	lambda.Start(LambdaHandler)
}

func LambdaHandler(request LambdaRequest) (LambdaResponse, error) {
	err := config.AuthorizeClientCredentials(request.ClientID, request.ClientSecret)
	if err != nil {
		fmt.Printf("Error authorizing client: %v\n", err)
		return LambdaResponse{
			Status: "Failure",
		}, err
	}

	err = updateEmergencyGroupEnabled(request.GroupID, &request.EnableEmergencyGroup)
	if err != nil {
		fmt.Printf("API Error: %v\n", err)
		return LambdaResponse{
			Status: "Failure",
		}, err
	}

	return LambdaResponse{
		Status: "Success",
	}, nil
}

func updateEmergencyGroupEnabled(groupID string, enable *bool) error {
	// Get the emergency group
	fmt.Println("Getting emergency group...")
	group, response, err := api.GetArchitectEmergencygroup(groupID)
	printResponse(response)
	if err != nil {
		return err
	}

	// Set enabled to new value
	fmt.Printf("Setting enabled to '%v'...\n", *enable)
	group.Enabled = enable

	// Put the new configurations
	fmt.Println("Putting emergency group...")
	group, response, err = api.PutArchitectEmergencygroup(groupID, *group)
	printResponse(response)
	if err != nil {
		return err
	}

	return nil
}

func printResponse(response *platformclientv2.APIResponse) {
	fmt.Printf("Response:\n  Success: %v\n  Status code: %v\n  Correlation ID: %v\n", response.IsSuccess, response.StatusCode, response.CorrelationID)
}
