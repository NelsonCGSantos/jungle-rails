describe("Add to Cart", () => {
  beforeEach(() => {
    cy.visit("/");
  });

  it('should increase the cart count by one when "Add to Cart" is clicked', () => {
    // Ensure initial cart count is 0
    cy.get("nav").contains("My Cart (0)");

    // Click 'Add to Cart' for the first product
    cy.get(".products article").first().find("button").contains("Add").click();

    // Ensure the cart count is now 1
    cy.get("nav").contains("My Cart (1)");
  });
});
