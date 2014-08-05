From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/21] libext2fs: fix memory leak when failing to iterate
 inline_data directory
Date: Mon, 04 Aug 2014 18:05:49 -0700
Message-ID: <20140805010549.2611.73733.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40240 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBFy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:54 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The xattr_get method returns to us a pointer to a buffer containing
the EA value.  If for some reason we decide to fail out of iterating
the EA part of an inline-data directory, we must free the buffer that
xattr_get passed to us (via inline_data_ea_get).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 8a71d18..aeef329 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -214,7 +214,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 		goto out;
 	}
 	if (data.ea_size <= 0)
-		goto out;
+		goto out1;
 
 	ctx->buf = data.ea_data;
 	ctx->buflen = data.ea_size;
@@ -222,7 +222,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 	ctx->errcode = ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0);
 	if (ctx->errcode) {
 		ret |= BLOCK_ABORT;
-		goto out;
+		goto out1;
 	}
 #endif
 

