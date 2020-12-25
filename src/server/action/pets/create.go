package pets

import (
	"github.com/google/uuid"
	"github.com/jinzhu/gorm"
	"github.com/scottwinkler/terraform-aws-petstore/src/server/model/pet"
)

//CreatePetRequest request struct
type CreatePetRequest struct {
	Name    string `json:"name" binding:"required"`
	Species string `json:"species" binding:"required"`
	Age     int    `json:"age" binding:"required"`
}

//CreatePet creates a pet in database
func CreatePet(db *gorm.DB, req *CreatePetRequest) (*pet.Pet, error) {
	uuid, _ := uuid.NewRandom()
	newPet := &pet.Pet{
		ID:      uuid.String(),
		Name:    req.Name,
		Species: req.Species,
		Age:     req.Age,
	}
	id, err := pet.Create(db, newPet)
	p, err := pet.FindById(db, id)
	res := p
	return res, err
}
