From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 21/53] ext4: make "offset" consistent in ext4_check_dir_entry()
Date: Sun, 30 May 2010 22:49:34 -0400
Message-ID: <1275274206-3900-21-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44694 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab0EaCu1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:27 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

commit b8b8afe236e97b6359d46d3a3f8c46455e192271 upstream (as of v2.6.33-git11)

The callers of ext4_check_dir_entry() usually pass in the "file
offset" (ext4_readdir, htree_dirblock_to_tree, search_dirblock,
ext4_dx_find_entry, empty_dir), but a few callers (add_dirent_to_buf,
ext4_delete_entry) only pass in the buffer offset.

To accomodate those last two (which would be hard to fix otherwise),
this patch changes ext4_check_dir_entry() to print the physical block
number and the relative offset as well as the passed-in offset.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/dir.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9dc9316..92ae84f 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -84,9 +84,11 @@ int ext4_check_dir_entry(const char *function, struct inode *dir,
 
 	if (error_msg != NULL)
 		ext4_error(dir->i_sb, function,
-			"bad entry in directory #%lu: %s - "
-			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
-			dir->i_ino, error_msg, offset,
+			"bad entry in directory #%lu: %s - block=%llu"
+			"offset=%u(%u), inode=%u, rec_len=%d, name_len=%d",
+			dir->i_ino, error_msg, 
+			(unsigned long long) bh->b_blocknr,     
+			(unsigned) (offset%bh->b_size), offset,
 			le32_to_cpu(de->inode),
 			rlen, de->name_len);
 	return error_msg == NULL ? 1 : 0;
-- 
1.6.6.1.1.g974db.dirty

