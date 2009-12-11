From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] replaced BUG() with return
	-EIO	from	ext4_ext_get_blocks
Date: Fri, 11 Dec 2009 13:11:29 -0800
Message-ID: <1260565889.21896.22.camel@bobble.smo.corp.google.com>
References: <1260540418-11844-1-git-send-email-surbhi.palande@canonical.com>
	 <1260554859.21896.8.camel@bobble.smo.corp.google.com>
	 <4B22A572.5010201@redhat.com>
	 <1260562923.21896.11.camel@bobble.smo.corp.google.com>
	 <4B22AC36.5020106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Surbhi Palande <surbhi.palande@canonical.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 216-239-44-51.google.com ([216.239.44.51]:13666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbZLKVZu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 16:25:50 -0500
In-Reply-To: <4B22AC36.5020106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-12-11 at 14:31 -0600, Eric Sandeen wrote:
> Frank Mayhar wrote:
> > On Fri, 2009-12-11 at 14:02 -0600, Eric Sandeen wrote:
> >> My first thought was that this was a bandaid too, but I guess it can
> >> come about due to on-disk corruption for any reason, so it should
> >> be handled gracefully, and I suppose this approach seems fine.
> > 
> > That's why we've been running with it, yes.
> 
> now if this is coming about as the result of a programming error, we'd
> better sort that out ;)  Do you have any reason to believe that the
> corruption a hardware or admin issue, vs. an actual bug somewhere?

In fact the original corruption was due to an ext4 bug.  After we fixed
the bug, though, we had a problem with machines going into crash loops.
Analysis revealed that the machines in question had corruptions caused
by the (now fixed) bug but the nature of the corruptions were causing us
to hit this case.  Every time the system came back up it would start
processing again only to run into the same corruption.  And, of course,
the corruption wasn't being found and fixed by fsck.  All we could do
here was change this path to return EIO in this case; rebuilding the
file systems was out of the question at the time since they didn't
belong to us.

Philosophically, I prefer returning EIO here to doing a BUG_ON
regardless, since it also makes the code more robust in the face of
possible hardware errors.

> The amount of info printed is probably just a judgement call; for a developer,
> printing out the inode & iblock is enough 'cause we can then just go use
> debugfs & look at it.  For a bug report, perhaps more info would be useful
> because that one set of printks may be all we'll get ... up to you.

Yeah, I tend to lean toward "print everything I can think of" in
situations like this because you never know just what you might need...
But that's mostly for the hardcore testing cycle and not for production
use.

> Maybe we should think about a generic "print corrupted inode information"
> infrastructure that could be reused ...

That would probably be useful in the long run, yes.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

