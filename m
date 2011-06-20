From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Rewrite ext4_page_mkwrite() to return locked page
Date: Sun, 19 Jun 2011 22:53:14 -0400
Message-ID: <20110620025314.GC32133@thunk.org>
References: <1306767829-27580-1-git-send-email-jack@suse.cz>
 <20110606021754.GA7180@thunk.org>
 <20110608145549.GA5361@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56202 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1FTCxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jun 2011 22:53:16 -0400
Content-Disposition: inline
In-Reply-To: <20110608145549.GA5361@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 08, 2011 at 04:55:49PM +0200, Jan Kara wrote:
>   OK, so I read the code again and you are right that end_page_writeback()
> will be called before the work is queued and thus there are no problems
> with i_mutex (both with multiblock-IO code and with the old code). Sorry for
> confusion. But reading the code I have a few questions:
>   In multiblock io submission code we call end_page_writeback() and drop
> page references before we queue work converting extent from uninitialized
> to initialized. But what prevents mm from reclaiming the page (and possibly
> loading zeros from disk) before we finish the conversion? 

We hold a reference on the page (i.e., via get_page()), which we don't
drop until we are doing doing the conversion.  The workqueue function
(ext4_end_io_work, in fs/ext4/page_io.c) calls ext4_free_io_end(),
which drops the page reference.

> Related question is: Commit
> bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc removed getting and putting of
> inode reference when creating/freeing end IO work. But now I don't see what
> prevents mm from reaping the inode before the workqueue gets to processing
> it.

Actually it was commit f7ad6d2e9201a which removed the getting and
putting of the inode reference, and it describes the issues involved.
Specifically:

    The following BUG can occur when an inode which is getting freed when
    it still has dirty pages outstanding, and it gets deleted (in this
    because it was the target of a rename).  In ordered mode, we need to
    make sure the data pages are written just in case we crash before the
    rename (or unlink) is committed.  If the inode is being freed then
    when we try to igrab the inode, we end up tripping the BUG_ON at
    fs/ext4/page-io.c:146.
    
    To solve this problem, we need to keep track of the number of io
    callbacks which are pending, and avoid destroying the inode until they
    have all been completed.  That way we don't have to bump the inode
    count to keep the inode from being destroyed; an approach which
    doesn't work because the count could have already been dropped down to
    zero before the inode writeback has started (at which point we're not
    allowed to bump the count back up to 1, since it's already started
    getting freed).
    
    Thanks to Dave Chinner for suggesting this approach, which is also
    used by XFS.

> Finally, commit 1449032be17abb69116dbc393f67ceb8bd034f92 returned back the
> old IO submission code but apparently it forgot to return the old handling
> of uninitialized buffers so we unconditionnaly call block_write_full_page()
> without specifying end_io function. 

Yeah.  That was a bug, no question.  No one apparently ran into it (or
at least no one bothered to report it to linux-ext4 or linux-kernel as
far as I know) while it was the default (i.e., during 2.6.37), and as
of 2.6.38 we are now using the new IO submission code by default
again.  Given that no one has reported any problems with the new IO
submission code, I was planning on completely removing the
nomblk_io_submit mount option for the 3.1 kernel, which would fix the
bug by virtue of nuking code in question.  :-)

> So to return to our original discussion regarding i_mutex - you are right
> currently i_mutex does not cause a deadlock but to fix the first of the
> above problems we need to somehow pin the page before all metadata is
> properly updated, that metadata update requires i_mutex, and we will have
> to be careful to pin the page in such a way so that memory reclaim cannot
> get stuck reaping that page... If you can solve that, I'll be happy but
> currently I'd find it more robust to just call end_page_writeback() after
> we convert extents and avoid fs recursion from allocations.

So I think the current fs/ext4/page_io.c code solves the problem
simply by grabbing a reference on the bug, which should prevent the mm
layer from reclaiming the page.  Does that satisfy you?  Do you see
anything that I may have missed?

(I very well could have missed something; after all, this code is
subtle, which is why I didn't feel comfortable responsible until I
could find the time to go and research this in depth; sorry for delay
in getting back to you.)

						- Ted

P.S.  Upon further reflection, perhaps we need to drop a few more code
comments in it so it's clearer to folks who try to go through this
code path in the future.

