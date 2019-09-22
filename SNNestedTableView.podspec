Pod::Spec.new do |s|

	s.name = "SNNestedTableView"
	s.version = "0.0.1"
	s.summary = "SNNestedTableView Compment"
	s.swift_version = '5.1'

	s.description = <<-DESC
			这个项目是用来实现嵌套table或collection的实现，自定义程度比较高，只需继承遵守协议即可；
						DESC
	s.homepage = "https://github.com/SpectatorNan/SNNestedTableView"
	s.license      = { :type => "MIT", :file => "LICENSE" }
	s.author             = { "spectatorNan" => "spectatornan@gmail.com" }
	s.platform     = :ios, "8.0"
	s.source       = { :git => "https://github.com/SpectatorNan/SNNestedTableView.git", :tag => "#{s.version}" }
	s.requires_arc          = true

	s.source_files = "SNNestedTableView/Lib/**/*"


end