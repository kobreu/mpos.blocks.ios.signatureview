Pod::Spec.new do |s|
  s.name     = 'PWBSignatureView'
  s.version  = '0.1'
  s.platform = :ios
  s.license  = {:type =>'MIT', :file =>'LICENSE'}
  s.summary  = 'Signature Field'
  s.homepage = 'http://www.payworksmobile.com'
  s.author   = { 'payworks GmbH' => 'info@payworksmobile.com' }
  s.source   = { :git => 'https://bitbucket.org/tpischke/mpos.blocks.ios.signatureview.git', :tag => 'v0.1' }
  s.description = 'UIView which accepts a User to draw a signature on screen an saves the siganture as UIImage'
  s.source_files = 'PWBSignatureView/*.{h,m}'
  s.requires_arc =  true
  s.framework = 'QuartzCore'
  s.dependency 'cocos2d', '~> 2.1'
end
