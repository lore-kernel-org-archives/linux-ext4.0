From: Jan Kara <jack@suse.cz>
Subject: Re: [Ocfs2-devel] [PATCH 01/18] jbd2: Add buffer triggers
Date: Fri, 19 Dec 2008 01:40:05 +0100
Message-ID: <20081219004005.GG8424@duck.suse.cz>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com> <1228871395-10273-2-git-send-email-joel.becker@oracle.com> <20081213004512.GD15241@mail.oracle.com> <20081218180820.GC6797@atrey.karlin.mff.cuni.cz> <20081219003224.GC21870@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocfs2-devel@oss.oracle.com, mfasheh@suse.com,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59610 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753373AbYLSAkH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 19:40:07 -0500
Content-Disposition: inline
In-Reply-To: <20081219003224.GC21870@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-12-08 16:32:25, Joel Becker wrote:
> On Thu, Dec 18, 2008 at 07:08:21PM +0100, Jan Kara wrote:
> > > On Tue, Dec 09, 2008 at 05:09:38PM -0800, Joel Becker wrote:
> > > > Filesystems often to do compute intensive operation on some
> > > > metadata.  If this operation is repeated many times, it can be very
> > > > expensive.  It would be much nicer if the operation could be performed
> > > > once before a buffer goes to disk.
> > > 
> > > 	I realized, well, that I'm an idiot.  The previous patch has a
> > > significant bug: what if a block is deallocated, then reused as a
> > > different type of metadata, all before the committing transaction gets
> > > around to firing the triggers?  It could use the new block type's
> > > triggers against the b_frozen_data of the old block type.
> > > 	The easy answer is to add b_frozen_triggers alongside
> > > b_frozen_data.  Here's the new patch.
> >   I think this is a reasonable thing to do, although I'm not sure it can
> > really happen - at least ext3 uses a mechanism that does not allow
> > reusing a freed block in the same transaction (because otherwise there's
> > no way of recovering unjournaled data after crash).
> 
> 	Oh, frozen_data protects that sort of thing.  The concern is
> that the old block type is in the committing transaction, and the new
> block type is in the running transaction.  But the trigger type is from
> the new block type, and not valid to call against the committing block
> in the committing transaction.
  Sorry, I've confused frozen_data with committed_data. Buffer with
frozen_data happens quite often. So your fix is really needed.

> > > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > > index ebc667b..c8a1bac 100644
> > > --- a/fs/jbd2/commit.c
> > > +++ b/fs/jbd2/commit.c
> > > @@ -509,6 +509,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
> > >  		if (is_journal_aborted(journal)) {
> > >  			clear_buffer_jbddirty(jh2bh(jh));
> > >  			JBUFFER_TRACE(jh, "journal is aborting: refile");
> > > +			jbd2_buffer_abort_trigger(jh,
> > > +						  jh->b_frozen_data ?
> > > +						  jh->b_frozen_triggers :
> > > +						  jh->b_triggers);
> >   Wouldn't it be nicer if the jbd2_buffer_foo_trigger() functions
> > checked which set of triggers they should use and used it?
> 
> 	Well, it only does on the frozen-data check.  I suppose that
> could be pulled into the abort_trigger() function.  Maybe an additional
> patch?
  Yeah, I was just wondering why we don't do:
jbd2_buffer_abort_trigger(jh)
  and choose the proper set of triggers in the jbd2_buffer_abort_trigger()
function (and similarly for the commit trigger). Or does it make sence
to not call frozen trigger in some place if there're frozen data set?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
