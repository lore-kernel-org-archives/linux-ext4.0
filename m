From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Use generic FS in virtual environments
 challenges and solutions
Date: Thu, 30 Jan 2014 11:05:35 +0100
Message-ID: <20140130100535.GA12687@quack.suse.cz>
References: <87zjmekgdh.fsf@openvz.org>
 <20140129153746.GA14526@quack.suse.cz>
 <87wqhhkivb.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Konstantin Khorenko <khorenko@parallels.com>,
	Pavel Emelianov <xemul@parallels.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wqhhkivb.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 30-01-14 11:51:20, Dmitry Monakhov wrote:
> > >    B) Reduce fsck time. Theodore Tso have announced initiative to implement
> > >       ffck for ext4 [3]. I want to discuss perspectives of design and
> > >       implementation online fsck for ext4.
> >   Well, this comes up every once in a while and the answer is always the
> > same. Checking might be reasonably doable but comes almost for free when
> > using LVM snapshots and doing fsck on the snapshot. Fixing read-write
> > filesystem - good luck.
> But. What what about merging data from fixed snapshot back to original image?
> 
> ---time-axis------------------------------------------------->
> FS0----[Error]---[write-new-data]----------------->X????
>          |                                         |
> FS0-snap \-----[start fsck]-----[errors corrected]-/
> Obviously there are no way how we can merge fixed snapshot to modified filesystem
  Yes, snapshots are good only for read-only checks. If they find errors,
you have to bite the bullet, unmount the fs and run fsck. However fsck
finding errors should be rare enough, or do you have other experience?

> So the only option we have after we have discovered error on FS0-snap is
> to umount FS0 and run fsck on it. As result we double disk load, and
> still have big downtime, but what if error was relatively simple (wrong
> group stats, or wrong i_blocks for inode) it is possible to fix it
> online. My proposal is to start a discussion about list issues which can be
> fixed online.
  The trouble is that to reliably check even such simple thing as group
stats or i_blocks, you have to freeze all modifications to the group /
inode, make kernel flush all its internal state for these objects, check +
fix them, make kernel reread the new info, and unfreeze these objects. So a
lot of work for even the simplest fixes and it's not clear to me why people
should hit fs corruption often enough to warrant the complications.

There are also other guys who want to be able to make some groups not
available for allocation so if we spot some inconsistency in group metadata,
we simply won't do allocation from it anymore and then run fsck to fix the
damage during scheduled downtime. That is much easier to implement and
approach like this should go a long way towards making corrupted filesystem
still usable.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
