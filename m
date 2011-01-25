From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Tue, 25 Jan 2011 12:46:56 +0100
Message-ID: <20110125114656.GB4088@quack.suse.cz>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org>
 <20110123062900.GA7436@noexit>
 <20110124133143.GA5058@quack.suse.cz>
 <AA32FD05-E9BD-40AB-8495-EAD0547B5E02@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>,
	Ted Ts'o <tytso@mit.edu>, Manish Katiyar <mkatiyar@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab1AYLxs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 06:53:48 -0500
Content-Disposition: inline
In-Reply-To: <AA32FD05-E9BD-40AB-8495-EAD0547B5E02@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-01-11 18:06:24, Andreas Dilger wrote:
> >  jbd2_journal_start can always fail e.g. because the journal is aborted.
> > So it really just means no memory failures...
> > 
> >>> The tradeoff is that long-term, the code is more readable (as opposed
> >>> to having people look up what a random "true" or "false" value means).
> >>> But short-term, while it will make the patch smaller, it also makes
> >>> the patch harder audit, since we need to look at all of the places
> >>> where we _haven't_ made a change to make sure those call sites can
> >>> tolerate an error return.
> >> 
> >> 	I think we should start with jbd2_journal_start_can_fail() or
> >> something like it, and change it back to jbd2_journal_start() in the
> >> next window.  It's a silly name, but it catches exactly what you are
> >> worried about.
> > 
> >  Yes, I think this would be nice for auditting (but for that matter
> > current interface with additional argument isn't bad either and we can
> > just do the rename to _nofail in the final patch...).
> 
> The reason I don't like the "true" and "false" arguments is that it isn't
> at all clear which functions have "false" because they cannot fail, and
> which ones just haven't been updated yet.
> 
> In that light, I'd prefer to add _two_ new functions, one that indicates
> the function needs to retry (as it does now), and one that indicates that
> the caller will handle the error.  That way it is clear which functions
> have been investigated, and which ones haven't been looked at yet.  Once
> all of the functions have been changed, we can remove the old
> jbd2_journal_start() function to catch any patches that have not been
> updated to the new functions.
  I agree this would be good for the transition period but once we go
through all the callsites, I'd prefer to do a rename and have just
jbd2_journal_start() be the one which does not retry.

> Maybe jbd2_journal_start_canfail() and jbd2_journal_start_retry()?
  As I said above, I'd like the first one to live only temporarily so
I don't care about the name. The second one is probably better than
_nofail() but I still don't feel it describes well what the function
does...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
