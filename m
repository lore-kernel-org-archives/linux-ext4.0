From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Making it easier for end users to use ext4
Date: Mon, 14 Jul 2008 16:27:31 -0500
Message-ID: <487BC4C3.9020400@redhat.com>
References: <E1KITeX-0001PV-Pv@closure.thunk.org> <487BAA6B.7030001@redhat.com> <20080714195526.GA3382@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbYGNV1f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2008 17:27:35 -0400
In-Reply-To: <20080714195526.GA3382@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Jul 14, 2008 at 02:35:07PM -0500, Eric Sandeen wrote:
>>> Eric, when you have a chance, could you take a quick peek at the Fedora
>>> Core section of that page and update it appropriately.  
>> Sure, first I'll remove "core" since that terminology doesn't exist
>> anymore ;)
> 
> Is "FC" acronym as in "FC9" going away as well?  :-)

the "fc9" you see in rpms now stands for "Fedora Collection" - becase,
well, rpm got confused otherwise ;)

I probably forget this from time to time as well ;)

> 
>> I think very soon just saying "run the latest kernel + e2fsprogs from F9
>> updates-testing" will be a good start.  It won't have delalloc yet,
>> though.  Do we want to try to make that more widely available to people
>> who can't/don't build their own kernels?  I'm slightly hesitant I guess
>> both for the extra work of maintaining the repo & complete kernel
>> builds, as well as providing too much rope to people who may not know
>> just how much rope they've got ...
> 
> Well, there are two reasons why I was thinking it might be nice to
> synch up the ext4 code base.  One was the "more testers good"
> argument.  The other was is that while *most* of the various races and
> bug fixes that have gone in since 2.6.26 were delalloc related, some
> are real bugs that might bite 2.6.25 users if they start using the
> ext4 code in a more demanding workload.  That would result in perhaps
> preventable data loss, plus which we could end up spending time
> debugging a problem which had already been solved.

Sounds reasonable.  Should said fixes also go into the 2.6.2[56].x
stable trees for the same reasons, do you think?  And, well, if they
did, Fedora would also get them rather quickly.  :)

> If Fedora is going to be putting out another test kernel shortly, any
> chance we can get the 2.6.26-ext4-1 or 2.6.26-ext4-2 (with mingming's
> latest patch, to be released shortly) included in that test kernel?
> Again, the goal is to make it as easy as possible for people to test
> the latest version of ext4, so we can get those bugs fixed.

I've gone back and forth about how bleeding-edge to make the Fedora ext4
code, especially for F9.  Putting it all into rawhide would be fine,
that's what it's for.  But for F9 I'd like to stay on that fine line
between "fix the bugs & add the features quickly" and "don't push
unstable or barely-stable code into the release too soon and cause new
problems."

I don't mind pushing the stable patches into F9 on the early side, and
for rawhide we can push as much as is desired.

Thanks,
-Eric

> Regards,
> 
> 						- Ted

