From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Mon, 7 Jul 2014 20:55:43 +0200
Message-ID: <20140707185543.GA26056@amd.pavel.ucw.cz>
References: <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
 <20140706133247.GB18204@amd.pavel.ucw.cz>
 <20140706134325.GA18955@amd.pavel.ucw.cz>
 <20140706182936.GB471@thunk.org>
 <20140706213710.GA19847@amd.pavel.ucw.cz>
 <20140707010002.GD471@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58987 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaGGSzp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2014 14:55:45 -0400
Content-Disposition: inline
In-Reply-To: <20140707010002.GD471@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 2014-07-06 21:00:02, Theodore Ts'o wrote:
> On Sun, Jul 06, 2014 at 11:37:11PM +0200, Pavel Machek wrote:
> > 
> > Well, when I got report about hw problems, badblocks -c was my first
> > instinct. On the usb hdd, the most errors were due to 3.16-rc1 kernel
> > bug, not real problems.
> 
> The problem is with modern disk drives, this is a *wrong* instinct.
> That's my point.  In general, trying to mess with the bad blocks list
> in the ext2/3/4 file system is just not the right thing to do with
> modern disk drives.  That's because with modern disk drives, the hard
> drives will do bad block remapping.

Actually... I believe it was the right instinct. 

If I wanted to recover the data... remount-r would be the way to
go. Then back it up using dd_rescue. ... But that way I'd turn bad
sectors into silent data corruption.

If I wanted to recover data from that partition, fsck -c (or
badblocks, but that's trickier) and then dd_rescue would be the way to go.

> Basically, with modern disks, if the HDD has a hard ECC error, it will
> return an error --- but if you write to the sector, it will either
> rewrite onto that location on the platter, or if that part of the
> platter is truly gone, it will remap to the bad block spare pool.  So
> telling the disk to never use that block again isn't going to be the
> right answer.

Actually -- tool to do relocations would be nice. It is not exactly
easy to do it right by hand.

I know the theory. I had 5 read-error incidents this year.

#1: Seagate refuses to reallocate sectors. Not sure why, I tried
 pretty much everything.

#2: 3.16-rc1 produces incorrect errors every 4GB, leading to "bad
sectors" that disappear with other kernels

#3: Some more bad sectors appear on the Seagate

#4: Kernel on thinkpad reports errors in daily check. Which is strange
 because there's nothing in SMART.

#5: Some old IDE hdd has bad sectors in unused or unimportant areas. 

In #5 the theory might match the reality (I did not check, I trashed
the disks).

> The badblocks approach to dealing with hardware problems made sense
> back when we had IDE disks.  But that's been over a decade ago.  These
> days, it's horribly obsolete.

Forcing reallocation is hard & tricky. You may want to simply mark it
bad and lose a tiny bit of disk space... And even if you want to force
reallocation, you want to do fsck -c, first, and restore affected
files from backup.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
