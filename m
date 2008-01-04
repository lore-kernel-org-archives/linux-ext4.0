From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
Date: Fri, 4 Jan 2008 21:03:53 +0100
Message-ID: <4d8e3fd30801041203s2f017f20ld9fcbc82912468fe@mail.gmail.com>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	 <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de>
	 <20080104190137.GJ17436@mit.edu>
	 <20080104194129.GA16962@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>,
	"Mathieu Segaud" <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Andi Kleen" <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:27492 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYADUD4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 15:03:56 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1444609nze.1
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jan 2008 12:03:53 -0800 (PST)
In-Reply-To: <20080104194129.GA16962@one.firstfloor.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 4, 2008 8:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
[...]
> > I don't know, because people want to be able to say that they've
> > contributed fixes to the Linux kernel?
>
> My pet theory is that it is similar to the "unsubscribe me"
> cascade effect you sometimes see on mailing lists. One person
> sends a "unsubscribe me" to everybody and then suddenly a lot of
> people think that is the right way to unsubscribe and reply
> with lots of "unsubscribe me too".
>
> So one person sends a cleanup and it gets accepted and suddenly
> other people realize it is very easy to do these cleanups
> (not realizing the hidden costs they have) and then they go on...

Since I'm one of those people that sent "Codying style fixes" patches
I give my contribution to this discussion as well.

I think that _one_ of the reasons that made a few people sent this kind of
patches to the list is because checkpatch.pl is far better then any other
 kerneljanitor scripts/easy task and _seems_ to be an easy way to start
understanding the code, creation of patches and process in general.

> I thought we had the janitor project to steer these people into
> more useful directions, but apparently that is not well known
> enough anymore. Perhaps it just needs to be more regularly announced?
>
> Although I must admit I am not 100% happy with kernel-janitors
> either -- e.g. a few times I sent suggestions about easy things
> someone could do to that list, but never heard anything back.
>
> Anyways there are lots of ways to do trivial cleanups in a useful
> way and if people want to do this perhaps they should just
> ask on linux-kernel and people suggest something?

Yes please do that.
Even if fixing errors reported by checkpatch.pl still sounds like a
useful way to spent a couple of hours.
Maybe our mistake was to send the patches to lkml instead of to
trivial@kernel.org
or to kerneljanitors?

I mean, I now understand the rationales behind your complaints but I
don't think it's
 good idea to discourage people willing to perform easy task.
They just need guidance in order to be useful.

> My hope here is of course that these trivial changes are primarily
> used as a way to get "the feet wet" to understand the procedures
> for contribuing larger not quite as trivial changes

Agreed.

ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
