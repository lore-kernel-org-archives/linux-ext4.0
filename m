From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: Fix the loop condition in ext4_mb_free_committed_blocks
Date: Wed, 11 Jun 2008 11:55:45 +0800
Message-ID: <484F4CC1.3000109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65132 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYFKD7M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 23:59:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Since md is freed before the do-while checks it,
it's better to change it to while(1).

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 42553f6..063f820 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2572,7 +2572,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 		kfree(md);
 		ext4_mb_release_desc(&e4b);
 
-	} while (md);
+	} while (1);
 
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }
-- 
1.5.4.5
