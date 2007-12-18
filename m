From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 17 Dec 2007 22:32:49 -0500
Message-ID: <20071218033249.GQ7070@thunk.org>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20071217223455.GE3214@webber.adilger.int> <20071217225930.GJ7070@thunk.org> <20071217233634.GK3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55143 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXLRDcw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 22:32:52 -0500
Content-Disposition: inline
In-Reply-To: <20071217233634.GK3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2007 at 04:36:34PM -0700, Andreas Dilger wrote:
> > But the performance problems are starting to make me worry.  Do you
> > know how many tdb entries you had before tdb performance started going
> > really badly down the toilet?  I wonder if there are some tuning knobs
> > we could tweak to the performance numbers.
> 
> There is some test data at
> https://bugzilla.lustre.org/attachment.cgi?id=13924 which is a PDF
> file.  This shows 1000 items is reasonable, and 10000 is not.

I did some research, and the problem is that tdb uses a fixed number
of buckets for its hash size.  By default it is 131 hash buckets, but
you can pass in a different hash size when you create the tdb table.
So with 10,000 items, you will have an average of 76 objects per hash
chain, and that doesn't work terribly well, obviously.  Berkdb's hash
method uses an extensible hashing system which increases number of
bits that are used in the hash, and breaks up the hash buckets as they
get too big, which is a much nicer self-tuning algorithm.  With tdb,
you need to know from the get-go how much stuff you're likely going to
be storing in the tdb system, and adjust your hash size accordingly.

> The majority of the time is taken looking up existing entries, and this
> is due to one unusual requirement of the Lustre usage to be notified
> of duplicate insertions to detect duplicate use of objects, so this may
> have been a major factor in the slowdown.  It isn't really practical to
> use a regular libext2fs bitmap for our case, since the collision space
> is a 64-bit integer, but maybe we could have done this with an RB tree
> or some other mechanism.

Well, if you only need an in-core data structure, and it doesn't need
to be stored on disk, have you looked at e2fsck/dict.c, which was
lifted from Kazlib?  It's a userspace, single file, in-memory only RB
tree implementation.

Regards,

						- Ted
