From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 17 Dec 2007 16:36:34 -0700
Message-ID: <20071217233634.GK3214@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20071217223455.GE3214@webber.adilger.int> <20071217225930.GJ7070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53666 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbXLQXgh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2007 18:36:37 -0500
Content-Disposition: inline
In-Reply-To: <20071217225930.GJ7070@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 17, 2007  17:59 -0500, Theodore Tso wrote:
> On Mon, Dec 17, 2007 at 03:34:55PM -0700, Andreas Dilger wrote:
> > We had also wanted to move from using db4 to tdb for the Lustre lfsck data
> > (collection of EA information for distributed fsck) but even at 10000 files
> > the tdb performance was growing exponentially slower than db4 and we gave up.
> > I suspect the same problem hits undo manager when the number of blocks to
> > save is very high.
> 
> Hm.  I was very concerned about using db4, mainly because of the ABI
> and on-disk format compatibility nightmare, which is why I chose tdb.

Yes, we have had all sorts of compatibility problems using db4 (e.g.
RHEL and SLES ship different package names, put the libraries and headers
in different locations, don't support overlapping sets of db4 libraries
between releases, etc), which is why we were hoping to be able to use tdb.

> But the performance problems are starting to make me worry.  Do you
> know how many tdb entries you had before tdb performance started going
> really badly down the toilet?  I wonder if there are some tuning knobs
> we could tweak to the performance numbers.

There is some test data at https://bugzilla.lustre.org/attachment.cgi?id=13924
which is a PDF file.  This shows 1000 items is reasonable, and 10000 is not.

The majority of the time is taken looking up existing entries, and this
is due to one unusual requirement of the Lustre usage to be notified
of duplicate insertions to detect duplicate use of objects, so this may
have been a major factor in the slowdown.  It isn't really practical to
use a regular libext2fs bitmap for our case, since the collision space
is a 64-bit integer, but maybe we could have done this with an RB tree
or some other mechanism.

So, your mileage may vary with the undo manager usage, but it is
definitely worth writing a test case (e.g. time creation of filesystems of
progressively larger size on a large device) and seeing how bad it gets.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
