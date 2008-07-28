From: Theodore Tso <tytso@mit.edu>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Mon, 28 Jul 2008 13:01:10 -0400
Message-ID: <20080728170110.GF9378@mit.edu>
References: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com> <20080727202302.GA7922@mit.edu> <c354edc90807280811l57c39321lc7e6abeab2a82eb1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peter Meier <meiepeter@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34799 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754893AbYG1R3k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 13:29:40 -0400
Content-Disposition: inline
In-Reply-To: <c354edc90807280811l57c39321lc7e6abeab2a82eb1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2008 at 03:11:07PM +0000, Peter Meier wrote:
> Well, my installation went fine using "nodelalloc" with ext4-3,
> but then of course I killed the file system when I forgot to add
> rootflags=nodelalloc to the kernel's boot command line in the
> grub config, so it got mounted with delalloc and proceeded
> to eat itself.
> 
> I'm stubborn, so I'm going to try again. I'm unsure whether to
> try with 2.6.26-ext4-4 and delalloc turned on, however, since
> ming's patch was supposed to fix crashes, and I'm not really
> looking forward to crashes during installation. So my safest
> bet still seems to be to go with nodelalloc.

I'm using 2.6.26-ext4-4 with dealloc, and it works fine for me, even
with make -j4 kernel compiles.  Mingming's patches will fix crashes
that show up under pretty extreme benchmark loads; I've yet to have it
happen during day-to-day usage on my laptop.

> However, I still don't know whether I can turn delalloc back on
> later on the existing FS without missing out on anything from
> not having it turned on from the beginning, as per the ques-
> tion in my last mail. If anyone could answer that, that'd be
> much appreciated.

Well, delayed allocation can allow the filesystem to allocate blocks
in a more optimal pattern.  So yes, you can in theory miss out on some
improvements by not having it enabled from the very beginning.  Given
that most installers are not multithreaded, but install packages one
at a time, I doubt the difference will be significant.  However,
post-installation, if you run without delayed allocation and you have
multiple threads or processes writing into the same directory at the
same time, delayed allocation could make a much bigger difference.
For things like build directories, that's probably much less
important, though, since you can always just do a "make clean" and
then rebuild the object files.

So the bottom line is yes, it will make a difference, but it's
probably very minor.  I will say though that I am currently typing
this message using 2.6.26-ext4-4, and it's working just fine for me,
without any problems.  I've never seen any of the crashes which some
of our testers who have been using the system much more agressively
under benchmarking have reported.

Hopefully though we will have a fix for the journal credits patch
fairly soon, though.  Probably just another few days...

Regards,

						- Ted
