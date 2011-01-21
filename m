From: Tao Ma <tm@tao.ma>
Subject: [PATCH v2] ext3: speed up group trim with the right free block count.
Date: Fri, 21 Jan 2011 22:19:36 +0800
Message-ID: <1295619576-5662-1-git-send-email-tm@tao.ma>
References: <alpine.LFD.2.00.1101211136410.3275@dhcp-lab-213.englab.brq.redhat.com>
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:45988 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752143Ab1AUOT7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 09:19:59 -0500
In-Reply-To: <alpine.LFD.2.00.1101211136410.3275@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/21/2011 06:44 PM, Lukas Czerner wrote:
> Nice catch, do you plan to do the same for ext4 ? Btw, I do not think
> there is a need for new variable (free_count), you can as well do :
>
> free_blocks -= next - start;
> ...
> if (free_blocks < minblocks)
> 	break;
yeah, the extra varaible isn't needed. Here is the updated patch.

Regards,
Tao

Subject: [PATCH v2] ext3: speed up group trim with the right free block count.
>From 48ab7651409df9b21dfaa9cec6a8db62467b8ca7 Mon Sep 17 00:00:00 2001
From: Tao Ma <boyu.mt@taobao.com>
Date: Fri, 21 Jan 2011 22:09:20 +0800
Subject: [PATCH v2] ext3: speed up group trim with the right free block count.

When we trim some free blocks in a group of ext3, we should
calculate the free blocks properly and check whether there are
enough freed blocks left for us to trim. Current solution will
only calculate free spaces if they are large for a trim which
is wrong.

Let us see a small example:
a group has 1.5M free which are 300k, 300k, 300k, 300k, 300k.
And minblocks is 1M. With current solution, we have to iterate
the whole group since these 300k will never be subtracted from
1.5M. But actually we should exit after we find the first 2
free spaces since the left 3 chunks only sum up to 900K if we
subtract the first 600K although they can't be trimed.

Cc: Jan Kara <jack@suse.cz>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/balloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 045995c..b9697f7 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1991,6 +1991,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 		spin_unlock(sb_bgl_lock(sbi, group));
 		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
 
+		free_blocks -= next - start;
 		/* Do not issue a TRIM on extents smaller than minblocks */
 		if ((next - start) < minblocks)
 			goto free_extent;
@@ -2040,7 +2041,7 @@ free_extent:
 		cond_resched();
 
 		/* No more suitable extents */
-		if ((free_blocks - count) < minblocks)
+		if (free_blocks < minblocks)
 			break;
 	}
 
-- 
1.7.1

