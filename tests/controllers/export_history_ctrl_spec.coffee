describe "ExportHistoryController", ->
  $rootScope = undefined
  $controller = undefined
  Wallet = undefined

  beforeEach angular.mock.module("walletApp")

  beforeEach ->
    angular.mock.inject ($injector, _$rootScope_, _$controller_) ->
      $rootScope = _$rootScope_
      $controller = _$controller_
      Wallet = $injector.get("Wallet")

      Wallet.legacyAddresses = () -> [
        { address: 'some_address', archived: false, isWatchOnly: false, label: 'some_label' }
        { address: 'watch_address', archived: false, isWatchOnly: true }
        { address: 'other_address', archived: true, isWatchOnly: false }
      ]

      Wallet.accounts = () -> [
        { label: "Checking", index: 0, archived: false, balance: 1, extendedPublicKey: 'xpub1' }
        { label: "Savings", index: 1, archived: false, balance: 1, extendedPublicKey: 'xpub2' }
        { label: "Something", index: 2, archived: true, extendedPublicKey: 'xpub3' }
      ]

  getCtrlScope = (activeIndex) ->
    scope = $rootScope.$new()
    $controller "ExportHistoryController",
      $scope: scope
      activeIndex: activeIndex
    scope.$digest()
    scope

  it "should create list of export targets", ->
    scope = getCtrlScope('')
    expect(scope.targets.length).toEqual(6)

  it "should have the correct active target count", ->
    scope = getCtrlScope('')
    expect(scope.activeCount).toEqual(4)

  it "should set the target to the first account when only one active is found", ->
    spyOn(Wallet, 'legacyAddresses').and.returnValue([])
    spyOn(Wallet, 'accounts').and.returnValue([{ label: "Checking", index: 0, archived: false, balance: 1, extendedPublicKey: 'xpub1' }])
    scope = getCtrlScope('')
    expect(scope.active).toEqual('xpub1')

  describe "activeIndex", ->
    it "should set all accounts when ''", ->
      scope = getCtrlScope('')
      expect(scope.active).toEqual('xpub1|xpub2')

    it "should set all addresses when 'imported'", ->
      scope = getCtrlScope('imported')
      expect(scope.active).toEqual('some_address|watch_address')

    it "should set the right account", ->
      scope = getCtrlScope(1)
      expect(scope.active).toEqual('xpub2')
