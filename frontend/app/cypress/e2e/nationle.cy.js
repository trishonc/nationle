describe('nationle', () => {
  it('checks if the app works', () => {
    cy.viewport(1512, 982)
    cy.visit('')

    for (let i = 1; i <= 6; i++) {
      cy.intercept('GET', `https://nationle-resized.s3.amazonaws.com//Bulgaria/${i}.jpg*`, 
        { fixture: `/bg_photos/${i}.jpg` });
    }

    cy.intercept('GET', 'https://nationle-flags.s3.amazonaws.com/*',
    {fixture: '/bg_photos/bg.png'})

    cy.get('[data-cy="header"]').should('be.visible')
    cy.get('[data-cy="image"]').should('be.visible') 
    cy.get('[data-cy="image"]').should('have.attr', 'src').and('include', '1.jpg');
    cy.get('[data-cy="guess"]').click()
    cy.get('[data-cy="invalid_country"]').should('exist')
    

    const countries = ['France', 'Germany', 'Italy', 'Spain', 'Czechia'];
    countries.forEach((country, index) => {
    cy.get('[data-cy="input"]').type(`${country}{enter}`);
    cy.get(`[data-cy="box${index}"]`).should('have.text', country);
    cy.get('[data-cy="guess"]').should('contain', `${index + 1}/6`);
    cy.get('[data-cy="image"]').should('have.attr', 'src').and('include', `${index+2}.jpg`);
    cy.get('[data-cy="left"]').click();
    cy.get('[data-cy="image"]').should('have.attr', 'src').and('include', `${index+1}.jpg`);
    });
    cy.get('[data-cy="right"]').click();
    cy.get('[data-cy="right"]').click();
    cy.get('[data-cy="image"]').should('have.attr', 'src').and('include', '1.jpg');
    cy.get('[data-cy="left"]').click();
    cy.get('[data-cy="image"]').should('have.attr', 'src').and('include', '6.jpg');
    

    cy.get('[data-cy="input"]').type('Austria{enter}')
    cy.get('[data-cy="box5"]').should('have.text', 'Austria');
    cy.get('[data-cy="loss"]').should('be.exist')

    cy.visit('')
    for (let i = 1; i <= 6; i++) {
      cy.intercept('GET', `https://nationle-resized.s3.amazonaws.com//Bulgaria/${i}.jpg*`, 
        { fixture: `/bg_photos/${i}.jpg` });
    }

    cy.intercept('GET', 'https://nationle-flags.s3.amazonaws.com/*',
    {fixture: '/bg_photos/bg.png'})
    cy.get('[data-cy="input"]').type('Bulgaria{enter}')
    cy.get('[data-cy="box0"]').should('have.text', 'Bulgaria');
    cy.get('[data-cy="win"]').should('be.exist')



    
  })
})