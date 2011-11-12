From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 on 32GB SD card.
Date: Fri, 11 Nov 2011 20:20:19 -0500
Message-ID: <20111112012019.GB4055@thunk.org>
References: <CAAMvbhF2tBWZduzZFx_sp_V2YVssPjTqVJROyTHnpLBDJ1XK9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: James Courtier-Dutton <james.dutton@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35104 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1KLFQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Nov 2011 00:16:08 -0500
Content-Disposition: inline
In-Reply-To: <CAAMvbhF2tBWZduzZFx_sp_V2YVssPjTqVJROyTHnpLBDJ1XK9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 11, 2011 at 12:31:19PM +0000, James Courtier-Dutton wrote:
> 
> I wish to use an SD card in an embedded device use the ext4 filesystem on it.
> How much RAM would ext4 need to support this?
> I am assuming ext4 holds some sort of allocation table/metadata in RAM.

The minimum amount of space which ext4 keeps pinned in memory for a
32G file system is 3 4k blocks, plus an in-core memory.  If you
include things like the root directory that always have to be there,
we're talking maybe 24k or so.  Of course, the moment you actually
*do* something with the file system more metadata will get paged in,
and if you are running with very little memory, blocks will get pushed
out of memory, and then will have to read back into memory, and things
like delayed allocation won't work as well.

So you have to distinguish between "the bare minimum so you can mount
a file system", and "what you need so that you have acceptably good
performance for your workload" --- and that's going to be very
dependent on your workload.

Also, note that with performance, it's highly dependant on the SD
card; some SD cards are crap, and only support one write window at a
time, and others may support 8 or more write windows.

The other question is making sure you have enough memory so that you
can run e2fsck on a 32GB file system.

In general, the best thing to do is to try it, and see if it works.

Regards,

						- Ted
