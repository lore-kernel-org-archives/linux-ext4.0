From: Theodore Tso <tytso@mit.edu>
Subject: Re: support freeze operation like xfs_freeze
Date: Fri, 26 Jan 2007 20:10:13 -0500
Message-ID: <20070127011013.GB9897@thunk.org>
References: <20070125172818.GA25037@swszl.szkp.uni-miskolc.hu> <45B907CA.70309@redhat.com> <20070126212208.GA9897@thunk.org> <45BA7F5A.5000703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vitez Gabor <vitezg@niif.hu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40070 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbXA0BKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jan 2007 20:10:30 -0500
Content-Disposition: inline
In-Reply-To: <45BA7F5A.5000703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 26, 2007 at 04:23:22PM -0600, Eric Sandeen wrote:
> xfs_freeze is actually -designed- to exit without unfreezing the 
> filesystem, FWIW, for better or worse.  And I suppose there is all sorts 
> of mayhem that could stem from setuid programs of all stripes...

I had a vague memory of that, but I probably supressed the horror.  :-)

> But anyway, on a less OT-topic, it has always seemed a little weird to 
> me that you can -only- freeze a filesystem on an lvm block device. 
> Surely there are occasionally legitimate reasons to freeze a filesystem 
> on an arbitrary block device, if the filesystem can support it?

The issue isn't that you can only freeze a filesystem on an LVM block
device; in fact, you can't.  You can only take a snapshot on an LVM
block device.  I wish you could take snapshots on arbitrary block
devices --- the EVMS1 kernel patches allowed that --- but
unfortunately they were implemented in a way that the kernel community
decided was too ugly to let live, or at least merge into mainline.

> I don't see how direct exposure to freezing routines via LVM ioctls is 
> any less dangerous than direct exposure to freezing routines on 
> /dev/hda1... 

So the issue is that you *don't* have direct expusire to the freezing
routines via LVM ioctl's.  All you can do is request a snapshot, and
the LVM ioctl's freeze the filesystems, take the snapshot and then
unfreeze the filesystem.  

You're right that the BLKROSET ioctls are probably just as dangerous
as well, and of course root can do all sorts of things like running
mkfs, or dd'ing into /dev/kmem, etc.  I think though the issue was
that someone requested a user mode program that was accessible via a
shell script, probably because XFS had that functionality, and the
concern was that few people trusted system administrators to be able
to handle such power responsibly.  Freezing the filesystem for hour or
minutes seems like a very bad idea, and that's exactly the sort of
thing that I can imagine a clueless level one system administrator
doing.  ("I know!  I'll freeze the filesystem while I backup all 30 TB
of it, and then I'll unfreeze it.")

The question really is what are the legimate uses of such a facility
where you wouldn't be better off taking a snapshot and then doing the
backup dump on the snapshot?  The real issue is that we can't take
snapshots on plain block devices, but that might be the better problem
to solve....

						- Ted
