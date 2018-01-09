From: Jeff Layton <jlayton@kernel.org>
Subject: [RFC PATCH] ext4: don't split xattr inode refcounts across i_ctime and i_version fields
Date: Tue,  9 Jan 2018 09:47:01 -0500
Message-ID: <20180109144701.27387-1-jlayton@kernel.org>
Cc: linux-ext4@vger.kernel.org, dhowells@redhat.com
To: adilger.kernel@dilger.ca, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756991AbeAIOrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 09:47:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jeff Layton <jlayton@redhat.com>

This patch is based on top of the i_version rework that I'm flogging
upstream. It's just a cleanup of some nastiness I noticed while in there.

This code uses the i_ctime and i_version fields to each store half of
a refcount. I suspect it was done this way long ago when the i_version
field was a 32 bits, and was never changed when the field was converted
to a 64 bit value.

Change the code to just store the refcount in the i_version field rather
than splitting it across both fields.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext4/xattr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 63656dbafdc4..6ea78dd367ca 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -294,14 +294,12 @@ ext4_xattr_inode_hash(struct ext4_sb_info *sbi, const void *buffer, size_t size)
 
 static u64 ext4_xattr_inode_get_ref(struct inode *ea_inode)
 {
-	return ((u64)ea_inode->i_ctime.tv_sec << 32) |
-		(u32) inode_peek_iversion_raw(ea_inode);
+	return inode_peek_iversion_raw(ea_inode);
 }
 
 static void ext4_xattr_inode_set_ref(struct inode *ea_inode, u64 ref_count)
 {
-	ea_inode->i_ctime.tv_sec = (u32)(ref_count >> 32);
-	inode_set_iversion_raw(ea_inode, ref_count & 0xffffffff);
+	inode_set_iversion_raw(ea_inode, ref_count);
 }
 
 static u32 ext4_xattr_inode_get_hash(struct inode *ea_inode)
-- 
2.14.3
