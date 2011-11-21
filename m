From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Better organizing ext4 development community
Date: Mon, 21 Nov 2011 10:58:36 -0500
Message-ID: <E1RSWGS-0000op-NX@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40435 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1KUP6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 10:58:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


There seems to be an increasing number of people interested in ext4 who
have been contributing to ext4, and so I thought this might be a good
time to pen a note about how we might be able to organize things a
little better.

The weekly conference calls
===========================

We have a weekly conference call at Monday 8am US/Pacific and 11am
US/Eastern.  The people who participate on this call are primarily from
the following companies (alphabetically): Google, HP, IBM, Red Hat, and
Whamcloud.  The attendees are primarily mostly from the US, due to
history of who has known about the calls, but also due to the time of
the conference calls.

Given there are more people who are participating on this call from
Asia, especially from Tao Bao and other companies, I think it's
important that we revisit whether that time is best, and to try to
invite some folks from the other countries to participate.   I know that
language may be a barrier in some cases, but I think it's important that
we try to get a wider representation that has a chance to hear what's
going.

I'd like to hear what folks from Asia think about this; if we started
having some conference calls that alternated between being convenient
for folks based out of Asia time zones and folks based out of US time
zones, would that be helpful?

Getting together for a face to face meeting
===========================================

Again, because of the fact that we quite a few newcomers to the ext4
development community, it seems that it might be a good idea if we could
get together so we could know each other better.  I'd like to propose
that we try doing so either immediately before or immediately after the
Linux Storage, File System, and MM workshop in San Fracisco, which will
be taking place during the first week of April next year.  I'm hoping
that we can get good representation from all of the companies who have
an interest in ext4 development, and if we start early, we can hopefully
get people thinking about some kind of discussion topic to propose for
the LSF workshop (proposing a discussion topic that would be of general
interest is how you get an invite to the LSF), and so people have ample
time to work out the logistics --- getting travel approval, getting
Visa's, etc.

If you would be interested in attending an ext4 get together next year
in April, please let me know, so I can start guaging interesting and
numbers.

Review Bottleneck
=================

Currently, patches, especially large patch series which introduce some
new feature, have become bottlenecked on my time to review them.   It
would be very helpful if we had more people reviewing patches.  And it
needs to be substantive reviews, and preferably from people who work at
companies other than the developer who has submitted the patches.

So some way that we can get more people reviewing patches would
certainly be helpful.  There have been some people who have suggested
different ways that we might do things, from the method used in XFS
(where no patch gets submitted until it gets an independent review;
which would be a bit scary since at the moment so little review takes
place I'm concerned it would hold back development significantly), to
giving people patchwork accounts and formally delegating work to people
(it has worked for some subsystems, and utterly failed for others).

Or we could keep going with the current method, with people
understanding that if you review other people's patches, it makes it
more likely I will have time to integrate your patches (and if some
folks do more review work, I'll take that into account about which
patches series I'm more likely to review myself for integration).


What do you think?  This, like all of the other parts of this note, was
meant to start a discussion.  I've been extraordinarily pleased with
Ext4 development: with what we've been able to achieve, and the people
we've managed to attract to use and to work on this project.   With your
help, we can make things even better!

Cheers,

						- Ted
