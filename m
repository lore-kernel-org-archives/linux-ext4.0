From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 14:55:25 -0700
Message-ID: <1219269325.7895.45.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker>  <20080820115331.GA9965@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39848 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYHTVzl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 17:55:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KLw9GP027343
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:58:09 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KLtPks237196
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:55:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KLtPqk020361
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:55:25 -0400
In-Reply-To: <20080820115331.GA9965@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 07:53 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > mpage_da_map_blocks block allocation failed for inode 323784 at l=
ogical
> > > offset 313 with max blocks 11 with error -28
> > > This should not happen.!! Data will be lost
>=20
> We don't actually lose the data if free blocks are subsequently made
> available, correct?
>=20

Well, I thought with Aneesh's new ext4_da_invalidate patch  in the patc=
h
queue, the dirty page get invalidate if ext4_da_writepages() could not
successfully map/allocate blocks. That means we lost data:(=20

I have a feeling that we did not try very hard before invalidate the
dirty page which fail to map to disks. Perhaps we should try a few more
times before give up. Also in that case, perhaps we should turn off
delalloc fs wide, so the new writers won't take the subsequently made
avaible free blocks away from this unlucky delalloc da writepages.

> > I tried this patch. There are still multiple ways we can get wrong =
free
> > block count. The patch reduced the number of errors. So we are doin=
g
> > better with patch. But I guess we can't use the percpu_counter base=
d
> > free block accounting with delalloc. Without delalloc it is ok even=
 if
> > we find some wrong free blocks count . The actual block allocation =
will fail in
> > that case and we handle it perfectly fine. With delalloc we cannot
> > afford to fail the block allocation. Should we look at a free block
> > accounting rewrite using simple ext4_fsblk_t and and a spin lock ?
>=20
> It would be a shame if we did given that the whole point of the percp=
u
> counter was to avoid a scalability bottleneck.  Perhaps we could take
> a filesystem-level spinlock only when the number of free blocks as
> reported by the percpu_counter falls below some critical level?

Perhaps the  thresh hold should b higher, but other than that, the
current ext4_has_free_blocks() code, does 1) get the freeblocks counter
2) if the counter < FBC_BATCH , it will call
percpu_counter_sum_and_set(), which will take the per-cpu-counter lock,
and do accurate accounting.

So after think again, I could not see what suggested above diffrent fro=
m
what current ext4_has_free_blocks() does?


Right now the ext4_has_free_blocks() uses the=20

#define FBC_BATCH       (NR_CPUS*4)

as the thresh hold.  I thought that was good enough as
ext4_da_reserve_space() only request 1 block at a time (called at
write_begin time), but maybe I am wrong...

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
