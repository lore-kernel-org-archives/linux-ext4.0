From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 09:06:54 +0200
Message-ID: <20090406070654.GP5178@kernel.dk>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <20090404135620.79d8cb3e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:45955 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZDFHG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 03:06:56 -0400
Content-Disposition: inline
In-Reply-To: <20090404135620.79d8cb3e@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 04 2009, Arjan van de Ven wrote:
> On Sat, 4 Apr 2009 19:34:12 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > Latency is more important than throughput. It's that simple.
> > 
> > It's really not that simple, otherwise the schedulers would be much
> > simpler. It's pretty easy to get good latency if you disregard any
> > throughput concerns, 
> 
> I'd be very interested in a scheduler like that.....
> How much work would it be to make it ?
> 
> (if nothing else it would be a good number to have "should be within
> 50% of the perfect one for the tradeoff")

It'd be pretty close to the first version of CFQ. The easiest would be
to add a cfq sysfs know that basically just switches a bunch of things
off in CFQ. Never idle, always dispatch only a single request at the
time, etc. At least for test purposes it would not be that hard. CFQ
doesn't export all of the settings that allow to make this possible
right now, otherwise it could just be done with a shell script.

-- 
Jens Axboe

