From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Better organizing ext4 development community
Date: Mon, 21 Nov 2011 14:51:44 -0700
Message-ID: <DA5E3B75-913C-4F50-B3DF-DF28FFF36C89@dilger.ca>
References: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22656 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1KUVvp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 16:51:45 -0500
In-Reply-To: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-21, at 8:58 AM, Theodore Ts'o wrote:
> The weekly conference calls
> ===========================
> 
> We have a weekly conference call at Monday 8am US/Pacific and 11am
> US/Eastern.  The people who participate on this call are primarily from
> the following companies (alphabetically): Google, HP, IBM, Red Hat, and
> Whamcloud.  The attendees are primarily mostly from the US, due to
> history of who has known about the calls, but also due to the time of
> the conference calls.
> 
> I'd like to hear what folks from Asia think about this; if we started
> having some conference calls that alternated between being convenient
> for folks based out of Asia time zones and folks based out of US time
> zones, would that be helpful?

At Whamcloud we have regularly scheduled concalls that cross a lot of
timezones, and realistically the only time that allows people to join
is early PT in the USA, end of day in Europe, and ~midnight in Asia.

I don't personally have an objection to attending concalls at midnight
in my timezone, but that makes it 2AM ET which was usually a deal breaker
for our scheduling.  Going any earlier means before 7AM in Europe.

> Getting together for a face to face meeting
> ===========================================
> 
> Again, because of the fact that we quite a few newcomers to the ext4
> development community, it seems that it might be a good idea if we could
> get together so we could know each other better.  I'd like to propose
> that we try doing so either immediately before or immediately after the
> Linux Storage, File System, and MM workshop in San Fracisco, which will
> be taking place during the first week of April next year.  I'm hoping
> that we can get good representation from all of the companies who have
> an interest in ext4 development, and if we start early, we can hopefully
> get people thinking about some kind of discussion topic to propose for
> the LSF workshop (proposing a discussion topic that would be of general
> interest is how you get an invite to the LSF), and so people have ample
> time to work out the logistics --- getting travel approval, getting
> Visa's, etc.
> 
> If you would be interested in attending an ext4 get together next year
> in April, please let me know, so I can start guaging interesting and
> numbers.

I'd be OK to attend such a meeting, but I agree with Amir that relatively
few ext4 developers are invited to KS so it doesn't necessarily reduce the
travel.  In years past we would attend OLS, but that is (AFAIK) largely
unattended by ext4 developers these days.

> Review Bottleneck
> =================
> So some way that we can get more people reviewing patches would
> certainly be helpful.  There have been some people who have suggested
> different ways that we might do things, from the method used in XFS
> (where no patch gets submitted until it gets an independent review;
> which would be a bit scary since at the moment so little review takes
> place I'm concerned it would hold back development significantly), to
> giving people patchwork accounts and formally delegating work to people
> (it has worked for some subsystems, and utterly failed for others).
> 
> Or we could keep going with the current method, with people
> understanding that if you review other people's patches, it makes it
> more likely I will have time to integrate your patches (and if some
> folks do more review work, I'll take that into account about which
> patches series I'm more likely to review myself for integration).

I've been doing reviews on a subset of the patches that pass the list
(e.g. metadata checksums, bigalloc extent size, inline data, online
resize).  I'll admit I've also been lax in terms of making positive
comments when I've completed a review without finding any problems, and
sometimes my inspections are not as detailed as they need to be.  Since
code inspection makes up a significant fraction of my day job, it is hard
to get excited about it later on.

I wouldn't object to using Gerrit to do inspections for the ext4 patches.
We use that internally, and it allows tracking of patches, easily comparing
new patches against the old ones to speed up re-inspection, and hooks into
Jenkins and other automated testing tools to allow automated building.

> What do you think?  This, like all of the other parts of this note, was
> meant to start a discussion.  I've been extraordinarily pleased with
> Ext4 development: with what we've been able to achieve, and the people
> we've managed to attract to use and to work on this project.   With your
> help, we can make things even better!


Cheers, Andreas





