From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: media error but where?
Date: Sun, 6 Jul 2014 21:00:02 -0400
Message-ID: <20140707010002.GD471@thunk.org>
References: <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
 <20140706133247.GB18204@amd.pavel.ucw.cz>
 <20140706134325.GA18955@amd.pavel.ucw.cz>
 <20140706182936.GB471@thunk.org>
 <20140706213710.GA19847@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47977 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbaGGBAF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jul 2014 21:00:05 -0400
Content-Disposition: inline
In-Reply-To: <20140706213710.GA19847@amd.pavel.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 06, 2014 at 11:37:11PM +0200, Pavel Machek wrote:
> 
> Well, when I got report about hw problems, badblocks -c was my first
> instinct. On the usb hdd, the most errors were due to 3.16-rc1 kernel
> bug, not real problems.

The problem is with modern disk drives, this is a *wrong* instinct.
That's my point.  In general, trying to mess with the bad blocks list
in the ext2/3/4 file system is just not the right thing to do with
modern disk drives.  That's because with modern disk drives, the hard
drives will do bad block remapping.

Basically, with modern disks, if the HDD has a hard ECC error, it will
return an error --- but if you write to the sector, it will either
rewrite onto that location on the platter, or if that part of the
platter is truly gone, it will remap to the bad block spare pool.  So
telling the disk to never use that block again isn't going to be the
right answer.

The badblocks approach to dealing with hardware problems made sense
back when we had IDE disks.  But that's been over a decade ago.  These
days, it's horribly obsolete.

						- Ted
