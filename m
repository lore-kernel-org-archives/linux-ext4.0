From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 4/5] tune2fs: update journal super block when changing UUID for fs.
Date: Thu, 10 Jul 2014 18:35:07 +0400
Message-ID: <1405002908-16332-5-git-send-email-a3at.mail@gmail.com>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Cc: darrick.wong@oracle.com, adilger@dilger.ca, tytso@mit.edu,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:55677 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGJOfb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:35:31 -0400
Received: by mail-la0-f51.google.com with SMTP id mc6so6112770lab.24
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:35:30 -0700 (PDT)
In-Reply-To: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
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
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/tune2fs.c | 74 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 18 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b395c7c..d1fa6ba 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -180,6 +180,38 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
+/**
+ * Try to get journal super block if any
+ */
+static int get_journal_sb(ext2_filsys jfs, char buf[EXT2_SUPERBLOCK_SIZE])
+{
+	int retval;
+	int start;
+	journal_superblock_t *jsb;
+
+	if (!(jfs->super->s_feature_incompat &
+	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+		return EXT2_ET_UNSUPP_FEATURE;
+	}
+
+	/* Get the journal superblock */
+	if ((retval = io_channel_read_blk64(jfs->io,
+	    ext2fs_journal_sb_start(jfs->blocksize), -EXT2_SUPERBLOCK_SIZE, buf))) {
+		com_err(program_name, retval, "%s",
+		_("while reading journal superblock"));
+		return retval;
+	}
+
+	jsb = (journal_superblock_t *) buf;
+	if ((jsb->s_header.h_magic != (unsigned)ntohl(JFS_MAGIC_NUMBER)) ||
+	    (jsb->s_header.h_blocktype != (unsigned)ntohl(JFS_SUPERBLOCK_V2))) {
+		fputs(_("Journal superblock not found!\n"), stderr);
+		return EXT2_ET_BAD_MAGIC;
+	}
+
+	return 0;
+}
+
 /*
  * Remove an external journal from the filesystem
  */
@@ -223,29 +255,15 @@ static int remove_journal_device(ext2_filsys fs)
 			_("while trying to open external journal"));
 		goto no_valid_journal;
 	}
-	if (!(jfs->super->s_feature_incompat &
-	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-		fprintf(stderr, _("%s is not a journal device.\n"),
-			journal_path);
-		goto no_valid_journal;
-	}
 
-	start = ext2fs_journal_sb_start(fs->blocksize);
-	/* Get the journal superblock */
-	if ((retval = io_channel_read_blk64(jfs->io, start,
-	    -EXT2_SUPERBLOCK_SIZE, buf))) {
-		com_err(program_name, retval, "%s",
-			_("while reading journal superblock"));
+	if ((retval = get_journal_sb(jfs, buf))) {
+		if (retval == EXT2_ET_UNSUPP_FEATURE)
+			fprintf(stderr, _("%s is not a journal device.\n"),
+				journal_path);
 		goto no_valid_journal;
 	}
 
 	jsb = (journal_superblock_t *) buf;
-	if ((jsb->s_header.h_magic != (unsigned)ntohl(JFS_MAGIC_NUMBER)) ||
-	    (jsb->s_header.h_blocktype != (unsigned)ntohl(JFS_SUPERBLOCK_V2))) {
-		fputs(_("Journal superblock not found!\n"), stderr);
-		goto no_valid_journal;
-	}
-
 	/* Find the filesystem UUID */
 	nr_users = ntohl(jsb->s_nr_users);
 	for (i = 0; i < nr_users; i++) {
@@ -2695,6 +2713,7 @@ retry_open:
 	if (U_flag) {
 		int set_csum = 0;
 		dgrp_t i;
+		char buf[EXT2_SUPERBLOCK_SIZE];
 
 		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
@@ -2740,6 +2759,25 @@ retry_open:
 				ext2fs_group_desc_csum_set(fs, i);
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 		}
+
+		/* If this is a journal dev, we need to copy UUID into jsb */
+		if (!(rc = get_journal_sb(fs, buf))) {
+			journal_superblock_t *jsb;
+
+			jsb = (journal_superblock_t *) buf;
+			fputs(_("Need to update journal superblock.\n"), stdout);
+			memcpy(jsb->s_uuid, sb->s_uuid, sizeof(sb->s_uuid));
+
+			/* Writeback the journal superblock */
+			if ((rc = io_channel_write_blk64(fs->io,
+				ext2fs_journal_sb_start(fs->blocksize),
+					-EXT2_SUPERBLOCK_SIZE, buf)))
+				goto closefs;
+		} else if (rc != EXT2_ET_UNSUPP_FEATURE)
+			goto closefs;
+		else
+			rc = 0; /** Reset rc to avoid ext2fs_mmp_stop() */
+
 		ext2fs_mark_super_dirty(fs);
 		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-- 
2.0.0

