From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sun, 9 Jan 2011 09:12:49 +0100
Message-ID: <20110109081249.GA32496@bitwizard.nl>
References: <20101228025343.GD10149@thunk.org> <20101228081917.GA1351@bitwizard.nl> <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com> <4D1F6244.7050203@redhat.com> <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com> <20110107052613.GE2857@thunk.org> <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com> <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com> <20110108080520.GE12433@bitwizard.nl> <20110108220059.GV21922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:10472 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750835Ab1AIIMv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Jan 2011 03:12:51 -0500
Content-Disposition: inline
In-Reply-To: <20110108220059.GV21922@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 08, 2011 at 05:00:59PM -0500, Ted Ts'o wrote:
> On Sat, Jan 08, 2011 at 09:05:20AM +0100, Rogier Wolff wrote:
> > Although those two numbers are equal right now, there is no reason to
> > assume that they will remain so in the future. So if the superblock
> > size (or the offset) changes in the future, it's much better to have
> > programmed this so that it will keep on working as opposed to getting
> > to deal with ugly bugs in code that hasn't changed in years...
> 
> No.  The superblock nor its offset will never change.  It's like the
> syscall ABI, only worse.  If we changed it would break *everybody*.
> Fortunately there is a huge amount of space left over in the 1024 byte
> superblock.

It's called defensive programming. It prevents bugs before they
happen. By your reasoning you could've written 2048 or 0x800 there.

My version:

  - documents why something is subtracted from the blockszize and how
    much.
  - keeps on working even if the superblock would oddly change size
    in the future. Even if now you don't expect that to happen ever.


	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
