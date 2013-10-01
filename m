From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/31] libext2fs: openfs() musn't allow bigalloc without
 EXT2_FLAGS_64BITS
Date: Mon, 30 Sep 2013 18:29:28 -0700
Message-ID: <20131001012928.28415.62086.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22942 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3JAB3i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:38 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, only the 64-bit bitmap implementation supports the block<->cluster
conversions that bigalloc requires.  Therefore, if we have a bigalloc
filesystem, require EXT2_FLAGS_64BITS be passed in to ext2fs_open().

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/openfs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 3c0bf14..f486a35 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -272,6 +272,18 @@ errcode_t ext2fs_open3(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
+
+	/*
+	 * bigalloc requires cluster-aware bitfield operations, which at the
+	 * moment means we need EXT2_FLAG_64BITS.
+	 */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
+	    !(flags & EXT2_FLAG_64BITS)) {
+		retval = EXT2_ET_CANT_USE_LEGACY_BITMAPS;
+		goto cleanup;
+	}
+
 	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
 	    (fs->super->s_log_block_size != fs->super->s_log_cluster_size)) {

