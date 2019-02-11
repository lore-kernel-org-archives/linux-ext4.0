Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFC4C282DA
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E9902229E
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549906189;
	bh=EAE5XTp2CnZtPTu38eM/2/yI4Xw18GQgFMm3/m3KB8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VCisEGWy9gqSZN5URwt8giSweLFe9JwVN79bD7wxFSgwXBZOWbUr/WhA4ChOLp8UI
	 kcAk7OCzz1MGmloFhv+a4DutXnSeok6XV7krvbFgzqfXS/He/OjnHn67DYii6q+lDO
	 gDOn6CIN4c8Vg6X+h1n06Vv1KhJ46QgBBJSxYj9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbfBKR3p (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfBKR3j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 12:29:39 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A0F4222A4;
        Mon, 11 Feb 2019 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549906178;
        bh=EAE5XTp2CnZtPTu38eM/2/yI4Xw18GQgFMm3/m3KB8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHTmzwqOLeP3vsvuXl1B6MAKnM3/9Md/Ms6o7izCjd4LViDs4k6M+8JXLciu5iVne
         FQZDmdI6p3PbHkCdArAP4Q8RhLvWt/IcYJJ2VMFnG9aie92OdqeqOjN04pbAjUjY9F
         bN3Aa74FhUm7lm53iUnUaHPs/G5rgKEmmSYmE/Mo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v2 04/20] fs: add ->s_master_keys to struct super_block
Date:   Mon, 11 Feb 2019 09:27:22 -0800
Message-Id: <20190211172738.4633-5-ebiggers@kernel.org>
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

Add an ->s_master_keys keyring to 'struct super_block'.  New fscrypt
ioctls will allow adding and removing encryption keys from this keyring.
This will enable solving multiple interrelated problems with how fscrypt
keys are provided and managed currently, including:

- Making the key status (which is currently per-process) match the
  filesystem-level status of which encrypted files are "unlocked".

- Supporting a proper API to remove encryption keys, "locking" the
  corresponding encrypted files.

- Caching an HMAC transform for each master key, allowing the use of
  HKDF while still retaining good performance.

- Preventing denial of service via keyctl_invalidate().

Similar to the existing ->s_cop, the keyring is added to the VFS-level
superblock struct rather than separately to the ext4, f2fs, and ubifs
superblock structs so that it can be used by the shared code in
fs/crypto/.  To minimize overhead, the keyring will only be allocated if
userspace actually adds a key; otherwise will stay NULL.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/super.c         | 3 +++
 include/linux/fs.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 48e25eba8465..7ca05dda905c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -291,6 +291,9 @@ static void __put_super(struct super_block *s)
 		security_sb_free(s);
 		put_user_ns(s->s_user_ns);
 		kfree(s->s_subtype);
+#ifdef CONFIG_FS_ENCRYPTION
+		key_put(s->s_master_keys);
+#endif
 		call_rcu(&s->rcu, destroy_super_rcu);
 	}
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ba7889bb9ef6..70d929ac89f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1405,6 +1405,7 @@ struct super_block {
 	const struct xattr_handler **s_xattr;
 #ifdef CONFIG_FS_ENCRYPTION
 	const struct fscrypt_operations	*s_cop;
+	struct key		*s_master_keys; /* master crypto keys in use */
 #endif
 	struct hlist_bl_head	s_roots;	/* alternate root dentries for NFS */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
-- 
2.20.1

