Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38C8C282DF
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77F8218AE
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555630228;
	bh=dTyhSc/O0SkFAocISfOv3+cMBSo+CGvkbVDnhYr6Ahc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HFray1X/C/LnYPOnkIYWT5VNyE8tNiB13k9ijl5PmLBS8PNNAGglwJ+MnPlV1utEz
	 XJst5IkGWdueX1Uj2Jn8u7K8isVl5Xo5vOkls0JmKG4g1iidlQfvrJBYAr+mf0ttQP
	 VtgWR69uZUwRRnGwvANexlGYLQ4v9LMR1aVVUIIw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfDRXa1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 19:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfDRXa0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 19:30:26 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB1E2217D7;
        Thu, 18 Apr 2019 23:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555630225;
        bh=dTyhSc/O0SkFAocISfOv3+cMBSo+CGvkbVDnhYr6Ahc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+Mjf0Cg0DTpP4lt8uIiO2MYHOgSdpzRZsogZ0fpaf/2nfRP6OSgktd/kCbhO0N8V
         BBdSdLzBnG2fBr9zgZTmBGlIKrYGkKTgn0RLFbF0U0svd8u4ywkv0Dj1mvk3wO2RKN
         mgvrcdhWx6VPAkyeh/R9mh/sCKnmvH6kEoMEgEb8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v5 01/16] fs, fscrypt: move uapi definitions to new header <linux/fscrypt.h>
Date:   Thu, 18 Apr 2019 16:29:08 -0700
Message-Id: <20190418232923.250800-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190418232923.250800-1-ebiggers@kernel.org>
References: <20190418232923.250800-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

More fscrypt definitions are being added, and we shouldn't use a
disproportionate amount of space in <linux/fs.h> for fscrypt stuff.
So move the fscrypt definitions to a new header <linux/fscrypt.h>.

For source compatibility with existing userspace programs, <linux/fs.h>
still includes the new header.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS                  |  1 +
 include/linux/fscrypt.h      |  1 +
 include/uapi/linux/fs.h      | 54 ++-------------------------------
 include/uapi/linux/fscrypt.h | 58 ++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 51 deletions(-)
 create mode 100644 include/uapi/linux/fscrypt.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3671fdea5010e..8228ba0713ab3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6352,6 +6352,7 @@ T:	git git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
 S:	Supported
 F:	fs/crypto/
 F:	include/linux/fscrypt*.h
+F:	include/uapi/linux/fscrypt.h
 F:	Documentation/filesystems/fscrypt.rst
 
 FSI-ATTACHED I2C DRIVER
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 28c74e0a72310..1ed0bc2b75f3c 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <uapi/linux/fscrypt.h>
 
 #define FS_CRYPTO_BLOCK_SIZE		16
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 121e82ce296b5..0f4e66b1bcd09 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -13,6 +13,9 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#ifndef __KERNEL__
+#include <linux/fscrypt.h>
+#endif
 
 /* Use of MS_* flags within the kernel is restricted to core mount(2) code. */
 #if !defined(__KERNEL__)
@@ -212,57 +215,6 @@ struct fsxattr {
 #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
 #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 
-/*
- * File system encryption support
- */
-/* Policy provided via an ioctl on the topmost directory */
-#define FS_KEY_DESCRIPTOR_SIZE	8
-
-#define FS_POLICY_FLAGS_PAD_4		0x00
-#define FS_POLICY_FLAGS_PAD_8		0x01
-#define FS_POLICY_FLAGS_PAD_16		0x02
-#define FS_POLICY_FLAGS_PAD_32		0x03
-#define FS_POLICY_FLAGS_PAD_MASK	0x03
-#define FS_POLICY_FLAG_DIRECT_KEY	0x04	/* use master key directly */
-#define FS_POLICY_FLAGS_VALID		0x07
-
-/* Encryption algorithms */
-#define FS_ENCRYPTION_MODE_INVALID		0
-#define FS_ENCRYPTION_MODE_AES_256_XTS		1
-#define FS_ENCRYPTION_MODE_AES_256_GCM		2
-#define FS_ENCRYPTION_MODE_AES_256_CBC		3
-#define FS_ENCRYPTION_MODE_AES_256_CTS		4
-#define FS_ENCRYPTION_MODE_AES_128_CBC		5
-#define FS_ENCRYPTION_MODE_AES_128_CTS		6
-#define FS_ENCRYPTION_MODE_SPECK128_256_XTS	7 /* Removed, do not use. */
-#define FS_ENCRYPTION_MODE_SPECK128_256_CTS	8 /* Removed, do not use. */
-#define FS_ENCRYPTION_MODE_ADIANTUM		9
-
-struct fscrypt_policy {
-	__u8 version;
-	__u8 contents_encryption_mode;
-	__u8 filenames_encryption_mode;
-	__u8 flags;
-	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
-};
-
-#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
-#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
-#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
-
-/* Parameters for passing an encryption key into the kernel keyring */
-#define FS_KEY_DESC_PREFIX		"fscrypt:"
-#define FS_KEY_DESC_PREFIX_SIZE		8
-
-/* Structure that userspace passes to the kernel keyring */
-#define FS_MAX_KEY_SIZE			64
-
-struct fscrypt_key {
-	__u32 mode;
-	__u8 raw[FS_MAX_KEY_SIZE];
-	__u32 size;
-};
-
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  *
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
new file mode 100644
index 0000000000000..193339cb53fdb
--- /dev/null
+++ b/include/uapi/linux/fscrypt.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_FSCRYPT_H
+#define _UAPI_LINUX_FSCRYPT_H
+
+#include <linux/types.h>
+
+/*
+ * File system encryption support
+ */
+/* Policy provided via an ioctl on the topmost directory */
+#define FS_KEY_DESCRIPTOR_SIZE	8
+
+#define FS_POLICY_FLAGS_PAD_4		0x00
+#define FS_POLICY_FLAGS_PAD_8		0x01
+#define FS_POLICY_FLAGS_PAD_16		0x02
+#define FS_POLICY_FLAGS_PAD_32		0x03
+#define FS_POLICY_FLAGS_PAD_MASK	0x03
+#define FS_POLICY_FLAG_DIRECT_KEY	0x04	/* use master key directly */
+#define FS_POLICY_FLAGS_VALID		0x07
+
+/* Encryption algorithms */
+#define FS_ENCRYPTION_MODE_INVALID		0
+#define FS_ENCRYPTION_MODE_AES_256_XTS		1
+#define FS_ENCRYPTION_MODE_AES_256_GCM		2
+#define FS_ENCRYPTION_MODE_AES_256_CBC		3
+#define FS_ENCRYPTION_MODE_AES_256_CTS		4
+#define FS_ENCRYPTION_MODE_AES_128_CBC		5
+#define FS_ENCRYPTION_MODE_AES_128_CTS		6
+#define FS_ENCRYPTION_MODE_SPECK128_256_XTS	7 /* Removed, do not use. */
+#define FS_ENCRYPTION_MODE_SPECK128_256_CTS	8 /* Removed, do not use. */
+#define FS_ENCRYPTION_MODE_ADIANTUM		9
+
+struct fscrypt_policy {
+	__u8 version;
+	__u8 contents_encryption_mode;
+	__u8 filenames_encryption_mode;
+	__u8 flags;
+	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
+};
+
+#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
+#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
+#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
+
+/* Parameters for passing an encryption key into the kernel keyring */
+#define FS_KEY_DESC_PREFIX		"fscrypt:"
+#define FS_KEY_DESC_PREFIX_SIZE		8
+
+/* Structure that userspace passes to the kernel keyring */
+#define FS_MAX_KEY_SIZE			64
+
+struct fscrypt_key {
+	__u32 mode;
+	__u8 raw[FS_MAX_KEY_SIZE];
+	__u32 size;
+};
+
+#endif /* _UAPI_LINUX_FSCRYPT_H */
-- 
2.21.0.392.gf8f6787159e-goog

