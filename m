From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] fix panic in jbd by adding locks
Date: Thu, 23 Aug 2007 14:41:44 -0400
Message-ID: <20070823184142.GA31706@dhcp-243-37.rdu.redhat.com>
References: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com> <20070815113737.GC7642@atrey.karlin.mff.cuni.cz> <20070815121704.GL24127@dhcp-243-37.rdu.redhat.com> <20070816160835.GB26703@atrey.karlin.mff.cuni.cz> <20070816163744.GB10817@dhcp-243-37.rdu.redhat.com> <20070820152021.GF3784@duck.suse.cz> <20070821154311.GE27557@dhcp-243-37.rdu.redhat.com> <20070821164815.GI18718@duck.suse.cz> <20070821174500.GF27557@dhcp-243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761367AbXHWSkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Aug 2007 14:40:25 -0400
Content-Disposition: inline
In-Reply-To: <20070821174500.GF27557@dhcp-243-37.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 21, 2007 at 01:45:02PM -0400, Josef Bacik wrote:
> > > handle_t's are removed and such before processing the revoke lists, but right
> > > before we process the revoke lists we set the journals running transaction to
> > > NULL, which means we can continue on our merry way.  AFAICS the revoke lists are
> > > per journal, not per transaction, so once we give up the j_state_lock after
> > > having made sure the handle_t's had done their thing, we set the
> > > running_transaction to NULL letting people continue to do their thing, and since
> > > the revoke table is on a per journal basis, its completely valid for a new
> > > transaction to be started, a handle to be added to it, journal_cancel_revoke()
> > > to be run against that handle while still in journal_commit_transaction().  It
> > > wouldn't necessarily be a handle_t from the transaction we are in the middle of
> > > committing, it would be from a new transaction, and since the revoke list is per
> > > journal, both the transaction thats currently being committed and the new
> > > transaction would have access to the same revoke list, hence the race.  Is this
> > > correct?  If not let me know because I want to understand this code better.
> >   The trick is, there are in fact two revoke tables. So the commit code
> > does the following:
> >   1) It waits until all handles of the running transaction are released
> > (this is the while loop waiting checking t_updates).
> >   2) It does some cleanup of unused buffers.
> >   3) Switches revoke tables - i.e. journal->j_revoke now points to a
> > freshly initialized table, the table of the committing transaction is kept
> > hidden.
> >   4) Transaction state is changed to FLUSH, journal->j_running_transaction
> > is set to NULL, etc.
> >   5) Data writeout is performed.
> >   6) Saved revoke hash table is written.
> > 
> >   After 3), journal_revoke() and journal_revoke_cancel() access the new
> > hash table and thus have no influence on journal_write_revoke_records(). It
> > could possibly be that the pointer to the old hash table would be stored in
> > some local variable - but all the places where we store a pointer to the
> > hash table seem to be contained inside journal_start(), journal_stop()
> > pairs (all functions working with hash tables take a transaction handle
> > as an argument) and because all handles were released at some point in time,
> > we know that this should not happen either.
> >   I hope it is clearer now. If you still have any questions, please ask.
> > 
> 
> Ahh the switch is what I was overlooking, thank you that makes more sense.
> Course now I have to figure out what really is going on here :(.  I'll see if I
> can't sort this out.  Thanks much for your help,
> 

I'm having some difficulty thinking of a good way to troubleshoot this, list
poisening is on by default, and I don't think any other kind of quick switches
that would help flush this bug out.  One thing I was thinking about, what if
somebody comes right behind us trying to commit a separate transaction?  I think
this could be possible as by the time we get to the
journal_write_revoke_records() we aren't holding any locks on the journal
itself, so we could come behind the transaction thats currently running, and
switch the revoke record tables on it while its doing its thing.  Do you have
any suggestions on a good way to approach this problem?  And as for my newest
theory, what have I not thought of :).  Thank you,

Josef
