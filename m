From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] ext4: remove redundant code in ext4_fill_super()
Date: Fri, 30 May 2008 13:14:25 +0800
Message-ID: <483F8D31.7090505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYE3FP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2008 01:15:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The previous sb_min_blocksize() has already set the block size.

This piece of code was introduced in commit:
	afc7cbca5bfd556c3e12d3acefbee5ab0cbd4670
	(ext4: Support large blocksize up to PAGESIZE)
And it should be a mistake.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext4/super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09d9359..5d07aa9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1843,11 +1843,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto out_fail;
 	}
 
-	if (!sb_set_blocksize(sb, blocksize)) {
-		printk(KERN_ERR "EXT4-fs: bad blocksize %d.\n", blocksize);
-		goto out_fail;
-	}
