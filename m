Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0635EC43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6F412186A
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552853239;
	bh=z+KQUUBIqy7fby+Bsr0TJzflcgCUzE4USn8oAT7n/ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t42B4Jl3/tg2A3dkMRomOv16EtUK1dctW7mhhmdbInLZYQYDdMg6ZwUejN+AsMY6c
	 lkGvamAGeOXskCtCuRI69zHXj680YypAdY8anAsckbRhtwibZSXPYMiklwAMCQs7Ko
	 F2yONIFSWeNvmQCMCHHJcRH6/hdWMOu26xGzOyZ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfCQUHP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbfCQUHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Mar 2019 16:07:15 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A2521741;
        Sun, 17 Mar 2019 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552853233;
        bh=z+KQUUBIqy7fby+Bsr0TJzflcgCUzE4USn8oAT7n/ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iihmcneDfnodYkTF4M5zZdEwLyhDiqRuudGSDDw9hCD2fAIaZTZ3S13qW0OEzbAvw
         PqPRcAXZz2j1E9vx9B3hfABRax/ClkiAn53iQtTjXbBChulH5mWk7FleonETWHBpz+
         KTMq46ikY3c/zEQiHsR12xZJC2epfZIDEXTnmXdY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 2/5] fscrypt: fix race allowing rename() and link() of ciphertext dentries
Date:   Sun, 17 Mar 2019 13:04:41 -0700
Message-Id: <20190317200444.5967-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190317200444.5967-1-ebiggers@kernel.org>
References: <20190317200444.5967-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Close some race conditions where fscrypt allowed rename() and link() on
ciphertext dentries that had been looked up just prior to the key being
concurrently added.  It's better to return -ENOKEY in this case.

This avoids doing the nonsensical thing of encrypting the names a second
time when searching for the actual on-disk dir entries.  It also
guarantees that DCACHE_ENCRYPTED_NAME dentries are never rename()d, so
the dcache won't have support all possible combinations of moving
DCACHE_ENCRYPTED_NAME around during __d_move().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       | 12 +++++++++++-
 include/linux/fscrypt.h |  9 +++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index a9492f75bbe1..2e7498a821a4 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -49,7 +49,8 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(fscrypt_file_open);
 
-int __fscrypt_prepare_link(struct inode *inode, struct inode *dir)
+int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+			   struct dentry *dentry)
 {
 	int err;
 
@@ -57,6 +58,10 @@ int __fscrypt_prepare_link(struct inode *inode, struct inode *dir)
 	if (err)
 		return err;
 
+	/* ... in case we looked up ciphertext name before key was added */
+	if (dentry->d_flags & DCACHE_ENCRYPTED_NAME)
+		return -ENOKEY;
+
 	if (!fscrypt_has_permitted_context(dir, inode))
 		return -EXDEV;
 
@@ -78,6 +83,11 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (err)
 		return err;
 
+	/* ... in case we looked up ciphertext name(s) before key was added */
+	if ((old_dentry->d_flags | new_dentry->d_flags) &
+	    DCACHE_ENCRYPTED_NAME)
+		return -ENOKEY;
+
 	if (old_dir != new_dir) {
 		if (IS_ENCRYPTED(new_dir) &&
 		    !fscrypt_has_permitted_context(new_dir,
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 5a0c3fee1ea2..4ad7a856e0f1 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -214,7 +214,8 @@ extern int fscrypt_zeroout_range(const struct inode *, pgoff_t, sector_t,
 
 /* hooks.c */
 extern int fscrypt_file_open(struct inode *inode, struct file *filp);
-extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir);
+extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+				  struct dentry *dentry);
 extern int __fscrypt_prepare_rename(struct inode *old_dir,
 				    struct dentry *old_dentry,
 				    struct inode *new_dir,
@@ -401,8 +402,8 @@ static inline int fscrypt_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static inline int __fscrypt_prepare_link(struct inode *inode,
-					 struct inode *dir)
+static inline int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+					 struct dentry *dentry)
 {
 	return -EOPNOTSUPP;
 }
@@ -497,7 +498,7 @@ static inline int fscrypt_prepare_link(struct dentry *old_dentry,
 				       struct dentry *dentry)
 {
 	if (IS_ENCRYPTED(dir))
-		return __fscrypt_prepare_link(d_inode(old_dentry), dir);
+		return __fscrypt_prepare_link(d_inode(old_dentry), dir, dentry);
 	return 0;
 }
 
-- 
2.21.0

