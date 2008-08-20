From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] jbd jbd2:
  fixdiowritereturningEIOwhentry_to_release_page fails
Date: Wed, 20 Aug 2008 11:50:05 +0900
Message-ID: <6.0.0.20.2.20080820105459.04243b28@172.19.0.2>
References: <1217971027.7516.20.camel@mingming-laptop>
 <1218029114.15342.58.camel@think.oraclecorp.com>
 <20080806135337.GA3615@duck.suse.cz>
 <1218063477.6383.41.camel@mingming-laptop>
 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
 <1218104494.15342.171.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
 <1218200055.15342.230.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
 <1218547706.15342.305.camel@think.oraclecorp.com>
 <20080813101650.GA14392@duck.suse.cz>
 <1218632396.15342.340.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080819113242.03f9e8c8@172.19.0.2>
 <20080819001651.30c7620f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	MingmingCao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Zach Brown <zach.brown@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59716 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYHTCwX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 22:52:23 -0400
In-Reply-To: <20080819001651.30c7620f.akpm@linux-foundation.org>
References: <1217971027.7516.20.camel@mingming-laptop>
 <1218029114.15342.58.camel@think.oraclecorp.com>
 <20080806135337.GA3615@duck.suse.cz>
 <1218063477.6383.41.camel@mingming-laptop>
 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
 <1218104494.15342.171.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
 <1218200055.15342.230.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2>
 <1218547706.15342.305.camel@think.oraclecorp.com>
 <20080813101650.GA14392@duck.suse.cz>
 <1218632396.15342.340.camel@think.oraclecorp.com>
 <6.0.0.20.2.20080819113242.03f9e8c8@172.19.0.2>
 <20080819001651.30c7620f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At 16:16 08/08/19, Andrew Morton wrote:
>On Tue, 19 Aug 2008 16:03:45 +0900 Hisashi Hifumi 
><hifumi.hisashi@oss.ntt.co.jp> wrote:
>
>> 
>> At 21:59 08/08/13, Chris Mason wrote:
>> >On Wed, 2008-08-13 at 12:16 +0200, Jan Kara wrote:
>> >
>> >> > With that said, I don't have strong feelings against falling back to
>> >> > buffered IO when the invalidate fails.  Maybe Zach remembers something I
>> >> > don't?
>> >>   I don't have a strong opinion either. Falling back to buffered writes is
>> >> simpler at least for ext3/ext4 because properly synchronizing against
>> >> writepage() call does not seem to have a nice solution either in
>> >> do_launder_page() or in releasepage(). OTOH is hides the fact the invalidate
>> >> is failing and so if we screw up something in future and it fails often, it
>> >> might be hard to notice / track down the performance penalty.
>> >
>> >In general, these races don't happen often, and when they do it is
>> >because someone is mixing page cache and O_DIRECT io to the same file.
>> >That is explicitly outside the main use case of O_DIRECT.
>> >
>> >So, I'd rather see us slow down O_DIRECT in the mixed use case than have
>> >big impacts in complexity or speed to other parts of the kernel.  If
>> >falling back avoids problems in some filesystems or avoids clearing the
>> >uptodate bit unexpectedly, I'd much rather take the fallback patch.
>> >
>> >-chris
>> 
>> Hi Andrew.
>> I think we don't have strong feelings against falling back to buffered 
>writes to
>> fix the direct-io -EIO problem.
>> 
>> Please review my patch.
>> 
>
>umm, what problem does it solve?

>
>If I recall correctly, we had a problem with pages which are pinned by
>an ext3 transaction, and those pages weren't releaseable for direct-io,
>and this caused some problem?

Sorry, I should describe about this problem.
Yes, Dio write returns EIO when try_to_release_page fails because sometimes 
bh is still referenced by jbd or other place.

The race between freeing buffer and committing transaction(jbd) was fixed
but I found another race. We have been discussing about this issue, and
I proposed that falling back to buffered writes to fix this issue.
I think we don't have strong feelings against falling back to buffered 
writes to fix the direct-io -EIO problem.

>
>I think falling back to buffered writes is always a safe course, but
>it'd be nice to have a full description of the change, please.

[PATCH] VFS: fix dio write returning EIO when try_to_release_page fails

Dio write returns EIO when try_to_release_page fails because bh is
still referenced.
The patch 
"commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Fri Jul 25 01:46:22 2008 -0700

    jbd: fix race between free buffer and commit transaction
" 
was merged into 2.6.27-rc1, but I noticed that this patch is not enough
to fix the race.
I did fsstress test heavily to 2.6.27-rc1, and found that dio write still 
sometimes got EIO through this test.
The patch above fixed race between freeing buffer(dio) and committing 
transaction(jbd) but I discovered that there is another race, 
freeing buffer(dio) and ext3/4_ordered_writepage.
: background_writeout()
     ->write_cache_pages()
       ->ext3_ordered_writepage()
     	   walk_page_buffers() -> take a bh ref
 	   block_write_full_page() -> unlock_page
		: <- end_page_writeback
                : <- race! (dio write->try_to_release_page fails)
      	   walk_page_buffers() ->release a bh ref

ext3_ordered_writepage holds bh ref and does unlock_page remaining 
taking a bh ref, so this causes the race and failure of 
try_to_release_page.

To fix this race, I used the approach of falling back to buffered writes
if try_to_release_page fails on a page.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.27-rc3.org/mm/filemap.c linux-2.6.27-rc3/mm/filemap.c
--- linux-2.6.27-rc3.org/mm/filemap.c	2008-08-13 13:48:47.000000000 +0900
+++ linux-2.6.27-rc3/mm/filemap.c	2008-08-19 15:45:31.000000000 +0900
@@ -2129,13 +2129,20 @@ generic_file_direct_write(struct kiocb *
 	* After a write we want buffered reads to be sure to go to disk to get
 	* the new data.  We invalidate clean cached page from the region we're
 	* about to write.  We do this *before* the write so that we can return
-	* -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	* without clobbering -EIOCBQUEUED from ->direct_IO().
 	*/
 	if (mapping->nrpages) {
 		written = invalidate_inode_pages2_range(mapping,
 					pos >> PAGE_CACHE_SHIFT, end);
-		if (written)
+		/*
+		* If a page can not be invalidated, return 0 to fall back
+		* to buffered write.
+		*/
+		if (written) {
+			if (written == -EBUSY)
+				return 0;
 			goto out;
+		}
 	}
 
 	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
diff -Nrup linux-2.6.27-rc3.org/mm/truncate.c linux-2.6.27-rc3/mm/truncate.c
--- linux-2.6.27-rc3.org/mm/truncate.c	2008-08-13 13:48:48.000000000 +0900
+++ linux-2.6.27-rc3/mm/truncate.c	2008-08-19 12:10:46.000000000 +0900
@@ -380,7 +380,7 @@ static int do_launder_page(struct addres
  * Any pages which are found to be mapped into pagetables are unmapped prior to
  * invalidation.
  *
- * Returns -EIO if any pages could not be invalidated.
+ * Returns -EBUSY if any pages could not be invalidated.
  */
 int invalidate_inode_pages2_range(struct address_space *mapping,
 				  pgoff_t start, pgoff_t end)
@@ -440,7 +440,7 @@ int invalidate_inode_pages2_range(struct
 			ret2 = do_launder_page(mapping, page);
 			if (ret2 == 0) {
 				if (!invalidate_complete_page2(mapping, page))
-					ret2 = -EIO;
+					ret2 = -EBUSY;
 			}
 			if (ret2 < 0)
 				ret = ret2;


