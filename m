From: Nick Piggin <npiggin@suse.de>
Subject: Re: + fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to -mm tree
Date: Wed, 13 Jun 2007 13:43:56 +0200
Message-ID: <20070613114356.GD17547@wotan.suse.de>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, mark.fasheh@oracle.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758474AbXFMLoR@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070613134005.GA13815@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 13, 2007 at 05:40:05PM +0400, Dmitriy Monakhov wrote:
> On 14:19 ?????? 29 ??????     , akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      fs: introduce write_begin, write_end, and perform_write aops
> > has been added to the -mm tree.  Its filename is
> >      fs-introduce-write_begin-write_end-and-perform_write-aops.patch
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > ------------------------------------------------------
> > Subject: fs: introduce write_begin, write_end, and perform_write aops
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > These are intended to replace prepare_write and commit_write with more
> > flexible alternatives that are also able to avoid the buffered write
> > deadlock problems efficiently (which prepare_write is unable to do).
> > 
> > [mark.fasheh@oracle.com: API design contributions, code review and fixes]
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> I've finaly find time to review Nick's "write_begin/write_end aop" patch set.
> And i have some fixes and questions. My be i've missed somthing and it was 
> already disscussed, but i cant find in LKML.

Thanks, that's really helpful.

 
> 1) loop dev:
> 	loop.c code itself is not perfect. In fact before Nick's patch
> 	partial write was't possible. Assumption what write chunks are
> 	always page aligned is realy weird ( see "index++" line).
> 	Fixed by "new aop loop fix" patch

I think you're right, fix looks good.

 
> 2)block_write_begin:
> 	After we enter to block_write_begin with *pagep == NULL and
> 	some page was grabed we remember this page in *pagep
> 	And if __block_prepare_write() we have to clear *pagep , as 
> 	it was before. Because this may confuse caller.
> 	for example caller may have folowing code:
> 		ret = block_write_begin(..., pagep,...)
> 		if (ret && *pagep != NULL) {
> 			unlock_page(*pagep);
> 			page_cache_release(*pagep);
> 		}
> 	Fixed my "new aop block_write_begin fix" patch

I don't think the caller can rely on that if it returns failure.
But that is more defensive I guess. Maybe setting it to 1 or
so would catch abusers.

 
> 3) __page_symlink:
> 	Nick's patch add folowing code:
> 	+ err = pagecache_write_begin(NULL, mapping, 0,PAGE_CACHE_SIZE,
> 	+                 AOP_FLAG_UNINTERRUPTIBLE, &page,&fsdata);
> 	symlink now consume whole page. I have only one question "WHY???".
> 	I don't see any advantages, but where are huge list of
> 	dissdvantages:
> 	a) fs with blksize == 1k and pagesize == 16k after this patch
> 	   waste more than 10x times disk space for nothing.
> 	b) What happends if we want use fs with blksize == 4k on i386
> 	   after it was used by ia64 ??? (before this patch it was
> 	   possible).
> 	
> 	I dont prepare patch for this because i dont understand issue
> 	witch Nick aimed to fix.

I don't know why myself :P I think it would be just fine to use
len-1 as it did previously, so it must have been a typo?


> 4) iov_iter_fault_in_readable:
> 	Function prerform check for signgle region, with out respect to
> 	segment nature of iovec, For example writev no longer works :) :
> 	writev(3, [{"\1", 1}, {"\2"..., 4096}], 2) = -1 EFAULT (Bad address)
> 	this hidden bug, and it was invisiable because XXXX_fault_in_readable
> 	return value was ignored before. Lets iov_iter_fault_in_readable
> 	perform checks for all segments.
> 	Fixed by :"iov_iter_fault_in_readable fix"

OK thanks. I would rather just change this to use the length of
the first iovec always (prefaulting multiple iovecs would have to
be benchmarked on real apps that make heavy use of writev, I
suspect).

 
> 5) ext3_write_end:
> 	Before  write_begin/write_end patch set we have folowing locking
> 	order:
> 		stop_journal(handle);
> 		unlock_page(page);
> 	But now order is oposite:
> 		unlock_page(page);
> 		stop_journal(handle);
> 	Can we got any race condition now? I'm not sure is it actual problem,
> 	may be somebody cant describe this.

Can we just change it to the original order? That would seem to be
safest unless one of the ext3 devs explicitly acks it.
