From: Johannes Stezenbach <js@sig21.net>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Mon, 18 Jul 2016 16:17:23 +0200
Message-ID: <20160718141723.GA8809@sig21.net>
References: <20160718105707.GA4253@sig21.net>
 <20160718133843.GA26664@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160718133843.GA26664@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 18, 2016 at 09:38:43AM -0400, Theodore Ts'o wrote:
> On Mon, Jul 18, 2016 at 12:57:07PM +0200, Johannes Stezenbach wrote:
> > 
> > I'm running 4.7.0-rc7 with ext4 on lvm on dm-crypt on SSD
> > and out of the blue on idle machine the following error
> > message appeared:
> > 
> > [373851.683131] EXT4-fs (dm-3): error count since last fsck: 1
> > [373851.683151] EXT4-fs (dm-3): initial error at time 1468438194: dx_probe:740: inode 22288562
> > [373851.683158] EXT4-fs (dm-3): last error at time 1468438194: dx_probe:740: inode 22288562
> > 
> > inode 22288562 is a directory with ~800 small files in it,
> > but AFAICT nothing was accessing it, no cron job running etc.
> > No further error message was logged.  Accessing the directory
> > and the files in it also gives no further errors.
> 
> Yes, thes messages gets printed once a day in case there was a file
> system corruption detected earlier.  The problem is people
> unfortunately run with their file systems set to errors=continue,
> which I sometimes refer to as the "don't worry, be happy" option.  The
[snip]

I've not willingly done this, but I recently upgraded to a bigger
SSD and so created new file system, and the mount option for errors=
isn't specified so it uses the default from superblock, and
mkfs.ext4 has defaulted to "Errors behavior: Continue"
according to dumpe2fs -h.  I'm using Debian sid FWIW, just checked
the source of e2fsprogs-1.43.1 and found:

#define EXT2_ERRORS_DEFAULT             EXT2_ERRORS_CONTINUE


During reboot after crash I saw the usual "Clearing orphaned inode"
messages scroll by, however they did not make it into systemd journal.
So I suspect if there were any other fsck errors during boot
they were lost, too, thanks to systemd-fsck.

Thanks for your detailed reply.


Johannes
