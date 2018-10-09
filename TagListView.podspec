Pod::Spec.new do |s|
  s.name         = "TagListView"
  s.version      = "2.0.0"
  s.summary      = "Simple but highly customizable iOS tag list view, in Swift."
  s.homepage     = "https://github.com/ElaWorkshop/TagListView"
  s.social_media_url = "http://twitter.com/elabuild"

  s.license      = "MIT"
  s.author       = { "LIU Dongyuan" => "liu.dongyuan@gmail.com" }

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/ios-vidiemme-bucket/TagListView.git", :tag => s.version }
  s.source_files = "TagListView/*.swift"
  s.resources    = "TagListView/*.xib"
  s.requires_arc = true
end
