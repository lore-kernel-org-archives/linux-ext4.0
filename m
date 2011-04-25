From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 25 Apr 2011 15:28:58 +0900
Message-ID: <20110425152858.a9edfe58.toshi.okajima@jp.fujitsu.com>
References: <4D9BF57A.6030705@jp.fujitsu.com>
	<20110406055708.GB23285@quack.suse.cz>
	<4D9C18DF.90803@jp.fujitsu.com>
	<20110406174617.GC28689@quack.suse.cz>
	<4DA84A7B.3040403@jp.fujitsu.com>
	<20110415171310.GB5432@quack.suse.cz>
	<4DABFEBD.7030102@jp.fujitsu.com>
	<20110418105105.GB5557@quack.suse.cz>
	<4DAD5934.1030901@jp.fujitsu.com>
	<20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
	<20110422221025.GF2977@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com, toshi.okajima@jp.fujitsu.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57542 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1DYIDd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 04:03:33 -0400
In-Reply-To: <20110422221025.GF2977@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

On Sat, 23 Apr 2011 00:10:25 +0200
Jan Kara <jack@suse.cz> wrote:
> On Fri 22-04-11 15:58:39, Toshiyuki Okajima wrote:
> > I have confirmed that the following patch works fine while my or
> > Mizuma-san's reproducer is running. Therefore,
> >  we can block to write the data, which is mmapped to a file, into a disk
> > by a page-fault while fsfreezing. 
> > 
> > I think this patch fixes the following two problems:
> > - A deadlock occurs between ext4_da_writepages() (called from
> > writeback_inodes_wb) and thaw_super(). (reported by Mizuma-san)
> > - We can also write the data, which is mmapped to a file,
> >   into a disk while fsfreezing (ext3/ext4).
> >                                        (reported by me)
> > 
> > Please examine this patch.
>   Thanks for the patch. The ext3 part is not as easy as this. You cannot
> really get i_alloc_sem in ext3_page_mkwrite() because mmap_sem is already
> held by page fault code and i_alloc_sem should be acquired before it (yes I
> know, ext4 already has this bug which should be fixed when I get to it).
> Also you'll find that performance of random writers via mmap (which is
> relatively common) is going to be rather bad with this patch (because the
> file will be heavily fragmented). We have to be more clever which is
> exactly why it's taking me so long with my patch :) But tests are already
> running so if everything goes fine, I should have patches to submit next
> week.
OK, I'll wait your patch. :)

> 
> The ext4 part looks correct. I'd just also like to have some comments about
> how freeze handling is done because it's kind of subtle.

How about this?

Thanks,
Toshiyuki Okajima

----------------------------------------------------------------------------------------------------
Subject: [PATCH] ext4: prevent the mmapped page flushing to disk while fsfreezing

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..411b177 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5812,7 +5812,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 	ret = 0;
 	if (PageMappedToDisk(page))
-		goto out_unlock;
+		goto out_frozen;
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -5830,6 +5830,14 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
 			unlock_page(page);
+out_frozen:
+			/*
+			 * We must wait here while the filesystem is being 
+			 * frozen otherwise a flushing thread can write this 
+			 * page to the disk (we can update the filesystem even 
+			 * if it is frozen).
+			 */
+			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 			goto out_unlock;
 		}
 	}
-- 
1.5.5.6
