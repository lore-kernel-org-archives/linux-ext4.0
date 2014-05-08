From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] blkid,ext2fs: avoid name clash with __u{8,16,32,64}
Date: Thu,  8 May 2014 15:23:56 -0600
Message-ID: <1399584236-17686-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:36390 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaEHVde (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 May 2014 17:33:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Try to avoid name clashes with definitions of __u8, __u16, __u32,
and __u64 in userspace, in case other headers also define these
types.  Define HAVE___{S,U}{8,16,32,64} preprocessor macros to
show that these types are already defined.

This would avoid the need to check for _BLKID_TYPES_H in ext2_types.h
and _EXT2_TYPES_H in blkid_types.h, but since older versions of these
headers did not use HAVE___U8 et.al. keep these checks around for now.

Report an error if there are no 64-bit types available.  The code
will not compile if these are not available.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/blkid/blkid_types.h.in |   39 ++++++++++++++++++++++++++++++++++++---
 lib/ext2fs/ext2_types.h.in |   35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/lib/blkid/blkid_types.h.in b/lib/blkid/blkid_types.h.in
index 2edc0da..d4c81d0 100644
--- a/lib/blkid/blkid_types.h.in
+++ b/lib/blkid/blkid_types.h.in
@@ -9,18 +9,26 @@
 
 @ASM_TYPES_HEADER@
 
+#ifndef HAVE___U8
+#define HAVE___U8
 #ifdef __U8_TYPEDEF
 typedef __U8_TYPEDEF __u8;
 #else
 typedef unsigned char __u8;
 #endif
+#endif /* HAVE___U8 */
 
+#ifndef HAVE___S8
+#define HAVE___S8
 #ifdef __S8_TYPEDEF
 typedef __S8_TYPEDEF __s8;
 #else
 typedef signed char __s8;
 #endif
+#endif /* HAVE___S8 */
 
+#ifndef HAVE___U16
+#define HAVE___U16
 #ifdef __U16_TYPEDEF
 typedef __U16_TYPEDEF __u16;
 #else
@@ -30,11 +38,15 @@ typedef	unsigned int	__u16;
 #if (@SIZEOF_SHORT@ == 2)
 typedef	unsigned short	__u16;
 #else
+#undef HAVE___U16
   ?==error: undefined 16 bit type
 #endif /* SIZEOF_SHORT == 2 */
 #endif /* SIZEOF_INT == 2 */
 #endif /* __U16_TYPEDEF */
+#endif /* HAVE___U16 */
 
+#ifndef HAVE___S16
+#define HAVE___S16
 #ifdef __S16_TYPEDEF
 typedef __S16_TYPEDEF __s16;
 #else
@@ -44,12 +56,15 @@ typedef	int		__s16;
 #if (@SIZEOF_SHORT@ == 2)
 typedef	short		__s16;
 #else
+#undef HAVE___S16
   ?==error: undefined 16 bit type
 #endif /* SIZEOF_SHORT == 2 */
 #endif /* SIZEOF_INT == 2 */
 #endif /* __S16_TYPEDEF */
+#endif /* HAVE___S16 */
 
-
+#ifndef HAVE___U32
+#define HAVE___U32
 #ifdef __U32_TYPEDEF
 typedef __U32_TYPEDEF __u32;
 #else
@@ -62,12 +77,16 @@ typedef	unsigned long	__u32;
 #if (@SIZEOF_SHORT@ == 4)
 typedef	unsigned short	__u32;
 #else
+#undef HAVE___U32
  ?== error: undefined 32 bit type
 #endif /* SIZEOF_SHORT == 4 */
 #endif /* SIZEOF_LONG == 4 */
 #endif /* SIZEOF_INT == 4 */
 #endif /* __U32_TYPEDEF */
+#endif /* HAVE___U32 */
 
+#ifndef HAVE___S32
+#define HAVE___S32
 #ifdef __S32_TYPEDEF
 typedef __S32_TYPEDEF __s32;
 #else
@@ -80,12 +99,16 @@ typedef	long		__s32;
 #if (@SIZEOF_SHORT@ == 4)
 typedef	short		__s32;
 #else
+#undef HAVE___S32
  ?== error: undefined 32 bit type
 #endif /* SIZEOF_SHORT == 4 */
 #endif /* SIZEOF_LONG == 4 */
 #endif /* SIZEOF_INT == 4 */
 #endif /* __S32_TYPEDEF */
+#endif /* HAVE___S32 */
 
+#ifndef HAVE___U64
+#define HAVE___U64
 #ifdef __U64_TYPEDEF
 typedef __U64_TYPEDEF __u64;
 #else
@@ -97,11 +120,17 @@ typedef unsigned long long	__u64;
 #else
 #if (@SIZEOF_LONG@ == 8)
 typedef unsigned long	__u64;
+#else
+#undef HAVE___U64
+ ?== error: undefined 64 bit type
 #endif /* SIZEOF_LONG == 8 */
 #endif /* SIZEOF_LONG_LONG == 8 */
 #endif /* SIZEOF_INT == 8 */
 #endif /* __U64_TYPEDEF */
+#endif /* HAVE___U64 */
 
+#ifndef HAVE___S64
+#define HAVE___S64
 #ifdef __S64_TYPEDEF
 typedef __S64_TYPEDEF __s64;
 #else
@@ -110,17 +139,21 @@ typedef int		__s64;
 #else
 #if (@SIZEOF_LONG_LONG@ == 8)
 #if defined(__GNUC__)
-typedef __signed__ long long 	__s64;
+typedef __signed__ long long	__s64;
 #else
-typedef signed long long 	__s64;
+typedef signed long long	__s64;
 #endif /* __GNUC__ */
 #else
 #if (@SIZEOF_LONG@ == 8)
 typedef long		__s64;
+#else
+#undef HAVE___S64
+ ?== error: undefined 64 bit type
 #endif /* SIZEOF_LONG == 8 */
 #endif /* SIZEOF_LONG_LONG == 8 */
 #endif /* SIZEOF_INT == 8 */
 #endif /* __S64_TYPEDEF */
+#endif /* HAVE___S64 */
 
 #undef __S8_TYPEDEF
 #undef __U8_TYPEDEF
diff --git a/lib/ext2fs/ext2_types.h.in b/lib/ext2fs/ext2_types.h.in
index 5b98f71..1320431 100644
--- a/lib/ext2fs/ext2_types.h.in
+++ b/lib/ext2fs/ext2_types.h.in
@@ -9,18 +9,26 @@
 
 @ASM_TYPES_HEADER@
 
+#ifndef HAVE___U8
+#define HAVE___U8
 #ifdef __U8_TYPEDEF
 typedef __U8_TYPEDEF __u8;
 #else
 typedef unsigned char __u8;
 #endif
+#endif /* HAVE___U8 */
 
+#ifndef HAVE___S8
+#define HAVE___S8
 #ifdef __S8_TYPEDEF
 typedef __S8_TYPEDEF __s8;
 #else
 typedef signed char __s8;
 #endif
+#endif /* HAVE___S8 */
 
+#ifndef HAVE___U16
+#define HAVE___U16
 #ifdef __U16_TYPEDEF
 typedef __U16_TYPEDEF __u16;
 #else
@@ -30,11 +38,15 @@ typedef	unsigned int	__u16;
 #if (@SIZEOF_SHORT@ == 2)
 typedef	unsigned short	__u16;
 #else
+#undef HAVE___U16
   ?==error: undefined 16 bit type
 #endif /* SIZEOF_SHORT == 2 */
 #endif /* SIZEOF_INT == 2 */
 #endif /* __U16_TYPEDEF */
+#endif /* HAVE___U16 */
 
+#ifndef HAVE___S16
+#define HAVE___S16
 #ifdef __S16_TYPEDEF
 typedef __S16_TYPEDEF __s16;
 #else
@@ -44,12 +56,15 @@ typedef	int		__s16;
 #if (@SIZEOF_SHORT@ == 2)
 typedef	short		__s16;
 #else
+#undef HAVE___S16
   ?==error: undefined 16 bit type
 #endif /* SIZEOF_SHORT == 2 */
 #endif /* SIZEOF_INT == 2 */
 #endif /* __S16_TYPEDEF */
+#endif /* HAVE___S16 */
 
-
+#ifndef HAVE___U32
+#define HAVE___U32
 #ifdef __U32_TYPEDEF
 typedef __U32_TYPEDEF __u32;
 #else
@@ -62,12 +77,16 @@ typedef	unsigned long	__u32;
 #if (@SIZEOF_SHORT@ == 4)
 typedef	unsigned short	__u32;
 #else
+#undef HAVE___U32
  ?== error: undefined 32 bit type
 #endif /* SIZEOF_SHORT == 4 */
 #endif /* SIZEOF_LONG == 4 */
 #endif /* SIZEOF_INT == 4 */
 #endif /* __U32_TYPEDEF */
+#endif /* HAVE___U32 */
 
+#ifndef HAVE___S32
+#define HAVE___S32
 #ifdef __S32_TYPEDEF
 typedef __S32_TYPEDEF __s32;
 #else
@@ -80,12 +99,16 @@ typedef	long		__s32;
 #if (@SIZEOF_SHORT@ == 4)
 typedef	short		__s32;
 #else
+#undef HAVE___S32
  ?== error: undefined 32 bit type
 #endif /* SIZEOF_SHORT == 4 */
 #endif /* SIZEOF_LONG == 4 */
 #endif /* SIZEOF_INT == 4 */
 #endif /* __S32_TYPEDEF */
+#endif /* HAVE___S32 */
 
+#ifndef HAVE___U64
+#define HAVE___U64
 #ifdef __U64_TYPEDEF
 typedef __U64_TYPEDEF __u64;
 #else
@@ -97,11 +120,17 @@ typedef unsigned long long	__u64;
 #else
 #if (@SIZEOF_LONG@ == 8)
 typedef unsigned long	__u64;
+#else
+#undef HAVE___U64
+ ?== error: undefined 64 bit type
 #endif /* SIZEOF_LONG_LONG == 8 */
 #endif /* SIZEOF_LONG == 8 */
 #endif /* SIZEOF_INT == 8 */
 #endif /* __U64_TYPEDEF */
+#endif /* HAVE___U64 */
 
+#ifndef HAVE___S64
+#define HAVE___S64
 #ifdef __S64_TYPEDEF
 typedef __S64_TYPEDEF __s64;
 #else
@@ -117,10 +146,14 @@ typedef signed long long	__s64;
 #else
 #if (@SIZEOF_LONG@ == 8)
 typedef long		__s64;
+#else
+#undef HAVE___S64
+ ?== error: undefined 64 bit type
 #endif /* SIZEOF_LONG_LONG == 8 */
 #endif /* SIZEOF_LONG == 8 */
 #endif /* SIZEOF_INT == 8 */
 #endif /* __S64_TYPEDEF */
+#endif /* HAVE___S64 */
 
 #undef __S8_TYPEDEF
 #undef __U8_TYPEDEF
-- 
1.7.3.4

