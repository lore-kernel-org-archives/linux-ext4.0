From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 4 Feb 2011 14:59:21 +0100
Message-ID: <20110204135921.GD4104@quack.suse.cz>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
 <4D4B06AF.6000106@redhat.com>
 <AANLkTi=wAX8yLSsbn-zM5t6DrE22asYnz6KdQBfSYuUT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Michael Rubin <mrubin@google.com>, Jan Kara <jack@suse.cz>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1BDOAS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Feb 2011 09:00:18 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=wAX8yLSsbn-zM5t6DrE22asYnz6KdQBfSYuUT@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-02-11 23:57:25, Amir Goldstein wrote:
> On Thu, Feb 3, 2011 at 9:49 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> Can you give a rough estimate of how those commits diverge between
> bugfixes, kernel API changes, code cleanups?
> 
> Next3 has been following ext3 since 2.6.31 and I remember changes of
> the 2 latter, but not many major bugfixes.
  So I took the work and went through the commit log of ext3 since 2.6.19
(when ext4 was merged). We have
305 commits in total, from those are:
62 cleanups
113 bugfixes
105 changes because of API changing or other kernel-wide efforts
25 features, speedups, and similar

The cathegorization of commits is somewhat arbitrary in some cases but I
think the numbers should be roughly fair...

> I hardly think we can get away with throwing out ext3 code base, but
> maybe it can go into bugfixes-only mode? that is unless Jan likes to
> apply cleanups ;-)
  As you can see, it pretty much is. 25 feature commits in 5 years (and
those features are often like - report mount options in /proc/mounts,
unify error messages, avoid loading bitmap when block group is full, etc.)
is IMHO bugfixes-only mode if you don't want the filesystem to start
bitrotting. I've merged one bigger feature in last year and that was FITRIM
support on the grounds that it did not touch any code outside of FITRIM ioctl
handling itself. So when Lukas wanted to do the work with implementing it,
I was OK with it.

Sure I could be harder on people pushing cleanups on me but I don't want to
scare newbies away so I try to be nice and if the result actually is
better, I take it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
