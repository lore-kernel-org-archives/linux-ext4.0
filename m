From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 15:37:41 -0500
Message-ID: <20120308203741.GE29510@shiny>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
 <20120308180951.GB29510@shiny>
 <4F59148A.4070001@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Zach Brown <zab@zabbo.net>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50603 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2CHUhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 15:37:51 -0500
Content-Disposition: inline
In-Reply-To: <4F59148A.4070001@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 08, 2012 at 12:20:26PM -0800, Boaz Harrosh wrote:
> On 03/08/2012 10:09 AM, Chris Mason wrote:
> > 
> > But, why are we writeback for a second or more?  Aren't there other
> > parts of this we would want to fix as well?
> > 
> > I'm not against only turning on stable pages when they are needed, but
> > the code that isn't the default tends to be somewhat less used.  So it
> > does increase testing burden when we do want stable pages, and it tends
> > to make for awkward bugs that are hard to reproduce because someone
> > neglects to mention it.
> > 
> > IMHO it's much more important to nail down the 2 second writeback
> > latency. That's not good.
> > 
> 
> I think I understand this one. It's do to the sync nature introduced
> by page_waiting in mkwrite.

Pages go from dirty to writeback for a few reasons.  Background
writeout, or O_DIRECT or someone running sync

background writeout shouldn't be queueing up so much work that
synchronous writeout has a 2 second delay.

If the latencies are coming from something that was run through
fsync...well there's not too much we can do about that.  The problem is
that our page_mkwrite call isn't starting the IO it is just waiting on
it, so we can't bump the priority on it.

-chris
