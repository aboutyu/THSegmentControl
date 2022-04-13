
Pod::Spec.new do |spec|

  spec.name             = "THSegmentControl"
  spec.version          = "1.0.1"
  spec.summary          = "Super Easy SegmentControl."
  spec.description      = "This is Super Easy SegmentControl."
  spec.homepage         = "https://github.com/aboutyu/THSegmentControl"
  spec.license          = { :type => "MIT", :file => "LICENSE" }
  spec.author           = { "James" => "aboutyu@gmail.com" }
  spec.platform         = :ios, "14.5"
  spec.swift_version    = '5.0'
  spec.swift_version    = spec.swift_version.to_s
  spec.source           = { :git => "https://github.com/aboutyu/THSegmentControl.git", :tag => spec.version }
  spec.source_files     = "THSegmentControl/lib/*.swift"

end

