From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sat, 8 Jan 2011 17:00:59 -0500
Message-ID: <20110108220059.GV21922@thunk.org>
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org>
 <20101228081917.GA1351@bitwizard.nl>
 <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
 <4D1F6244.7050203@redhat.com>
 <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
 <20110107052613.GE2857@thunk.org>
 <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com>
 <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com>
 <20110108080520.GE12433@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36121 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1AHWBJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Jan 2011 17:01:09 -0500
Content-Disposition: inline
In-Reply-To: <20110108080520.GE12433@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 08, 2011 at 09:05:20AM +0100, Rogier Wolff wrote:
> Although those two numbers are equal right now, there is no reason to
> assume that they will remain so in the future. So if the superblock
> size (or the offset) changes in the future, it's much better to have
> programmed this so that it will keep on working as opposed to getting
> to deal with ugly bugs in code that hasn't changed in years...

No.  The superblock nor its offset will never change.  It's like the
syscall ABI, only worse.  If we changed it would break *everybody*.
Fortunately there is a huge amount of space left over in the 1024 byte
superblock.

						- Ted
