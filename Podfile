source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "7.0"

inhibit_all_warnings!  # Not much you can do about warnings on Pods anyway

pod 'CocoaLumberjack', '~> 1.9.1'
pod 'MagicalRecord'


# HOW TO TURN ON LOGGING OF MAGICAL RECORD:

# UNCOMMENT THIS BELOW, THEN RUN pod update ON THIS PROJECT, clean and rebuild.  (This code disables logging, which is quite verbose)

enableMRLogging = false

if enableMRLogging then

    post_install do |installer|
        target = installer.project.targets.find{|t| t.to_s == "Pods-MagicalRecord"}
        target.build_configurations.each do |config|
            s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
            s = [ '$(inherited)' ] if s == nil;
            s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0') if config.to_s == "Debug";
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
        end
    end

end