Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45580 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeIYECh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:37 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 19/25] vfs: Handle case-exact lookup in d_add_ci
Date: Mon, 24 Sep 2018 17:56:49 -0400
Message-Id: <20180924215655.3676-20-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This prevents a soft hang if called d_add_ci is called from the FS
layer, when doing a CI search but the result dentry is the exact match.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/dcache.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 0e8e5de3c48a..3b55023cca7e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2059,6 +2059,20 @@ struct dentry *d_obtain_root(struct inode *inode)
 }
 EXPORT_SYMBOL(d_obtain_root);
 
+static inline bool d_same_name(const struct dentry *dentry,
+				const struct dentry *parent,
+				const struct qstr *name)
+{
+	if (likely(!(parent->d_flags & DCACHE_OP_COMPARE))) {
+		if (dentry->d_name.len != name->len)
+			return false;
+		return dentry_cmp(dentry, name->name, name->len) == 0;
+	}
+	return parent->d_op->d_compare(dentry,
+				       dentry->d_name.len, dentry->d_name.name,
+				       name) == 0;
+}
+
 /**
  * d_add_ci - lookup or allocate new dentry with case-exact name
  * @inode:  the inode case-insensitive lookup has found
@@ -2080,6 +2094,10 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 {
 	struct dentry *found, *res;
 
+	/* Trivial case: CI search is exact match.  */
+	if (d_same_name(dentry, dentry->d_parent, name))
+		return d_splice_alias(inode, dentry);
+
 	/*
 	 * First check if a dentry matching the name already exists,
 	 * if not go ahead and create it now.
@@ -2112,21 +2130,6 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 }
 EXPORT_SYMBOL(d_add_ci);
 
-
-static inline bool d_same_name(const struct dentry *dentry,
-				const struct dentry *parent,
-				const struct qstr *name)
-{
-	if (likely(!(parent->d_flags & DCACHE_OP_COMPARE))) {
-		if (dentry->d_name.len != name->len)
-			return false;
-		return dentry_cmp(dentry, name->name, name->len) == 0;
-	}
-	return parent->d_op->d_compare(dentry,
-				       dentry->d_name.len, dentry->d_name.name,
-				       name) == 0;
-}
-
 /**
  * __d_lookup_rcu - search for a dentry (racy, store-free)
  * @parent: parent dentry
-- 
2.19.0
