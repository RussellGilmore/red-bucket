package test

import (
	"fmt"
	"log"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

var (
	awsRegion           = os.Getenv("AWS_REGION")
	projectName         = "red-bucket-test"
	bucketName          = strings.ToLower(random.UniqueId())
	apexDomain          = os.Getenv("APEX_DOMAIN")
	recordName          = fmt.Sprintf("%s.%s", strings.ToLower(random.UniqueId()), apexDomain)
	enableStaticWebsite = true
	opts                = &terraform.Options{
		TerraformDir: ".",
		Vars: map[string]interface{}{
			"region":                awsRegion,
			"project_name":          projectName,
			"bucket_name":           bucketName,
			"apex_domain":           apexDomain,
			"record_name":           recordName,
			"enable_static_website": enableStaticWebsite,
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

func verifyRedBucketNames(t *testing.T) {
	actualBucketName := terraform.Output(t, opts, "red_bucket_name")
	expectedBucketName := projectName + "-" + bucketName + "-s3"
	assert.Equal(t, expectedBucketName, actualBucketName)
}

func createTestSite() {
	// Create the test-site directory
	err := os.Mkdir("test-site", 0755)
	if err != nil {
		log.Fatal(err)
	}

	// Create the index.html file
	file, err := os.Create("test-site/index.html")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// Write "Hello World" to the index.html file
	_, err = file.WriteString("Hello World")
	if err != nil {
		log.Fatal(err)
	}
}

func cleanupTestSite() {
	err := os.RemoveAll("test-site")
	if err != nil {
		log.Fatal(err)
	}
}

// Test the red bucket terraform module
func TestRedBucket(t *testing.T) {
	defer test_structure.RunTestStage(t, "terraform_destroy", func() {
		cleanupTestSite()
		destroyTerraform(t)
	})

	test_structure.RunTestStage(t, "terraform_init_and_apply", func() {
		createTestSite()
		deployTerraform(t)
	})

	test_structure.RunTestStage(t, "validate_red_bucket_names", func() {
		verifyRedBucketNames(t)
	})
}
