Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C643AC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF792175B
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/iVqFOU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfA2RwC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:52:02 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:35088 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2RwC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 12:52:02 -0500
Received: by mail-it1-f196.google.com with SMTP id p197so5923887itp.0
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pjIqhj17ud7k7lsqJuPirzMlFDbU86F7EHNftih3+qk=;
        b=K/iVqFOUcwU5DrOYzjsVlwFJ1JwisPS2EF/OKBCkTlWJAi5G3BfaiNJVVSIa1spqdt
         Ay/Dd9iTb26loBFSOFUUbdAvlSzTgovsERwnkO151J8vRx10f83lCyOQzVhoQZvn2kM5
         Pb/udwfG+eARiV2qrTNOo+DOpcv5Bb2KaNHSzuwjB6bPiRrx8g/qwqWa4amUg6fHEHJR
         ZCINN8wmdmnsbWNmeMnXgpbVXeDMRg9Bfn796eH/qgnccoY3iSh30YU27O76YS0zHn6Q
         6iAEKD3QvxIjfIy7zBa9ejuKQoAaosLZ5EdOMzIPPpGaLwR/iHDAfk7S9ia7LsD5rogf
         1lEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pjIqhj17ud7k7lsqJuPirzMlFDbU86F7EHNftih3+qk=;
        b=JbpvrdCYLa0B0/LdTC45Rf2hFC2k3MMTyANPF0KYm7ZMfzODz6mb4BapeE+2dc9In7
         0YOtyt4ZoZ6vtSNWG4zAoCyXXNEXBylIDw4yxWramlar2OKWt5fm0uvW20z9AKijglCu
         gIvPvfhTTq/csvYG9C+w5kDZuHCAeN8IcZXkjIsrKIacniXdjCkptPmChIk8+/IM+4s9
         rp5WkfseQtCbEc8XZ4nWQKfzVM4iJ00U+bB963umTYmCy22gLNH4CPjY6Ho0fpY0K4ms
         +ZaLs77ZE40OpkPuduTynR5dL4GG/i4zt5Yna2HVti3GyJ3WxRCjodnBN18whXyajjB/
         tKUg==
X-Gm-Message-State: AJcUukcrFyA1vkq1THeSR87NHWr6HYs/tiY89Cap4dexttBdYEWNZLfS
        CCKoLLYwxiOPzjTzosrnp8ha7cznErU=
X-Google-Smtp-Source: ALg8bN4BGtQmoIR8PXSfd6MAJFzcIl5186QBB5KLqfq+KmSWHLgjVBXdBYHdkdeAtxHCjUC/sJ+Dxw==
X-Received: by 2002:a02:a15e:: with SMTP id m30mr17041324jah.143.1548784320492;
        Tue, 29 Jan 2019 09:52:00 -0800 (PST)
Received: from C02TN4C6HTD6.us.cray.com ([63.239.150.218])
        by smtp.gmail.com with ESMTPSA id b5sm15838778ioc.21.2019.01.29.09.51.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 09:52:00 -0800 (PST)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca
Subject: [PATCH v7 2/4] e2image: add -b and -B options to use supperblock backup
Date:   Tue, 29 Jan 2019 20:51:32 +0300
Message-Id: <20190129175134.26652-3-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190129175134.26652-1-c17828@cray.com>
References: <20190129175134.26652-1-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

e2image has no ability to use superblock backup to copy metadata.
This feature can be useful if someone wants to make partition
image and fix it using e2fsck utility.

New -b option allows to pass superblock number, like e2fsck utility does.
e2image doesn't change primary superblock and store it as is, so
it can be fixed using e2fsck latter. Option -B allows setting
superblock size.

Signed-off-by: Artem Blagodarenko <c17828@cray.com>
---
 misc/e2image.8.in | 33 +++++++++++++++++++++++++++++++++
 misc/e2image.c    | 43 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index a7bfdf24..bbbb57ae 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -12,6 +12,15 @@ e2image \- Save critical ext2/ext3/ext4 filesystem metadata to a file
 ]
 [
 .B \-f
+.B \-b
+.I superblock
+]
+[
+.B \-B
+.I blocksize
+]
+[
+.B \-fr
 ]
 .I device
 .I image-file
@@ -167,6 +176,22 @@ the
 option will prevent analysis of problems related to hash-tree indexed
 directories.
 .PP
+Option
+.B \-b
+.I superblock
+can be used to get image from partition with broken primary superblock.
+The partition is copied as-is including broken primary superblock.
+.PP
+Option
+.B \-B
+.I blocksize
+can be used to set superblock block size. Normally, e2fsck will search
+for the superblock at various different block sizes in an attempt to find
+the appropriate blocksize. This search can be fooled in some cases.  This
+option forces e2fsck to only try locating the superblock at a particular
+blocksize. If the superblock is not found, e2fsck will terminate with a
+fatal error.
+.PP
 Note that this will work even if you substitute "/dev/hda1" for another raw
 disk image, or QCOW2 image previously created by
 .BR e2image .
@@ -217,6 +242,14 @@ This can be useful to write a qcow2 image containing all data to a
 sparse image file where it can be loop mounted, or to a disk partition.
 Note that this may not work with qcow2 images not generated by e2image.
 .PP
+Options
+.B \-b
+.I superblock
+and
+.B \-B
+.I blocksize
+can be used same way as for raw images.
+.PP
 .SH INCLUDING DATA
 Normally
 .B e2image
diff --git a/misc/e2image.c b/misc/e2image.c
index 9e21d0db..3c881fee 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -104,7 +104,8 @@ static int get_bits_from_size(size_t size)
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -f ] device image-file\n"),
+	fprintf(stderr, _("Usage: %s [ -r|Q ] [ -f ] [ -b superblock ] [ -B blocksize]"
+			  "[ -fr ] device image-file\n"),
 		program_name);
 	fprintf(stderr, _("       %s -I device image-file\n"), program_name);
 	fprintf(stderr, _("       %s -ra  [  -cfnp  ] [ -o src_offset ] "
@@ -1267,7 +1268,8 @@ static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
 	free_qcow2_image(img);
 }
 
-static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
+static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags,
+				 blk64_t superblock)
 {
 	struct process_block_struct	pb;
 	struct ext2_inode		inode;
@@ -1295,6 +1297,22 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 		}
 	}
 
+	if (superblock) {
+		int j;
+
+		ext2fs_mark_block_bitmap2(meta_block_map, superblock);
+		meta_blocks_count++;
+
+		/*
+		 * Mark the backup superblock descriptors
+		 */
+		for (j = 0; j < fs->desc_blocks; j++) {
+			ext2fs_mark_block_bitmap2(meta_block_map,
+			ext2fs_descriptor_block_loc2(fs, superblock, j));
+		}
+		meta_blocks_count += fs->desc_blocks;
+	}
+
 	mark_table_blocks(fs);
 	if (show_progress)
 		fprintf(stderr, "%s", _("Scanning inodes...\n"));
@@ -1474,6 +1492,8 @@ int main (int argc, char ** argv)
 	int ignore_rw_mount = 0;
 	int check = 0;
 	struct stat st;
+	blk64_t superblock = 0;
+	int blocksize = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1487,8 +1507,14 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt(argc, argv, "nrsIQafo:O:pc")) != EOF)
+	while ((c = getopt(argc, argv, "b:B:nrsIQafo:O:pc")) != EOF)
 		switch (c) {
+		case 'b':
+			superblock = strtoull(optarg, NULL, 0);
+			break;
+		case 'B':
+			blocksize = strtoul(optarg, NULL, 0);
+			break;
 		case 'I':
 			flags |= E2IMAGE_INSTALL_FLAG;
 			break;
@@ -1540,6 +1566,11 @@ int main (int argc, char ** argv)
 						 "with raw or QCOW2 images."));
 		exit(1);
 	}
+	if (superblock && !img_type) {
+		com_err(program_name, 0, "%s", _("-b option can only be used "
+						 "with raw or QCOW2 images."));
+		exit(1);
+	}
 	if ((source_offset || dest_offset) && img_type != E2IMAGE_RAW) {
 		com_err(program_name, 0, "%s",
 			_("Offsets are only allowed with raw images."));
@@ -1590,8 +1621,8 @@ int main (int argc, char ** argv)
 		}
 	}
 	sprintf(offset_opt, "offset=%llu", source_offset);
-	retval = ext2fs_open2(device_name, offset_opt, open_flag, 0, 0,
-			      unix_io_manager, &fs);
+	retval = ext2fs_open2(device_name, offset_opt, open_flag,
+			      superblock, blocksize, unix_io_manager, &fs);
         if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
@@ -1681,7 +1712,7 @@ skip_device:
 		exit(1);
 	}
 	if (img_type)
-		write_raw_image_file(fs, fd, img_type, flags);
+		write_raw_image_file(fs, fd, img_type, flags, superblock);
 	else
 		write_image_file(fs, fd);
 
-- 
2.14.3

