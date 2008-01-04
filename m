From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
Date: Fri, 4 Jan 2008 20:41:29 +0100
Message-ID: <20080104194129.GA16962@one.firstfloor.org>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de> <20080104190137.GJ17436@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47207 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYADTjZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 14:39:25 -0500
Content-Disposition: inline
In-Reply-To: <20080104190137.GJ17436@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Personally I find it annoying, but I'm willing to live with the
> cleanup patches.  I don't think they add anything, though.  Maybe I

The problem I see is that if someone has a more involved outstanding
patch series against the code that is being cleaned up (and more complicated
features tend to require some time to stabilize so "just merge early"
is not always the solution) then it is a serious mess to readapt 
a patch series to the cleanups.  Yes it can be all done but it wastes
time that would be more constructively used e.g. for better testing.

Now if some area is changed anyways then they're usually ok because
all outstanding patches will need to be adapted anyways.

So I guess a useful rule for cleanup patches would be "only if that
code changed recently" 

> > The recent flurry of cleanup code patches on l-k causes far more
> > problems than it solves. I'm not even sure why people do this? Just
> > because it is en vogue recently? 
> 
> I don't know, because people want to be able to say that they've
> contributed fixes to the Linux kernel?

My pet theory is that it is similar to the "unsubscribe me" 
cascade effect you sometimes see on mailing lists. One person
sends a "unsubscribe me" to everybody and then suddenly a lot of 
people think that is the right way to unsubscribe and reply
with lots of "unsubscribe me too".

So one person sends a cleanup and it gets accepted and suddenly
other people realize it is very easy to do these cleanups
(not realizing the hidden costs they have) and then they go on...

I thought we had the janitor project to steer these people into
more useful directions, but apparently that is not well known
enough anymore. Perhaps it just needs to be more regularly announced?

Although I must admit I am not 100% happy with kernel-janitors 
either -- e.g. a few times I sent suggestions about easy things
someone could do to that list, but never heard anything back.

Anyways there are lots of ways to do trivial cleanups in a useful
way and if people want to do this perhaps they should just
ask on linux-kernel and people suggest something?  

My hope here is of course that these trivial changes are primarily
used as a way to get "the feet wet" to understand the procedures
for contribuing larger not quite as trivial changes

-Andi

P.S.: Mathieu, this is not against you personally; you just happened
to be a convenient example of a larger problem in this case. Sorry.
