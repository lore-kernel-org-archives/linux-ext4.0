From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH V2] ext4: Fix the loop condition in ext4_mb_free_committed_blocks
Date: Thu, 12 Jun 2008 10:57:05 +0800
Message-ID: <48509081.7070103@cn.fujitsu.com>
References: <484F4CC1.3000109@cn.fujitsu.com> <20080611142356.GL8397@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56743 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbYFLDAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 23:00:34 -0400
In-Reply-To: <20080611142356.GL8397@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> Since md is freed before the do-while checks it,
>> it's better to change it to while(1).
> 
> This actually isn't a bug, since there is no problem checking a
> pointer that has been freed; its only *dereferencing* a pointer which
> is bad.  That being said, md is never NULL at the end of the loop,
> since in the middle of the loop is the only break condition:
> 
> 	if (md == NULL)
> 		break;
> 
> So the patch saves a tiny amount of compiled code, but it isn't really
> a fix in any way.
> 
> That being said, if we're going to make this sort of change, my
> preference would be to use the more common C idiom:
> 
> 	while (1) {
> 	      ...
> 	}
> 
> as opposed to
> 
> 	do {
> 	      ...
> 	} while (1);
> 
> The former makes it quite clear that any exit from the loop is not
> going to be coming from loop construct itself, but from any embedded
> break statements inside the loop construct
> 

Yes. You are right. Revise the patch as you suggested.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c9900aa..bd6cf22 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2521,7 +2521,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 		return;
 
 	/* there is committed blocks to be freed yet */
-	do {
+	while (1) {
 		/* get next array of blocks */
 		md = NULL;
 		spin_lock(&sbi->s_md_lock);
@@ -2561,7 +2561,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 		kfree(md);
 		ext4_mb_release_desc(&e4b);
 
-	} while (md);
+	}
 
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }
-- 1.5.4.5 
