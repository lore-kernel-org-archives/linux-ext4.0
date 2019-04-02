Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3756AC10F0F
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E992084B
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554220149;
	bh=J8AYoIAYRLSpKetMu795TZzPCxfx2dR17Mj9p52i4FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XYjYyt0tzNWphwxwdpv9L+bwS26bov//lSjrtJPjEsYLeuQ+XcsPVSBXmBmrkzZUD
	 WbSyidGZWwxO5mkQfiaEGOLHjwBx1sNq9ciTa9C+TkV8M4ru/7Hjlm70L8wQ3C77n8
	 cjTtk6+O8sOQFrAmOWQDtfmmAvJbhtuToNvGaAQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbfDBPtI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731209AbfDBPsh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 11:48:37 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008572147C;
        Tue,  2 Apr 2019 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554220115;
        bh=J8AYoIAYRLSpKetMu795TZzPCxfx2dR17Mj9p52i4FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gS/jQmACZAyfkQftTDMvUGXhPj/pRx6QscOfJiV6cxnNNL5+7TSfwZoEvn6UFbDuB
         yu5Mr1Q1xtc3gjVBu1k4F7aspG6FSOiLmRbLncGgydZe88H68DgNjEKLzCTv7IcdiZ
         dTzqVCcGXy03sSvxf8f/AaetlmqZF5yOPEfHSZT8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH v4 09/17] fscrypt: add FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl
Date:   Tue,  2 Apr 2019 08:45:52 -0700
Message-Id: <20190402154600.32432-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190402154600.32432-1-ebiggers@kernel.org>
References: <20190402154600.32432-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a new fscrypt ioctl, FS_IOC_GET_ENCRYPTION_KEY_STATUS.  Given a key
specified by 'struct fscrypt_key_specifier' (the same way a key is
specified for the other fscrypt key management ioctls), it returns
status information in a 'struct fscrypt_get_key_status_arg'.

The main motivation for this is that applications need to be able to
check whether an encrypted directory is "unlocked" or not, so that they
can add the key if it is not, and avoid adding the key (which may
involve prompting the user for a passphrase) if it already is.

It's possible to use some workarounds such as checking whether opening a
regular file fails with ENOKEY, or checking whether the filenames "look
like gibberish" or not.  However, no workaround is usable in all cases.

Like the other key management ioctls, the keyrings syscalls may seem at
first to be a good fit for this.  Unfortunately, they are not.  Even if
we exposed the keyring ID of the ->s_master_keys keyring and gave
everyone Search permission on it (note: currently the keyrings
permission system would also allow everyone to "invalidate" the keyring
too), the fscrypt keys have an additional state that doesn't map cleanly
to the keyrings API: the secret can be removed, but we can be still
tracking the files that were using the key, and the removal can be
re-attempted or the secret added again.

After later patches, some applications will also need a way to determine
whether a key was added by the current user vs. by some other user.
Reserved fields are included in fscrypt_get_key_status_arg for this and
other future extensions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyring.c          | 60 ++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h      |  7 +++++
 include/uapi/linux/fscrypt.h | 15 +++++++++
 3 files changed, 82 insertions(+)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index ee9be002c1490..08e14497c8e30 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -11,6 +11,7 @@
  *
  * - FS_IOC_ADD_ENCRYPTION_KEY: add a key
  * - FS_IOC_REMOVE_ENCRYPTION_KEY: remove a key
+ * - FS_IOC_GET_ENCRYPTION_KEY_STATUS: get key status
  */
 
 #include <linux/key-type.h>
@@ -482,6 +483,65 @@ int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key);
 
+/*
+ * Retrieve the status of an fscrypt master encryption key.
+ *
+ * We set ->status to indicate whether the key is absent, present, or
+ * incompletely removed.  "Incompletely removed" means that the master key
+ * secret has been removed, but some files which had been unlocked with it are
+ * still in use.  This field allows applications to easily determine the state
+ * of an encrypted directory without using a hack such as trying to open a
+ * regular file in it (which can confuse the "incompletely removed" state with
+ * absent or present).
+ */
+int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
+{
+	struct super_block *sb = file_inode(filp)->i_sb;
+	struct fscrypt_get_key_status_arg arg;
+	struct key *key;
+	struct fscrypt_master_key *mk;
+	int err;
+
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	if (!valid_key_spec(&arg.key_spec))
+		return -EINVAL;
+
+	if (memchr_inv(arg.__reserved, 0, sizeof(arg.__reserved)))
+		return -EINVAL;
+
+	memset(arg.__out_reserved, 0, sizeof(arg.__out_reserved));
+
+	key = fscrypt_find_master_key(sb, &arg.key_spec);
+	if (IS_ERR(key)) {
+		if (key != ERR_PTR(-ENOKEY))
+			return PTR_ERR(key);
+		arg.status = FSCRYPT_KEY_STATUS_ABSENT;
+		err = 0;
+		goto out;
+	}
+	mk = key->payload.data[0];
+	down_read(&key->sem);
+
+	if (!is_master_key_secret_present(&mk->mk_secret)) {
+		arg.status = FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED;
+		err = 0;
+		goto out_release_key;
+	}
+
+	arg.status = FSCRYPT_KEY_STATUS_PRESENT;
+	err = 0;
+out_release_key:
+	up_read(&key->sem);
+	key_put(key);
+out:
+	if (!err && copy_to_user(uarg, &arg, sizeof(arg)))
+		err = -EFAULT;
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_ioctl_get_key_status);
+
 int __init fscrypt_init_keyring(void)
 {
 	return register_key_type(&key_type_fscrypt);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index b6f8832dadba4..5f251cad255b8 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -116,6 +116,7 @@ extern int fscrypt_inherit_context(struct inode *, struct inode *,
 extern void fscrypt_sb_free(struct super_block *sb);
 extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
 extern int fscrypt_ioctl_remove_key(struct file *filp, const void __user *arg);
+extern int fscrypt_ioctl_get_key_status(struct file *filp, void __user *arg);
 
 /* keysetup.c */
 extern int fscrypt_get_encryption_info(struct inode *);
@@ -335,6 +336,12 @@ static inline int fscrypt_ioctl_remove_key(struct file *filp,
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_ioctl_get_key_status(struct file *filp,
+					       void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 /* keysetup.c */
 static inline int fscrypt_get_encryption_info(struct inode *inode)
 {
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 3302a407131e6..042e70a4ff7ee 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -71,11 +71,26 @@ struct fscrypt_remove_key_arg {
 	__u32 __reserved[6];
 };
 
+/* Struct passed to FS_IOC_GET_ENCRYPTION_KEY_STATUS */
+struct fscrypt_get_key_status_arg {
+	/* input */
+	struct fscrypt_key_specifier key_spec;
+	__u32 __reserved[6];
+
+	/* output */
+#define FSCRYPT_KEY_STATUS_ABSENT		1
+#define FSCRYPT_KEY_STATUS_PRESENT		2
+#define FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED	3
+	__u32 status;
+	__u32 __out_reserved[15];
+};
+
 #define FS_IOC_SET_ENCRYPTION_POLICY	  _IOR('f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT	  _IOW('f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY	  _IOW('f', 21, struct fscrypt_policy)
 #define FS_IOC_ADD_ENCRYPTION_KEY	 _IOWR('f', 23, struct fscrypt_add_key_arg)
 #define FS_IOC_REMOVE_ENCRYPTION_KEY	  _IOW('f', 24, struct fscrypt_remove_key_arg)
+#define FS_IOC_GET_ENCRYPTION_KEY_STATUS _IOWR('f', 25, struct fscrypt_get_key_status_arg)
 
 /**********************************************************************/
 
-- 
2.21.0

