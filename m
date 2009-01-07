From: Christian Ohm <chr.ohm@gmx.net>
Subject: Re: How to recover a damaged ext4 file system?
Date: Wed, 7 Jan 2009 22:42:06 +0100
Message-ID: <20090107214148.GA3151@moongate.localnet>
References: <20090105135347.GA3337@localdomain> <20090106120527.GT3932@webber.adilger.int> <20090106193404.GA18957@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44099 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759720AbZAGVmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 16:42:18 -0500
Content-Disposition: inline
In-Reply-To: <20090106193404.GA18957@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday,  6 January 2009 at 14:34, Theodore Tso wrote:
> On Tue, Jan 06, 2009 at 05:05:27AM -0700, Andreas Dilger wrote:
> > 
> > You should try to run e2fsck with the backup group descriptors, using
> > the -B and/or -b options (at a guess -B 4096 and -b 32768).
> 
> That probably won't help, given that the fsck transcript already says
> this:
> 
> > > fsck.ext4: Group descriptors look bad... trying backup blocks...

Yes, I think I tried that without success.

> It looks like both the primary and the backup block group descriptors
> are bad.  I'm not sure how this happened; normally nothing touches the
> backup block superblocks at all.  Stupid question --- are you sure the
> partition table is sane; that's always the first thing to check.

I think so; I didn't explicitly look, but didn't notice anything strange.

> Can you upload someplace the output of
> 
> dumpe2fs /dev/XXX
> dumpe2fs -o superblock=32768 /dev/XXX
> dumpe2fs -o superblock=98304 /dev/XXX
> 
> That would be helpful to see what had happened.

I'll do that soon; I got another harddisk to copy the partition, but both disks
aren't connected right now. 

> > 2. Is this corruption a fault of ext4? I guess this is difficult to
> > answer, but I had ext3 survive any lockups without much problems. So
> > far ext4 seems not quite that robust, but perhaps another file
> > system would have blown up as well in this situation. Is there any
> > information I can give you to help make ext4 more robust?
> 
> I'm not sure what the hard system hang did, but it looks like it
> splattered a lot of random crap all over the harddrive.  I doubt ext4
> did this, and I doubt ext3 would have done any better.... we need to
> know a lot more about exactly what sort damage was done to the
> filesytem to say for certain, though.

I did one copy of the partition already (took three hours, so not something to
do often...), and ran fsck -y on that. The result was an endless fsck loop like
that described in
http://www.linuxquestions.org/questions/linux-hardware-18/corrupt-ext3-partition-need-to-recover-376366/.
Oh, and I have to try if dumpe2fs actually works, either that or debugfs failed
when I tried to run it on the original disk (I also ran dumpe2fs on the copy
while fsck was doing its looping, and depending on the time it did or did not
find a file system on the device). Anyway, I hope I can experiment some more
tomorrow.

Oh, and is there a human understandable description of the on-disk data format
to compare with a hexdump? A (admittedly very short) search didn't turn up
anything.

Best regards,
Christian Ohm

