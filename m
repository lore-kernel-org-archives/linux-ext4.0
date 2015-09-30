From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: don't print warnings on successful MMP read completion
Date: Wed, 30 Sep 2015 10:42:56 -0700
Message-ID: <20150930174256.GL10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21958 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbbI3RnC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2015 13:43:02 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the MMP block reads without error, don't spam dmesg with warnings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/mmp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6eb1a61..7bc0873 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -104,8 +104,9 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	ret = -EINVAL;
 
 warn_exit:
-	ext4_warning(sb, "Error %d while reading MMP block %llu",
-		     ret, mmp_block);
+	if (ret)
+		ext4_warning(sb, "Error %d while reading MMP block %llu",
+			     ret, mmp_block);
 	return ret;
 }
 
