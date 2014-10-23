From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/6] e2fsprogs: define bitwise types and annotate conversion
 routines
Date: Thu, 23 Oct 2014 16:27:14 -0500
Message-ID: <544972B2.9000502@redhat.com>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaJWV1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 17:27:16 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLRF5B026118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:27:16 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com [10.11.146.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLREMb013669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:27:15 -0400
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This lays the groundwork for sparse-checking e2fsprogs for
endianness; defines bitwise types, and fixes up the ext2fs_*
swapping routines to do the proper casts.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/jfs_user.h          |    3 --
 lib/blkid/blkid_types.h.in |   15 +++++++++++++
 lib/ext2fs/bitops.h        |   50 ++++++++++++++++++++++---------------------
 lib/ext2fs/ext2_types.h.in |   15 +++++++++++++
 lib/ext2fs/ext2fs.h        |    6 -----
 5 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index cbc14e8..f05c18c 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -87,9 +87,6 @@ typedef struct {
 
 #define cond_resched()	do { } while (0)
 
-typedef unsigned int __be32;
-typedef __u64 __be64;
-
 #define __init
 
 /*
diff --git a/lib/blkid/blkid_types.h.in b/lib/blkid/blkid_types.h.in
index d4c81d0..2bb3d85 100644
--- a/lib/blkid/blkid_types.h.in
+++ b/lib/blkid/blkid_types.h.in
@@ -164,4 +164,19 @@ typedef long		__s64;
 #undef __S64_TYPEDEF
 #undef __U64_TYPEDEF
 
+#ifdef __CHECKER__
+#define __bitwise		__attribute__((bitwise))
+#define __force			__attribute__((force))
+#else
+#define __bitwise
+#define __force
+#endif
+
+typedef __u16	__bitwise	__le16;
+typedef __u32	__bitwise	__le32;
+typedef __u64	__bitwise	__le64;
+typedef __u16	__bitwise	__be16;
+typedef __u32	__bitwise	__be32;
+typedef __u64	__bitwise	__be64;
+
 #endif /* _*_TYPES_H */
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 4fb7dc6..bc59608 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -11,31 +11,33 @@
  */
 
 #ifdef WORDS_BIGENDIAN
-#define ext2fs_cpu_to_le64(x) ext2fs_swab64((x))
-#define ext2fs_le64_to_cpu(x) ext2fs_swab64((x))
-#define ext2fs_cpu_to_le32(x) ext2fs_swab32((x))
-#define ext2fs_le32_to_cpu(x) ext2fs_swab32((x))
-#define ext2fs_cpu_to_le16(x) ext2fs_swab16((x))
-#define ext2fs_le16_to_cpu(x) ext2fs_swab16((x))
-#define ext2fs_cpu_to_be64(x) ((__u64)(x))
-#define ext2fs_be64_to_cpu(x) ((__u64)(x))
-#define ext2fs_cpu_to_be32(x) ((__u32)(x))
-#define ext2fs_be32_to_cpu(x) ((__u32)(x))
-#define ext2fs_cpu_to_be16(x) ((__u16)(x))
-#define ext2fs_be16_to_cpu(x) ((__u16)(x))
+#define ext2fs_cpu_to_le64(x) ((__force __le64)ext2fs_swab64((__u64)(x)))
+#define ext2fs_le64_to_cpu(x) ext2fs_swab64((__force __u64)(__le64)(x))
+#define ext2fs_cpu_to_le32(x) ((__force __le32)ext2fs_swab32((__u32)(x)))
+#define ext2fs_le32_to_cpu(x) ext2fs_swab32((__force __u32)(__le32)(x))
+#define ext2fs_cpu_to_le16(x) ((__force __le16)ext2fs_swab16((__u16)(x)))
+#define ext2fs_le16_to_cpu(x) ext2fs_swab16((__force __u16)(__le16)(x))
+
+#define ext2fs_cpu_to_be64(x) ((__force __be64)(__u64)(x))
+#define ext2fs_be64_to_cpu(x) ((__force __u64)(__be64)(x))
+#define ext2fs_cpu_to_be32(x) ((__force __be32)(__u32)(x))
+#define ext2fs_be32_to_cpu(x) ((__force __u32)(__be32)(x))
+#define ext2fs_cpu_to_be16(x) ((__force __be16)(__u16)(x))
+#define ext2fs_be16_to_cpu(x) ((__force __u16)(__be16)(x))
 #else
-#define ext2fs_cpu_to_le64(x) ((__u64)(x))
-#define ext2fs_le64_to_cpu(x) ((__u64)(x))
-#define ext2fs_cpu_to_le32(x) ((__u32)(x))
-#define ext2fs_le32_to_cpu(x) ((__u32)(x))
-#define ext2fs_cpu_to_le16(x) ((__u16)(x))
-#define ext2fs_le16_to_cpu(x) ((__u16)(x))
-#define ext2fs_cpu_to_be64(x) ext2fs_swab64((x))
-#define ext2fs_be64_to_cpu(x) ext2fs_swab64((x))
-#define ext2fs_cpu_to_be32(x) ext2fs_swab32((x))
-#define ext2fs_be32_to_cpu(x) ext2fs_swab32((x))
-#define ext2fs_cpu_to_be16(x) ext2fs_swab16((x))
-#define ext2fs_be16_to_cpu(x) ext2fs_swab16((x))
+#define ext2fs_cpu_to_le64(x) ((__force __le64)(__u64)(x))
+#define ext2fs_le64_to_cpu(x) ((__force __u64)(__le64)(x))
+#define ext2fs_cpu_to_le32(x) ((__force __le32)(__u32)(x))
+#define ext2fs_le32_to_cpu(x) ((__force __u32)(__le32)(x))
+#define ext2fs_cpu_to_le16(x) ((__force __le16)(__u16)(x))
+#define ext2fs_le16_to_cpu(x) ((__force __u16)(__le16)(x))
+
+#define ext2fs_cpu_to_be64(x) ((__force __be64)ext2fs_swab64((__u64)(x)))
+#define ext2fs_be64_to_cpu(x) ext2fs_swab64((__force __u64)(__be64)(x))
+#define ext2fs_cpu_to_be32(x) ((__force __be32)ext2fs_swab32((__u32)(x)))
+#define ext2fs_be32_to_cpu(x) ext2fs_swab32((__force __u32)(__be32)(x))
+#define ext2fs_cpu_to_be16(x) ((__force __be16)ext2fs_swab16((__u16)(x)))
+#define ext2fs_be16_to_cpu(x) ext2fs_swab16((__force __u16)(__be16)(x))
 #endif
 
 /*
diff --git a/lib/ext2fs/ext2_types.h.in b/lib/ext2fs/ext2_types.h.in
index 1320431..a00ed7f 100644
--- a/lib/ext2fs/ext2_types.h.in
+++ b/lib/ext2fs/ext2_types.h.in
@@ -164,6 +164,21 @@ typedef long		__s64;
 #undef __S64_TYPEDEF
 #undef __U64_TYPEDEF
 
+#ifdef __CHECKER__
+#define __bitwise		__attribute__((bitwise))
+#define __force			__attribute__((force))
+#else
+#define __bitwise
+#define __force
+#endif
+
+typedef __u16	__bitwise	__le16;
+typedef __u32	__bitwise	__le32;
+typedef __u64	__bitwise	__le64;
+typedef __u16	__bitwise	__be16;
+typedef __u32	__bitwise	__be32;
+typedef __u64	__bitwise	__be64;
+
 #endif /* _*_TYPES_H */
 
 @PUBLIC_CONFIG_HEADER@
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index fef6910..506d43b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -66,12 +66,6 @@ extern "C" {
 #include <ext2fs/ext3_extents.h>
 #endif /* EXT2_FLAT_INCLUDES */
 
-#ifdef __CHECK_ENDIAN__
-#define __bitwise __attribute__((bitwise))
-#else
-#define __bitwise
-#endif
