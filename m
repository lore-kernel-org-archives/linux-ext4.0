From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 14:55:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
References: <537C4A2F.8040402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, chrubis@suse.cz
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaEUMzU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 08:55:20 -0400
In-Reply-To: <537C4A2F.8040402@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 May 2014, Xiaoguang Wang wrote:

> Date: Wed, 21 May 2014 14:39:43 +0800
> From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, chrubis@suse.cz
> Subject: OpenPosix test case mmap_11-4 fails in ext4 filesystem
> 
> Hi,
> 
> Recently I met the mmap_11-4 fails when running LTP in RHEL7.0RC. Attached is a
> test program to reproduce this problem, which is written by Cyril.  Uncommenting the
> msync() makes the test succeed in old linux distribution, such as RHEL6.5GA, but
> fails in RHEL7.0RC.

Hi,

please contact you Red Hat support to triage the issue within Red
Hat.

> 
> I also read  some ext4's source code in RHEL7.0RC and here is the possible reason
> according to my understanding. Hope this will help you something.
> --------------------------------------------------------------------------------------------
> 
> When calling msync() in an ext4 file system, ext4_bio_write_page will be
> called to write back dirty pages. Here is the source code in RHEL7.0RC:
> 
> int ext4_bio_write_page(struct ext4_io_submit *io, struct page *page, int len, struct writeback_control *wbc)
>  {
>          struct inode *inode = page->mapping->host;
>          unsigned block_start, blocksize;
>          struct buffer_head *bh, *head;
>          int ret = 0;
>          int nr_submitted = 0;
>  
>          blocksize = 1 << inode->i_blkbits;
>  
>          BUG_ON(!PageLocked(page));
>          BUG_ON(PageWriteback(page));
>  
>          set_page_writeback(page);
>          ClearPageError(page);
>  
>          ......
> 
>          bh = head = page_buffers(page);
>          do {
>                  block_start = bh_offset(bh);
>                  if (block_start >= len) {
>                          /*
>                           * Comments copied from block_write_full_page_endio:
>                           *
>                           * The page straddles i_size.  It must be zeroed out on
>                           * each and every writepage invocation because it may
>                           * be mmapped.  "A file is mapped in multiples of the
>                           * page size.  For a file that is not a multiple of
>                           * the  page size, the remaining memory is zeroed when
>                           * mapped, and writes to that region are not written
>                           * out to the file."
>                           */
>                          zero_user_segment(page, block_start,
>                                            block_start + blocksize);
>                          clear_buffer_dirty(bh);
>                          set_buffer_uptodate(bh);
>                          continue;
>                  }
>                  ......
>          } while ((bh = bh->b_this_page) != head);
> --------------------------------------------------------------------------------------------
> I deleted some irrelevant code.
> 
> The argument len is computed by the following code:
> loff_t size = i_size_read(inode);  // file's length
> if (index == size >> PAGE_CACHE_SHIFT)
>         len = size & ~PAGE_CACHE_MASK;
> else
>         len = PAGE_CACHE_SIZE;
> 
> That means len is the valid file length in every page.
> 
> When ext4 file system's block size is 1024, then there will be 4 struct buffer head attached to this page.
> 
> See the above "do... while ..." statements in ext4_bio_write_page(), "block_start = bh_offset(bh);" will make
> block_start be 0 for the first buffer head, 1024 for the second, 2048 for the third, 3072 for the forth.
> 
> So in the reproduce program, in this case, len is 2048,  the  "if (block_start >= len) "
> condition will be satisfied in the third and forth iteration, so "zero_user_segment(page, block_start, block_start + blocksize);" will
> be called, then the content beyond the file's end will be zeroed, so the reproduce program will succeed.
> 
> But when ext4 file system's block size if 4096, then there will only on buffer head attached to
> this page, then when len is 2048,  "while ((bh = bh->b_this_page) != head);" statement  will make the "do ... while..."
> statement execute only once. In the first iteration, "block_start = bh_offset(bh); " will make
> block_start be 0, " if (block_start >= len) "  won't be satisfied,  zero_user_segment() won't be called,
> so the content in current page  beyond the file's end will not be zeroed, so the reproduce program fails.

Actually this is the same even with block size < page size. The zero
our will always be block aligned. The last block will alway be
written out.

-Lukas

> 
> In RHEL6.5GA, block_write_full_page() will be called to do work similar to ext4_bio_write_page, this function does
> not do the zero work in unit of struct buffer head, so this bug is not exist.
> 
> The above is my understanding. If it's not correct, I'd like that you explain the true reason, thanks.
> 
> Also I don't know whether this can be considered an ext4 bug or not. And according msync()'s definition,
> it seems that it dose not require msync() to zero the partial page beyond mmaped file's area. But at least, msync()'s behavior will be
> different when ext4 file system has different block size, I think we may fix these to keep consistency.
> 
> Or you think ext4's implementation is correct and the LTP mmap_11-4 case is invalid? Thanks.
> 
> Regards,
> Xiaoguang Wang
> 
