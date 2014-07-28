From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Work on ext4
Date: Mon, 28 Jul 2014 08:45:23 -0400
Message-ID: <20140728124523.GM6725@thunk.org>
References: <CAPDOMVi_qXwY3R2fYiSwu9Bs2fA4kwamt3TKzVEZOZmuaLkbMA@mail.gmail.com>
 <20140725145946.GT1865@thunk.org>
 <CAPDOMVgmkoXQxGODzVaYWYykPWVmpG=jyKNbGv5=3BZ=XQnGrg@mail.gmail.com>
 <20140725154142.GU1865@thunk.org>
 <53D280C7.1080904@redhat.com>
 <CAPDOMVhJTQtrcpouejTU17MRpPGD6Sie+hRNsC97aR_Be7jL1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Nick Krause <xerofoify@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60487 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaG1Mp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 08:45:26 -0400
Content-Disposition: inline
In-Reply-To: <CAPDOMVhJTQtrcpouejTU17MRpPGD6Sie+hRNsC97aR_Be7jL1g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 12:01:54AM -0400, Nick Krause wrote:
> I have got some work in brtfs for now , Ted so I won't
> be able to run the tests for you for the next few weeks
> probably. Sorry about the issues, but brtfs seems
> more work then ext4 as of this point in time.

Yes, that's probably true.

One bit of advice.  I'd encourage you to think about this not about
your lending help to a project.  At your level of experience, you will
be consuming far more project development resources than you will be
contributing, no matter whether it is btrfs or ext4.  I'd suggest that
you focus on learning, and in order to do that, you will need to focus
on one area --- and by that I mean not just one subsystem, but one
feature or one specific subarea --- for a sustained amount of effort.
I have to agree with Hugo Mills' observation that you are "bouncing
all over the place like a hyperactive puppy".  His advice is on the
mark; listen to it.

There are no short cuts.  Malcolm Gladwell's book "Outliers" quotes
some studies which show that on average, master musicians have
accumulated an average 10,000 hours of practice before they achieved
mastery.  Some other sources have "debunked" Gladwell's claim by
showing in their studies, it has required 10,000 to **30,000** hours
of practice.  So if anything 10,000 hours is not a magic threshold,
and it might be much more than that for some.

No doubt you will be higher functioning contributor --- a journeyman
--- before you achieve complete mastery of the craft of programming,
but at this point, you are barely an apprentice.  And as such, people
who spend time hand holding you are doing so in the hopes that some
point, the investment the OSS community has put into you will pay off,
and you will start adding more value than you are subtracting, and
then, in turn, that you will "pay it forward".  But that point, at
which the breakeven is reached and you can start contributing at a
high level and perhaps, mentoring other enthusiastic newocmers, is
months if not years away.

Good luck on your journey,

						- Ted
