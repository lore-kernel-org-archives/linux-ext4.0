From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck performance.
Date: Sun, 20 Feb 2011 18:41:31 -0500
Message-ID: <20110220234131.GC4001@thunk.org>
References: <20110220090656.GA11402@bitwizard.nl>
 <20110220170931.GB3017@thunk.org>
 <20110220193406.GC3017@thunk.org>
 <20110220215531.GA21917@bitwizard.nl>
 <20110220222013.GA2849@thunk.org>
 <20110220231514.GC21917@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53598 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab1BTXlo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 18:41:44 -0500
Content-Disposition: inline
In-Reply-To: <20110220231514.GC21917@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 12:15:14AM +0100, Rogier Wolff wrote:
> > BTW, my backup plan was to replace tdb with something else.  One of
> > the candidates I was looking at was sqlite, but rumors of its speed
> > deficiencies are making me worry that it won't be a good fit.  I don't
> > want to use berk_db because it has a habit of changing API's
> > regularly, and you can never be sure which version of berk_db
> > different distributions might be using.  One package which I thought
> > held promise was Koyoto Cabinet, but unfortunately, it's released
> > under GPLv3, which makes it incompatible with the license used by
> > e2fsprogs (which has to be GPLv2, since there are a few files which
> > are shared with the Linux kernel).
> 
> Hmm. I'll take a look.

If you could put a bit of time into this, that would be really great.
I have a lot of things that I need to do at the moment, and trying to
improve [scratch_files] performance is something I've known about for
a while, but I just haven't had time to get to it.

The fact that the problem can be solved by using 64-bit capable CPU's
and a large swap space has kept this from rising to the top of the
priority heap, but it is an important use case, since we do have NAS
boxes that use cheap-sh*t 32-bit processors, and I'd like to be able
to support them.  But I just don't have the time ATM, so if I can
delegate this out to someone else, that would be really helpful.

	      	     	     	   	- Ted
