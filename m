From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Tue, 26 Apr 2011 08:19:38 -0400
Message-ID: <20110426121938.GD9486@thunk.org>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
 <4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
 <BANLkTikJjHKchRTt3t2jW+O_1wba9v8jmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
	jim@meyering.net, cmm@us.ibm.com, hughd@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32771 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1DZMTo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2011 08:19:44 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikJjHKchRTt3t2jW+O_1wba9v8jmg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2011 at 03:41:47PM +0800, Yongqiang Yang wrote:
> This function is only called from write path which flushes pages to
> disk,  actually, pages' state have been set right at time when
> write_end() is called.  Why did we handle pages' state in this
> function?

This was a bug on my part.  A lot of page_io.c was copied from
fs/buffer.c, and then optimized for bulk page writes, instead of
sending down a separate 4k bio write request at a time.  I
(incorrectly) copied logic from block_commit_write() into the write
completion callback().  So I agree with Curt that the messing with the
page state should be removed from ext4_end_bio().

As far as messing with the buffer_dirty() logic, it's just wrong to be
clearing the buffer dirty bit at all in the write callback.  In the
original codepath, the buffer dirty bit was set by
block_commit_write(), only to be cleared immediately by
__block_write_full_page().  I'm pretty sure the setting and clearing
the buffer dirty bit can be optimized out of fs/ext4/page_io.c

What does bother me a little bit is that we have code that tests
buffer_dirty() in the delalloc logic in fs/ex4/inode.c --- note
ext4_bh_delay_on_unwritten(), and write_cache_pages_da(), where we are
testing the buffer_dirty bit for the pages that hang off of struct
page.  The only thing that might bear on this is the
ext4_block_truncate_page(), which does call mark_buffer_dirty() on the
buffer containing the truncation point (which by the way has made me
very worried about the punch code getting very well tested on 1k block
size file systems, since the edge cases when the region to be
truncated are not page-aligned are obviously going to be very hard to
get right).

I *think* we should be nuking the buffer_dirty manipulations in the
delalloc path, but we need to look very closely at that to make sure
there isn't anything going on here...

							- Ted
