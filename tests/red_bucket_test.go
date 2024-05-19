package test

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

var (
	awsRegion   = os.Getenv("AWS_REGION")
	projectName = fmt.Sprintf("red-bucket-%s", strings.ToLower(random.UniqueId()))
	opts        = &terraform.Options{
		TerraformDir: ".",
		Vars: map[string]interface{}{
			"region":       awsRegion,
			"project_name": projectName,
		},
	}
)

// Destroy the terraform code
func destroyTerraform(t *testing.T) {
	terraform.Destroy(t, opts)
}

// Deploy the terraform code
func deployTerraform(t *testing.T) {
	_, err := terraform.InitAndApplyE(t, opts)
	if err != nil {
		terraform.Apply(t, opts)
	}
}

func verifyRedBackendNames(t *testing.T) {
	bucketName := terraform.Output(t, opts, "red_bucket_s3_bucket")
	expectedBucketName := projectName + "-s3"
	assert.Equal(t, expectedBucketName, bucketName)
}

// Test the red bucket terraform module
func TestRedBackend(t *testing.T) {
	defer test_structure.RunTestStage(t, "terraform_destroy", func() {
		destroyTerraform(t)
	})

	test_structure.RunTestStage(t, "terraform_init_and_apply", func() {
		deployTerraform(t)
	})

	test_structure.RunTestStage(t, "validate_red_backend_names", func() {
		verifyRedBackendNames(t)
	})
}
