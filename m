From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: spinlocks in ext4
Date: Thu, 11 Oct 2012 20:17:32 -0400
Message-ID: <20121012001732.GA3990@thunk.org>
References: <CAK5=ZRLQErM1dOT_Tuf-SC4-3VK_o6TRg-0k8A=iQGgFY6S+aw@mail.gmail.com>
 <20121009005425.GB20682@thunk.org>
 <20121009011036.GC20682@thunk.org>
 <CAK5=ZRJt3KCQniUA+-E4kn_51nFvB34796wOoG4vrmzU5nfwOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peter Fordham <peter.fordham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55127 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477Ab2JLARh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 20:17:37 -0400
Content-Disposition: inline
In-Reply-To: <CAK5=ZRJt3KCQniUA+-E4kn_51nFvB34796wOoG4vrmzU5nfwOA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2012 at 11:37:46AM -0700, Peter Fordham wrote:
> On 8 October 2012 18:10, Theodore Ts'o <tytso@mit.edu> wrote:
> > How expensive are memory barriers on ARM, anyway?
> 
> The performance monitors seem to be telling me that a DMB just after a
> store which misses in the L1 & L2, (causing an eviction of a clean
> line and a line-fill, I assume) takes over 100 cycles.

If we assume a 1GHz clock, 100 cycles is 0.1 microseconds (100ns).  A
4k read on an eMMC device (what I assume you are using) is about 5ms.
A super expensive PCIe attached flash has a read latency of around
20-50 microseconds.  Read latency for an SSD is around 1ms.

> I'm seeing a 20% slow down in ext4 performance when enabling SMP on my
> device. I'm starting to think there might be issues with the memory
> system.

So what are you measuring and how are you measuring it?  If 0.1
microseconds is significant, it must be something where everything is
in cache, and you're never hitting the storage device.

More to the point, as Arjan pointed out to me on Google+, using a
mutex is going to add at least one, and probably more, memory barriers
(due to the locks needed by the scheduler) *plus* the scheduling
overhead.  So your claim that using a mutex is superior to using
spinlocks makes absolutely no sense.

					- Ted
