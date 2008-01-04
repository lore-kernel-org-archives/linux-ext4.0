From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
Date: Fri, 4 Jan 2008 23:33:28 +0100
Message-ID: <20080104223328.GB19248@one.firstfloor.org>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de> <20080104190137.GJ17436@mit.edu> <20080104194129.GA16962@one.firstfloor.org> <4d8e3fd30801041203s2f017f20ld9fcbc82912468fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:50087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbYADWbV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 17:31:21 -0500
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801041203s2f017f20ld9fcbc82912468fe@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2008 at 09:03:53PM +0100, Paolo Ciarrocchi wrote:
> On Jan 4, 2008 8:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
> [...]
> > > I don't know, because people want to be able to say that they've
> > > contributed fixes to the Linux kernel?
> >
> > My pet theory is that it is similar to the "unsubscribe me"
> > cascade effect you sometimes see on mailing lists. One person
> > sends a "unsubscribe me" to everybody and then suddenly a lot of
> > people think that is the right way to unsubscribe and reply
> > with lots of "unsubscribe me too".
> >
> > So one person sends a cleanup and it gets accepted and suddenly
> > other people realize it is very easy to do these cleanups
> > (not realizing the hidden costs they have) and then they go on...
> 
> Since I'm one of those people that sent "Codying style fixes" patches
> I give my contribution to this discussion as well.
> 
> I think that _one_ of the reasons that made a few people sent this kind of
> patches to the list is because checkpatch.pl is far better then any other
>  kerneljanitor scripts/easy task and _seems_ to be an easy way to start
> understanding the code, creation of patches and process in general.

The problem is that it has large hidden costs as pointed out. So while
it might be easy for you it's not a cheap operation for the whole development
process.

> 
> > I thought we had the janitor project to steer these people into
> > more useful directions, but apparently that is not well known
> > enough anymore. Perhaps it just needs to be more regularly announced?
> >
> > Although I must admit I am not 100% happy with kernel-janitors
> > either -- e.g. a few times I sent suggestions about easy things
> > someone could do to that list, but never heard anything back.
> >
> > Anyways there are lots of ways to do trivial cleanups in a useful
> > way and if people want to do this perhaps they should just
> > ask on linux-kernel and people suggest something?
> 
> Yes please do that.
> Even if fixing errors reported by checkpatch.pl still sounds like a
> useful way to spent a couple of hours.
> Maybe our mistake was to send the patches to lkml instead of to
> trivial@kernel.org
> or to kerneljanitors?

No, they would have ended in tree too eventually and caused the same problem.

How about if you're looking for simple work for a few hours you just
send an email to l-k and ask if someone has an idea for something? 
I'm sure you'll get suggestions. Probably more than you can take.

e.g. from the top of my hat what would be useful:

- Go through Documentation/* files and check if the options etc. described
in there are still in the code

That will actually require you to find code in the source tree and understand
it at least a little bit which are both very useful skills in general.

- Or check for kerneldoc comments that do not appear in the kerneldoc output
(because the files are missing in the DocBook templates) 

- Or build the kernel and check for any "deprecated" warnings and fix them
[perhaps not 100% trivial, but should be doable by studying other code 
a bit -- i expect that people who attempt to write such patches have at least
some knowledge of programming and C so that should be possible]

> I mean, I now understand the rationales behind your complaints but I
> don't think it's
>  good idea to discourage people willing to perform easy task.
> They just need guidance in order to be useful.

Yes, the best way to get guidance is to ask.

-Andi
