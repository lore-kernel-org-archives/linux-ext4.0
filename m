From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Thu, 30 Jul 2009 16:33:51 -0400
Message-ID: <20090730203351.GB6833@mit.edu>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com> <20090729181007.GC14105@mit.edu> <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36526 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZG3UeB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jul 2009 16:34:01 -0400
Content-Disposition: inline
In-Reply-To: <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 30, 2009 at 08:30:53PM +0200, Jan Kara wrote:
>   I have to say I'm a bit worried about modify-in-place tricks - it's
> not trivial to make sure buffer is not part of any transaction in the
> journal, since the buffer head could have been evicted from memory, but
> the transaction still is not fully checkpointed. Hence in memory, you
> don't have any evidence of the fact that if the machine crashes, your
> modify-in-place gets overwritten by journal-replay.

Yeah, good point; tracking which blocks might get overwritten on a
journal replay is tough.  What we *could* do that would make this easier
is to insert a revoke record for all extent tree blocks after the
blocks have been written to disk (since at that point there's no need
for that block to be replayed).

Whether or not this optimization is worth it largely depends on time
between how many blocks are getting allocated using fallocate(), and
what the average number of blocks are that get written at a time by
the application (normally enterprise databases) when write into the
unitialized area.  If the average size is say, 32k, and the amount of
space they allocate is say, 32 megs, then without doing any special
DIO optimization, on average we will end up having to do 1024
synchronous waits on a journal commit.  If the database doesn't use
any fallocates at all, then it will have to do a 32 meg write to
initialize the area, followed by 32 megs of data writes, written
randomly 32k at a time.

So being aggressive with pre-zeroing extra datablocks when we convert
uninit extents to initialized extents mean that we still have to do
some percentage of zero'izing data writes combined with the extra
journal traffic, so it's likely we haven't reduced the total disk
bandwidth by much, and the latency improvements of not having to do
the 32meg zero writes gets offset with the data=ordered latency hits
when we do the journal commit.

So it would seem to me that if we really want to get the full benefit
of preallocation in the DIO case, we really do need to think about
seeing if it's possible bypass the journal. 

It may be useful here to write a benchmark that simulates the behavior
of an eneterprise database using fallocate, so we can see what the
performance hit is of making sure we don't lose data on a crash, and
then how much of that performance hit we can claw back with various
optimizations.

					- Ted
