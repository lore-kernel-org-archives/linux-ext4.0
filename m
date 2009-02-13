From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: next-20090206: deadlock on ext4
Date: Fri, 13 Feb 2009 16:21:50 -0600
Message-ID: <4995F27E.3070401@redhat.com>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com>	 <498C7671.1050309@redhat.com>	 <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com>	 <498C9876.3060208@redhat.com> <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alexander Beregalov wrote:

> I have reproduced it with 2.6.29-rc4.
> Loop file was on XFS.
> I can not reproduce it on ext4 on raw device.
> Let me know if I can do anything else to help resolving it.
>   
Can you try this patch from Aneesh?  Works for me...

Thanks,
-Eric

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't use the range_cylic mode implemented by
write_cache_pages

With delayed allocation we lock the page in write_cache_pages and 
try to build an in memory extent of contiguous blocks. This is 
needed so that we can get a large contiguous blocks request. Now 
with range_cyclic mode in write_cache_pages if we have not done an 
I/O we loop back to 0 index and try to write the page.  That would 
imply we will attempt to take page lock of lower index page holding
the page lock of higher index page. This can cause a dead lock with
other writeback thread.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Tested-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/inode.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6.28.x86_64/fs/ext4/inode.c
===================================================================
--- linux-2.6.28.x86_64.orig/fs/ext4/inode.c
+++ linux-2.6.28.x86_64/fs/ext4/inode.c
@@ -2437,6 +2437,7 @@ static int ext4_da_writepages(struct add
 	int no_nrwrite_index_update;
 	int pages_written = 0;
 	long pages_skipped;
+       int range_cyclic = 0, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
@@ -2488,9 +2489,14 @@ static int ext4_da_writepages(struct add
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 		range_whole = 1;
 
-	if (wbc->range_cyclic)
+       if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-	else
+	       wbc->range_start = index << PAGE_CACHE_SHIFT;
+	       wbc->range_end  = LLONG_MAX;
+	       wbc->range_cyclic = 0;
+	       range_cyclic = 1;
+	       cycled = 0;
+       } else
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
 	mpd.wbc = wbc;
@@ -2504,6 +2510,7 @@ static int ext4_da_writepages(struct add
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
+retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2546,6 +2553,7 @@ static int ext4_da_writepages(struct add
 			pages_written += mpd.pages_written;
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
+		       io_done = 1;
 		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
@@ -2554,6 +2562,13 @@ static int ext4_da_writepages(struct add
 			 */
 			break;
 	}
+       if (!io_done && !cycled) {
+	       cycled = 1;
+	       index = 0;
+	       wbc->range_start = index << PAGE_CACHE_SHIFT;
+	       wbc->range_end  = mapping->writeback_index - 1;
+	       goto retry;
+       }
 	if (pages_skipped != wbc->pages_skipped)
 		printk(KERN_EMERG "This should not happen leaving %s "
 				"with nr_to_write = %ld ret = %d\n",
@@ -2561,6 +2576,7 @@ static int ext4_da_writepages(struct add
 
 	/* Update index */
 	index += pages_written;
+       wbc->range_cyclic = range_cyclic;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		/*
 		 * set the writeback_index so that range_cyclic
