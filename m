From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 01/18] jbd2: Add buffer triggers
Date: Thu, 18 Dec 2008 16:32:25 -0800
Message-ID: <20081219003224.GC21870@mail.oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<1228871395-10273-2-git-send-email-joel.becker@oracle.com>
	<20081213004512.GD15241@mail.oracle.com>
	<20081218180820.GC6797@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mfasheh@suse.com, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20081218180820.GC6797@atrey.karlin.mff.cuni.cz>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 18, 2008 at 07:08:21PM +0100, Jan Kara wrote:
> > On Tue, Dec 09, 2008 at 05:09:38PM -0800, Joel Becker wrote:
> > > Filesystems often to do compute intensive operation on some
> > > metadata.  If this operation is repeated many times, it can be very
> > > expensive.  It would be much nicer if the operation could be performed
> > > once before a buffer goes to disk.
> > 
> > 	I realized, well, that I'm an idiot.  The previous patch has a
> > significant bug: what if a block is deallocated, then reused as a
> > different type of metadata, all before the committing transaction gets
> > around to firing the triggers?  It could use the new block type's
> > triggers against the b_frozen_data of the old block type.
> > 	The easy answer is to add b_frozen_triggers alongside
> > b_frozen_data.  Here's the new patch.
>   I think this is a reasonable thing to do, although I'm not sure it can
> really happen - at least ext3 uses a mechanism that does not allow
> reusing a freed block in the same transaction (because otherwise there's
> no way of recovering unjournaled data after crash).

	Oh, frozen_data protects that sort of thing.  The concern is
that the old block type is in the committing transaction, and the new
block type is in the running transaction.  But the trigger type is from
the new block type, and not valid to call against the committing block
in the committing transaction.

> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index ebc667b..c8a1bac 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -509,6 +509,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
> >  		if (is_journal_aborted(journal)) {
> >  			clear_buffer_jbddirty(jh2bh(jh));
> >  			JBUFFER_TRACE(jh, "journal is aborting: refile");
> > +			jbd2_buffer_abort_trigger(jh,
> > +						  jh->b_frozen_data ?
> > +						  jh->b_frozen_triggers :
> > +						  jh->b_triggers);
>   Wouldn't it be nicer if the jbd2_buffer_foo_trigger() functions
> checked which set of triggers they should use and used it?

	Well, it only does on the frozen-data check.  I suppose that
could be pulled into the abort_trigger() function.  Maybe an additional
patch?

>   Otherwise the patch looks nice.

	Thanks for taking a look!

-- 

"Win95 file and print sharing are for relatively friendly nets."
	- Paul Leach, Microsoft

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
