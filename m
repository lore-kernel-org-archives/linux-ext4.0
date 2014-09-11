From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/4] ext4: validate external journal superblock checksum
Date: Wed, 10 Sep 2014 17:28:32 -0700
Message-ID: <20140911002831.10109.84707.stgit@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42267 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIKA2h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 20:28:37 -0400
In-Reply-To: <20140911002818.10109.51772.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the external journal device has metadata_csum enabled, verify
that the superblock checksum matches the block before we try to
mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7045f1d..222ed5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4372,6 +4372,15 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 		goto out_bdev;
 	}
 
+	if ((le32_to_cpu(es->s_feature_ro_compat) &
+	     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    es->s_checksum != ext4_superblock_csum(sb, es)) {
+		ext4_msg(sb, KERN_ERR, "external journal has "
+				       "corrupt superblock");
+		brelse(bh);
+		goto out_bdev;
+	}
+
 	if (memcmp(EXT4_SB(sb)->s_es->s_journal_uuid, es->s_uuid, 16)) {
 		ext4_msg(sb, KERN_ERR, "journal UUID does not match");
 		brelse(bh);

