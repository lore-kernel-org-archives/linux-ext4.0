From: Jan Kara <jack@suse.com>
Subject: [PATCH 17/21] resize2fs: Remove duplicate condition
Date: Wed, 26 Aug 2015 18:22:32 +0200
Message-ID: <1440606156-5754-18-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbbHZQW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:59 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.com>
---
 resize/resize2fs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 3cff977b1d53..70c963783f3f 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -716,19 +716,9 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
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
