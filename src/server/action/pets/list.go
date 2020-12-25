package pets

import (
	"github.com/jinzhu/gorm"
	"github.com/scottwinkler/terraform-aws-petstore/src/server/model/pet"
)

//ListPetRequest request struct
type ListPetsRequest struct {
	Limit uint
}

//ListPetResponse response struct
type ListPetsResponse struct {
	Items *[]pet.Pet `json:"items"`
}

//ListPets returns a list of pets from database
func ListPets(db *gorm.DB, req *ListPetsRequest) (*ListPetsResponse, error) {
	pets, err := pet.List(db, req.Limit)
	res := &ListPetsResponse{Items: pets}
	return res, err
}
