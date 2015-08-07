From: Jan Kara <jack@suse.com>
Subject: [PATCH 15/19] resize2fs: Remove duplicit condition
Date: Fri,  7 Aug 2015 12:51:25 +0200
Message-ID: <1438944689-24562-16-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbbHGKvs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:48 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.com>
---
 resize/resize2fs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 9a8be30bbce1..22300836300d 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -682,19 +682,9 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 	}
 
 	/*
-	 * If we are shrinking the number block groups, we're done and
+	 * If we are not increasing the number block groups, we're done and
 	 * can exit now.
 	 */
-	if (rfs->old_fs->group_desc_count > fs->group_desc_count) {
-		retval = 0;
-		goto errout;
-	}
