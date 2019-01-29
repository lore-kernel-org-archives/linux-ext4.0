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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E66EC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D4912175B
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PCFPfbwk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfA2RwA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:52:00 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:38446 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2Rv7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 12:51:59 -0500
Received: by mail-it1-f194.google.com with SMTP id z20so5891141itc.3
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3+Et5nP7uv92grLMjDx+Rta0GfSYsc+7mr2xH64pblU=;
        b=PCFPfbwk2KC//PzyPJz5PxBMAFRircsD0XjgwRBlqVUMWIpPpprcyM7Ewxktmrwwv3
         xm+VqiNvh3eYqBH/piEGPW1d+3Wtl65Dlis0xSmMOJwpS06MtYBijFX99IXcHBS8g3KR
         ChbDlnU28S+ZpP2SUaLYlaRclQUW7uGOF+sUEyzMD9R17g37JTaGpPOEke8ZC0V0lMu7
         oQxzBsOI03W6n3koHwM0BKgZCx1fRpmL4jd68LkU3ZJJ7F6VFQyuqC8O3tDdMbL5BqtZ
         WnRlUv2wNY4op3z85xJ/iHGmBhUmIHVyBKj/jruqSHfPYr/kPh1Rl1HxXVMt0VnCuV+E
         mtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3+Et5nP7uv92grLMjDx+Rta0GfSYsc+7mr2xH64pblU=;
        b=auC1clNmsrX1UrD2XEbsYKCpeW2aldHMIOdbKIN9yp8eKidiLJJg8uG58Btr2qyLVF
         9TELoXZK0EB9MEUBu/eWidNFXc7tMS3C4NxE5YgaKUNzKMIXjhS4FUjOQf4TS8qdOpeT
         2Pb87QziiXY6B8nL+2ReX64hGIF6kzP/OtFlwCk4rOxvimHG3x1wCvitB4HT6hCzPCJa
         a/GOkpJUWTVxvPJO/2q+5JrkoYd5Sf+TqX2sWjEH1jbv0kSO7E9Xu3hatL0Hl4J3Wa+x
         1OlrJVnLT6EnnOXJZkyN/VZFffuMjmQXs6iswBn8lBv1bgj1ckIkVyXbcMr4g1LSot65
         iEwA==
X-Gm-Message-State: AJcUukcP7WHVXNKW5VS5J6JkgkJNE9DQ/vjagUtYZvn8hEiqe7NN5Irr
        OXeMilK4/90BdxJP1epu6YRI3bR/ooI=
X-Google-Smtp-Source: ALg8bN5sX1IemyK14o27WySLJFWNGb1POb/hXzIBvGdBMNuMP4tgvXNSnwLAlI4CAW39uF8KtFi1zg==
X-Received: by 2002:a02:85ae:: with SMTP id d43mr17034558jai.70.1548784318464;
        Tue, 29 Jan 2019 09:51:58 -0800 (PST)
Received: from C02TN4C6HTD6.us.cray.com ([63.239.150.218])
        by smtp.gmail.com with ESMTPSA id b5sm15838778ioc.21.2019.01.29.09.51.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 09:51:58 -0800 (PST)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca
Subject: [PATCH v7 1/4] ext2fs: opening filesystem code refactoring
Date:   Tue, 29 Jan 2019 20:51:31 +0300
Message-Id: <20190129175134.26652-2-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190129175134.26652-1-c17828@cray.com>
References: <20190129175134.26652-1-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

There are similar opening filesystem code in different utilities.

The patch moves improved handling from try_open_fs()
into ext2fs_open(). This function make one of the action
based on parameters:
1) open filesystem with given superblock, superblock size
2) open filesystem with given superblock, but try to
find right block size

Signed-off-by: Artem Blagodarenko <c17828@cray.com>
---
 e2fsck/unix.c       | 28 +++-------------------------
 lib/ext2fs/openfs.c | 39 +++++++++++++++++++++++++++++++++++----
 misc/dumpe2fs.c     | 17 ++---------------
 3 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5b3552ec..ddcf52a4 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1151,31 +1151,9 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 			     ext2_filsys *ret_fs)
 {
 	errcode_t retval;
-
-	*ret_fs = NULL;
-	if (ctx->superblock && ctx->blocksize) {
-		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
-				      flags, ctx->superblock, ctx->blocksize,
-				      io_ptr, ret_fs);
-	} else if (ctx->superblock) {
-		int blocksize;
-		for (blocksize = EXT2_MIN_BLOCK_SIZE;
-		     blocksize <= EXT2_MAX_BLOCK_SIZE; blocksize *= 2) {
-			if (*ret_fs) {
-				ext2fs_free(*ret_fs);
-				*ret_fs = NULL;
-			}
-			retval = ext2fs_open2(ctx->filesystem_name,
-					      ctx->io_options, flags,
-					      ctx->superblock, blocksize,
-					      io_ptr, ret_fs);
-			if (!retval)
-				break;
-		}
-	} else
-		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
-				      flags, 0, 0, io_ptr, ret_fs);
-
+	retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
+			   flags, ctx->superblock, ctx->blocksize,
+			   io_ptr, ret_fs);
 	if (retval == 0) {
 		(*ret_fs)->priv_data = ctx;
 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 85d73e2a..16d36200 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -114,10 +114,10 @@ static void block_sha_map_free_entry(void *data)
  *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
  *				filesystems)
  */
-errcode_t ext2fs_open2(const char *name, const char *io_options,
-		       int flags, int superblock,
-		       unsigned int block_size, io_manager manager,
-		       ext2_filsys *ret_fs)
+static errcode_t __ext2fs_open2(const char *name, const char *io_options,
+				int flags, int superblock,
+				unsigned int block_size, io_manager manager,
+				ext2_filsys *ret_fs)
 {
 	ext2_filsys	fs;
 	errcode_t	retval;
@@ -515,6 +515,37 @@ cleanup:
 	return retval;
 }
 
+errcode_t ext2fs_open2(const char *name, const char *io_options,
+		       int flags, int superblock,
+		       unsigned int block_size, io_manager manager,
+		       ext2_filsys *ret_fs)
+{
+	errcode_t retval;
+
+	*ret_fs = NULL;
+	if (superblock && block_size) {
+		retval = __ext2fs_open2(name, io_options,
+				      flags, superblock, block_size,
+				      manager, ret_fs);
+	} else {
+		int size;
+
+		for (size = EXT2_MIN_BLOCK_SIZE;
+		     size <= EXT2_MAX_BLOCK_SIZE; size *= 2) {
+			if (*ret_fs) {
+				ext2fs_free(*ret_fs);
+				*ret_fs = NULL;
+			}
+			retval = __ext2fs_open2(name, io_options, flags,
+						superblock, size,
+						manager, ret_fs);
+			if (!retval)
+				break;
+		}
+	}
+	return retval;
+}
+
 /*
  * Set/get the filesystem data I/O channel.
  *
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 384ce925..183e2f6f 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -667,21 +667,8 @@ int main (int argc, char ** argv)
 	if (image_dump)
 		flags |= EXT2_FLAG_IMAGE_FILE;
 try_open_again:
-	if (use_superblock && !use_blocksize) {
-		for (use_blocksize = EXT2_MIN_BLOCK_SIZE;
-		     use_blocksize <= EXT2_MAX_BLOCK_SIZE;
-		     use_blocksize *= 2) {
-			retval = ext2fs_open (device_name, flags,
-					      use_superblock,
-					      use_blocksize, unix_io_manager,
-					      &fs);
-			if (!retval)
-				break;
-		}
-	} else {
-		retval = ext2fs_open(device_name, flags, use_superblock,
-				     use_blocksize, unix_io_manager, &fs);
-	}
+	retval = ext2fs_open2(device_name, 0, flags, use_superblock,
+			      use_blocksize, unix_io_manager, &fs);
 	flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (retval && !retval_csum) {
 		retval_csum = retval;
-- 
2.14.3

