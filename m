From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] mke2fs: set s_overhead_blocks
Date: Mon, 11 Feb 2013 14:45:34 -0600
Message-ID: <5119586E.8060400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab3BKUp2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 15:45:28 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1BKjRaE018482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2013 15:45:27 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r1BKjOA6002451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2013 15:45:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The recent thread on the list about strange df behavior made me go
look at how we were calculating s_overhead_blocks again, and I realized
that mkfs still doesn't set it.  It seems like a simple thing to do;
just look at how many blocks are in use when mkfs is done.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

However, I realize that resize2fs breaks this.  And by the time
we have a populated fs, with bigalloc/meta/flex/whatnot, the
calculation of overhead gets very tricky again.  (at least
for shrinking; growing is probably easier)

Ted, did you have a better patch for this?  You added the
superblock field so maybe you had something in mind to keep it
up to date as the filesystem size changes?


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..3413bb2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2346,6 +2346,38 @@ static int create_quota_inodes(ext2_filsys fs)
 	return 0;
 }
 
+/*
+ * Set the filesystem's metadata overhead - the number of blocks
+ * used for all mkfs-time metadata.  We could carefully account
+ * for all blocks, or do it the easy way:  See how many blocks
+ * have been used by mkfs, at the end of mkfs.  Add the space used
+ * by the root dir and lost+found back in.
+ */
+void set_fs_overhead(ext2_filsys fs) {
+	unsigned int		overhead;
+	struct ext2_inode       inode;
+	ext2_ino_t		inum;
+	blk64_t			iblocks;
+
+	/* overhead is everything mkfs has used ... */
+	overhead = ext2fs_blocks_count(fs->super) -
+		ext2fs_free_blocks_count(fs->super);
+
+	/* ... not counting / and /lost+found */
+	if (!ext2fs_read_inode(fs, EXT2_ROOT_INO, &inode)) {
+		iblocks = ext2fs_inode_i_blocks(fs, &inode);
+		overhead -= (iblocks << 9) / fs->blocksize;
+	}
+
+	if (!ext2fs_lookup(fs, EXT2_ROOT_INO, "lost+found", 10, 0, &inum) &&
+	    !ext2fs_read_inode(fs, inum, &inode)) {
+		iblocks = ext2fs_inode_i_blocks(fs, &inode);
+		overhead -= (iblocks << 9) / fs->blocksize;
+	}
+
+	fs->super->s_overhead_blocks = overhead;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -2733,6 +2764,8 @@ no_journal:
 				       EXT4_FEATURE_RO_COMPAT_QUOTA))
 		create_quota_inodes(fs);
 
+	set_fs_overhead(fs);
+
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));

