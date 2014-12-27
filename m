From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: prevent online resize with backup superblock
Date: Fri, 26 Dec 2014 23:59:44 -0500
Message-ID: <20141227045944.GB24553@thunk.org>
References: <5499ED8A.5010907@ispras.ru>
 <20141224223316.GD29088@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andrey Tsyvarev <tsyvarev@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Maxim Malkov <malkov@ispras.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43866 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaL0E7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Dec 2014 23:59:47 -0500
Content-Disposition: inline
In-Reply-To: <20141224223316.GD29088@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Prevent BUG or corrupted file systems after the following:

mkfs.ext4 /dev/vdc 100M
mount -t ext4 -o sb=40961 /dev/vdc /vdc
resize2fs /dev/vdc

We previously prevented online resizing using the old resize ioctl.
Move the code to ext4_resize_begin(), so the check applies for all of
the resize ioctl's.

Reported-by: Maxim Malkov <malkov@ispras.ru>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/resize.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index bf76f40..8a8ec62 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -24,6 +24,18 @@ int ext4_resize_begin(struct super_block *sb)
 		return -EPERM;
 
 	/*
+	 * If we are not using the primary superblock/GDT copy don't resize,
+         * because the user tools have no way of handling this.  Probably a
+         * bad time to do it anyways.
+         */
+	if (EXT4_SB(sb)->s_sbh->b_blocknr !=
+	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
+		ext4_warning(sb, "won't resize using backup superblock at %llu",
+			(unsigned long long)EXT4_SB(sb)->s_sbh->b_blocknr);
+		return -EPERM;
+	}
+
+	/*
 	 * We are not allowed to do online-resizing on a filesystem mounted
 	 * with error, because it can destroy the filesystem easily.
 	 */
@@ -758,18 +770,6 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 		       "EXT4-fs: ext4_add_new_gdb: adding group block %lu\n",
 		       gdb_num);
 
-	/*
-	 * If we are not using the primary superblock/GDT copy don't resize,
-         * because the user tools have no way of handling this.  Probably a
-         * bad time to do it anyways.
-         */
-	if (EXT4_SB(sb)->s_sbh->b_blocknr !=
-	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
-		ext4_warning(sb, "won't resize using backup superblock at %llu",
-			(unsigned long long)EXT4_SB(sb)->s_sbh->b_blocknr);
-		return -EPERM;
-	}
