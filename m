From: Jan Kara <jack@suse.cz>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Thu, 22 May 2014 15:42:19 +0200
Message-ID: <20140522134219.GF7999@quack.suse.cz>
References: <537C4A2F.8040402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, chrubis@suse.cz
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaEVNmV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 09:42:21 -0400
Content-Disposition: inline
In-Reply-To: <537C4A2F.8040402@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 21-05-14 14:39:43, Xiaoguang Wang wrote:
> Recently I met the mmap_11-4 fails when running LTP in RHEL7.0RC. Attached is a
> test program to reproduce this problem, which is written by Cyril.  Uncommenting the
> msync() makes the test succeed in old linux distribution, such as RHEL6.5GA, but
> fails in RHEL7.0RC.
  Thanks for report and the detailed analysis!

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
  You are right, the code is wrong. The breakage actually seems to have
happened already in 2010 when Ted originally wrote the code and Yongqiang's
patch in 2011 fixed it only partially. I'll send the fix in a minute.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
