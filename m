Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869CE26E173;
	Wed, 20 May 2026 13:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779283160; cv=none; b=YKQmy/UFXkCAzSVp0kE/Q9TclyfNRhs6yXQXlqkLDgDCCMUZmiZiLlIn6BVbfq6d/9trfVjhKDV9JXRGRFX5OgJ6FL0A+VusXy2/Xq7+CqyWWc0JfFWrPQJdUAtEd0EE4vyBqe8nu+NlEmUdCMcqn39mL3hC/++MmFVY6IZGHf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779283160; c=relaxed/simple;
	bh=SxXJfJ/t87d0oAqml2EfIj1f99SASTet1nox2o96RDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4woRwZWeRH8iqmAqUhFzRS5XGotfTpXiHa7WzbALfyumdhs3ul33A08fmEcEtJXa7M159fqX5yKaD/8Ec4SMEaf1pbu5Kyl3ZXjOQBl8xcJp7kyKo4zCLCyXnzjCGWKFFJ42Zbh5sOeryKvHxXjxkllX31K810X0Unj1sJEUgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RYHMNvRm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RYHMNvRm"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K7CGkk790111;
	Wed, 20 May 2026 13:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ejtYiUufuHM79JTQigx1n3RoGiGOVU
	VRhCid8JdYsf4=; b=RYHMNvRmsdAOSVSrq2qj2ybHZ7lvDQYmfLy6Zuj2aIvQyw
	biZ4+BpA1N6ewSmnPyoPDWCS8ea0f7Y2w2HmOKBfaESDrMGCiFSEoWFGh1xHD6Jw
	K0M+I4Act3KH3AawrFkETCVlSOHed3dzPGv5ffgRMucJZjE/cZHgOEcw5F6DXt4S
	LT6cqDrKdaCvPs6FwuZY1rdzAIAnSdleuzKOIrrNrb3ZUZ/ph8qWL040NvuFJuOh
	N5AhgO06pWCaGdUjoe2+OAuoNXFuzi3LB4CqakE/O6Xi68dprv0f18h0MixE4yZr
	p+zOCBtdxfpieM6jypvyzlAD1JlYqSQMVx3dLeaA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8h663-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 13:18:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KD9BFI027981;
	Wed, 20 May 2026 13:18:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky76vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 13:18:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KDIFgb37224838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 13:18:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BFA520043;
	Wed, 20 May 2026 13:18:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 703CC20040;
	Wed, 20 May 2026 13:18:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.50])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 20 May 2026 13:18:10 +0000 (GMT)
Date: Wed, 20 May 2026 18:47:51 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 07/23] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Message-ID: <ag20f0l_cbjZ3Qwn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-8-yi.zhang@huaweicloud.com>
 <agw-Wt4c4Fwevezk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <agxmG0MhIywySPaA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <a1e84c7e-c241-44bd-8289-b8909c17b3b9@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1e84c7e-c241-44bd-8289-b8909c17b3b9@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDEyNyBTYWx0ZWRfX9lDdXp6rgRQ7
 6X3lHllzVKQV6KFQ1dcg9Fyq1NdyeJGkHuukW/B0yy4Fy9qoelKryEWdSyWIUdztQI55p7/e5ob
 +q1woxVEwDVBL9+2JtzlpRRDunxMU5eMwYuByTSJ7SlXuju/Dl/qTkn4yxwV4H7Uda3K8jxwcbG
 oznY2FVvyjqfNVa5/d9Y5yahqBsCkknL3+CDZgPOWUy9r6XIUReS/mBO7m0+nnFZtdut9j7Nssg
 AXbngV6r6BasGD85yimLZb//og5SFNW/88i6ntea1CEIWnIetAoKkRe3k2DQPQdN9+8RbUExkSQ
 83uCT4Or3caTsrlHySP4LB2s/OyeCGTjx+i2Ii9BN8tV3hG7taBp6dm1+HfMAPKbfL0jMi9xm5a
 i9t9wzlCvK9sbC80auPHt7Z3gWRDs7gs9kgzoB0EPMOHr3Xd+N1PIC06/uzu8aujgQATpT0yEuL
 b5m6bctZZuteZl0m7Xw==
X-Proofpoint-GUID: Z60JMaGyz52oXxJoN_I_fnNOOpkT7iMh
X-Proofpoint-ORIG-GUID: ciW_NhdLBZBFrq6gGVNi5LyTSBGXnFyF
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0db49a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=UQLbFkMFH8svXddqZaIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200127

On Wed, May 20, 2026 at 04:18:48PM +0800, Zhang Yi wrote:
> On 5/19/2026 9:31 PM, Ojaswin Mujoo wrote:
> > On Tue, May 19, 2026 at 04:11:30PM +0530, Ojaswin Mujoo wrote:
> >> On Mon, May 11, 2026 at 03:23:27PM +0800, Zhang Yi wrote:
> >>> From: Zhang Yi <yi.zhang@huawei.com>
> >>>
> >>> The data=ordered mode introduces two fundamental conflicts with the
> >>> iomap buffered write path, leading to potential deadlocks.
> >>>
> >>> 1) Lock ordering conflict
> >>>    In the iomap writeback path, each folio is processed sequentially:
> >>>    the folio lock is acquired first, followed by starting a transaction
> >>>    to create block mappings. In data=ordered mode, writeback triggered
> >>>    by the journal commit process may attempt to acquire a folio lock
> >>>    that is already held by iomap. Meanwhile, iomap, under that same
> >>>    folio lock, may start a new transaction and wait for the currently
> >>>    committing transaction to finish, resulting in a deadlock.
> >>
> >> Right, makes sense.
> >>>
> >>> 2) Partial folio submission not supported
> >>>    When block size is smaller than folio size, a folio may contain both
> >>>    mapped and unmapped blocks. In data=ordered mode, if the journal
> >>>    waits for such a folio to be written back while the regular writeback
> >>>    process has already started committing it (with the writeback flag
> >>>    set), mapping the remaining unmapped blocks can deadlock. This is
> >>>    because the writeback flag is cleared only after the entire folio is
> >>>    processed and committed.
> >>
> >> Okay so IIUC, if we do end up using iomap with ordered data, there are 2
> >> codepaths with issues here:
> >>
> >> txn_commit
> >>   ordered data writeback (say it goes via iomap)
> >> 	  folio_lock
> >> 		iomap_writeback_folio
> >> 			folio_start_writeback
> >> 			  iomap_writeback_range
> >> 				  ext4_map_block
> >> 					  txn_start
> >> 						  wait for tnx commit - DEADLOCK
> >>
> >> Currently we avoid this by having ext4_normal_submit_inode_buffers()
> >> pass can_map = 0 so journal flush makese sure not to start any txn.
> >>
> >> Then we have
> >>
> >> txn_commit                          background writeback (via iomap)
> >>
> >>                                     folio_lock()
> >>   ordered data writeback
> >> 	  folio_lock
> >> 			  
> >>                                 		iomap_writeback_folio
> >>                                 			folio_start_writeback
> >>                                 			  iomap_writeback_range
> >>                                 				  ext4_map_block
> >>                                 					  txn_start
> >> 																						  wait for txn commit - DEADLOCK
> > 
> > Sorry I forget to remove tabs
> > 
> > this is what I meant:
> > 
> > txn_commit
> >   ordered data writeback (say it goes via iomap)
> >     folio_lock
> >     iomap_writeback_folio
> >       folio_start_writeback
> >         iomap_writeback_range
> >           ext4_map_block
> >             txn_start
> >               wait for tnx commit - DEADLOCK
> > 
> > Currently we avoid this by having ext4_normal_submit_inode_buffers()
> > pass can_map = 0 so journal flush makese sure not to start any txn.
> 
> Yeah, but we can also solve this problem by adding similar tags. This
> is not the most difficult part.
> 
> > 
> > Then we have
> > 
> > txn_commit                          background writeback (via iomap)
> > 
> >                                     folio_lock()
> >   ordered data writeback
> >     folio_lock
> > 
> >                                     iomap_writeback_folio
> >                                       folio_start_writeback
> >                                         iomap_writeback_range
> >                                           ext4_map_block
> >                                             txn_start
> >                                               wait for txn commit - DEADLOCK
> > 
> > 
> >> 	  
> >> Currently, this is taken care because we try to start the txn before
> >> taking any folio locks/starting writeback, and hence we cannot deadlock.
> 
> Yeah. You are right! Actually, this deadlock scenario should essentially
> belong to the first category: "Lock ordering conflict". This is not the
> scenario I want to describe here. The problematic scenario is as
> follows:
> 
> T0: Assume we have a folio contains four blocks, from front to back,
>     they are A, B, C, D. The last block D is written in delalloc mode
>     (the block is not allocated yet).
> 
> T1: The writeback process starts to write back data, set writeback flag
>     on the folio, allocates block D, and adds it to transaction N's
>     order list of jbd2 in JI_WAIT_DATA mode.
> 
> T2: This folio completes the writeback and clears the writeback flag.
> 
> T3: Before transaction N commit, we punch block B and C, and overwrite
>     A-C,
> 
> T4: Transaction N commit and folio writeback are running concurrently.
> 
> Transaction N commit        folio writeback(iomap)
> 
>                             iomap_writeback_folio()
>                              folio_start_writeback()  -- set writeback
> 
> jbd2_journal_finish_inode_data_buffers()
>  __filemap_fdatawait_range()
>   -- wait writeback flag to clear
>                                iomap_writeback_range()
>                                 ext4_map_block() -- map block B and C
>                                  start handle
>                                   wait for transaction N commit
>                                    - DEADLOCK
> 
> IOMAP does not support submitting partial folios during writeback.
> Therefore, the writeback flag is cleared only after the entire folio
> has been submitted. As a result, the commit of transaction N would never
> wait for this flag to be cleared if we need to map some blocks in this
> folio.

Hey Zhang, 

thanks for the traces, it makes it so much clearer.

> 
> Currently, this is handled by ext4_bio_write_folio(), which supports
> writing back partial folios. The writeback flag is only set after the
> block has been mapped and before the bio is actually issued. There are
> no other limitations that would block this flag from being cleared
> after the I/O is completed.

So IIUC the issue with iomap is that we set the writeback before
we start a txn handle and this way a txn handle can wait for a commit
which is waiting for writeback on the same folio to be cleared.

ext4_do_writepages currently starts the txn first, allocates and then
sets writeback and starts submitting buffers. This sequence ensures that
we dont get into the above deadlock because we never wait for commit
with a folio lock/writeback held.

Thanks,
Ojaswin
> 
> >>
> >> If the above description makes sense, do you think it'd be good to add
> >> them to the commit message. The reason is that although these paths seem
> >> obvious when we look at them a lot, it took me a good bit of time to
> >> understand what deadlocks you are talking about here :p
> >>
> >> Having the code traces like above makes it very clear.
> 
> Indeed, these problematic cases are complicated and subtle. I also spent
> some time recalling this scene. I can add these code traces in my next
> iteration.
> 
> Thanks,
> Yi.
> 
> >>>
> >>> To support data=ordered mode, the iomap core would need two invasive
> >>> changes:
> >>>  - Acquire the transaction handle before locking any folio for
> >>>    writeback.
> >>>  - Support partial folio submission.
> >>>
> >>> Both changes are complicated and risk performance regressions.
> >>> Therefore, we must avoid using data=ordered mode when converting to the
> >>> iomap path.
> >>>
> >>> Currently, data=ordered mode is used in three scenarios:
> >>>  - Append write
> >>>  - Post-EOF partial block truncate-up followed by append write
> >>>  - Online defragmentation
> >>>
> >>> We can address the first two without data=ordered mode:
> >>>  - For append write: always allocate unwritten blocks (i.e. always
> >>>    enable dioread_nolock), preserving the behavior of current
> >>>    extent-type inodes.
> >>>  - For post-EOF truncate-up + append write: postpone updating i_disksize
> >>>    until after the zeroed partial block has been written back.
> >>
> >> I'm still going through how we are addressing no data=ordered so will
> >> get back on this in some time.
> >>
> >> Thanks,
> >> Ojaswin
> >>
> >>>
> >>> Online defragmentation does not yet support iomap; this can be resolved
> >>> separately in the future.
> >>>
> >>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >>> ---
> >>>  fs/ext4/ext4_jbd2.h | 7 ++++++-
> >>>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> >>> index 63d17c5201b5..26999f173870 100644
> >>> --- a/fs/ext4/ext4_jbd2.h
> >>> +++ b/fs/ext4/ext4_jbd2.h
> >>> @@ -383,7 +383,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
> >>>  
> >>>  static inline int ext4_should_order_data(struct inode *inode)
> >>>  {
> >>> -	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
> >>> +	/*
> >>> +	 * inodes using the iomap buffered I/O path do not use the
> >>> +	 * data=ordered mode.
> >>> +	 */
> >>> +	return !ext4_inode_buffered_iomap(inode) &&
> >>> +		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
> >>>  }
> >>>  
> >>>  static inline int ext4_should_writeback_data(struct inode *inode)
> >>> -- 
> >>> 2.52.0
> >>>
> 
