From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 1/2] ext4: introduce new i_write_mutex to protect fallocate
Date: Tue, 03 Jun 2014 15:04:32 +0900
Message-ID: <001801cf7ef1$b01a85a0$104f90e0$@samsung.com>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
 <20140529162810.GG25041@thunk.org>
 <000c01cf7c9b$edaf2f90$c90d8eb0$@samsung.com>
 <20140602143807.GB30598@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34542 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaFCGEf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2014 02:04:35 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6K00A6GWVK5LC0@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 03 Jun 2014 15:04:32 +0900 (KST)
In-reply-to: <20140602143807.GB30598@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Sat, May 31, 2014 at 03:45:36PM +0900, Namjae Jeon wrote:
> > ext4 file write is already serialized with inode mutex.
> 
> Right, I had forgotten about that.  The case where we really care
> about parallel writes is in the direct I/O case, and eventually I'd
> like for us to be able to support non-overwriting/non-isize-extending
> writes in parallel but we're not there yet.
Okay.
> 
> > So I think the impact of adding another lock will be very very less..
> > When I run parallel write test of fio to prove it, I can not see the difference on w/wo
> i_write_mutex.
> 
> If there is an impact, it won't show up there.  Where it will show up
> will be in high scalability workloads.  For people who don't have the
> half-million dollars (and up) expensive RAID arrays, a fairly good
> facsimile is to use a > 16 core system, preferably a system at least 4
> sockets, and say 32 or 64 gigs of memory, of which you can dedicate
> half to a ramdisk.  Then run the fio scalability benchmark in that
> scenario.  That way, things like cache line bounces and lock
> contentions will be much more visible when the system is no longer
> bottleneck by the HDD.
Yes, Right. I agree that result should be measured on high-end server
as you pointed again. Unfortunately I don't have such equipment yet..
> 
> > Yes, Right. We can use shared lock to remove a little bit lock contention in ext4 file write.
> > I will share rwsem lock patch.. Could you please revert i_write_mutex patch ?
> 
> So the shared lock will help somewhat (since writes will be far more
> common than fallocate calls) but I suspect, not all that much.  And if
> I revert the i_write_mutex call, now, we won't have time to replace it
> with a different patch since the merge window is already open.
> 
> And since this patch is needed to fix a xfstests failure (although
> it's for collapse range in data journalling mode, so not a common
> case), if we can't really see a performance loss in the much more
> common server configurations, I'm inclined to leave it in for now, and
> we can try to improve performance in the next kernel revision.
IMHO, If our goal is to solve the problem of xfstests, we can use only
"ext4: fix ZERO_RANGE test failure in data journalling" patch without
i_write_mutex patch. And we can add lock for fallocate on next kernel
after checking with sufficient time.

Thanks!

> 
> What do other people think?
> 
> 						- Ted

