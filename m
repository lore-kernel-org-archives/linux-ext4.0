From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: support freeze operation like xfs_freeze
Date: Fri, 26 Jan 2007 16:23:22 -0600
Message-ID: <45BA7F5A.5000703@redhat.com>
References: <20070125172818.GA25037@swszl.szkp.uni-miskolc.hu> <45B907CA.70309@redhat.com> <20070126212208.GA9897@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Vitez Gabor <vitezg@niif.hu>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXAZWY0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jan 2007 17:24:26 -0500
In-Reply-To: <20070126212208.GA9897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Thu, Jan 25, 2007 at 01:40:58PM -0600, Eric Sandeen wrote:
>> on an lvm volume.  So, I think ext[34] are perfectly capable of being
>> frozen, there's just no generic userspace utility to point at a generic
>> block device to do that freezing.  xfs's collection of ioctls to do this
>> directly got grandfathered in, I guess.  :)
> 
> xfs's collection of ioctls do the right thing if the program which
> freezes the filesystems exits without unfreezing the filesystem
> (closing the file descriptor used by the freeze ioctl should unfreeze
> the filesystem, I hope)?  And I assume that if a setuid program which
> freezes filesystems forgets to catch SIGTSTP, and a hostile user types
> ^Z at the wrong time, that's considered a buggy setuid program?  :-)

xfs_freeze is actually -designed- to exit without unfreezing the 
filesystem, FWIW, for better or worse.  And I suppose there is all sorts 
of mayhem that could stem from setuid programs of all stripes...

I didn't mean to imply that it was better or worse, just that those xfs 
ioctls went in back when ioctls weren't getting quite so much scrutiny. 
  And it provided the freeze functionality for a linux filesystem at a 
time when there weren't other options.

Having the lvm tools do this automatically through generic layers during 
snapshot is absolutely a much nicer, cleaner way to go when snapshotting.

> One of the reasons why direct exposire to the freeze routines was
> always considered a little dangerous, and my guess is that's why we
> don't have a first class VFS interface.  Then again, XFS managed to
> get an exemption from some of the standard kernel merging rules,
> including allowing the IRIX compatibility layer, and I'm guessing the
> xfs collection of ioctls snuck in that way too.  :-)
> 
> 					- Ted

I prefer to think of it as a portability layer... :)

But anyway, on a less OT-topic, it has always seemed a little weird to 
me that you can -only- freeze a filesystem on an lvm block device. 
Surely there are occasionally legitimate reasons to freeze a filesystem 
on an arbitrary block device, if the filesystem can support it?

I don't see how direct exposure to freezing routines via LVM ioctls is 
any less dangerous than direct exposure to freezing routines on 
/dev/hda1... heck I can issue BLKROSET ioctls too, and that's arguably a 
lot more dangerous, because it's going to come as a big surprise to the 
filesystem, rather than a coordinated freeze.

-Eric
