Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B35C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B248217FA
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555630256;
	bh=OpxiKoOPd9b3NVEDkbQhJb7kLewB27NRt1GJWMq1hUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=evokjVolKhXBkYPdTTnWfD/rtkpp7/IFmH1caQd3KfaDMhccMocZyVZO+nOA1O+3T
	 RKEFvcntV6HX8KVZzzyH7XveM2/xNJmF2ipR10E7ptpY2dd/OPQPCdxSRDu2kK3UTS
	 1ZOiiNNz5+M+CSY/h84Un1ytAZIERuSoFECNdBGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfDRXaz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 19:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfDRXaa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 19:30:30 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C30C5218A6;
        Thu, 18 Apr 2019 23:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555630228;
        bh=OpxiKoOPd9b3NVEDkbQhJb7kLewB27NRt1GJWMq1hUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfjoxHUdrP3Ha8Nf2gwwmrtqI4VSEKdAPhaXgdZNJiBNOloYmtlDyR0TzWTuwRvoG
         8n9DynM7RfN4BeYpPatgQpUM3K82SvoBVHN733OnPOS4Q+RyxtarUWPu/g0e3hPx09
         AHz/Tsw/by1per4g0PVWlx+yWHc+EcFoywrFQR68=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v5 08/16] fscrypt: add FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl
Date:   Thu, 18 Apr 2019 16:29:15 -0700
Message-Id: <20190418232923.250800-9-ebiggers@kernel.org>
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
index f3c2f9329e296..74ecd1c824983 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -11,6 +11,7 @@
  *
  * - FS_IOC_ADD_ENCRYPTION_KEY: add a key
  * - FS_IOC_REMOVE_ENCRYPTION_KEY: remove a key
+ * - FS_IOC_GET_ENCRYPTION_KEY_STATUS: get key status
  */
 
 #include <linux/key-type.h>
@@ -496,6 +497,65 @@ int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
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
index 183f2bde95256..9826225d3451b 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -130,6 +130,7 @@ extern int fscrypt_inherit_context(struct inode *, struct inode *,
 extern void fscrypt_sb_free(struct super_block *sb);
 extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
 extern int fscrypt_ioctl_remove_key(struct file *filp, const void __user *arg);
+extern int fscrypt_ioctl_get_key_status(struct file *filp, void __user *arg);
 
 /* keysetup.c */
 extern int fscrypt_get_encryption_info(struct inode *);
@@ -355,6 +356,12 @@ static inline int fscrypt_ioctl_remove_key(struct file *filp,
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
2.21.0.392.gf8f6787159e-goog

