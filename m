From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: avoid unnecessary spinlock in critical POSIX ACL path
Date: Mon, 27 Apr 2009 17:33:43 -0400
Message-ID: <1240868023-22060-2-git-send-email-tytso@mit.edu>
References: <1240868023-22060-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47677 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbZD0Vdu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 17:33:50 -0400
In-Reply-To: <1240868023-22060-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a filesystem supports POSIX ACL's, the VFS layer expects the filesystem
to do POSIX ACL checks on any files not owned by the caller, and it does
this for every single pathname component that it looks up.

That obviously can be pretty expensive if the filesystem isn't careful
about it, especially with locking. That's doubly sad, since the common
case tends to be that there are no ACL's associated with the files in
question.

ext4 already caches the ACL data so that it doesn't have to look it up
over and over again, but it does so by taking the inode->i_lock spinlock
on every lookup. Which is a noticeable overhead even if it's a private
lock, especially on CPU's where the serialization is expensive (eg Intel
Netburst aka 'P4').

For the special case of not actually having any ACL's, all that locking is
unnecessary. Even if somebody else were to be changing the ACL's on
another CPU, we simply don't care - if we've seen a NULL ACL, we might as
well use it.

So just load the ACL speculatively without any locking, and if it was
NULL, just use it. If it's non-NULL (either because we had a cached
entry, or because the cache hasn't been filled in at all), it means that
we'll need to get the lock and re-load it properly.

(This commit was ported from a patch originally authored by Linus for
ext3.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/acl.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 647e0d6..605aeed 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -129,12 +129,15 @@ fail:
 static inline struct posix_acl *
 ext4_iget_acl(struct inode *inode, struct posix_acl **i_acl)
 {
-	struct posix_acl *acl = EXT4_ACL_NOT_CACHED;
+	struct posix_acl *acl = ACCESS_ONCE(*i_acl);
 
-	spin_lock(&inode->i_lock);
-	if (*i_acl != EXT4_ACL_NOT_CACHED)
-		acl = posix_acl_dup(*i_acl);
-	spin_unlock(&inode->i_lock);
+	if (acl) {
+		spin_lock(&inode->i_lock);
+		acl = *i_acl;
+		if (acl != EXT4_ACL_NOT_CACHED)
+			acl = posix_acl_dup(acl);
+		spin_unlock(&inode->i_lock);
+	}
 
 	return acl;
 }
-- 
1.5.6.3

