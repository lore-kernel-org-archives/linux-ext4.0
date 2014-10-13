From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: check s_chksum_driver when looking for bg csum presence
Date: Mon, 13 Oct 2014 14:18:45 -0700
Message-ID: <20141013211845.GH12009@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40617 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaJMVSz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2014 17:18:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert the ext4_has_group_desc_csum predicate to look for a checksum
driver instead of the metadata_csum flag and change the bg checksum
calculation function to look for GDT_CSUM before taking the crc16
path.

Without this patch, if we mount with ^uninit_bg,^metadata_csum and
later metadata_csum gets turned on by accident, the block group
checksum functions will incorrectly assume that checksumming is
enabled (metadata_csum) but that crc16 should be used
(!s_chksum_driver).  This is totally wrong, so fix the predicate
and the checksum formula selection.

(Granted, if the metadata_csum feature bit gets enabled on a live FS
then something underhanded is going on, but we could at least avoid
writing garbage into the on-disk fields.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    4 ++--
 fs/ext4/super.c |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fb6aadf..db38ca0f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2367,8 +2367,8 @@ extern int ext4_register_li_request(struct super_block *sb,
 static inline int ext4_has_group_desc_csum(struct super_block *sb)
 {
 	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
+	       (EXT4_SB(sb)->s_chksum_driver != NULL);
 }
 
 static inline int ext4_has_metadata_csum(struct super_block *sb)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ae47d4..de38a96 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2032,6 +2032,10 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 	}
 
 	/* old crc16 code */
+	if (!(sbi->s_es->s_feature_ro_compat &
+	      cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+		return 0;
+
 	offset = offsetof(struct ext4_group_desc, bg_checksum);
 
 	crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
