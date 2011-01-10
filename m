From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Mon, 10 Jan 2011 09:49:12 +0100
Message-ID: <20110110084912.GE21505@bitwizard.nl>
References: <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com> <4D1F6244.7050203@redhat.com> <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com> <20110107052613.GE2857@thunk.org> <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com> <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com> <20110108080520.GE12433@bitwizard.nl> <20110108220059.GV21922@thunk.org> <20110109081249.GA32496@bitwizard.nl> <20110109145838.GA3346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:45379 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751393Ab1AJItO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 03:49:14 -0500
Content-Disposition: inline
In-Reply-To: <20110109145838.GA3346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 09, 2011 at 09:58:38AM -0500, Ted Ts'o wrote:
> On Sun, Jan 09, 2011 at 09:12:49AM +0100, Rogier Wolff wrote:
> > > No.  The superblock nor its offset will never change.  It's like the
> > > syscall ABI, only worse.  If we changed it would break *everybody*.
> > > Fortunately there is a huge amount of space left over in the 1024 byte
> > > superblock.
> > 
> > It's called defensive programming. It prevents bugs before they
> > happen. By your reasoning you could've written 2048 or 0x800 there.
> 
> Defensive programming would be something like
> 
> 	  BUG_ON(sizeof(struct ext4_super_block) != 1024);

It is one form of "defense", but not what I call defensive
programming. Defensive programming, is that you make things robust in
the the face of unexpected changes. 

If you do the BUG_ON and do this throughout the code, one day your
grandson will be increasing the superblock size. He'll fix all the
BUG_ON and your other "defensive" measures. But lo and behold. He's
human, and forgot one or two. Especially the run-time detections that
only get called occasionally (like in this case on an error
sitatuation) might take a while before they are noticed.

What use is it to turn a "we've found a serious error in your
filesystem, we strongly recommend you no longer write to it and run
fsck first" into a "system halted"?

What is wrong with just putting the right formula where it belongs?

We need to set the variable "len" to the amount of free space beyond
the superblock in the first block of the filesystem.  So we take the
size of the first block, subtract the size of the superblock and we
subtract the start of the superblock. It's as simple as that.


> We could add that, if people like.  I do have regression tests (i.e.,
> boot a system with ext4) which would die if anything like that
> changed, though.

How about


Makefile: 
	ext4.o: ...the objects.... testsbsize.out

	testsbsize.out:	testsbsize
		./testsbsize

(oh and something about useing "hostcc" for testsbsize). 

with testsbsize.c:
	#include <stdio.h>
	#include <...ext4....> 
	int main (int argc, char **argv)
	{
		if (sizeof (struct ext4_super_block) != 1024) {
			fprintf (stderr, "Superblock size is %d, should be 1024.\n", sizeof (struct ext4_super_block));
			exit (1);
		}
		exit (0);
	}

Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
