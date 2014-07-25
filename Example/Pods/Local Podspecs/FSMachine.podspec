Pod::Spec.new do |s|
  s.name             = "FSMachine"
  s.version          = "1.0.0"
  s.summary          = "A straightforward state machine."
  s.description      = <<-DESC
                       A straightforward state machine implementation in Obj-C.

                       Features:

                       * Support for Moore and Mealy-style machines
                       * Actions on state enter/exit, and during transitions
                       * Conditional transitions
                       * Up-front machine validation
                       * Configurable logging
                       DESC
  s.homepage         = "https://github.com/danhawkes/FSMachine"
  s.license          = 'Apache 2.0'
  s.author           = { "danhawkes" => "dan@arcs.co" }
  s.source           = { :git => "https://github.com/danhawkes/FSMachine.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes'
end
