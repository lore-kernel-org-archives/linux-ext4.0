From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 20/53] ext4: Handle non empty on-disk orphan link
Date: Sun, 30 May 2010 22:49:33 -0400
Message-ID: <1275274206-3900-20-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44721 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0EaCu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:29 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 6e3617e579e070d3655a93ee9ed7149113e795e0 upstream (as of v2.6.33-git11)

In case of truncate errors we explicitly remove inode from in-core
orphan list via orphan_del(NULL, inode) without modifying the on-disk list.

But later on, the same inode may be inserted in the orphan list again
which will result the on-disk linked list getting corrupted.  If inode
i_dtime contains valid value, then skip on-disk list modification.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/namei.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8bd1e20..1dd84f6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2020,6 +2020,13 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		goto out_unlock;
+	/*
+	 * Due to previous errors inode may be already a part of on-disk
+	 * orphan list. If so skip on-disk list modification.
+	 */
+	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
+		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
+			goto mem_insert;
 
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
@@ -2037,6 +2044,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 *
 	 * This is safe: on error we're going to ignore the orphan list
 	 * anyway on the next recovery. */
+mem_insert:
 	if (!err)
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
 
-- 
1.6.6.1.1.g974db.dirty

