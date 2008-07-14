From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Making it easier for end users to use ext4
Date: Mon, 14 Jul 2008 14:35:07 -0500
Message-ID: <487BAA6B.7030001@redhat.com>
References: <E1KITeX-0001PV-Pv@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbYGNTfT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:19 -0400
In-Reply-To: <E1KITeX-0001PV-Pv@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> So I got a comment on my recent blog posting about using ext4 that
> Googling ext4 results in a lot of ancient status reports and not a lot
> of good information about how to get started with ext4.  The comment was
> fair, so I took a few minutes to update this web page:
> 
>       http://ext4.wiki.kernel.org/index.php/Ext4_Howto
> 
> with some getting started information.
> 
> Eric, when you have a chance, could you take a quick peek at the Fedora
> Core section of that page and update it appropriately.  

Sure, first I'll remove "core" since that terminology doesn't exist
anymore ;)

> It would
> probably be a good idea to include the yum repository with the latest
> 1.41 e2fsprogs RPM's, etc.  One other thought is if we start encouraging
> people to use ext4 on FC9, whether it might be a good idea to take all
> of the patches to ext4 since 2.6.25, add them to the patch queue, and
> then back port the resulting stack of patches to 2.6.25 so that FC9
> users who are interested in testing ext4 would get the benefit of the
> latest ext4 code, and also so any bug reports we get would also be
> against the latest code.  

well, left to its own devices, F9 will see 2.6.26 at least as a testing
kernel pretty soon I think.  Waiting for that seems reasonable vs. the
above patch gyrations....

> Alternatively, the repository could just
> simply include 2.6.26 plus the latest ext4 patch set, whichever would be
> easier.

I think very soon just saying "run the latest kernel + e2fsprogs from F9
updates-testing" will be a good start.  It won't have delalloc yet,
though.  Do we want to try to make that more widely available to people
who can't/don't build their own kernels?  I'm slightly hesitant I guess
both for the extra work of maintaining the repo & complete kernel
builds, as well as providing too much rope to people who may not know
just how much rope they've got ...

For pre-built fedora stuff I'd rather those users just follow what gets
packaged from upstream unless someone really, really thinks we should do
otherwise.

-Eric

> If other ext4 developers have a chance, it would be a good idea to go
> through the http://ext4.wiki.kernel.org site, and do some grooming of
> the site.  Some of the pages like the FAQ, which were originally
> targetted primarily at ext4 developers, may need to have some of the
> more developer-centric content moved to other pages now that we will
> start having more users coming to look at that site.  And of course,
> there is some very badly out-of-date information on that site as well!
> 
>       	      	   	 	     		     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

