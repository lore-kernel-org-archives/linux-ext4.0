From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
 fallocate
Date: Mon, 2 Jun 2014 10:38:07 -0400
Message-ID: <20140602143807.GB30598@thunk.org>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
 <20140529162810.GG25041@thunk.org>
 <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?J0x1a8OhxaE=?= Czerner' <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45550 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaFBOiM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 10:38:12 -0400
Content-Disposition: inline
In-Reply-To: <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 31, 2014 at 03:45:36PM +0900, Namjae Jeon wrote:
> ext4 file write is already serialized with inode mutex.

Right, I had forgotten about that.  The case where we really care
about parallel writes is in the direct I/O case, and eventually I'd
like for us to be able to support non-overwriting/non-isize-extending
writes in parallel but we're not there yet.

> So I think the impact of adding another lock will be very very less..
> When I run parallel write test of fio to prove it, I can not see the difference on w/wo i_write_mutex.

If there is an impact, it won't show up there.  Where it will show up
will be in high scalability workloads.  For people who don't have the
half-million dollars (and up) expensive RAID arrays, a fairly good
facsimile is to use a > 16 core system, preferably a system at least 4
sockets, and say 32 or 64 gigs of memory, of which you can dedicate
half to a ramdisk.  Then run the fio scalability benchmark in that
scenario.  That way, things like cache line bounces and lock
contentions will be much more visible when the system is no longer
bottleneck by the HDD.

> Yes, Right. We can use shared lock to remove a little bit lock contention in ext4 file write.
> I will share rwsem lock patch.. Could you please revert i_write_mutex patch ?

So the shared lock will help somewhat (since writes will be far more
common than fallocate calls) but I suspect, not all that much.  And if
I revert the i_write_mutex call, now, we won't have time to replace it
with a different patch since the merge window is already open.

And since this patch is needed to fix a xfstests failure (although
it's for collapse range in data journalling mode, so not a common
case), if we can't really see a performance loss in the much more
common server configurations, I'm inclined to leave it in for now, and
we can try to improve performance in the next kernel revision.

What do other people think?

						- Ted
