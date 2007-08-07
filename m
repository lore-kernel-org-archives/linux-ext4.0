From: <gregkh@suse.de>
Subject: patch ext4_ext_put_in_cache-uses-__u32-to-receive-physical-block-number.patch queued to -stable tree
Date: Tue, 07 Aug 2007 01:24:58 -0700
Message-ID: <20070807083032.8DBA514458DB@imap.suse.de>
References: <200707310737.l6V7bk50021902@imap1.linux-foundation.org>
Cc: <stable-commits@vger.kernel.org>
To: cmm@us.ibm.com, akpm@linux-foundation.org, gregkh@suse.de,
	linux-ext4@vger.kernel.org, yanzheng@21cn.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:40858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558AbXHGIao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2007 04:30:44 -0400
In-Reply-To: <200707310737.l6V7bk50021902@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: "ext4_ext_put_in_cache" uses __u32 to receive physical block number

to the 2.6.22-stable tree.  Its filename is

     ext4_ext_put_in_cache-uses-__u32-to-receive-physical-block-number.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Jul 31 00:48:13 2007
From: Mingming Cao <cmm@us.ibm.com>
Date: Tue, 31 Jul 2007 00:37:46 -0700
Subject: "ext4_ext_put_in_cache" uses __u32 to receive physical block number
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org, cmm@us.ibm.com, stable@kernel.org, yanzheng@21cn.com
Message-ID: <200707310737.l6V7bk50021902@imap1.linux-foundation.org>


From: Mingming Cao <cmm@us.ibm.com>

Yan Zheng wrote:

> I think I found a bug in ext4/extents.c, "ext4_ext_put_in_cache" uses
> "__u32" to receive physical block number.  "ext4_ext_put_in_cache" is
> used in "ext4_ext_get_blocks", it sets ext4 inode's extent cache
> according most recently tree lookup (higher 16 bits of saved physical
> block number are always zero). when serving a mapping request,
> "ext4_ext_get_blocks" first check whether the logical block is in
> inode's extent cache. if the logical block is in the cache and the
> cached region isn't a gap, "ext4_ext_get_blocks" gets physical block
> number by using cached region's physical block number and offset in
> the cached region.  as described above, "ext4_ext_get_blocks" may
> return wrong result when there are physical block numbers bigger than
> 0xffffffff.
>

You are right.  Thanks for reporting this!

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Yan Zheng <yanzheng@21cn.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/ext4/extents.c~ext4_ext_put_in_cache-uses-__u32-to-receive-physical
+++ a/fs/ext4/extents.c
@@ -1544,7 +1544,7 @@ int ext4_ext_walk_space(struct inode *in
 
 static void
 ext4_ext_put_in_cache(struct inode *inode, __u32 block,
-			__u32 len, __u32 start, int type)
+			__u32 len, ext4_fsblk_t start, int type)
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
_

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable



Patches currently in stable-queue which might be from cmm@us.ibm.com are

queue-2.6.22/ext4_ext_put_in_cache-uses-__u32-to-receive-physical-block-number.patch
