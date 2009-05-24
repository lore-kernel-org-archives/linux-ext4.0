From: Gertjan van Wingerde <gertjan@vanwingerde.net>
Subject: [PATCH v2] dump: support for ext4 file-systems on Linux.
Date: Sun, 24 May 2009 18:08:57 +0200
Message-ID: <4A197119.4000902@vanwingerde.net>
References: <4A1935AA.6090103@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090604090406040501050609"
Cc: linux-ext4@vger.kernel.org, dump-devel@lists.sourceforge.net
To: stelian@popies.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:51246 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbZEXQI6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 May 2009 12:08:58 -0400
In-Reply-To: <4A1935AA.6090103@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090604090406040501050609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

version 2 attached. The original patch contained a bug in which ext4 extents index nodes were dumped as well as part of a regular file dump.
Still only for Linux.

---
Gertjan van Wingerde.


On 05/24/09 13:55, Gertjan van Wingerde wrote:
> Hi,
> 
> Find attached a patch I created to support the dumping and restoring of ext4 file-systems under Linux.
> For now it only works on Linux, as it uses the ext2fs library functions to get hold of the real data blocks.
> I don't understand dump enough to also handle the non-Linux case, although it would seems that relying on
> the ext2fs library for other systems would be appropriate.
> 
> N.B. Note that I am not subscribed to the mailing list, so cc me on replies.
> 
> ---
> Gertjan.


--------------090604090406040501050609
Content-Type: text/plain;
 name="dump_ext4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dump_ext4.diff"

diff -u --recursive --new-file dump-0.4b41/dump/traverse.c dump-0.4b41.ext4/dump/traverse.c
--- dump-0.4b41/dump/traverse.c	2005-05-02 17:10:46.000000000 +0200
+++ dump-0.4b41.ext4/dump/traverse.c	2009-05-24 16:13:52.417643761 +0200
@@ -777,8 +777,6 @@
 	struct block_context *p;
 	e2_blkcnt_t i;
 
-	if (blockcnt < NDADDR)
-		return 0;
 	p = (struct block_context *)private;
 	for (i = p->next_block; i < blockcnt; i++) {
 		p->buf[p->cnt++] = 0;
@@ -986,19 +984,6 @@
 		msg("Warning: undefined file type 0%o\n", dp->di_mode & IFMT);
 		return;
 	}
-	if (i_size > (u_quad_t)NDADDR * sblock->fs_bsize)
-#ifdef	__linux__
-		cnt = NDADDR * EXT2_FRAGS_PER_BLOCK(fs->super);
-#else
-		cnt = NDADDR * sblock->fs_frag;
-#endif
-	else
-		cnt = howmany(i_size, sblock->fs_fsize);
-	blksout(&dp->di_db[0], cnt, ino);
-	if ((quad_t) (size = i_size - NDADDR * sblock->fs_bsize) <= 0) {
-		dump_xattr(ino, dp);
-		return;
-	}
 #ifdef	__linux__
 	bc.max = NINDIR(sblock) * EXT2_FRAGS_PER_BLOCK(fs->super);
 	bc.buf = (int *)malloc (bc.max * sizeof (int));
@@ -1006,7 +991,7 @@
 	bc.ino = ino;
 	bc.next_block = NDADDR;
 
-	ext2fs_block_iterate2(fs, (ext2_ino_t)ino, 0, NULL, dumponeblock, (void *)&bc);
+	ext2fs_block_iterate2(fs, (ext2_ino_t)ino, BLOCK_FLAG_DATA_ONLY, NULL, dumponeblock, (void *)&bc);
 	/* deal with holes at the end of the inode */
 	if (i_size > ((u_quad_t)bc.next_block) * sblock->fs_fsize) {
 		remaining = i_size - ((u_quad_t)bc.next_block) * sblock->fs_fsize;
@@ -1024,6 +1009,15 @@
 	free(bc.buf);
 	dump_xattr(ino, dp);
 #else
+	if (i_size > (u_quad_t)NDADDR * sblock->fs_bsize)
+		cnt = NDADDR * sblock->fs_frag;
+	else
+		cnt = howmany(i_size, sblock->fs_fsize);
+	blksout(&dp->di_db[0], cnt, ino);
+	if ((quad_t) (size = i_size - NDADDR * sblock->fs_bsize) <= 0) {
+		dump_xattr(ino, dp);
+		return;
+	}
 	for (ind_level = 0; ind_level < NIADDR; ind_level++) {
 		dmpindir(ino, dp->di_ib[ind_level], ind_level, &size);
 		if (size <= 0)

--------------090604090406040501050609--
