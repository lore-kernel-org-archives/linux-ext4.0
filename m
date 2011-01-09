From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sun, 9 Jan 2011 09:58:38 -0500
Message-ID: <20110109145838.GA3346@thunk.org>
References: <20101228081917.GA1351@bitwizard.nl>
 <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
 <4D1F6244.7050203@redhat.com>
 <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
 <20110107052613.GE2857@thunk.org>
 <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com>
 <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com>
 <20110108080520.GE12433@bitwizard.nl>
 <20110108220059.GV21922@thunk.org>
 <20110109081249.GA32496@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56695 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1AIO7H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Jan 2011 09:59:07 -0500
Content-Disposition: inline
In-Reply-To: <20110109081249.GA32496@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 09, 2011 at 09:12:49AM +0100, Rogier Wolff wrote:
> > No.  The superblock nor its offset will never change.  It's like the
> > syscall ABI, only worse.  If we changed it would break *everybody*.
> > Fortunately there is a huge amount of space left over in the 1024 byte
> > superblock.
> 
> It's called defensive programming. It prevents bugs before they
> happen. By your reasoning you could've written 2048 or 0x800 there.

Defensive programming would be something like

	  BUG_ON(sizeof(struct ext4_super_block) != 1024);

(unfortunately #error sizeof(struct ext4_super_block) != 1024 won't
work since #error is handled by the preprocessor, and I don't think we
can trigger a compile-time warning for a structure size issue).

We could add that, if people like.  I do have regression tests (i.e.,
boot a system with ext4) which would die if anything like that
changed, though.

And yes, I have similar regression tests in e2fsprogs that would
trigger if the superblock size were to ever change.

	       		       	       - Ted

P.S.  The only way I can think of to do it at compile time would be to
build a test .o file with -g, and then use a program like pahole that
pulls the information out of the DWARF information.  Might actually be
a good thing to do that, since it could also be useful for automating
searches for unoptimize structures.  Unfortunately, many developers
don't have the DWARF utilities installed, so that would add a
dependency on the kernel build.

