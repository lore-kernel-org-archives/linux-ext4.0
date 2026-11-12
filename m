Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794467594;
	b=hJYoKgFtOrqHhnwU5ezrkpSZxx3Kpeot2INQEeaFt209hBA0Ao5ZmmCJKAec8PAj7kFd
	 qujoXOuFR9oEnm/M7YO+6i01LiFqcpgw3uxyGue8404HHjm1ROh7U9xxzAbQj4gUogUi9
	 YHwNMhsLoWPbT01Mcx2RqYLXf8PGftlToyHRebuQYRjm4EWAIPAshUnHCzUGm8WqABtNx
	 W+xRN5HUZylN6dm3y/v8X1v5P5rcs9KP8nHXyki+XpWRU8uCMuZfS+qFx9hyA/QX09c4A
	 D5wUMxP6p7x8LAVlc6B2IsK/n5IVqnjfk86A2XIuBLFxvBXatHP9prRo0RxYu0ei9ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794467594;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qsqGSTbuRNKZnI7NwMZMdPxyYhwVdYf7QErG0oOfLSI=;
	b=p0d0nTCBWGiQuQn/wNBSNhhBPGOqg2re2FJUQHfuL9gXglxKYZtct9FEXt1mIIYzX+Qt
	 9T4m6mznvj4dTzVNhZuBCpjkvU+f8Fr1EvNrB3pno4kbVttnbqa6xHVxh0WBk52j7kxiV
	 bIZdk/YlDE5UPsE/nRB6cWHLna0/zvwr2Tk8Auw6nKs/eBDKRSdSTtIIQjvWSoXLCa1ly
	 v1Q2RPjwZikr7m+CDFQjWInYcmKg/Zko6Z+BeHdP3TUIMHTvCJR13Dtq/gZSctsMRx1Rt
	 P86+OzqHZd3zMvMIU6QZufc0PG86Zg42eIV665x8NNXltniktlAzGTcIVbwk+JqBCxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=jkAv3dlc;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7450C606A31C;
	Thu, 12 Nov 2026 07:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7450C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=jkAv3dlc
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC2iR0j2854634;
	Thu, 12 Nov 2026 07:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qsqGSTbuRNKZnI7NwMZMdPxyYhwVdY
	f7QErG0oOfLSI=; b=jkAv3dlcBdUtjDUle0s2xjiC5+69Zf1BukXgyo8D9JKLMg
	WTfzO45/qXsRObs6UKZ03REWi20UDqG4YF4b1FfI9/JpxbLiITdYi8fltNAz616W
	BAXXyaHUv9R1oV2jMzkjjVJJcqCVCSEWOu1G4Y7GpgxvrG9p/7TDiCoQj+0BHSs7
	dCll428f/CY1KNxscze2nOhF633e71bagiBR6nI1IhoPXppaeFe/OmiepTJU6VuC
	4f7AwJYyGqZ6wu5wq8BxdaS6lo68MuJHtrMKMhhqeD1WvZW3d+NzpOcNPpKBsuWY
	334nuyGVq4heFl4s0at2YcdtNZB968ATI46pX6Cw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsuq765j3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 07:12:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC2oo6V097881;
	Thu, 12 Nov 2026 07:12:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hvkq0vaej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 07:12:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AC7CsLh35193280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Nov 2026 07:12:54 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 139712004E;
	Thu, 12 Nov 2026 07:12:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FD6B20043;
	Thu, 12 Nov 2026 07:12:52 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Nov 2026 07:12:52 +0000 (GMT)
Date: Thu, 12 Nov 2026 12:42:49 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ext4: fix endio zeroout corruption by tracking
 to-be-converted unwritten IOs
Message-ID: <avVm8XuQbU4sSIF1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <fce5c384-3a18-4156-b0eb-a0d584b8b459@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fce5c384-3a18-4156-b0eb-a0d584b8b459@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAyNiBTYWx0ZWRfX+WVVijjn8Top
 lSz5u8MKQXfGvJeTdiVnP1X+cxTnLrZzlPFNzCffZLZ/YCvVcrrApHVOvwzIifFTQ3VPn5biolS
 oYcuVA6Zz1IsviEnQP5Pe3TYjKxXvvk=
X-Authority-Analysis: v=2.4 cv=HbCB3SE8 c=1 sm=1 tr=0 ts=6af566f9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=NEAV23lmAAAA:8
 a=VnNF1IyMAAAA:8 a=Qz-7wdRGm9AEoJX1_joA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: tfpTyOGcNsqoW1YTZ9qFWqdWGXGfyTdm
X-Proofpoint-GUID: h7ixKFMzfecfkEiS-fLOYu0vhst-0R0c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAyNiBTYWx0ZWRfX5OpzURdTW4r/
 /rnW7MyHOKRQA/2A2IthYKGsVHQCA+pYU93Qm2ySpJdJwMugUkBCJ4d0rYq1on/MZXtp8iWFIVx
 RWDC5cP9vcm7/xZ9M8K4gQ6dBmlamxEieNH4U2lggjlId6TobWd3SskgotVi28wlnCoeSkqb1rp
 mt37nnY3AaDigj6d/r5sjWAxOPEUPdfrleB5WyUJxClYv8FsrCPhSn/TQuKEwaTKJpnLolimOgl
 Gv139PyUtzLlZS+fz95YUTfU1SfulJaQKeJZZS9w96Bb+9w9K1pPb8ICEOS/3a00qeb/ozkPWcM
 imCa5+LVro7TE43S6PKQt0y4IVHcqUuB02yHbor1v/AVVlw1qUqM+EVllI5qghz8fyUJvaPRQ+V
 HcEVRIJYwzjcE0CRwv1SG5swctpMZ5GPi7o2jpqj9noUoWRDYjwcZQduoTWh4qCgnD4/DeteAJA
 mWgQ/oPx20I+O3x+V6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120026

On Thu, Nov 12, 2026 at 11:33:35AM +0800, Zhang Yi wrote:
> On 11/3/2026 2:26 AM, Ojaswin Mujoo wrote:
> > There is a data corruption in the zeroout fallback
> > ext4_split_extent_zeroout() when we encounter an error like ENOSPC
> > while trying to perform endio extent splitting.
> > 
> > The issue was discovered by Fedora coreos community while using 1kb
> > blocks size on a 64kb pagesize arch like powerpc or aarch64 and the
> > discussion can be found at [1].
> > 
> > ** The Issue **
> > 
> > The issue can be encountered as follows:
> > 
> > 1. Make an FS with no reserved to root reserved blocks and fill it
> >    completely.
> > 2. Delete a file so that ext4_sb_info thinks there is free space but
> >    mballoc doesnt have any (until txn is committed).
> > 3. Now when endio kicks in it eventually reaches:
> > 
> > ext4_handle_unwritten_extents
> >   ext4_split_convert_extents
> >     ext4_split_extent
> >       ext4_split_extent_at
> >         ext4_ext_insert_extent
> >           ext4_new_meta_blocks  // extent tree split/grow needs a block
> >             ext4_mb_new_blocks
> >               ext4_claim_free_clusters  // thinks we have free space but mballoc
> >                                            has none until txn commit frees it
> >               ext4_mb_regular_allocator
> >                 // return -ENOSPC
> >     // ext4_split_extent fallsback to zeroout
> >     ext4_split_extent_zeroout
> >       // We try to zeroout surrounding unwritten ranges. This code has a bug
> >          where we zero an unwritten extent which could have valid data on disk 
> >          whose endio has not yet converted it
> > 
> > The main issue is that zeroout assumes any unwritten extent is valid to
> > zeroout but it could actually be a soon-to-be-converted extent holding
> > valid data.
> > 
> 
> Hi Ojaswin,
> 
> Thank you for your analysis! This makes sense to me. I apologize for not
> having considered this concurrent scenario earlier and for amplifying
> the data loss issue.
> 
> > ** The fix **
> > 
> > The way this series fixes it is by per-inode tracking the no. of
> > unwritten IOs that are submitted but not yet converted
> > (ei->i_conv_pending_ios). If we end up in the zeroout fallback and see
> > there are such IOs existing in the inode, then we don't zeroout and just
> > return back the original error. More design notes can be found in
> > subsequent patches.
> > 
> 
> Regarding the solution, I agree that your approach looks like it can fix
> this issue, and the idea is fairly straightforward. When zeroing out, if
> there is other concurrent I/O, just fall back and return an error.
> However, I've been thinking about it over the past few days, hoping to
> find another simpler and more elegant solution, but that seems rather
> difficult.
> 
> First, due to the map range caching mechanism in the iomap writeback
> path and for performance reasons, we probably can't go back to splitting
> extents when issuing I/O as before. Moreover, the previous approach also
> couldn't completely avoid zeroing the entire unwritten extent when the
> I/O completes, so the problem already existed before. It just required
> concurrency and had a very low probability. Therefore, I agree that we
> need to address this problem head-on.

Hi Zhang, thank you so much for looking into this.

So I agree that it is a tricky issue to solve since we don't want to
add too much complexity in the fast path. Actually the first prototype I
did for this (back in sep before we started seeing this in distros) was
becuase I was working on moving zeroout to the fast path rather than
just a fallback and had hit this fairly easily there.

In the first prototype, I took the exact approach you discussed here. A
new CONV_PENDING type for extent cache with all the plumbing to ensure
we don't lose the status untill the conversion happens. What I reliased
was that although this was a much more accurate fix, it needed lots of
core changes to es layer, and I ran into several bugs where data got
corrupted cause the status was getting lost or not in sync. I did manage
to fix most of them but it somehow makes me a bit uncomfortable from the
POV of a backport.

The patch for the inital version (v v rough and not cleaned up since
Sep) can be found here [1]. 

I'll address your below ideas on how/if i implemented them in [1]

> 
> 
> Here's a rough idea I'd like to share:
> 
> 1. Add an in-core extent status flag, something like
>    EXTENT_STATUS_PENDING_WRITTEN.  Like EXTENT_STATUS_DELAYED, these
>    entries would be must-keep.  The idea is to mark ranges for which
>    we've submitted I/O over an unwritten extent but haven't done the
>    conversion yet.  It would just be an extra flag on top of
>    EXTENT_STATUS_UNWRITTEN; the zeroout paths would be the only thing

I added a CONV_PENDING es type rather than flag. I did start with the
flag over UNWRITTEN approach but most places like merging logic care
that the type rather than flag and which was causing us to merge
UNWRITTEN and CONV_PENDING which we can't allow. So instead of modiying
code around merging and other areas I just made CONV_PENDING a separate
type.

>    looking at it, and everywhere else the entry would still behave like
>    a normal unwritten extent.  We'd have to drop the flag whenever the
>    entry changes state, and also when the I/O or the conversion fails.

Yes true, this is handled. We also make sure the CONV_PENDING extents
can't be evicted from es cache.

> 
> 2. When submitting I/O, once we know the actual range being submitted,
>    we'd split the existing unwritten extent status entry and add a
>    pending-written entry for that subrange.  Then, when the I/O
>    completes, or when fallocate and similar paths want to split an
>    unwritten extent, we could check the extent status tree for the range
>    we're about to zero; if there's a pending-written entry there, we'd
>    just skip the zeroout fallback and return the original error.

> 
> 3. We'd need to set the pending-written entry under i_data_sem.  Since
>    ext4_split_extent_zeroout() already runs under i_data_sem, that
>    should be enough to avoid the race.
> 
> 4. One thing to be careful about: a pending-written entry is still
>    unwritten, but it shouldn't be merged with a normal unwritten entry.

Yup, this 2, 3 and 4 are exactly implemented as you mentioned.
> 
> Some advantages I see:
> 
> 1. We don't need to add anything to struct ext4_inode_info.
> 
> 2. We don't need a new lock, and we avoid things like
>    EXT4_GET_BLOCKS_NO_CONV_ACC for paths that don't account for
>    themselves, as well as walking ioend/iovec at I/O completion just to
>    keep a count.  I think the code would be a bit easier to follow.
> 
> 3. Random I/O into preallocated files seems pretty common, so tracking
>    at per-extent (or more precisely, per-range) granularity should give
>    better exclusion than a per-inode counter and hopefully reduce the
>    chance of writeback/conversion failures.

Yes I agree, the es approach did feel more elegant and performance
efficient, especially if we want to consider moving zeroout to the fast
path in the future. However, again I was a bit apprehensive of the
complexity it brings and the amount of core paths we are touhcing. I was
planing to do that as an improvement once we have something basic like
the counter approach in this patchset implemented.

> 
> A few disadvantages I'm a bit worried about:
> 
> 1. We'd have to audit all the ext4_es_cache_extent() callers for
>    conflicts, and all ext4_es_remove_extent()/ext4_es_insert_extent()
>    call sites, to make sure pending-written entries don't get dropped or
>    overwritten. I'm not sure yet whether this is definitely feasible.
> 
> 2. It changes the core semantics of the extent status tree, so it's
>    quite a bit more code and work, and probably not something for
>    stable.  I see it more as a long-term fix.

Yep, thats true and [1] does take of 1. as well and was passing some of
the basic stress tests IIRC.


> 
> What do you think?

I agree that in the long term es cache approach is definitely the way to
move forward. I'm just wondering if it would be feasible to backport
something like that. Then again if we want to backport only till 7.0,
maybe it wont be that big of a deal. 

There are 2 approaches that I can see here:
1. USe this patch set's counter apprach as a stop gap, easy to backport
solution which works but is a bit clumsy. With the immediate fix in
place, we can take time to test and design the extent status approach
correctly and land it as a feature rather than something that needs
backport.

2. Ditch the counter approach and just fix it in one shot with extent
status approach like in [1].

I'm happy to work on either of the two, what do you think shall be the
right way forward?

[1] https://github.com/OjaswinM/linux/commit/9e4e2b65773fb575d1ef4248aa57714bfc0c2987

Regards,
ojaswin

> 
> Thanks,
> Yi.
> 
> > For direct IO, ext4_iomap_begin() is called once per mapping and has no
> > way to account something only once per dio. So we first fix it in a
> > simple way by relying on inode->i_dio_count which is already
> > incremented/decremented once per dio. The last patch optimizes this by
> > moving dio accounting to i_conv_pending_ios as well, by using a custom
> > ext4_iomap_next() (needed because we want to increment once per
> > dio). Since iomap_next() infra was added in 7.2+ this can't be
> > backported so kept this approach separate.
> > 
> > There are other approaches considered like completely disabling zeroout
> > (not ideal as it's a useful fallback) or tracking the conv_pending ranges
> > in extent cache (this is an intrusive change) however the current
> > approach was chosen as a middle ground to balance complexity vs
> > accuracy of accounting.
> > 
> > ** Backport Notes **
> > 
> > This issue seems to have existed ever since we had the zeroout logic
> > however this was never encountered until we moved extent splitting from
> > writeback time to endio time in commit:
> > 
> > ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O") (merged
> > in 7.0)
> > 
> > which changed the dioread_nolock writeback/dio path to submit I/O
> > without pre-splitting extents, deferring the split to endio. This means
> > multiple concurrent writes can share a single unwritten extent, and a
> > failed split on one of them could zeroout data belonging to another,
> > which exposes this issue in the zeroout logic. 
> > 
> > Note that the issue in zeroout was always present but the above patch
> > just uncovered it. However, for the purpose of backports, I've used this
> > patch. Seeing how we never saw this issue before this, hopefully just
> > backporting it till 7.0 should be fine.
> > 
> > ** Testing **
> > 
> > I've tested -g quick for various configurations to catch any obvious
> > issues or counter leaks, saw no regressions. I'll continue to test for
> > auto group. I've also added some new tests to hit this regression which
> > I'll post soon.
> > 
> > [1] https://github.com/coreos/fedora-coreos-tracker/issues/2234
> > 
> > Thoughts and suggestions welcome.
> > 
> > Regards,
> > ojaswin
> > 
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > ---
> > Ojaswin Mujoo (8):
> >       ext4: add extra_flags param to ext4_convert_unwritten_extents()
> >       ext4: fix endio zeroout corruption by tracking unwritten to-be-converted IOs
> >       ext4: add tracing for i_conv_pending_ios tracking
> >       ext4: don't zeroout if we have inflight unwritten IOs in non buffered-iomap path
> >       ext4: don't zeroout if we have inflight direct IOs
> >       ext4: make sure zero range WRITE_ZEROES uses NO_CONV_ACC flag
> >       ext4: don't zeroout if we have inflight unwritten IOs in buffered iomap path
> >       ext4: optimize inflight dio tracking for zeroout
> > 
> >  fs/ext4/ext4.h              |  29 +++++++--
> >  fs/ext4/extents-test.c      |   2 +
> >  fs/ext4/extents.c           | 117 ++++++++++++++++++++++++++++-------
> >  fs/ext4/file.c              |  14 ++++-
> >  fs/ext4/inode.c             | 146 +++++++++++++++++++++++++++++++++++++++++++-
> >  fs/ext4/page-io.c           |  27 +++++++-
> >  fs/ext4/super.c             |  12 ++++
> >  include/trace/events/ext4.h |  25 ++++++++
> >  8 files changed, 342 insertions(+), 30 deletions(-)
> > ---
> > base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
> > change-id: 20261023-ext4-endio-zero-bug-ec627ae61f39
> > 
> > Best regards,
> 
