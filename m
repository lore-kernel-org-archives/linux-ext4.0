From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] ext4: avoid deadlock on sync-mounted FS w/o journal
Date: Thu, 16 Feb 2012 15:41:45 -0800
Message-ID: <4F3D9439.3050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Martin.Wilck@ts.fujitsu.com
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab2BPXlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Feb 2012 18:41:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Martin.Wilck@ts.fujitsu.com

Processes hang forever on a sync-mounted ext2 file system that
is mounted with the ext4 module (default in Fedora 16).

I can reproduce this reliably by mounting an ext2 partition with
"-o sync" and opening a new file an that partition with vim. vim
will hang in "D" state forever.  The same happens on ext4 without
a journal.

I am attaching a small patch here that solves this issue for me.
In the sync mounted case without a journal,
ext4_handle_dirty_metadata() may call sync_dirty_buffer(), which
can't be called with buffer lock held.

Also move mb_cache_entry_release inside lock to avoid race
fixed previously by 8a2bfdcb ext[34]: EA block reference count racing fix
Nonte too that ext2 fixed this same problem in 2006 with
b2f49033 [PATCH] fix deadlock in ext2

Signed-off-by: Martin.Wilck@ts.fujitsu.com
[sandeen@redhat.com: move mb_cache_entry_release before unlock, edit commit msg]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 93a00d8..4410ae7 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -487,18 +487,19 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
+		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		if (ce)
+			mb_cache_entry_release(ce);
+		unlock_buffer(bh);
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, 1);
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
-		if (ce)
-			mb_cache_entry_release(ce);
 	}
-	unlock_buffer(bh);
 out:
 	ext4_std_error(inode->i_sb, error);
 	return;

