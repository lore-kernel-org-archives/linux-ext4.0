From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 20:48:15 +0530
Message-ID: <20080821151815.GD6509@skywalker>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu> <1219269325.7895.45.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:37359 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760556AbYHUPSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 11:18:30 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7LFIR6C019042
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 20:48:27 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LFIRhp1790078
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 20:48:27 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7LFIRrh004895
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 20:48:27 +0530
Content-Disposition: inline
In-Reply-To: <1219269325.7895.45.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 02:55:25PM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 07:53 -0400=EF=BC=8CTheodore T=
so=E5=86=99=E9=81=93=EF=BC=9A
> > On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > > mpage_da_map_blocks block allocation failed for inode 323784 at=
 logical
> > > > offset 313 with max blocks 11 with error -28
> > > > This should not happen.!! Data will be lost
> >=20
> > We don't actually lose the data if free blocks are subsequently mad=
e
> > available, correct?
> >=20
>=20
> Well, I thought with Aneesh's new ext4_da_invalidate patch  in the pa=
tch
> queue, the dirty page get invalidate if ext4_da_writepages() could no=
t
> successfully map/allocate blocks. That means we lost data:(=20
>=20
> I have a feeling that we did not try very hard before invalidate the
> dirty page which fail to map to disks. Perhaps we should try a few mo=
re
> times before give up. Also in that case, perhaps we should turn off
> delalloc fs wide, so the new writers won't take the subsequently made
> avaible free blocks away from this unlucky delalloc da writepages.

How do we try hard ? The mballoc already try had to allocate blocks. So=
 I
am not sure what do we achieve by requesting for block allocation again=
=2E


>=20
> > > I tried this patch. There are still multiple ways we can get wron=
g free
> > > block count. The patch reduced the number of errors. So we are do=
ing
> > > better with patch. But I guess we can't use the percpu_counter ba=
sed
> > > free block accounting with delalloc. Without delalloc it is ok ev=
en if
> > > we find some wrong free blocks count . The actual block allocatio=
n will fail in
> > > that case and we handle it perfectly fine. With delalloc we canno=
t
> > > afford to fail the block allocation. Should we look at a free blo=
ck
> > > accounting rewrite using simple ext4_fsblk_t and and a spin lock =
?
> >=20
> > It would be a shame if we did given that the whole point of the per=
cpu
> > counter was to avoid a scalability bottleneck.  Perhaps we could ta=
ke
> > a filesystem-level spinlock only when the number of free blocks as
> > reported by the percpu_counter falls below some critical level?
>=20
> Perhaps the  thresh hold should b higher, but other than that, the
> current ext4_has_free_blocks() code, does 1) get the freeblocks count=
er
> 2) if the counter < FBC_BATCH , it will call
> percpu_counter_sum_and_set(), which will take the per-cpu-counter loc=
k,
> and do accurate accounting.
>=20
> So after think again, I could not see what suggested above diffrent f=
rom
> what current ext4_has_free_blocks() does?
>=20
>=20
> Right now the ext4_has_free_blocks() uses the=20
>=20
> #define FBC_BATCH       (NR_CPUS*4)
>=20
> as the thresh hold.  I thought that was good enough as
> ext4_da_reserve_space() only request 1 block at a time (called at
> write_begin time), but maybe I am wrong...
>=20

I have right now threshold check as below.

+       /* Each CPU can accumulate FBC_BATCH blocks in their local
+        * counters. So we need to make sure we have free blocks more
+        * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+        */
+       if (free_blocks - (nblocks + root_blocks) <
+                                       (4 * (FBC_BATCH * nr_cpu_ids)))
{

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
