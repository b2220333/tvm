#######################################################
# Enhanced version of find Vulkan.
#
# Usage:
#   find_vulkan(${USE_VULKAN})
#
# - When USE_VULKAN=ON, use auto search
# - When USE_VULKAN=/path/to/vulkan-sdk-path, use the sdk
#
# Provide variables:
#
# - Vulkan_FOUND
# - Vulkan_INCLUDE_DIRS
# - Vulkan_LIBRARY
# - Vulkan_SPIRV_TOOLS_LIBRARY
#

macro(find_vulkan use_vulkan)
  set(__use_vulkan ${use_vulkan})
  if(IS_DIRECTORY ${__use_vulkan})
    set(__vulkan_sdk ${__use_vulkan})
    message(STATUS "Custom Vulkan SDK PATH=" ${__use_vulkan})
   elseif(IS_DIRECTORY $ENV{VULKAN_SDK})
     set(__vulkan_sdk $ENV{VULKAN_SDK})
   else()
     set(__vulkan_sdk "")
   endif()

   if(__vulkan_sdk)
     set(Vulkan_INCLUDE_DIRS ${__vulkan_sdk}/include)
     find_library(Vulkan_LIBRARY vulkan ${__vulkan_sdk}/lib)
     if(Vulkan_LIBRARY)
       set(Vulkan_FOUND TRUE)
     endif()
   endif(__vulkan_sdk)

   # resort to find vulkan of option is on
   if(NOT Vulkan_FOUND)
     if(__use_vulkan STREQUAL "ON")
       find_package(Vulkan QUIET)
     endif()
   endif()
   # additional libraries

  if(Vulkan_FOUND)
    get_filename_component(VULKAN_LIBRARY_PATH ${Vulkan_LIBRARY} DIRECTORY)
    find_library(Vulkan_SPIRV_TOOLS_LIBRARY SPIRV-Tools
      ${VULKAN_LIBRARY_PATH}/spirv-tools)
  endif(Vulkan_FOUND)
endmacro(find_vulkan)
