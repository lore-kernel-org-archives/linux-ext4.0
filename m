From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Mon, 05 May 2008 17:10:59 -0700
Message-ID: <1210032659.16169.64.camel@badari-desktop>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57630 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbYEFAKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2008 20:10:49 -0400
In-Reply-To: <20080505170636.GK25722@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-05-05 at 19:06 +0200, Jan Kara wrote:
> On Thu 01-05-08 08:16:21, Badari Pulavarty wrote:
> > Hi Andrew & Jan,
> > 
> > I was able to reproduce the customer problem involving DIO
> > (invalidate_inode_pages2) problem by writing simple testcase
> > to keep writing to a file using buffered writes and DIO writes
> > forever in a loop. I see DIO writes fail with -EIO.
> > 
> > After a long debug, found 2 cases how this could happen.
> > These are race conditions with journal_try_to_free_buffers()
> > and journal_commit_transaction().
> > 
> > 1) journal_submit_data_buffers() tries to get bh_state lock. If
> > try lock fails, it drops the j_list_lock and sleeps for
> > bh_state lock, while holding a reference on the buffer.
> > In the meanwhile, journal_try_to_free_buffers() can clean up the
> > journal head could call try_to_free_buffers(). try_to_free_buffers()
> > would fail due to the reference held by journal_submit_data_buffers()
> > - which in turn causes failues for DIO (invalidate_inode_pages2()).
> > 
> > 2) When the buffer is on t_locked_list waiting for IO to finish,
> > we hold a reference and give up the cpu, if we can't get
> > bh_state lock. This causes try_to_free_buffers() to fail.
> > 
> > Fix is to drop the reference on the buffer if we can't get
> > bh_state lock, give up the cpu and re-try the whole operation -
> > instead of waiting for the vh_state lock.
> > 
> > Does this look like a resonable fix ?
>   As Mingming pointed out there are few other places where we could hold
> the bh reference. Note also that we accumulate references to buffers in the
> wbuf[] list and we need that for submit_bh() which consumes one bh
> reference. Generally, it seems to me as a too fragile and impractical
> rule "nobody can hold bh reference when not holding page lock" which is
> basically what it comes down to if you really want to be sure that
> journal_try_to_free_buffers() succeeds. And also note that in principle
> there are other places which hold references to buffers without holding the
> page lock - for example writepage() in ordered mode (although this one is
> in practice hardly triggerable). So how we could fix at least the races
> with commit code is to implement launder_page() callback for ext3/4 which
> would wait for the previous transaction commit in case the page has buffers
> that are part of that commit (I don't want this logic in
> journal_try_to_free_buffers() as that is called also on memory-reclaim
> path, but journal_launder_page() is fine with me). This would be correct
> but could considerably slow down O_DIRECT writes in cases they're mixed
> with buffered writes so I'm not sure if this is acceptable.

Yes. I have been discussing all of these with Mingming. I agree with you
that it looks silly to update all the places to not hold a ref on the
buffer while waiting for spinlocks. 

Adding a launder_page() seems to be the right approach. I wouldn't worry
about making O_DIRECT slower. Currently, its failing with -EIO in this
case anyway. 

Unfortunately, this happens at a customer site and I can't effort to
give them a complete re-write type patch - I need to get this into 
older distro release :( Thats why I am trying to fix the cases.
I am finding more and more of these ..

Thanks,
Badari

