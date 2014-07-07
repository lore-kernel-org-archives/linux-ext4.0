From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: media error but where?
Date: Mon, 7 Jul 2014 19:21:10 -0400
Message-ID: <20140707232110.GE8254@thunk.org>
References: <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
 <20140706133247.GB18204@amd.pavel.ucw.cz>
 <20140706134325.GA18955@amd.pavel.ucw.cz>
 <20140706182936.GB471@thunk.org>
 <20140706213710.GA19847@amd.pavel.ucw.cz>
 <20140707010002.GD471@thunk.org>
 <20140707185543.GA26056@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140707185543.GA26056@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 07, 2014 at 08:55:43PM +0200, Pavel Machek wrote:
> If I wanted to recover the data... remount-r would be the way to
> go. Then back it up using dd_rescue. ... But that way I'd turn bad
> sectors into silent data corruption.
> 
> If I wanted to recover data from that partition, fsck -c (or
> badblocks, but that's trickier) and then dd_rescue would be the way to go.

Ah, if that's what you're worried about, just do the following:

badblocks -b 4096 -o /tmp/badblocks.sdXX /dev/sdXX
debugfs -R "icheck $(cat /tmp/badblocks.sdXX)" /dev/sdXX > /tmp/bad-inodes
debugfs -R "ncheck $(sed -e 1d /tmp/bad-inodes | awk '{print $2}' | sort -nu)" > /tmp/bad-files

This will give you a list of the files that contain blocks that had
I/O errors.  So now you know which files have contents which have
probably been corrupted.  No more silent data corruption.  :-)

> Actually -- tool to do relocations would be nice. It is not exactly
> easy to do it right by hand.

It's not *that* hard.  All you really need to do is:

for i in $(cat /tmp/badblocks.sdXX) ; do
    dd if=/dev/zero of=/dev/sdXX bs=4k seek=$i count=1
done
e2fsck -f /dev/sdXX

For bonus points, you could write a C program which tries to read the
block one final time before doing the forced write of all zeros.

It's a bit harder if you are trying to interpret the device-driver
dependent error messages, and translate the absolute sector number
into a partition-relative block number.  (Except sometimes, depending
on the block device, the number which is given is either a relative
sector number, or a relative block number.)


For disks that do bad block remapping, an even simpler thing to do is
to just delete the corrupted files.  When the blocks get reallocated
for some other purpose, the HDD should automatically remap the block
on write, and if the write fails, such that you are getting an I/O
error on the write, it's time to replace the disk.

> Forcing reallocation is hard & tricky. You may want to simply mark it
> bad and lose a tiny bit of disk space... And even if you want to force
> reallocation, you want to do fsck -c, first, and restore affected
> files from backup.

Trying to force reallocation isn't that hard, so long as you have
resigned yourself that you've lost the data in the blocks in question.
And if it doesn't work, for whatever reason, I would simply not trust
the disk any longer.

For me at least, it's all about the value of the disk versus the value
of my time and the data on the disk.  When I take my hourly rate into
question ($annual comp divided by 2000) the value of trying to save a
particular hard drive almost never works out in my favor.  So these
days, my bias is to do what I can to save the data, but to not fool
around with trying to play fancy games with e2fsck -c.  I'll just want
to save what I can, and hopefully, with regular backups, that won't
require heroic measures, and then trash and replace the HDD.

Cheers,

					- Ted

P.S.  I'm not sure why you consider running badblocks to be tricky.
The only thing you need to be careful about is passing the file system
blocksize to badblocks.  And since the block size is almost always 4k
for any non-trivial file system, all you really need to do is
"badblocks -b 4096".  Or, if you really like:

	   badblocks -b $(dumpe2fs -h /dev/sdXX | awk -F: '/^Block size: / {print $2}') /dev/sdXX

See?  Easy peasy!  :-)
