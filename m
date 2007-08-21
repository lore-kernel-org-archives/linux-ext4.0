From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] fix panic in jbd by adding locks
Date: Tue, 21 Aug 2007 11:43:12 -0400
Message-ID: <20070821154311.GE27557@dhcp-243-37.rdu.redhat.com>
References: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com> <20070815113737.GC7642@atrey.karlin.mff.cuni.cz> <20070815121704.GL24127@dhcp-243-37.rdu.redhat.com> <20070816160835.GB26703@atrey.karlin.mff.cuni.cz> <20070816163744.GB10817@dhcp-243-37.rdu.redhat.com> <20070820152021.GF3784@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbXHUPl0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Aug 2007 11:41:26 -0400
Content-Disposition: inline
In-Reply-To: <20070820152021.GF3784@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 20, 2007 at 05:20:21PM +0200, Jan Kara wrote:
>   OK, thanks. So record probably points to an already freed memory which has
> been overwritten by garbage...
> 
> > >   Thanks for details. I'm still not convinced. What they essentially
> > > write is that slab cache revoke_record_cache is not guarded by any spin
> > > lock. It's not and that should be fine as slab caches are SMP safe by
> > > themselves.
> > 
> > No its the list_del thats not gaurded, so the hash list gets screwed up outside
> > of a lock.  If there are other problems that need to be addressed then ok, but I
> > still think that we should be protecting all of the list traversal/changing
> > should be protected by the lock.  Thank you,
>   But the traversal in journal_write_revoke_records() *is* in fact guarded
> by the commit logic in journal_commit_transaction() handling code - it
> doesn't allow anybody to mess with revoke lists when a transaction is
> committing. So there's no need to guard the hash list again in
> journal_write_revoke_records() by the spinlock. And if the logic does not
> work and lets somebody modify revoke lists during commit, we have more
> serious problems than hash list corruption. That's why I'm trying to find
> out where's the real culprit of the Oops. But so far I cannot find out how
> the corruption can happen...

I should note here I'm not trying to be argumentative, I just want to
understand.  Ok so journal_commit_transaction() will make sure all the
handle_t's are removed and such before processing the revoke lists, but right
before we process the revoke lists we set the journals running transaction to
NULL, which means we can continue on our merry way.  AFAICS the revoke lists are
per journal, not per transaction, so once we give up the j_state_lock after
having made sure the handle_t's had done their thing, we set the
running_transaction to NULL letting people continue to do their thing, and since
the revoke table is on a per journal basis, its completely valid for a new
transaction to be started, a handle to be added to it, journal_cancel_revoke()
to be run against that handle while still in journal_commit_transaction().  It
wouldn't necessarily be a handle_t from the transaction we are in the middle of
committing, it would be from a new transaction, and since the revoke list is per
journal, both the transaction thats currently being committed and the new
transaction would have access to the same revoke list, hence the race.  Is this
correct?  If not let me know because I want to understand this code better.
Thank you,

Josef
