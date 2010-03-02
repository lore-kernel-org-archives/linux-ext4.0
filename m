From: Jan Kara <jack@suse.cz>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
 been remounted readonly
Date: Tue, 2 Mar 2010 14:26:43 +0100
Message-ID: <20100302132643.GB3829@quack.suse.cz>
References: <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
 <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
 <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
 <16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
 <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
 <20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
 <877hq2tyg8.fsf@openvz.org>
 <20100224165646.GL3687@quack.suse.cz>
 <20100302093431.GB5106@lst.de>
 <874okz6nzj.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0CBN0e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 08:26:34 -0500
Content-Disposition: inline
In-Reply-To: <874okz6nzj.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-03-10 13:01:52, Dmitry Monakhov wrote:
> Christoph Hellwig <hch@lst.de> writes:
> >>   Al, Christoph, do I miss something or there is really nothing which
> >> prevents a process from opening a file after the fs_may_remount_ro() check
> >> in do_remount_sb()?
> >
> > No, there is nothing.  We really do need a multi-stage remount read-only
> > process:
> >
> >  1) stop any writes from userland, that is opening new files writeable
> This is not quite good idea because sync may take really long time,
> #fsstress -p32 -d /mnt/TEST -l9999999 -n99999999 -z -f creat=100 -f write=100
> #sleep 60;
> #killall -9 fsstress
> #time mount mnt -oremount,ro
> it take several minutes to complete.
> And at the end it may fail but other reason.
  Two points here:
1) Current writeback code has a bug that while we are umounting/remounting,
sync_filesystem() just degrades to doing all writeback in sync mode
(because any non-sync writeback fails to get s_umount sem for reading
and thus skips all the inodes of the superblock). This has considerable
impact on the speed of sync during umount / remount.

2) IMHO it's not bad to block all opens for writing during remounting RO
(and thus also during the sync). It's not a performance issue (remounting
RO does not happen often), it won't confuse any application or so even if
we later decide we cannot really finish remounting. Surely we'd have to
come up with a better waiting scheme than just cpu_relax() in
mnt_want_write() but that shouldn't be hard. The only thing I'm slightly
worried about is whether we won't hit some locking issues (i.e., caller
of mnt_want_write holding some lock needed to finish remount...).

> >  2) stop any periodic writeback from the VM or filesystem-internal
> >  3) write out all filesystem data and metadata
> >  4) mark the filesystem fully read-only
> 
> I've tried to sole the issue in lightly another way
> Please take a look on this 
> http://marc.info/?l=linux-fsdevel&m=126723036525624&w=2
> 1) Mark fs as GOING_TO_REMOUNT
> 2) any new writer will clear this flag
>    This allow us to not block 
> 3) check flag before fssync and after and return EBUSY in this case. 
> 4) At this time we may to block writers (this is absent in my patch)
>    It is acceptable to block writers at this time because later stages
>    doesn't take too long.
> 5) perform fs-specific remount method.
> 6) Marks filesystem as MS_RDONLY.
  I like my solution more since in my solution, admin does not have go
hunting for an application which keeps touching the filesystem while he is
trying to remount it read only (currently, using lsof is usually enough but
after your changes, running something like "while true; do touch /mnt/;
done" has much larger window to stop remounting RO).
  But in principle your solution is acceptable for me as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
