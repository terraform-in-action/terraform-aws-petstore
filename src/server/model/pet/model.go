package pet

type Pet struct {
	ID      string `gorm:"primary_key" json:"id"`
	Name    string `json:"name"`
	Species string `json:"species"`
	Age     int    `json:"age"`
}
