From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Wed, 18 Mar 2009 14:19:29 -0400
Message-ID: <20090318181929.GQ15989@mit.edu>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu> <20090317092859.GA30636@skywalker> <20090318131215.GA11965@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43925 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbZCRSTe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 14:19:34 -0400
Content-Disposition: inline
In-Reply-To: <20090318131215.GA11965@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 18, 2009 at 02:12:15PM +0100, Jan Kara wrote:
> > Wouldn't this cause a deadlock ? We want to commit a transaction because
> > we don't have enough journal space (via journal_start) and now that would cause block
> > allocation which would do another journal_start()
>   Yes, that's exactly what I think. We cannot start a transaction while
> committing another transaction. Also you must put the block allocation
> into the transaction you're going to commit because of data consistency
> guarantees.
>   So if you want to do "alloc on commit" you have to reserve enough
> credits to the running transaction at the "block reservation" time and
> then use them for allocation at commit time. But this gets complex
> because the number of needed credits is hard to estimate (we don't know how
> many bitmaps / group descriptors we're going to modify). I'm not yet
> sure how to solve this problem...

Yeah, agreed, this is going to get tricky.  What we would have to do
is estimate a worst case, and include that in the running tally, and
then subtract it off when we start allocating the data blocks.

But the problem then is what happens to new file system operations?
If we stall them, it will be a major performance hit.  We can't let
them start a new transaction, because we can't have to open
transactions at the same time.  If we let them continue to run against
the current transaction, then #1, we could run out of space (although
the we give ourselves 25% of the journal as "slop" space which is
extremely generous), and #2, there is a race where the new file system
operations that do delayed allocation won't get allocated on the
commit.

So this is not going to be an easy problem to solve, not without
massively complicating the jbd2 layer...

							- Ted
