describe("Product Details", () => {
  beforeEach(() => {
    cy.visit("/");
  });

  it("Navigates to product detail page when a product is clicked", () => {
    // Find the first product and click on it
    cy.get(".products article").first().click();

    // Assert that the product detail page is displayed
    cy.get(".product-detail").should("be.visible");

    // Optionally, verify that the URL changes as expected
    cy.url().should("include", "/products/");
  });
});
