From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Date: Fri, 14 Dec 2012 18:01:13 -0800
Message-ID: <20121215020113.GK9453@blackbox.djwong.org>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org>
 <50CA8556.7030905@mit.edu>
 <20121214021048.GF9453@blackbox.djwong.org>
 <CALCETrWRqFmTpYNyDwUyzQpSVZjVEOCCZfHHohVR5uvHzS+s0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21537 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2LOCDV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2012 21:03:21 -0500
Content-Disposition: inline
In-Reply-To: <CALCETrWRqFmTpYNyDwUyzQpSVZjVEOCCZfHHohVR5uvHzS+s0Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 14, 2012 at 05:12:37PM -0800, Andy Lutomirski wrote:
> On Thu, Dec 13, 2012 at 6:10 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Thu, Dec 13, 2012 at 05:48:06PM -0800, Andy Lutomirski wrote:
> >> On 12/13/2012 12:08 AM, Darrick J. Wong wrote:
> >> > Several complaints have been received regarding long file write latencies when
> >> > memory pages must be held stable during writeback.  Since it might not be
> >> > acceptable to stall programs for the entire duration of a page write (which may
> >> > take many milliseconds even on good hardware), enable a second strategy wherein
> >> > pages are snapshotted as part of submit_bio; the snapshot can be held stable
> >> > while writes continue.
> >> >
> >> > This provides a band-aid to provide stable page writes on jbd without needing
> >> > to backport the fixed locking scheme in jbd2.  A mount option is added to ext4
> >> > to allow administrators to enable it there.
> >>
> >> I'm a bit confused as to what it has to do with ext3.  Wouldn't this be
> >> useful as a mount option everywhere, though?
> >
> > ext3 requires snapshots; the rest are ok with either strategy.
> >
> > *If* snapshotting is generally liked, then yes I'll go redo it as a vfs mount
> > option.
> >
> >> If this becomes widely used, would it be better to snapshot on
> >> wait_for_stable_page instead of on io submission?
> >
> > That really depends on how long you can afford to wait and how much free
> > memory you have. :)  It's all a big tradeoff between write latency and
> > consumption of memory pages and bandwidth, and one that I doubt I'm qualified
> > to make for everyone.
> >
> >> FWIW, I'm about to pound pretty hard on this whole patchset on a box
> >> that doesn't need stable pages.  I'll let you know how it goes.
> >
> > Yay!
> >
> > --D
> 
> It survived.  I hit at least one mm bug, but I really don't think it's
> a problem with your code.  (I have not tried this workload on Linux
> 3.7 at all before.  It normally runs on 3.5.)  The box in question is

Would you mind sending along the bug report so I can make sure?

> ext4 on LVM on dm-crypt on (hardware) RAID 5 on hpsa, which should not
> need stable pages.
> 
> The majority of the data written (that wasn't unlinked before it was
> dropped from cache) was checksummed when written and verified later.
> Most of this data was written using mmap.  This workload hammers the
> vm concurrently in several threads, and it frequently stalls when
> stable pages are enabled, so it's probably exercising the code
> decently well.

Did you observe any change in performance?

> Feel free to add Tested-by: Andy Lutomirski <luto@amacapital.net>

Will do!  Thanks for the testing!

--D
