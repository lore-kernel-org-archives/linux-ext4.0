From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 1 Jun 2007 12:00:04 -0600
Message-ID: <20070601180003.GX5181@schatzie.adilger.int>
References: <1179777153.3910.13.camel@garfield> <p731wgwcbac.fsf@bingen.suse.de> <20070601114100.GB13905@thunk.org> <20070601121339.GF7217@one.firstfloor.org> <20070601135241.GB28663@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54620 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762128AbXFASAK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 14:00:10 -0400
Content-Disposition: inline
In-Reply-To: <20070601135241.GB28663@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 01, 2007  09:52 -0400, Theodore Tso wrote:
> On Fri, Jun 01, 2007 at 02:13:39PM +0200, Andi Kleen wrote:
> > Clusters usually have other ways to do this, haven't they? 
> > Typically they have STONITH too. It's probably too simple minded
> > to just replace a real cluster setup which also handles split 
> > brain and other conditions. So it's purely against mistakes.
> 
> Yes, it's only real value is to protect against Cluster-HA
> malfunctions or misconfiguration.

While I agree that HA systems _should_ be enough for this, in our
experience even with an HA system some people get it wrong (e.g.
manually mounting and bypassing HA, HA itself is broken, comms failure,
STONITH failure, etc).

I agree it is not intended to be a replacement for an HA/STONITH
solution, just belt & suspenders that would have saved hundreds of
TB of user data in several cases if it were available.  We will
enable it by default on all of our filesystems, and of course I'd
advise anyone in a SAN environment (whether they _intend_ to have
shared disk access or not) to enable it also.

> > Besides relying on it would seem dangerous because it is not synchronous
> > and you could do a lot of damage in 5 seconds. 
> 
> Well, the MMP feature is assigned an incompatible feature bit, so a
> kernel who doesn't know about MMP will refuse to touch it; and a
> kernel which does follow the MMP protocol will check the MMP block
> (delaying the mount by 10 seconds) to make sure no other system is
> using the block.

Correct.  There is a "fast path" where it will wait a shorter time
during mount if the fs is reported cleanly unmounted.  We can't skip
the check entirely, because 2 systems might be mounting at the same
time.

> So aside from being !@#!@ annoying (which is why it will never be the
> default), it does work, modulo the problem that without STONITH or any
> kind of I/O fencing, we do risk the other system coming back to life
> and then modifying the filesystem in parallel.  So as everyone has
> said, this is not solution that works in isolation, but is really only
> a backup.

If the kmmpd is not scheduled in more than 10s then it will re-read the
block to ensure that the local system is still the one in control.  If
not, it will ext3_error() and (in our case at least) this will make the
client fs read-only.  Even if there is some IO leakage from the local
client, this is far better than to continue running with 2 systems writing
to the same disk.

Ideally there would also be a block-layer functionality to fence the IO
on the local system (e.g. plug the elevator output, I don't think that
there is anything that could be done about IO already submitted to the
device), but the function I thought did this (set_device_rdonly()) is
only checked at mount time and is useless.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
