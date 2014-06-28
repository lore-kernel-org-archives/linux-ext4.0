From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH] tune2fs: update journal super block when changing UUID for fs.
Date: Sat, 28 Jun 2014 18:29:46 +0400
Message-ID: <1403965786-14561-1-git-send-email-a3at.mail@gmail.com>
Cc: chintzung@gmail.com, Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33282 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaF1OaI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Jun 2014 10:30:08 -0400
Received: by mail-la0-f54.google.com with SMTP id mc6so3795568lab.27
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jun 2014 07:30:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using -U option you can change the UUID for fs, however it will not work
for journal device, since it have a copy of this UUID inside jsb (i.e.
journal super block). So copy UUID on change into that block.

Here is the initial thread:
http://comments.gmane.org/gmane.comp.file-systems.ext4/44532

You can reproduce this by executing following commands:
$ fallocate -l100M /tmp/dev
$ fallocate -l100M /tmp/journal
$ sudo /sbin/losetup /dev/loop1 /tmp/dev
$ sudo /sbin/losetup /dev/loop0 /tmp/journal
$ mke2fs -O journal_dev /tmp/journal
$ tune2fs -U da1f2ed0-60f6-aaaa-92fd-738701418523 /tmp/journal
$ sudo mke2fs -t ext4 -J device=/dev/loop0 /dev/loop1
$ dumpe2fs -h /tmp/dev | fgrep UUID
dumpe2fs 1.43-WIP (18-May-2014)
Filesystem UUID:          8a776be9-12eb-411f-8e88-b873575ecfb6
Journal UUID:             e3d02151-e776-4865-af25-aecb7291e8e5
$ sudo e2fsck /dev/vdc
e2fsck 1.43-WIP (18-May-2014)
External journal does not support this filesystem

/dev/loop1: ********** WARNING: Filesystem still has errors **********

Reported-by: Chin Tzung Cheng <chintzung@gmail.com>
Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
Here is the RFC patch for this, I'm not sure about the check for *is this 
journal device or not*, so I will glad to see some comments. Thanks.

 misc/tune2fs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d95cc3d..ffa07f6 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2411,6 +2411,10 @@ int main(int argc, char **argv)
 	struct ext2_super_block *sb;
 	io_manager io_ptr, io_ptr_orig = NULL;
 	int rc = 0;
+	/** For journal dev */
+	journal_superblock_t	*jsb;
+	int jsb_start;
+	char		buf[1024];
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -2736,6 +2740,26 @@ retry_open:
 				ext2fs_group_desc_csum_set(fs, i);
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 		}
+
+		/* If this is a journal dev, we need to copy UUID into jsb */
+		jsb_start = 1;
+		if (fs->blocksize == 1024)
+			jsb_start++;
+		if ((rc = io_channel_read_blk64(fs->io, jsb_start, -1024, buf))) {
+			goto closefs;
+		}
+		jsb = (journal_superblock_t *) buf;
+		if ((jsb->s_header.h_magic == (unsigned) ntohl(JFS_MAGIC_NUMBER)) ||
+				(jsb->s_header.h_blocktype == (unsigned) ntohl(JFS_SUPERBLOCK_V2))) {
+			fputs(_("Need to update journal superblock.\n"), stdout);
+			memcpy(jsb->s_uuid, sb->s_uuid, sizeof(sb->s_uuid));
+
+			/* Writeback the journal superblock */
+			if ((rc = io_channel_write_blk64(fs->io, jsb_start, -1024, buf))) {
+				goto closefs;
+			}
+		}
+
 		ext2fs_mark_super_dirty(fs);
 		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-- 
2.0.0

