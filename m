From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Wed, 12 Mar 2008 16:02:36 -0400
Message-ID: <20080312200236.GE15804@mit.edu>
References: <n7xejaoynp9.fsf@sor.suse.de> <1204813967.8679.28.camel@norville.austin.ibm.com> <n7xzltbwzq3.fsf@sor.suse.de> <1204824227.7964.4.camel@norville.austin.ibm.com> <n7xiqzywr7u.fsf@sor.suse.de> <1204903187.7975.10.camel@norville.austin.ibm.com> <n7xr6egkk6w.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59330 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754331AbYCLUCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2008 16:02:45 -0400
Content-Disposition: inline
In-Reply-To: <n7xr6egkk6w.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2008 at 04:59:03PM +0100, Matthias Koenig wrote:
> 1. Do we agree that fstab fs_passno could be used besides fsck -A by a 
>    separate script to decide if a filesystem (that could not be checked 
>    in the fsck -A phase) should be checked?

Well, historically there have been /etc/fstab entries which look like
this:

/dev/zipdrive       /media/zipdisk   ext3 default,noauto 0 0

This is because there might not be a zip disk in the drive at the time
of the boot.  However, a root user could insert a zip disk, and then
run the command "fsck /dev/zipdrive" and expect it to work, and the
follow that up with "mount /dev/zipdrive".

So passno == 0 can't mean "don't mount the filesystem, ever".  All it
means is "don't mount it at boot".  So I don't think trying to kludge
new fields into fs_passno is the way to go.

------------

So here's another way you could do things that doesn't require any
patches to fsck at all.  Just add "comment=crypto" into the option
field of /etc/fstab, like this.  

/dev/mapper/crypto-frobnitz /crypto1           ext3    comment=crypto  1 1

Then you can skip filesystems that have the comment=crypto in the
options field via:

     fsck -AR -t opts=!comment=crypto

To check all of the filesystems that have the comment=crypto field
via:

     fsck -AR -t opts=comment=crypto

Why did I use "comment=crypto"?  Because if you use "crypto", then
mount will try to pass crypto to the kernel, and if the kernel doesn't
understand an option, it will reject the mount.  Mount doesn't send
"comment" mount options to the kernel, so this works.

Of course, you'll need to modify mount to be able to only mount all
crypto filesystems, or not to mount any crypto filesystems, so you
could change it to understand that "crypto" is not to be passed down
to the kernel, at which point you could just have this in /etc/fstab:

/dev/mapper/crypto-frobnitz /crypto1           ext3    crypto  1 1

And then the fsck invocations would become:

     fsck -AR -t opts=!crypto

and

     fsck -AR -t opts=crypto

Which of course looks much nicer.

I put in the "-t opts=" matching a long time ago (as in 10+ years
ago), because someone had wanted to do something strange like this.  I
had completely forgotten about it until now....

							- Ted
