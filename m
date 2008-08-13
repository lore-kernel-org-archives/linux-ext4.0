From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2: fix
  diowritereturningEIOwhentry_to_release_page fails
Date: Wed, 13 Aug 2008 15:02:23 +0900
Message-ID: <6.0.0.20.2.20080813144259.03d393d0@172.19.0.2>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
 <1218029114.15342.58.camel@think.oraclecorp.com>
 <20080806135337.GA3615@duck.suse.cz>
 <1218063477.6383.41.camel@mingming-laptop>
 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
 <1218104494.15342.171.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
 <1218200055.15342.230.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
 <1218547706.15342.305.camel@think.oraclecorp.com>
 <1218571599.6423.22.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zach Brown <zach.brown@oracle.com>
To: Mingming Cao <cmm@us.ibm.com>, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57246 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYHMGEe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 02:04:34 -0400
In-Reply-To: <1218571599.6423.22.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
 <20080804145047.04794bf3.akpm@linux-foundation.org>
 <1217907353.7611.39.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
 <1217953055.7899.11.camel@think.oraclecorp.com>
 <1217971027.7516.20.camel@mingming-laptop>
 <1218029114.15342.58.camel@think.oraclecorp.com>
 <20080806135337.GA3615@duck.suse.cz>
 <1218063477.6383.41.camel@mingming-laptop>
 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
 <1218104494.15342.171.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
 <1218200055.15342.230.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
 <1218547706.15342.305.camel@think.oraclecorp.com>
 <1218571599.6423.22.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At 05:06 08/08/13, Mingming Cao wrote:

>> With that said, I don't have strong feelings against falling back to
>> buffered IO when the invalidate fails.  
>> 
>> 
>It seems a little odd that we have to back to buffered IO in this case.
>The pages are all flushed,  DIO just want to make sure the
>journaltransactions who still keep those buffers are removed from their
>list. It did that, the only reason to keep DIO fail is someone else
>hasn't release the bh.
>
>Current code enforce all the buffers have to be freed and pages are
>removed from page cache, in order to force later read are from disk.  I
>am not sure why can't we just leave the page in the cache, just clear it
>uptodate flag, without reduce the page ref count?   I think DIO should
>proceed it's IO in this case...

Like this?
Following patch just clears PG_uptodate when try_to_release_page fails.

diff -Nrup linux-2.6.27-rc3.org/mm/truncate.c linux-2.6.27-rc3/mm/truncate.c
--- linux-2.6.27-rc3.org/mm/truncate.c	2008-08-13 13:48:48.000000000 +0900
+++ linux-2.6.27-rc3/mm/truncate.c	2008-08-13 14:24:47.000000000 +0900
@@ -345,8 +345,10 @@ invalidate_complete_page2(struct address
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
-		return 0;
+	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL)) {
+		ClearPageUptodate(page);
+		return 1;
+	}
 
 	spin_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))


But this patch may cause some issue.
See, 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=84209e02de48d72289650cc5a7ae8dd18223620f;hp=2b12a4c524812fb3f6ee590a02e65b95c8c32229

ClearPageUptodate in truncate.c was removed at 2.6.27-rc2 because this triggers some 
problems around NFS,FUSE,madvice.

