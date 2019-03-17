Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3237FC4360F
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A392186A
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552853237;
	bh=YHR/+9P1+ldG9ELfX/j4cm4R/vh6YcN8N9+3+6wV3+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=O0W1F2/5Swv1pex9SNZrCQC7n//OGmrWU8qP9kcSegJ18dCdyPVAz/nMzDxXS9f4C
	 e2sahILYDIRhBM+jYXZD+5FTeGEwTyidrE+F/mc218ago7wNzX8uMMiwY2uvJJspU/
	 /6Mo6bwIvQTBrG4xFVCW1MqznvaaXasz1ljcytPE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfCQUHQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfCQUHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Mar 2019 16:07:14 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6371217F4;
        Sun, 17 Mar 2019 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552853233;
        bh=YHR/+9P1+ldG9ELfX/j4cm4R/vh6YcN8N9+3+6wV3+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frpCRYgIvwqYzym69BoMLZKxShI8KuRdIinQD8shXEvrvfR/d5KyqrSR0jWmApQnw
         TjJSawO74jvRWzjeX7MeJd1pWp7m/ShrZR0bw9gk4jExE8EsulsoPEkuJc5T70oT+I
         YFL5ZlJ9cmO8lBcEmn2aIqStEjy1uCHkc0V8vKUo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 3/5] fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
Date:   Sun, 17 Mar 2019 13:04:42 -0700
Message-Id: <20190317200444.5967-4-ebiggers@kernel.org>
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
 fs/dcache.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index aac41adf4743..e27d11151d0e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2718,6 +2718,20 @@ static void copy_name(struct dentry *dentry, struct dentry *target)
 		kfree_rcu(old_name, u.head);
 }
 
+static void fscrypt_update_flags(struct dentry *dentry)
+{
+#ifdef CONFIG_FS_ENCRYPTION
+	/*
+	 * When d_splice_alias() moves a directory's encrypted alias to its
+	 * decrypted alias as a result of the encryption key being added,
+	 * DCACHE_ENCRYPTED_NAME must be cleared.  Note that we don't have to
+	 * support arbitrary moves of this flag because fscrypt doesn't allow
+	 * encrypted aliases to be the source or target of a rename().
+	 */
+	dentry->d_flags &= ~DCACHE_ENCRYPTED_NAME;
+#endif
+}
+
 /*
  * __d_move - move a dentry
  * @dentry: entry to move
@@ -2795,6 +2809,7 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 	list_move(&dentry->d_child, &dentry->d_parent->d_subdirs);
 	__d_rehash(dentry);
 	fsnotify_update_flags(dentry);
+	fscrypt_update_flags(dentry);
 
 	write_seqcount_end(&target->d_seq);
 	write_seqcount_end(&dentry->d_seq);
-- 
2.21.0

