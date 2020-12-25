package pets

import (
	"fmt"

	"github.com/jinzhu/gorm"
	"github.com/scottwinkler/terraform-aws-petstore/src/server/model/pet"
)

//UpdatePetRequest request struct
type UpdatePetRequest struct {
	ID      string
	Name    string `json:"name"`
	Species string `json:"species"`
	Age     int    `json:"age"`
}

//UpdatePet updates a pet from database
func UpdatePet(db *gorm.DB, req *UpdatePetRequest) (*pet.Pet, error) {
	p, err := pet.FindById(db, req.ID)
	if err != nil {
		return nil, err
	}
	if len(req.Name) > 0 {
		p.Name = req.Name
	}
	if req.Age > 0 {
		p.Age = req.Age
	}
	if len(req.Species) > 0 {
		p.Species = req.Species
	}
	fmt.Printf("requested: %v", p)
	err = pet.Update(db, p)
	if err != nil {
		return nil, err
	}
	p, err = pet.FindById(db, req.ID)
	fmt.Printf("new: %v", p)
	res := p
	return res, err
}
