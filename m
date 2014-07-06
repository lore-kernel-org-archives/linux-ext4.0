From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: media error but where?
Date: Sun, 6 Jul 2014 14:29:36 -0400
Message-ID: <20140706182936.GB471@thunk.org>
References: <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
 <20140706133247.GB18204@amd.pavel.ucw.cz>
 <20140706134325.GA18955@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140706134325.GA18955@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 06, 2014 at 03:43:25PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Now I'm running fsck.new -cf. I don't think this filesystem has any
> > bad blocks. Still, it says "rootfs: Updating bad block inode."
> > ... "FILE SYSTEM WAS MODIFIED", "REBOOT LINUX".
> 
> And here's patch to fix this uglyness. Unfortunately, it makes it read
> the inode... but perhaps it is good idea as we are able to print
> before/after bad block counts...?
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Thanks, I'll take a look at these patches.  Honestly, I've been half
tempted to remove the e2fsck -c option entirely.  99.9% of the time,
with modern disks, which has bad block remapping, it doesn't do any
good, and often, it's harmful.

In general, e2fsck -c is not something I recommend people use.  If you
want to use badblocks by itself to see if there are any blocks that
are suffering read problems, that's fine, but if there is, in general
the safest thing to do is to mount the disk read-only, back it up, and
then either (a) reformat and see if you can restore onto it with
backups w/o any further errors, or (b) just trash the disk, and get a
new one, since in general the contents are way more valuable than the
disk itself.  Certainly after trying (a), you get any further errors,
(b) is defintely the way to go.

					- Ted
