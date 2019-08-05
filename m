Return-Path: <SRS0=I98z=WB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21843C41514
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Aug 2019 16:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA0E22173B
	for <linux-ext4@archiver.kernel.org>; Mon,  5 Aug 2019 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565022540;
	bh=xy1t3rSvYnShOxZuTt8ak8auiaMk1xeeLO3ak4sGGW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yL0z2L+bOa32LOfNa90KHv/XuP6tUTLB5As2ScyrJasnelj4KglzDKFQfqLxHJ0JA
	 61Z8cjUuMkXY5axjKOXM9lkyrs0ejKyiTsatAFuW8V9/84NteWav8GnF4kMcU/c6s2
	 p54sX7R9w5KFkXUk0loDadGekZKaLV/+/HMdp9bM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfHEQ27 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Aug 2019 12:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbfHEQ2j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Aug 2019 12:28:39 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13E732189E;
        Mon,  5 Aug 2019 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565022518;
        bh=xy1t3rSvYnShOxZuTt8ak8auiaMk1xeeLO3ak4sGGW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1aJJBldcpGb18JN2NarCFynGXoY9FVW3evN3jgQMOVasyEEIjksnWi5vY21TAqKF
         0Zudz6mVyQYLEwUzT7qMRIArco1zLZx7hxpFHw1UogyLGZdCa6GPil1gmxIoANw6wv
         UZmddSgC/pTRdUphRX+kvHBgBP96moWKmIRKolug=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        linux-api@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v8 16/20] fscrypt: require that key be added when setting a v2 encryption policy
Date:   Mon,  5 Aug 2019 09:25:17 -0700
Message-Id: <20190805162521.90882-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190805162521.90882-1-ebiggers@kernel.org>
References: <20190805162521.90882-1-ebiggers@kernel.org>
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

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  3 +++
 fs/crypto/keyring.c         | 47 +++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          | 14 ++++++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d0e23823423416..e84efc01512e4e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -431,6 +431,9 @@ extern struct key *
 fscrypt_find_master_key(struct super_block *sb,
 			const struct fscrypt_key_specifier *mk_spec);
 
+extern int fscrypt_verify_key_added(struct super_block *sb,
+				    const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
+
 extern int __init fscrypt_init_keyring(void);
 
 /* keysetup.c */
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 86bfcc02b31fcf..6ea71c2e18f0e7 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -562,6 +562,53 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
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
 /*
  * Try to evict the inode's dentries from the dentry cache.  If the inode is a
  * directory, then it can have at most one dentry; however, that dentry may be
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 0141d338c1fdb2..4072ba644595b9 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -233,11 +233,13 @@ static int set_encryption_policy(struct inode *inode,
 {
 	union fscrypt_context ctx;
 	int ctxsize;
+	int err;
 
 	if (!fscrypt_supported_policy(policy, inode))
 		return -EINVAL;
 
-	if (policy->version == FSCRYPT_POLICY_V1) {
+	switch (policy->version) {
+	case FSCRYPT_POLICY_V1:
 		/*
 		 * The original encryption policy version provided no way of
 		 * verifying that the correct master key was supplied, which was
@@ -251,6 +253,16 @@ static int set_encryption_policy(struct inode *inode,
 		 */
 		pr_warn_once("%s (pid %d) is setting deprecated v1 encryption policy; recommend upgrading to v2.\n",
 			     current->comm, current->pid);
+		break;
+	case FSCRYPT_POLICY_V2:
+		err = fscrypt_verify_key_added(inode->i_sb,
+					       policy->v2.master_key_identifier);
+		if (err)
+			return err;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
 	}
 
 	ctxsize = fscrypt_new_context_from_policy(&ctx, policy);
-- 
2.22.0.770.g0f2c4a37fd-goog

