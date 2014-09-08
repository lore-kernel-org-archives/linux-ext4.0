From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/25] libext2fs: report bad magic over bad sb checksum
Date: Mon, 08 Sep 2014 16:11:49 -0700
Message-ID: <20140908231149.25904.94554.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48870 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaIHXLy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:11:54 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't want ext2fs_open2() to report bad sb checksum on something
that's not even an ext* superblock.  This apparently happens pretty
easily if we try to open an XFS filesystem.  Thus, make it so that a
bad magic number code always trumps the sb checksum error code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/openfs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 00320f3..1d6f147 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -221,8 +221,6 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 			retval = EXT2_ET_UNKNOWN_CSUM;
 		if (!ext2fs_superblock_csum_verify(fs, fs->super))
 			retval = EXT2_ET_SB_CSUM_INVALID;
-		if (retval)
-			goto cleanup;
 	}
 
 #ifdef WORDS_BIGENDIAN
@@ -235,10 +233,11 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	}
 #endif
 
-	if (fs->super->s_magic != EXT2_SUPER_MAGIC) {
+	if (fs->super->s_magic != EXT2_SUPER_MAGIC)
 		retval = EXT2_ET_BAD_MAGIC;
+	if (retval)
 		goto cleanup;
-	}
+
 	if (fs->super->s_rev_level > EXT2_LIB_CURRENT_REV) {
 		retval = EXT2_ET_REV_TOO_HIGH;
 		goto cleanup;

