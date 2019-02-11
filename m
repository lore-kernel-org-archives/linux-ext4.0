Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC690C282CE
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D8522229E
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549906218;
	bh=kx4A/wd3XclKYx/v1H/ieh/bFjgPpxpI5fhXe5pGAMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=urB3gZDuZqt8GblffB211QpSHkeB7mfG7shVYqYYAR2wY/deARmU76IkzkS7IrOgi
	 GIApW/mLBGHaM+brbMcEMnfYEy+YXvhS4OXHWa7ksqWzTdlcmEL46kgOGF3EP/tmFz
	 HUNBmxHZXdpfxijv1rhVQobYt0qukGRzuHERqfng=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbfBKRaH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbfBKR3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 12:29:46 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35CF222B5;
        Mon, 11 Feb 2019 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549906184;
        bh=kx4A/wd3XclKYx/v1H/ieh/bFjgPpxpI5fhXe5pGAMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXXoG0DkjedIp5mKCJRjr8v+ZvEGZSU3DplSIWZZNnOf/uqVIhGZ1xK+n7Sp0AKjP
         b7upaHLekLQvPE8//IYZ+mlevInxw54Bjjfx2i7T8BgPRO84RUFRScMUv5kkYOswk9
         ZWb/L+FVkU/i138jPlAP8pno1TRqxIXx2UsbMEKc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v2 16/20] fscrypt: require that key be added when setting a v2 encryption policy
Date:   Mon, 11 Feb 2019 09:27:34 -0800
Message-Id: <20190211172738.4633-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211172738.4633-1-ebiggers@kernel.org>
References: <20190211172738.4633-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

By looking up the master keys in a filesystem-level keyring rather than
in the calling processes' key hierarchy, it becomes possible for a user
to set an encryption policy which refers to some key they don't actually
know, then encrypt their files using that key.  Cryptographically this
isn't much of a problem, but the semantics of this would be a bit weird.
Thus, enforce that a v2 encryption policy can only be set if the user
has previously added the key, or has capable(CAP_FOWNER).

We tolerate that this problem will continue to exist for v1 encryption
policies, however; there is no way around that.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  3 +++
 fs/crypto/keyring.c         | 47 +++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  6 +++++
 3 files changed, 56 insertions(+)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index b16cf3bd6cf1..2b58520ab0e2 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -402,6 +402,9 @@ extern struct key *
 fscrypt_find_master_key(struct super_block *sb,
 			const struct fscrypt_key_specifier *mk_spec);
 
+extern int fscrypt_verify_key_added(struct super_block *sb,
+				    const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
+
 extern int __init fscrypt_init_keyring(void);
 extern void fscrypt_exit_keyring(void);
 
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 15ca0f1d04e7..42462452e34e 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -556,6 +556,53 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 
+/*
+ * Verify that the current user has added a master key with the given identifier
+ * (returns -ENOKEY if not).  This is needed to prevent a user from encrypting
+ * their files using some other user's key which they don't actually know.
+ * Cryptographically this isn't much of a problem, but the semantics of this
+ * would be a bit weird, so it's best to just forbid it.
+ *
+ * The system administrator (CAP_FOWNER) can override this, which should be
+ * enough for any use cases where encryption policies are being set using keys
+ * that were chosen ahead of time but aren't available at the moment.
+ *
+ * Note that the key may have already removed by the time this returns, but
+ * that's okay; we just care whether the key was there at some point.
+ *
+ * Return: 0 if the key is added, -ENOKEY if it isn't, or another -errno code
+ */
+int fscrypt_verify_key_added(struct super_block *sb,
+			     const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
+{
+	struct fscrypt_key_specifier mk_spec;
+	struct key *key, *mk_user;
+	struct fscrypt_master_key *mk;
+	int err;
+
+	mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
+	memcpy(mk_spec.u.identifier, identifier, FSCRYPT_KEY_IDENTIFIER_SIZE);
+
+	key = fscrypt_find_master_key(sb, &mk_spec);
+	if (IS_ERR(key)) {
+		err = PTR_ERR(key);
+		goto out;
+	}
+	mk = key->payload.data[0];
+	mk_user = find_master_key_user(mk);
+	if (IS_ERR(mk_user)) {
+		err = PTR_ERR(mk_user);
+	} else {
+		key_put(mk_user);
+		err = 0;
+	}
+	key_put(key);
+out:
+	if (err == -ENOKEY && capable(CAP_FOWNER))
+		err = 0;
+	return err;
+}
+
 static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 {
 	struct fscrypt_info *ci;
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 07fec2f7fc72..456c25796844 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -209,6 +209,7 @@ static int set_encryption_policy(struct inode *inode,
 {
 	union fscrypt_context ctx;
 	int ctxsize;
+	int err;
 
 	if (!fscrypt_supported_policy(policy))
 		return -EINVAL;
@@ -227,6 +228,11 @@ static int set_encryption_policy(struct inode *inode,
 		 */
 		pr_warn_once("%s (pid %d) is setting deprecated v1 encryption policy; recommend upgrading to v2.\n",
 			     current->comm, current->pid);
+	} else {
+		err = fscrypt_verify_key_added(inode->i_sb,
+					       policy->v2.master_key_identifier);
+		if (err)
+			return err;
 	}
 
 	ctxsize = fscrypt_new_context_from_policy(&ctx, policy);
-- 
2.20.1

