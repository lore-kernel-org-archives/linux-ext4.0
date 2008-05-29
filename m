From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and journal locking order inversion.
Date: Thu, 29 May 2008 14:27:39 +0200
Message-ID: <20080529122739.GA29602@duck.suse.cz>
References: <20080528091648.GA15851@skywalker> <20080528100833.GC8289@duck.suse.cz> <20080529075056.GA24919@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50405 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751878AbYE2M1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 08:27:41 -0400
Content-Disposition: inline
In-Reply-To: <20080529075056.GA24919@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 29-05-08 13:20:56, Aneesh Kumar K.V wrote:
> On Wed, May 28, 2008 at 12:08:33PM +0200, Jan Kara wrote:
> >   Hi Aneesh,
> >   The question here is, who is holding the lock from the page we wait
> > for here. The two processes you show below don't seem to hold it. I'll
> > check the full log ... searching ... I see!
> >   The problem is in generic_write_end()! It calls mark_inode_dirty() under
> > page lock. That can possibly start a new transaction (which happened in
> > your case) and that violates lock ordering (mark_inode_dirty() got stuck
> > waiting for journal commit which is stuck waiting for other user to do
> > journal_stop which waits for the page lock). Actually, there is no real
> > need to call mark_inode_dirty() from under page lock - we just need to
> > update i_size there. Something like the patch attached (untested)?
> > 
> 
> The patch works.   Peter Zijlstra have patches to add lockdep annotation
> to lock_page. I guess we will have to test the lock inversion patch with
> the lockdep annotation to catch the deadlock scenarios like above.
>
> http://programming.kicks-ass.net/kernel-patches/lockdep-page_lock/
  Yes, that would be useful. Thanks for the pointer.

> Regarding delalloc I still have issues. The writepage can get called
> with buffer_head marked delay and dirty as show below. This will result
> in block allocation under lock_page.
> 
> RIP: 0010:[<ffffffff8030cc64>]  [<ffffffff8030cc64>] ext4_da_writepage+0x26/0xad
> 
> Call Trace:
>  [<ffffffff8026999f>] shrink_page_list+0x31e/0x588
>  [<ffffffff80269d35>] shrink_inactive_list+0x12c/0x40d
>  [<ffffffff805ce6a2>] ? _spin_unlock_irqrestore+0x3f/0x68
>  [<ffffffff8024e83a>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff805ce6af>] ? _spin_unlock_irqrestore+0x4c/0x68
>  [<ffffffff803975b7>] ? __up_read+0x8c/0x94
>  [<ffffffff8026a0f3>] shrink_zone+0xdd/0x103
>  [<ffffffff8026ad69>] kswapd+0x34b/0x53e
>  [<ffffffff80268e4d>] ? isolate_pages_global+0x0/0x34
>  [<ffffffff80243ff4>] ? autoremove_wake_function+0x0/0x36
>  [<ffffffff805ce6af>] ? _spin_unlock_irqrestore+0x4c/0x68
>  [<ffffffff8026aa1e>] ? kswapd+0x0/0x53e
>  [<ffffffff80243d1b>] kthread+0x44/0x6b
>  [<ffffffff8020c1f8>] child_rip+0xa/0x12
>  [<ffffffff8020b8e3>] ? restore_args+0x0/0x30
>  [<ffffffff80243fcf>] ? kthreadd+0x16b/0x190
>  [<ffffffff80243cd7>] ? kthread+0x0/0x6b
>  [<ffffffff8020c1ee>] ? child_rip+0x0/0x12
  I see two options here:
1) Just refuse to write the page if we see we have to do block allocation,
   there's no transaction running and for_reclaim is set (or we could even
   refuse the write if getting a new handle would mean blocking but that
   starts to get ugly). The page will be eventually written out via
   writepages call as far as I know.
2) Do similar tricks as in ext4_journaled_writepage() if we see we need to
   start a transaction - i.e., unlock the page, start the transaction, lock
   the page again, check that it's still the page we are interested in,
   proceed...

Option 2) has the disadvantage that when we are looking for a page to evict
(which usually means we are under memory pressure), we do complicated
locking which may be slow. 1) has the disadvantage that there can be
substantial portion of memory we will refuse to write out... I'm not sure
what is better.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
