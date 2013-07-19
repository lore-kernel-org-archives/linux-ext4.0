From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/5] ext4: Fix type declaration of ext4_validate_block_bitmap
Date: Fri, 19 Jul 2013 16:55:46 -0700
Message-ID: <20130719235546.24017.98557.stgit@blackbox.djwong.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32207 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3GSXzv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jul 2013 19:55:51 -0400
In-Reply-To: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block_group parameter to ext4_validate_block_bitmap is both used as a
ext4_group_t inside the function and the same type is passed in by all callers.
We might as well use the typedef consistently instead of open-coding the
'unsigned int'.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |    2 +-
 fs/ext4/ext4.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b430afe..735e701 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -352,7 +352,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
 
 void ext4_validate_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *desc,
-			       unsigned int block_group,
+			       ext4_group_t block_group,
 			       struct buffer_head *bh)
 {
 	ext4_fsblk_t	blk;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b577e45..39d24e2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1915,7 +1915,7 @@ extern ext4_group_t ext4_get_group_number(struct super_block *sb,
 
 extern void ext4_validate_block_bitmap(struct super_block *sb,
 				       struct ext4_group_desc *desc,
-				       unsigned int block_group,
+				       ext4_group_t block_group,
 				       struct buffer_head *bh);
 extern unsigned int ext4_block_group(struct super_block *sb,
 			ext4_fsblk_t blocknr);

