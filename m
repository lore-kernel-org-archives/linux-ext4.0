From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/jbd2: don't wait (forever) for stale tid caused by
 wraparound
Date: Mon, 18 Mar 2013 10:31:56 -0400
Message-ID: <20130318143156.GA14430@thunk.org>
References: <B2EC601CDDA242189A46599B31EA6AD3@atlassian.com>
 <1363412062.3937.196.camel@deadeye.wl.decadent.org.uk>
 <20130318025401.GA12611@thunk.org>
 <91B5F5AF93734BAA86939ED896DDEF63@atlassian.com>
 <1363582395.3937.319.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Barnett <gbarnett@atlassian.com>,
	linux-ext4@vger.kernel.org,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54103 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3CROcG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 10:32:06 -0400
Content-Disposition: inline
In-Reply-To: <1363582395.3937.319.camel@deadeye.wl.decadent.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 18, 2013 at 04:53:15AM +0000, Ben Hutchings wrote:
> 
> We need you to verify that this fix works first.  If it does, it should
> get included in the various 3.x.y stable branches and in Debian kernel
> packages.

I suspect it will be hard for George to verify this, since it requires
a tid wrap, which by definition takes a long time.

Also, this will probably not hit the stable kernels until after the
next merge window, since it's already post -rc3 and I really want to
make sure this gets a lot of testing and review.

I'll also note that I managed to trigger a BUG when incrementing by a
factor of (1 << 24), but we don't see a BUG_ON when incrementing by
((1 << 24) + 1).  (Neither of these testing changes were in the patch
that I sent out; so the patch is "safe" in that I very much doubt it
will make things worse --- those changes were to stress test the patch
so that I wouldn't have to wait several months until the tid wrapped
to test whether we had finally fixed all of the potential problems.)
So there is something we probably do want to look at a bit more
closely before we formally push this fix into mainline.

As far as the Debian servers are concerned, I'm pretty sure the patch
should be safe in that it won't make things worse than they were
before --- however, if you are looking for the lowest risk approach,
it's probably better to simply schedule downtime every few months and
force a reboot at a time that is minimizes developer inconvenience.
You can use "dumpe2fs -h /dev/XXX" to get the current sequence number
of the journal, if you measure the sequence number separated by 24 or
48 hours, you should be able to calculate when the the sequence number
will have incremented by 2**31, and thus calculate the frequency of
scheduled reboots for your workload.

Regards,

						- Ted
