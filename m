From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/12] libext2fs: automatically enable meta_bg to avoid
 filling up BG 0
Date: Mon, 12 Oct 2015 14:56:42 -0700
Message-ID: <20151012215642.29065.18353.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39899 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbbJLV4p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:56:45 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If during formatting we'd lose more than half of a block group to
group descriptors and other metadata, enable the meta_bg feature.
This enables us to create >500T filesystems with default options.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/initialize.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index f672a27..b5ca928 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -381,6 +381,11 @@ ipg_retry:
 	overhead = (int) (3 + fs->inode_blocks_per_group +
 			  super->s_reserved_gdt_blocks);
 
+	/* Enable meta_bg if we'd lose more than 3/4 of a BG to GDT blocks. */
+	if (super->s_reserved_gdt_blocks + fs->desc_blocks >
+	    super->s_blocks_per_group * 3 / 4)
+		fs->super->s_feature_incompat |= EXT2_FEATURE_INCOMPAT_META_BG;
+
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		overhead++;
 	else

