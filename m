From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 21:29:30 -0500
Message-ID: <4830E60A.2010809@redhat.com>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <8763tbcrbo.fsf@basil.nowhere.org> <20080519004325.GC8335@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbYESCaK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 May 2008 22:30:10 -0400
In-Reply-To: <20080519004325.GC8335@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
...

> Given how rarely people have reported problems, I think it's a really
> good idea to understand what exactly our exposure is for
> $COMMON_HARDWARE. 

I'll propose that very close to 0% of users will ever report "having
barriers off seems to have corrupted my disk on power loss!" even if
that's exactly what happened.  And it'd be very tricky to identify in a
post-mortem.  Instead we'd probably see other weird things caught down
the road during some later fsck or during filesystem use, and then
suggest that they go check their cables, run memtest86 or something...

Perhaps it's not the intent of this reply, Ted, but various other bits
of this thread have struck me as trying to rationalize away the problem.
 If the discussion were about proper locking to avoid corruption, would
we really be  saying well, gosh, it's a *really* small window, and
*most* people won't hit it very often, and proper locking would slow
things down....

So I think that as you suggest, looking for ways to make barriers less
painful is the far better route, rather than sacrificing correctness for
speed by turning them off by default when we know there is a chance for
problems.  People running journaling filesystems most likely expect to
be safe from this sort of thing, not most of the time, but all of the time.

-Eric
