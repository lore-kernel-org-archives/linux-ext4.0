From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/12] mke2fs: store checksum seed at format time
Date: Mon, 12 Oct 2015 14:57:37 -0700
Message-ID: <20151012215737.29065.99187.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40292 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbJLV5m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:57:42 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow users to turn on metadata_csum_seed at format time so that UUIDs
can be live-changed at any time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9a2a6cc..0c344ae 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1074,7 +1074,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT|
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
-		EXT4_FEATURE_INCOMPAT_ENCRYPT,
+		EXT4_FEATURE_INCOMPAT_ENCRYPT |
+		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2775,6 +2776,13 @@ int main (int argc, char *argv[])
 				 "Pass -O 64bit to rectify.\n"));
 	}
 
+	if (ext2fs_has_feature_csum_seed(fs->super) &&
+	    !ext2fs_has_feature_metadata_csum(fs->super)) {
+		printf("%s", _("The metadata_csum_seed feature "
+			       "requres the metadata_csum feature.\n"));
+		exit(1);
+	}
+
 	/* Calculate journal blocks */
 	if (!journal_device && ((journal_size) ||
 	    ext2fs_has_feature_journal(&fs_param)))
@@ -2830,6 +2838,11 @@ int main (int argc, char *argv[])
 		}
 	} else
 		uuid_generate(fs->super->s_uuid);
+
+	if (ext2fs_has_feature_csum_seed(fs->super))
+		fs->super->s_checksum_seed = ext2fs_crc32c_le(~0,
+				fs->super->s_uuid, sizeof(fs->super->s_uuid));
+
 	ext2fs_init_csum_seed(fs);
 
 	/*

