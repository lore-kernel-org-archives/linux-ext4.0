From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Rewrite ext4_page_mkwrite() to return locked page
Date: Wed, 8 Jun 2011 16:55:49 +0200
Message-ID: <20110608145549.GA5361@quack.suse.cz>
References: <1306767829-27580-1-git-send-email-jack@suse.cz>
 <20110606021754.GA7180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab1FHOzv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 10:55:51 -0400
Content-Disposition: inline
In-Reply-To: <20110606021754.GA7180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 05-06-11 22:17:54, Ted Tso wrote:
> On Mon, May 30, 2011 at 05:03:49PM +0200, Jan Kara wrote:
> > ext4_page_mkwrite() does not return page locked. This makes it hard
> > to avoid races with filesystem freezing code (so that we don't leave
> > writeable page on a frozen fs) or writeback code (so that we allow page
> > to be stable during writeback).
> > 
> > Also the current code uses i_alloc_sem to avoid races with truncate but that
> > seems to be the wrong locking order according to lock ordering documented in
> > mm/rmap.c.
> > 
> > Also add a check for frozen filesystem so that we don't busyloop in page fault
> > when the filesystem is frozen.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I'm not sure this commit description is accurate --- or I'm horribly
> confused.
> 
> The old code was in fact returning the page locked --- I assume you're
> referring to lock_page(page) (which is called right before the normal
> path return).  So what am I missing?
  OK, so I read the code again and you are right that end_page_writeback()
will be called before the work is queued and thus there are no problems
with i_mutex (both with multiblock-IO code and with the old code). Sorry for
confusion. But reading the code I have a few questions:
  In multiblock io submission code we call end_page_writeback() and drop
page references before we queue work converting extent from uninitialized
to initialized. But what prevents mm from reclaiming the page (and possibly
loading zeros from disk) before we finish the conversion? I suppose that
could be another cause of the problem described in
1449032be17abb69116dbc393f67ceb8bd034f92 but I don't see how that would be
addressed. Related question is: Commit
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc removed getting and putting of
inode reference when creating/freeing end IO work. But now I don't see what
prevents mm from reaping the inode before the workqueue gets to processing
it.

Finally, commit 1449032be17abb69116dbc393f67ceb8bd034f92 returned back the
old IO submission code but apparently it forgot to return the old handling
of uninitialized buffers so we unconditionnaly call block_write_full_page()
without specifying end_io function. So AFAICS we never convert unwritten
extents to written in some cases. For example when I mount the fs as:
mount -t ext4 -o nomblk_io_submit,dioread_nolock /dev/ubdb /mnt
and do
	int fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0600);
	char buf[1024];
	memset(buf, 'a', sizeof(buf));
	fallocate(fd, 0, 0, 16384);
	write(fd, buf, sizeof(buf));

I get a file full of zeros (after remounting the filesystem so that
pagecache is dropped) instead of seeing the first KB contain 'a's.

So to return to our original discussion regarding i_mutex - you are right
currently i_mutex does not cause a deadlock but to fix the first of the
above problems we need to somehow pin the page before all metadata is
properly updated, that metadata update requires i_mutex, and we will have
to be careful to pin the page in such a way so that memory reclaim cannot
get stuck reaping that page... If you can solve that, I'll be happy but
currently I'd find it more robust to just call end_page_writeback() after
we convert extents and avoid fs recursion from allocations.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
