From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 25 Jan 2008 08:33:29 -0500
Message-ID: <20080125133329.GB8184@mit.edu>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46338 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbYAYNdh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2008 08:33:37 -0500
Content-Disposition: inline
In-Reply-To: <20080125121851.GA3361@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2008 at 03:18:51PM +0300, Dmitri Monakhov wrote:
> First of all Linux already have at least one open-source(dm-snap),
> and several commercial snapshot solutions. 

Yes, but it requires that the filesystem be stored under LVM.  Unlike
what EVMS v1 allowed us to do, we can't currently take a snapshot of a
bare block device.  This patch could potentially be useful for systems
which aren't using LVM, however....

> You have to realize what delay between 1-3 stages have to be minimal.
> for example dm-snap perform it only for explicit journal flushing.
> From my experience if delay is more than 4-5 seconds whole system becomes
> unstable.

That's the problem.  You can't afford to freeze for very long.

What you *could* do is to start putting processes to sleep if they
attempt to write to the frozen filesystem, and then detect the
deadlock case where the process holding the file descriptor used to
freeze the filesystem gets frozen because it attempted to write to the
filesystem --- at which point it gets some kind of signal (which
defaults to killing the process), and the filesystem is unfrozen and
as part of the unfreeze you wake up all of the processes that were put
to sleep for touching the frozen filesystem.

The other approach would be to say, "oh well, the freeze ioctl is
inherently dangerous, and root is allowed to himself in the foot, so
who cares".  :-)

But it was this concern which is why ext3 never exported freeze
functionality to userspace, even though other commercial filesystems
do support this.  It wasn't that it wasn't considered, but the concern
about whether or not it was sufficiently safe to make available.

And I do agree that we probably should just implement this in
filesystem independent way, in which case all of the filesystems that
support this already have super_operations functions
write_super_lockfs() and unlockfs().

So if this is done using a new system call, there should be no
filesystem-specific changes needed, and all filesystems which support
those super_operations method functions would be able to provide this
functionality to the new system call.

      	      	     	    		      	 - Ted

P.S.  Oh yeah, it should be noted that freezing at the filesystem
layer does *not* guarantee that changes to the block device aren't
happening via mmap()'ed files.  The LVM needs to freeze writes the
block device level if it wants to guarantee a completely stable
snapshot image.  So the proposed patch doens't quite give you those
guarantees, if that was the intended goal.
