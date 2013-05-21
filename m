From: Dave Jones <davej@redhat.com>
Subject: Re: Trinity: BUG at fs/ext4/inode.c:1590!
Date: Tue, 21 May 2013 13:07:07 -0400
Message-ID: <20130521170707.GD9163@redhat.com>
References: <5199514D.5090606@gmx.de>
 <519A40DE.2060409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3EURHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 May 2013 13:07:14 -0400
Content-Disposition: inline
In-Reply-To: <519A40DE.2060409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 20, 2013 at 10:27:26AM -0500, Eric Sandeen wrote:

 > Dave, I had suggested earlier in the thread that an option to specify a seed and a nr. of syscalls
 > to skip would help narrow down what triggers a bug.
 >  i.e. in this case, we could find the last seed (for this child?) and then run with:

The seed is 'global', ie, child 1 uses seed+1, child 2 uses seed+2 etc etc.
We only log the seed value without the child number, so as long as you run with the same number
of child processes, the children will all get the correct seed values.
 
 > * that seed
 > * max syscalls 421
 > * skip the first 400 syscalls
 > 
 > and see if it reproduces.  Keep narrowing the window until we get the smallest set that reproduces.  fsx has something similar to this.

Setting the seed with -N should have the same net result as skipping the syscalls up until that point.

There are however two gotchas with the code to use prior seeds.

1. imagine this scenario.

   a. initial seed
   b. N syscalls done
   c. reseed
   d. N syscalls done.

  If we get an oops after D, you might think "great, I can ignore everything before (c)" but that may not necessarily
  be the case, if something at (b) created/corrupted some kernel state that (d) ends up falling over.

2. We gather a list of filenames at startup from /proc, /sys and /dev, and these change at each run.
   This has undesirable results when you're trying to recreate something based on 'fd 243' etc, when that
   ends up mapping to a different file.
   However, in Toralf's case, if he's using -V, we'll only gather fd's from there, and as long as the files/dirs
   at that path are static across runs, all should be good.

 > (heh, now I want an option to emit C code to recreate the last N syscalls it's made, for permanent testcases.  I suppose that'd be tough) ;)

Not tough, just yet another idea to add to the already mile-long TODO :-)
 
 > Here's a really hacky, untested patch that might implement the skipping I'm talking about.  Caveat; I've never actually used trinity.  :)

I think if we wanted to skip a few million syscalls this would involve
quite a wait, and you're not really going to be saving much time over
just doing the syscalls ;)

 > So if I'm missing something obvious about how to narrow down a failure to the call that caused it, I'm all ears.  :)

I really hope that -N is enough here.  The only real gotcha is the 2nd case
above, which we could solve by using a filename cache in the same way
there's a network socket cache.

	Dave

