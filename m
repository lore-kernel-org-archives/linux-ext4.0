From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Mon, 3 Aug 2009 11:36:28 +0200
Message-ID: <20090803093628.GA21712@duck.suse.cz>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <20090729181007.GC14105@mit.edu> <20090730183053.GE9223@atrey.karlin.mff.cuni.cz> <20090730203351.GB6833@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZHCJgb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 05:36:31 -0400
Content-Disposition: inline
In-Reply-To: <20090730203351.GB6833@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 30-07-09 16:33:51, Theodore Tso wrote:
> On Thu, Jul 30, 2009 at 08:30:53PM +0200, Jan Kara wrote:
> >   I have to say I'm a bit worried about modify-in-place tricks - it's
> > not trivial to make sure buffer is not part of any transaction in the
> > journal, since the buffer head could have been evicted from memory, but
> > the transaction still is not fully checkpointed. Hence in memory, you
> > don't have any evidence of the fact that if the machine crashes, your
> > modify-in-place gets overwritten by journal-replay.
> 
> Yeah, good point; tracking which blocks might get overwritten on a
> journal replay is tough.  What we *could* do that would make this easier
> is to insert a revoke record for all extent tree blocks after the
> blocks have been written to disk (since at that point there's no need
> for that block to be replayed).
  Hmm, but will this help you? You'd have to wait for revoke records to
commit before you can be sure that journal replay won't overwrite your
in-place changes.
  Looking at the O_DIRECT semantics, I don't think nobody really requires
the data being on disk after the write() returns and we crash - in
particular if we extend the file, the write will be just an ordinary
buffered write so in practice, it behaves like this already. Given the fact
that only a bit special applications use O_DIRECT, I think we can afford to
make a reservation that O_DIRECT writes even to a preallocated space do not
have any special data-consistency guarantees.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
