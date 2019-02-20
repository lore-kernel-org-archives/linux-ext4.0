Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F676C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 06:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D7521773
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 06:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550645720;
	bh=LHU0VKAUPXgaadVEq89d1supnSav2nCovQtUB0yGf0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AmLtYGYvFs5RMJDg1DT47N73e4EIZxi2CHXO9OP15rbDXZmEihzAuVIbUxs1NNvZm
	 oKLks7E+RgoNvEBo5TzyvntnqM1ERqmGt/cBWwHAG6V7PFT10TT33o3T8x8Docs96p
	 i0CNCFL23DWZ26pXGXRG7aSvfyaXRFA1eD9jH9Lk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfBTGym (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730638AbfBTGyk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Feb 2019 01:54:40 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA4A21903;
        Wed, 20 Feb 2019 06:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550645678;
        bh=LHU0VKAUPXgaadVEq89d1supnSav2nCovQtUB0yGf0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+ydz28B0pXQ0IUmw2HP+U0Ygtlm9rrAZzKSw7hqkk2+WzeFZgn6rZsJq91dihJUf
         IefxnWItu6q0oFt1nJ5si6eF13STdhyIgWJ8ScbnOvuWcZb9aZoU1yrsUHOhG/6RwT
         qP0fLQiCTpcNGreM77iQ7D6bPDa1hhS7dXmaBaAw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>
Subject: [RFC PATCH v3 08/18] fs/dcache.c: add shrink_dcache_inode()
Date:   Tue, 19 Feb 2019 22:52:39 -0800
Message-Id: <20190220065249.32099-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220065249.32099-1-ebiggers@kernel.org>
References: <20190220065249.32099-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When a filesystem encryption key is removed, we need all files which had
been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
again.  This is most easily done by evicting the inodes.  This can
currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
that is overkill and not usable by non-root users.

To evict just the needed inodes we also need the ability to evict those
inodes' dentries, since an inode is pinned by its dentries.  Therefore,
add a function shrink_dcache_inode() which iterates through an inode's
dentries and evicts any unused ones as well as any unused descendants
(since there may be negative dentries pinning the inode's dentries).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/dcache.c            | 32 ++++++++++++++++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 33 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 2593153471cf..6a7db8797b2d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1484,6 +1484,38 @@ void shrink_dcache_parent(struct dentry *parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+/**
+ * shrink_dcache_inode - prune dcache for inode
+ * @inode: inode to prune
+ *
+ * Evict all unused aliases of the specified inode from the dcache.  This is
+ * intended to be used when trying to evict a specific inode, since inodes are
+ * pinned by their dentries.  We also have to descend to ->d_subdirs for each
+ * alias, since aliases may be pinned by negative child dentries.
+ */
+void shrink_dcache_inode(struct inode *inode)
+{
+	for (;;) {
+		struct select_data data;
+		struct dentry *dentry;
+
+		INIT_LIST_HEAD(&data.dispose);
+		data.start = NULL;
+		data.found = 0;
+
+		spin_lock(&inode->i_lock);
+		hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias)
+			d_walk(dentry, &data, select_collect);
+		spin_unlock(&inode->i_lock);
+
+		if (!data.found)
+			break;
+
+		shrink_dentry_list(&data.dispose);
+		cond_resched();
+	}
+}
+
 static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
 {
 	/* it has busy descendents; complain about those instead */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index ef4b70f64f33..c02dab98bc97 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -245,6 +245,7 @@ extern struct dentry * d_obtain_alias(struct inode *);
 extern struct dentry * d_obtain_root(struct inode *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
+extern void shrink_dcache_inode(struct inode *);
 extern void shrink_dcache_for_umount(struct super_block *);
 extern void d_invalidate(struct dentry *);
 
-- 
2.20.1

