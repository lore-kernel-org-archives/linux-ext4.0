From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 20:01:08 +0200
Message-ID: <20090404180108.GH5178@kernel.dk>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:60955 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZDDSBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 14:01:11 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04 2009, Linus Torvalds wrote:
> 
> 
> On Sat, 4 Apr 2009, Jens Axboe wrote:
> > > 
> > > I'm sorry, but that fsync thing _is_ a real-world case, and it's the one 
> > > that a hell of a lot more people care about than some idiotic sqlite 
> > > throughput issue.
> > 
> > sqlite is just one case, I'm sure there are others. My point is that we
> > should make sure that we don't regress on the throughput side. It's a
> > trade off, we don't want throughput to fall through the floor either.
> 
> Jens, we _have_ regressed on the latency side. Everybody agrees. 

It appears so, yes.

> Also, I may be odd, but I really do think latency is more important than 
> throughput. When my disk has latencies in the sub-milliseconds, I simply 
> do not think it is _acceptable_ to have hickups that affect my workload in 
> human-visible terms. 

Not everyone has an Intel SSD. But yes, latency is definitely more
important than throughput. That's not the same as saying that throughput
doesn't matter, because it definitely does.

> You say sqlite might regress by 4-5x. But Ted's numbers improve latencies 
> by mor than that. I haven't re-created them yet myself (still reading 
> email), but the point is, 4-5x may sound bad to you, but turn it around: 
> the current latency situation is _really_ bad. If we can fix it, we 
> definitely should.

I haven't either. On monday I'll throw some testing and patches on the
boxes here. We can get the latency right, I want that as much as the
next guy. I just want to make sure it doesn't become too one-sided.

> > > Quite frankly, the fact that I can see _seconds_ of latencies with a 
> > > really good SSD is not acceptable. The fact that it is by design is even 
> > > less so.
> > 
> > Agree, multi-second latencies is not acceptable.
> 
> I can literally send you strace output from my MUA, where it pauses for 
> ten seconds after it has written about 5kB (that's _kilobytes_) of data 
> and does a 'fsync'.

Unless you make all journal writes sync, ext3 fsync will always suck big
time. But I get your point.

-- 
Jens Axboe

