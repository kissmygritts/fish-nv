const { expect, matchTemplate, MatchStyle } = require('@aws-cdk/assert');
const cdk = require('@aws-cdk/core');
const FrontendService = require('../lib/frontend-service-stack');

test('Empty Stack', () => {
    const app = new cdk.App();
    // WHEN
    const stack = new FrontendService.FrontendServiceStack(app, 'MyTestStack');
    // THEN
    expect(stack).to(matchTemplate({
      "Resources": {}
    }, MatchStyle.EXACT))
});
