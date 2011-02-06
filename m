From: Coly Li <i@coly.li>
Subject: [PATCH 1/5] mballoc: code cleanup in mb_find_buddy()
Date: Sun, 06 Feb 2011 12:53:44 +0800
Message-ID: <4D4E2958.2010705@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:47769 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752377Ab1BFE1T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:27:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current code calculate max no matter whether order is zero, it's
unnecessary. This cleanup patch sets max to "1 << (e4b->bd_blkbits
+ 3)" only when order == 0.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>
---
  fs/ext4/mballoc.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 851f49b..d5b372c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -427,9 +427,10 @@ static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
  	}

  	/* at order 0 we see each particular block */
-	*max = 1 << (e4b->bd_blkbits + 3);
-	if (order == 0)
+	if (order == 0) {
+		*max = 1 << (e4b->bd_blkbits + 3);
  		return EXT4_MB_BITMAP(e4b);
+	}

  	bb = EXT4_MB_BUDDY(e4b) + EXT4_SB(e4b->bd_sb)->s_mb_offsets[order];
  	*max = EXT4_SB(e4b->bd_sb)->s_mb_maxs[order];
-- 
1.7.3.4
