Return-Path: <SRS0=eYnO=RX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B87C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 18:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1502218A3
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553107218;
	bh=GVgaWnQRVDs7JRYe6xnoJZc6eiXCKyqXo6bHkLGC1Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tBq5Yv+lDBw+VZeJOc7k0vOgKm+hmICO8GObwsqNnXknmVg87a2dO98ZIct8H5OeF
	 79meZwAxAInofmrRjVQgMDlBpCTcGl9tw5oSIaQJ5xCyZCbQXUueIoiRlWojGIkYu+
	 WNK/PZGN4A4n7K0WXJjr1hcFbd5Sq4qGlOPrWLs0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfCTSkR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfCTSkQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Mar 2019 14:40:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD93B21873;
        Wed, 20 Mar 2019 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553107215;
        bh=GVgaWnQRVDs7JRYe6xnoJZc6eiXCKyqXo6bHkLGC1Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y8/2ajXXylCpL94BCn1e/yyk7Dy9TuPTbDGiY3kRwbwE3ldpc1fNoGMtRj8w/boP
         S56eq7xpwINi4YBF4SduNyFX1FQNMh0TY9Rlc75/i647zHz/s68hEW2dKCTJcLZZay
         ULqAZ530hqJSJNLGGnuZOzF01ai2/kfpobmEKHHQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH v2 3/5] fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
Date:   Wed, 20 Mar 2019 11:39:11 -0700
Message-Id: <20190320183913.12686-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
In-Reply-To: <20190320183913.12686-1-ebiggers@kernel.org>
References: <20190320183913.12686-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make __d_move() clear DCACHE_ENCRYPTED_NAME on the source dentry.  This
is needed for when d_splice_alias() moves a directory's encrypted alias
to its decrypted alias as a result of the encryption key being added.

Otherwise, the decrypted alias will incorrectly be invalidated on the
next lookup, causing problems such as unmounting a mount the user just
mount()ed there.

Note that we don't have to support arbitrary moves of this flag because
fscrypt doesn't allow dentries with DCACHE_ENCRYPTED_NAME to be the
source or target of a rename().

Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
Reported-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/dcache.c             |  2 ++
 include/linux/fscrypt.h | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index aac41adf47433..647e6ed426e20 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -2795,6 +2796,7 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 	list_move(&dentry->d_child, &dentry->d_parent->d_subdirs);
 	__d_rehash(dentry);
 	fsnotify_update_flags(dentry);
+	fscrypt_handle_d_move(dentry);
 
 	write_seqcount_end(&target->d_seq);
 	write_seqcount_end(&dentry->d_seq);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4ad7a856e0f1c..39bd2619a3424 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -88,6 +88,18 @@ static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
 		inode->i_sb->s_cop->dummy_context(inode);
 }
 
+/*
+ * When d_splice_alias() moves a directory's encrypted alias to its decrypted
+ * alias as a result of the encryption key being added, DCACHE_ENCRYPTED_NAME
+ * must be cleared.  Note that we don't have to support arbitrary moves of this
+ * flag because fscrypt doesn't allow encrypted aliases to be the source or
+ * target of a rename().
+ */
+static inline void fscrypt_handle_d_move(struct dentry *dentry)
+{
+	dentry->d_flags &= ~DCACHE_ENCRYPTED_NAME;
+}
+
 /* crypto.c */
 extern void fscrypt_enqueue_decrypt_work(struct work_struct *);
 extern struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *, gfp_t);
@@ -243,6 +255,10 @@ static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
 	return false;
 }
 
+static inline void fscrypt_handle_d_move(struct dentry *dentry)
+{
+}
+
 /* crypto.c */
 static inline void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
-- 
2.21.0.225.g810b269d1ac-goog

