From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: RE: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
 fallocate
Date: Tue, 3 Jun 2014 12:49:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406031246390.2112@localhost.localdomain>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com> <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain> <20140529162810.GG25041@thunk.org> <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com> <20140602143807.GB30598@thunk.org>
 <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-455720586-1401792579=:2112"
Cc: "'Theodore Ts'o'" <tytso@mit.edu>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>,
	"'Ashish Sangwan'" <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaFCKtn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2014 06:49:43 -0400
In-Reply-To: <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-455720586-1401792579=:2112
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Tue, 3 Jun 2014, Namjae Jeon wrote:

> Date: Tue, 03 Jun 2014 15:04:32 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: 'Theodore Ts'o' <tytso@mit.edu>
> Cc: 'Luká¹ Czerner' <lczerner@redhat.com>,
>     'linux-ext4' <linux-ext4@vger.kernel.org>,
>     'Ashish Sangwan' <a.sangwan@samsung.com>
> Subject: RE: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
>     fallocate
> 
> > 
> > On Sat, May 31, 2014 at 03:45:36PM +0900, Namjae Jeon wrote:
> > > ext4 file write is already serialized with inode mutex.
> > 
> > Right, I had forgotten about that.  The case where we really care
> > about parallel writes is in the direct I/O case, and eventually I'd
> > like for us to be able to support non-overwriting/non-isize-extending
> > writes in parallel but we're not there yet.
> Okay.
> > 
> > > So I think the impact of adding another lock will be very very less..
> > > When I run parallel write test of fio to prove it, I can not see the difference on w/wo
> > i_write_mutex.
> > 
> > If there is an impact, it won't show up there.  Where it will show up
> > will be in high scalability workloads.  For people who don't have the
> > half-million dollars (and up) expensive RAID arrays, a fairly good
> > facsimile is to use a > 16 core system, preferably a system at least 4
> > sockets, and say 32 or 64 gigs of memory, of which you can dedicate
> > half to a ramdisk.  Then run the fio scalability benchmark in that
> > scenario.  That way, things like cache line bounces and lock
> > contentions will be much more visible when the system is no longer
> > bottleneck by the HDD.
> Yes, Right. I agree that result should be measured on high-end server
> as you pointed again. Unfortunately I don't have such equipment yet..
> > 
> > > Yes, Right. We can use shared lock to remove a little bit lock contention in ext4 file write.
> > > I will share rwsem lock patch.. Could you please revert i_write_mutex patch ?
> > 
> > So the shared lock will help somewhat (since writes will be far more
> > common than fallocate calls) but I suspect, not all that much.  And if
> > I revert the i_write_mutex call, now, we won't have time to replace it
> > with a different patch since the merge window is already open.
> > 
> > And since this patch is needed to fix a xfstests failure (although
> > it's for collapse range in data journalling mode, so not a common
> > case), if we can't really see a performance loss in the much more
> > common server configurations, I'm inclined to leave it in for now, and
> > we can try to improve performance in the next kernel revision.
> IMHO, If our goal is to solve the problem of xfstests, we can use only
> "ext4: fix ZERO_RANGE test failure in data journalling" patch without
> i_write_mutex patch. And we can add lock for fallocate on next kernel
> after checking with sufficient time.

I would rather go with this solution. The race is not terribly
critical and this way we would have more time to come up with a
proper locking also with proper locking for AIO/DIO because from my
measurement I can see only about 50% of performance that xfs can
achieve. I believe that the reason is that we're actually using the
stock VFS locking, but we should be able to do something smarter
than that.

Thanks!
-Lukas

> 
> Thanks!
> 
> > 
> > What do other people think?
> > 
> > 						- Ted
> 
> 
--8323328-455720586-1401792579=:2112--
