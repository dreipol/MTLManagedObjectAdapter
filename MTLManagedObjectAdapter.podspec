Pod::Spec.new do |s|

    s.name         = "MTLManagedObjectAdapter"
    s.version      = "1.0.4"
    s.summary      = "Model framework for Cocoa and Cocoa Touch."
  
    s.homepage     = "https://github.com/Mantle/Mantle"
    s.license      = { :type => "MIT", :file => "LICENSE.txt" }
    s.author             = { "GitHub" => "" }
    s.platform     = :ios
    s.source       = { :git => "https://github.com/dreipol/MTLManagedObjectAdapter.git", :tag => "{s.version}" }
  
    s.source_files  = "MTLManagedObjectAdapter"
    s.requires_arc = true
    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.9'
    s.tvos.deployment_target = '9.0'
    s.watchos.deployment_target = '2.0'
    s.frameworks = 'Foundation', 'CoreData'
    s.dependency 'Mantle', '~> 2.0'
    s.prepare_command = "PREFIX=\"mtl_moa_\"\n# Add prefix to header imports\next_header_prefix_src() {\n  SOURCE_FILE=$1\n  EXT_HEADER_NAME=$2\n  sed -i.bak \"s/\"${EXT_HEADER_NAME}\"/\"${PREFIX}${EXT_HEADER_NAME}\"/g\" ${SOURCE_FILE} && rm ${SOURCE_FILE}.bak\n}\next_header_prefix_src MTLManagedObjectAdapter/MTLManagedObjectAdapter.m EXTRuntimeExtensions.h\next_header_prefix_src MTLManagedObjectAdapter/MTLManagedObjectAdapter.m EXTScope.h\next_header_prefix_src MTLManagedObjectAdapter/extobjc/EXTRuntimeExtensions.m EXTRuntimeExtensions.h\next_header_prefix_src MTLManagedObjectAdapter/extobjc/EXTScope.m EXTScope.h\n# Change header name\next_header_prefix_mv() {\n  SOURCE_FILE=$1\n  FILE_NAME=`basename ${SOURCE_FILE}`\n  DIR_NAME=`dirname ${SOURCE_FILE}`\n  mv ${SOURCE_FILE} `dirname ${SOURCE_FILE}`/${PREFIX}`basename ${SOURCE_FILE}`\n}\nexport -f ext_header_prefix_mv\nexport PREFIX=${PREFIX}\nfind MTLManagedObjectAdapter/extobjc -name \"*.h\" -exec bash -c 'ext_header_prefix_mv \"$0\"' {} \\;\nunset ext_header_prefix_mv\nunset PREFIX"

    s.subspec 'extobjc' do |sdkit|
        sdkit.source_files = "MTLManagedObjectAdapter/extobjc"
        sdkit.private_header_files    = "MTLManagedObjectAdapter/extobjc/*.h"
    end
  end
