From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] Print extent information in debugfs
Date: Thu, 23 Jul 2009 13:36:29 -0700
Message-ID: <6601abe90907231336o64cdc786r634d29be822316af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:29337 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZGWUge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 16:36:34 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n6NKaWYm001878
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 21:36:33 +0100
Received: from wf-out-1314.google.com (wfd26.prod.google.com [10.142.4.26])
	by wpaz29.hot.corp.google.com with ESMTP id n6NKaUrU007087
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 13:36:30 -0700
Received: by wf-out-1314.google.com with SMTP id 26so357230wfd.0
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 13:36:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Building on the email that Ricky Benitez sent out earlier this month ("Tool
to view extent metadata"), I really wanted to look at the extent descriptors
while working on the O_DIRECT/fallocate/page cache issue, so I created this
patch to debugfs; it adds to the 'stat' command, and only for extent-based
files.

The output pretty much mirrors the BLOCKS output; it shows each extent
simply as a range of logical blocks to the file, plus "[uninit]" if this bit
is set.

Here's some sample output from the 'stat' command for a ~100MB file (that's
been fallocate'd and written):

===========================================================
...
atime: 0x4a679eb7 -- Wed Jul 22 16:20:23 2009
mtime: 0x4a68b71f -- Thu Jul 23 12:16:47 2009
Extents (logical blocks):
(0-25599), (25600-30719 [uninit]), (30720-61439 [uninit]),
(61440-63487 [uninit]), (63488-94207 [uninit]), (94208-96255
[uninit]), (96256-124927 [uninit]), (124928-131071 [uninit])
BLOCKS:
(IND):133120, (0-63487):34816-98303, (63488-96255):100352-133119,
(96256-124927):135168-163839, (124928-131071):165888-172031
TOTAL: 131073
===========================================================

Does this seem reasonable?  Generally useful?

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>

---
--- debugfs/debugfs.c.orig	2009-06-30 20:41:09.000000000 -0700
+++ debugfs/debugfs.c	2009-07-23 13:15:32.000000000 -0700
@@ -552,6 +552,45 @@
 }


+static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	int			op = EXT2_EXTENT_ROOT;
+	unsigned int		printed = 0;
+	errcode_t 		errcode;
+
+	errcode = ext2fs_extent_open(current_fs, ino, &handle);
+	if (errcode)
+		return;
+
+	fprintf(f, "%sExtents (logical blocks):\n%s", prefix, prefix);
+
+	while (1) {
+		errcode = ext2fs_extent_get(handle, op, &extent);
+
+		if (errcode)
+			break;
+
+		op = EXT2_EXTENT_NEXT;
+
+		if (!(extent.e_flags & EXT2_EXTENT_FLAGS_LEAF))
+			continue;
+
+		fprintf(f,
+			"%s(%lld-%lld%s)",
+			printed ? ", " : "",
+			extent.e_lblk,
+			extent.e_lblk + (extent.e_len - 1),
+			extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT ?
+			         " [uninit]" : "");
+		printed = 1;
+	}
+	if (printed)
+		fprintf(f, "\n");
+}
+
+
 void internal_dump_inode(FILE *out, const char *prefix,
 			 ext2_ino_t inode_num, struct ext2_inode *inode,
 			 int do_dump_blocks)
@@ -649,6 +688,11 @@
 	if (inode->i_dtime)
 	  fprintf(out, "%sdtime: 0x%08x -- %s", prefix, inode->i_dtime,
 		  time_to_string(inode->i_dtime));
+
+	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		dump_extents(out, prefix, inode_num);
+	}
+
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
