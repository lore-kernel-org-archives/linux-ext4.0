From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 17 Dec 2007 17:59:30 -0500
Message-ID: <20071217225930.GJ7070@thunk.org>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20071217223455.GE3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34105 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbXLQW7i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 17:59:38 -0500
Content-Disposition: inline
In-Reply-To: <20071217223455.GE3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2007 at 03:34:55PM -0700, Andreas Dilger wrote:
> Did you see Eric's report that using the undo manager for mke2fs caused the
> performance to completely tank?  There is already enough memory pressure
> caused by a regular mke2fs that having to save the blocks into tdb for a
> large filesystem makes it unbearably slow.

Yup, I saw that, and had come to the same consluion (only use it when
uninit_groups/lazy_bg is enabled).

> We had also wanted to move from using db4 to tdb for the Lustre lfsck data
> (collection of EA information for distributed fsck) but even at 10000 files
> the tdb performance was growing exponentially slower than db4 and we gave up.
> I suspect the same problem hits undo manager when the number of blocks to
> save is very high.

Hm.  I was very concerned about using db4, mainly because of the ABI
and on-disk format compatibility nightmare, which is why I chose tdb.
But the performance problems are starting to make me worry.  Do you
know how many tdb entries you had before tdb performance started going
really badly down the toilet?  I wonder if there are some tuning knobs
we could tweak to the performance numbers.

						- Ted
