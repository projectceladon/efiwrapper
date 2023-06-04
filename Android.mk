EFIWRAPPER_LOCAL_PATH := $(call my-dir)
EFIWRAPPER_CFLAGS := -Wall -Wextra -Werror

ifeq ($(TARGET_UEFI_ARCH),x86_64)
EFIWRAPPER_CFLAGS += -DBUILD_X64
EFIWRAPPER_CFLAGS += -D__STDC_VERSION__=199901L
endif

ifeq ($(TARGET_BUILD_VARIANT),user)
    EFIWRAPPER_CFLAGS += -DUSER -DUSERDEBUG
endif

ifeq ($(TARGET_BOARD_PLATFORM),icelakeu)
    EFIWRAPPER_CFLAGS += -DPLATFORM_ICELAKE
endif

ifeq ($(TARGET_BOARD_PLATFORM),tigerlake)
    EFIWRAPPER_CFLAGS += -DPLATFORM_TIGERLAKE
endif

ifeq ($(TARGET_BOARD_PLATFORM),kabylake)
    EFIWRAPPER_CFLAGS += -DPLATFORM_KABYLAKE
endif

ifeq ($(TARGET_BOARD_PLATFORM),broxton)
    EFIWRAPPER_CFLAGS += -DPLATFORM_BROXTON
endif

ifeq ($(EFIWRAPPER_USE_EC_UART),true)
    EFIWRAPPER_CFLAGS += -DEFIWRAPPER_USE_EC_UART
endif

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
    EFIWRAPPER_CFLAGS += -DUSERDEBUG
endif

ifeq ($(CAPSULE_SOURCE),abl)
    EFIWRAPPER_CFLAGS += -DCAPSULE4ABL
endif

ifeq ($(CAPSULE_SOURCE),sbl)
    EFIWRAPPER_CFLAGS += -DCAPSULE4SBL
endif

EFIWRAPPER_CFLAGS += -DPRODUCT_NAME=\"$(TARGET_PRODUCT)\"

ifeq ($(PRODUCT_MANUFACTURER),)
    EFIWRAPPER_CFLAGS += -DPRODUCT_MANUFACTURER=\"unknown\"
else
    EFIWRAPPER_CFLAGS += -DPRODUCT_MANUFACTURER=\"$(PRODUCT_MANUFACTURER)\"
endif
ifeq ($(TARGET_BOARD_PLATFORM),celadon)
    EFIWRAPPER_CFLAGS += -DPLATFORM_CELADON
endif
ifeq ($(KERNELFLINGER_DISABLE_DEBUG_PRINT),true)
    EFIWRAPPER_CFLAGS += -DDISABLE_DEBUG_PRINT
endif

ifeq ($(IOC_USE_SLCAN),true)
    EFIWRAPPER_CFLAGS += -DIOC_USE_SLCAN
else ifeq ($(IOC_USE_CBC),true)
    EFIWRAPPER_CFLAGS += -DIOC_USE_CBC
endif

EFIWRAPPER_HOST_CFLAGS := \
	$(EFIWRAPPER_CFLAGS) \
	-fshort-wchar \
	-DEFI_FUNCTION_WRAPPER \
	-DGNU_EFI_USE_MS_ABI \
	-DHOST

ifeq ($(TARGET_IAFW_ARCH),x86_64)
    EFIWRAPPER_HOST_ARCH += x86_64
else
    EFIWRAPPER_HOST_ARCH += x86
endif

EFIWRAPPER_HOST_C_INCLUDES := \
	external/gnu-efi/gnu-efi-3.0/inc \
	external/gnu-efi/gnu-efi-3.0/inc/$(TARGET_EFI_ARCH_NAME) \
	external/gnu-efi/gnu-efi-3.0/inc/protocol

include $(call all-subdir-makefiles)

include $(CLEAR_VARS)
LOCAL_PATH := $(EFIWRAPPER_LOCAL_PATH)
LOCAL_MODULE := efiwrapper-$(TARGET_BUILD_VARIANT)
LOCAL_STATIC_LIBRARIES := \
	libefiwrapper-$(TARGET_BUILD_VARIANT) \
	libgnuefi \
	libefi \
	libefiwrapper_drivers-$(TARGET_BUILD_VARIANT)
LOCAL_CFLAGS := $(EFIWRAPPER_CFLAGS)
LOCAL_SRC_FILES := \
	main.c
include $(BUILD_IAFW_STATIC_LIBRARY)
