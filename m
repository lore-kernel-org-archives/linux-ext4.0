From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Sun, 6 Jul 2014 15:32:47 +0200
Message-ID: <20140706133247.GB18204@amd.pavel.ucw.cz>
References: <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48673 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGFNct (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jul 2014 09:32:49 -0400
Content-Disposition: inline
In-Reply-To: <20140704185626.GB11103@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 2014-07-04 14:56:26, Theodore Ts'o wrote:
> On Fri, Jul 04, 2014 at 07:21:04PM +0200, Pavel Machek wrote:
> > 
> > Is it possible that my fsck is so old it does not clear this "filesystem
> > had error in past" flag? Because I strongly suspect I'll boot into
> > init=/bin/bash, run fsck, it will tell me "all clean", and the messages
> > will repeat in the middle of fsck run.
> 
> Yes, that's what's going on.  E2fsprogs v1.41.12 does not have the
> code to clear those fields in the superblock; that code was added in
> v1.41.13.
> 
> (There have also been a ****huge**** number of bug fixes since May
> 2010, which is when 1.41.12 was released, so I'd strongly suggest that
> you upgrade to a newer version of e2fsprogs.  In particular DON'T try
> resizing an an ext4 file system, either on-line or off-line with a
> version of e2fsprogs that ancient; there is a very good chance you
> will badly corrupt the file system.)

Ok, I have compiled fsck from git, it calls itself 1.43-WIP (18-May-2014).

If I run it on my /dev/sda3, it still calls it clean and quits (even
through it should still have the "filesystem had error in past" flag).

I ran it -f, and it said all clean. Did not mention modifying the
filesystem.

Now I'm running fsck.new -cf. I don't think this filesystem has any
bad blocks. Still, it says "rootfs: Updating bad block inode."
... "FILE SYSTEM WAS MODIFIED", "REBOOT LINUX".

While looking at e2fsck sources:

                sprintf(buf, "badblocks -b %d -X %s%s%s %llu",
                fs->blocksize,
                        (ctx->options & E2F_OPT_PREEN) ? "" : "-s ",
                        (ctx->options & E2F_OPT_WRITECHECK) ? "-n " :
                "",
		                fs->device_name,
                ext2fs_blocks_count(fs->super)-1);
                f = popen(buf, "r");

...is it really good idea? I think it will do the bad thing in (crazy)
setup such as this, or in any setup with space in filename:

root@duo:/dev# ls -al  | grep echo
brw-rw----   1 root disk      8,   3 Jul  6 14:56 `echo ownered`
root@duo:/dev# /usr/local/bin/
e2fsck.new  unrar2      
root@duo:/dev# /usr/local/bin/e2fsck.new '`echo ownered`' 
e2fsck 1.43-WIP (18-May-2014)
`echo ownered` is mounted.
e2fsck: Cannot continue, aborting.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
