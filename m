Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69547C10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416A020850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfDMFnb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:31 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37482 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfDMFna (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 392A3281C30
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 02/10] ext2fs: Always attempt to load nls table when loading the filesystem
Date:   Sat, 13 Apr 2019 01:43:09 -0400
Message-Id: <20190413054317.7388-3-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

fs->encoding is exposed by the library, so we need to at least try to
load it when populating ext2_filsys.  Nevertheless, failing to do so
shouldn't be a fatal error, unless the user really needs that
information.  Thus, we ignore this failure during open/initialization
and let the user who needs it validate that field before trying to use
it.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 e2fsck/unix.c           | 12 ++++--------
 lib/ext2fs/initialize.c |  4 ++++
 lib/ext2fs/openfs.c     |  4 ++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5b3552ece6b1..7c24f2e31e4f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -55,7 +55,6 @@ extern int optind;
 #include "problem.h"
 #include "jfs_user.h"
 #include "../version.h"
-#include <ext2fs/nls.h>
 
 /* Command line options */
 static int cflag;		/* check disk */
@@ -1785,13 +1784,10 @@ print_unsupp_features:
 		goto get_newer;
 	}
 
-	if (ext2fs_has_feature_fname_encoding(sb)) {
-		fs->encoding = nls_load_table(sb->s_encoding);
-		if (!fs->encoding) {
-			log_err(ctx, _("%s has unsupported encoding: %0x\n"),
-				ctx->filesystem_name, sb->s_encoding);
-			goto get_newer;
-		}
+	if (ext2fs_has_feature_fname_encoding(sb) && !fs->encoding) {
+		log_err(ctx, _("%s has unsupported encoding: %0x\n"),
+			ctx->filesystem_name, sb->s_encoding);
+		goto get_newer;
 	}
 
 	/*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 30b1ae033340..2d470a070bcc 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -27,6 +27,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "nls.h"
 
 #ifndef O_BINARY
 #define O_BINARY 0
@@ -190,6 +191,9 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	assign_field(s_encoding);
 	assign_field(s_encoding_flags);
 
+	if (ext2fs_has_feature_fname_encoding(param))
+		fs->encoding = nls_load_table(param->s_encoding);
+
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 85d73e2a429b..9ee6cd07f7f3 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -32,6 +32,7 @@
 
 #include "ext2fs.h"
 #include "e2image.h"
+#include "nls.h"
 
 blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
 				     dgrp_t i)
@@ -502,6 +503,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		ext2fs_set_feature_shared_blocks(fs->super);
 	}
 
+	if (ext2fs_has_feature_fname_encoding(fs->super))
+		fs->encoding = nls_load_table(fs->super->s_encoding);
+
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs = fs;
 
-- 
2.20.1

