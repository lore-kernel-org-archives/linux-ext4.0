Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DCD31F9A3;
	Tue,  2 Jun 2026 05:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780378649; cv=none; b=PMxOAzb+IednnYzJ7GFj0T4eDyFmGpyEazghZLmjQp7Q511NuHqGDZTo2+q2BSd1Cq6hKArUrBzmb4yOqdHCdd1nC2LbHP7aVFWuN/RY5bfUsl/dgVHCd8fX0rsZpn8B2PdIMrwFbRESzFIAWQqZaUf+lm+51+zztCMq/BWSx6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780378649; c=relaxed/simple;
	bh=076f48Y8DYSAIChpmHyaHD6bvclvvNSv4Nb27ck+224=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rjn6twNO+Y2mGZqjOgmYj8Hc/5XJWql8DRSdfNg7YS67vN60HOSAUV9We0WDFZa/kiS23AgWN8PxxAHlCfbIF/vapBTsxIbOYDv/oD+/+9DcR25ZXSqWQSx7nzLZ/nRTLwtP3GJn2NEUQ3omzEvaWpfsuPu7fpIedGwtAxO6m2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RPa7BPXv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RPa7BPXv"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651KEvF8313051;
	Tue, 2 Jun 2026 05:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OC5/YK
	t0VpYglLmEmGMy/P+Fae8s8vKzWN1CKDs6MPo=; b=RPa7BPXvto3rlCSveLco0+
	ZJOM7ftkaEMrCjEAA344WgLpluVuk4E635JQ5ZrLfKZSESquOWQLTQvyiuK0BsHK
	lSBs4DfrTiVlH6hU0MevJXrFvYpyiq+P4ETH/W21nAEHaPrPS6Xe4QF9z11lJHHe
	KJikaxbm5jxIfg9NzDvbOUgoQeeWbhIwOrTEOViBuY/i4VI/IEA8/JOhxPu2Bcsk
	tKCjqQsdPOjV/Hq5YwLHraq2jpdpBcrWi2TIbfnX7OAkL1a2e/oyvNt6PK8E/8kl
	hTep1WL5U8xn/UbIhBZjaUiCz9WtDzgq4oV1TbS2uo9yC0BzSDLA+XSHxkE0/NlA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efnahm60f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 05:36:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6525OAeZ015438;
	Tue, 2 Jun 2026 05:36:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ega7q9wvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 05:36:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6525aiia48169266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 05:36:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CAFF20043;
	Tue,  2 Jun 2026 05:36:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43C9020040;
	Tue,  2 Jun 2026 05:36:29 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.47])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jun 2026 05:36:28 +0000 (GMT)
Date: Tue, 2 Jun 2026 11:05:02 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <ah5oM1EQwmpaotTL@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <5d2b13b9-d5a0-47ce-876c-ab01070cbe49@huaweicloud.com>
 <81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com>
 <ah3QlCt8V-3kVzW8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ad963861-4ae3-4753-9415-793bbac00e06@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad963861-4ae3-4753-9415-793bbac00e06@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA0OSBTYWx0ZWRfX+vonBZmAaacx
 mowiAIEHZhhEcLYgUGTDRjzcJPPTSM1QqNSvZbz4axIceh1MW771Iui7RDw1dq9czLR8giUp10E
 Z4hy2obOCuQrW6Cf0vVi40HknNy6yO+3Z8OpnGcQpEKmeSCSIkG4Bz0pU0/sRdc/Zn7DnRbN7PT
 6hsGdI0FbjXC3aOvbaa9l/Qfm8I1Oqz2ME2Lo7r6TzH8UTIpCTkf01NYOGiq3xHi/hn7QJE/jxe
 mPWcr0uxWZPNppjePVkJxt9n5ygS7/LL2KXaPURgyfONQkVXsIVLerYfGuBjGnodkgl1Ulcojc4
 8oyHTdRGOZ4x3GhlB1tmxtECbWC/9YIONhY51X6yxVAUmKPoD1TMYpwkF6PhRraBMst/vMTx/ki
 eaXAhaK7yyvXvmlXzn29BHznbkjGsOA+YT5tKVQ+K8yjppQ+Ge/OO+VRcQxJmeZa3l0tlXk7n5l
 eUC5p9lU/mhAYH/3hyg==
X-Proofpoint-ORIG-GUID: 8eoB0urlaF7d2FifjkzkIhH2SsgW_EAz
X-Authority-Analysis: v=2.4 cv=cOzQdFeN c=1 sm=1 tr=0 ts=6a1e6bef cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=X5YIm-aiG7nVVlhEWbMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4T2cLhBu6fIGz95osot2MdkeXM2F4Z5u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020049

On Tue, Jun 02, 2026 at 11:22:12AM +0800, Zhang Yi wrote:
> On 6/2/2026 2:33 AM, Ojaswin Mujoo wrote:
> > On Sat, May 30, 2026 at 04:24:24PM +0800, Zhang Yi wrote:
> > > On 5/30/2026 3:22 PM, Zhang Yi wrote:
> > > > Hi, Ojaswin!
> > > > 
> > > > On 5/27/2026 11:58 PM, Ojaswin Mujoo wrote:
> > > > > On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
> > > > > > From: Zhang Yi <yi.zhang@huawei.com>
> > > > > > 
> > > > > > For append writes, wait for ordered I/O to complete before updating
> > > > > > i_disksize. This ensures that zeroed data is flushed to disk before the
> > > > > > metadata update, preventing stale data from being exposed during
> > > > > > unaligned post-EOF append writes.
> > > > > > 
> > > > > > Suggested-by: Jan Kara <jack@suse.cz>
> > > > > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > > > > ---
> > > > > >   fs/ext4/ext4.h    | 11 +++++++
> > > > > >   fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
> > > > > >   fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
> > > > > >   fs/ext4/super.c   | 23 ++++++++++----
> > > > > >   4 files changed, 161 insertions(+), 13 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > > > > index 078feda47e36..9ce2128eea3e 100644
> > > > > > --- a/fs/ext4/ext4.h
> > > > > > +++ b/fs/ext4/ext4.h
> > > > > > @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
> > > > > >   #ifdef CONFIG_FS_ENCRYPTION
> > > > > >   	struct fscrypt_inode_info *i_crypt_info;
> > > > > >   #endif
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
> > > > > > +	 * and truncate-up operations. These parameters are used only in the
> > > > > > +	 * iomap buffered I/O path.
> > > > > > +	 */
> > > > > > +	ext4_lblk_t i_ordered_lblk;
> > > > > > +	ext4_lblk_t i_ordered_len;
> > > > > > +	wait_queue_head_t i_ordered_wq;
> > > > > >   };
> > > > > >   /*
> > > > > > @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
> > > > > >   			     __u64 len, __u64 *moved_len);
> > > > > >   /* page-io.c */
> > > > > > +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
> > > > > > +
> > > > > >   extern int __init ext4_init_pageio(void);
> > > > > >   extern void ext4_exit_pageio(void);
> > > > > >   extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> > > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > > index e013aeb03d7b..11fb369efeb1 100644
> > > > > > --- a/fs/ext4/inode.c
> > > > > > +++ b/fs/ext4/inode.c
> > > > > > @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
> > > > > >   {
> > > > > >   	struct iomap_ioend *ioend = wpc->wb_ctx;
> > > > > >   	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
> > > > > > +	ext4_lblk_t start, end, order_lblk, order_len;
> > > > > >   	/*
> > > > > >   	 * After I/O completion, a worker needs to be scheduled when:
> > > > > > @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
> > > > > >   	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
> > > > > >   		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> > > > > > +	/*
> > > > > > +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
> > > > > > +	 * handling and must not be merged with regular I/O operations.
> > > > > > +	 */
> > > > > > +	order_len = READ_ONCE(ei->i_ordered_len);
> > > > > > +	if (order_len) {
> > > > > > +		/*
> > > > > > +		 * Pair with smp_store_release() in ext4_block_zero_eof().
> > > > > > +		 * Ensure we see the updated i_ordered_lblk that was written
> > > > > > +		 * before the release store to i_ordered_len.
> > > > > > +		 */
> > > > > > +		smp_rmb();
> > > > > > +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
> > > > > > +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
> > > > > > +		end = EXT4_B_TO_LBLK(ioend->io_inode,
> > > > > > +				     ioend->io_offset + ioend->io_size);
> > > > > > +
> > > > > > +		if (start <= order_lblk && end >= order_lblk + order_len) {
> > > > > 
> > > > > Hi Zhang,
> > > > > 
> > > > > I guess this check is enough cause ordered_lblk and ordered_len will
> > > > > always be  contained in a single block.
> > > > 
> > > > Yeah.
> > > > 
> > > > > 
> > > > > > +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> > > > > > +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
> > > > > > +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
> > > > > 
> > > > > FWIU, we are wanting the ordered IO to not be merged and submitted asap
> > > > > since we want to wake up the waiters. Is there any other reason?
> > > > 
> > > > My original intention was to prevent the loss of the
> > > > EXT4_IOMAP_IOEND_ORDER_IO flag during worker processing triggered by I/O
> > > > completion, which could be caused by merging an ordered ioend with a
> > > > normal ioend.  In patch 19, we need to determine the flag to update
> > > > i_disksize to the correct position.
> > 
> > Ahh okay, we don't want the flag to be lost.
> > 
> > > > 
> > > > > 
> > > > > Adding the boundary in ->writeback_submit() only affects
> > > > > iomap_ioend_can_merge() which happens after we have woken up the waiters
> > > > > and deferred the IO to the wq. We ideally want it affect
> > > > > iomap_can_add_to_ioend() ie we need to add IOMAP_F_BOUNDARY in
> > > > > ->writeback_range().
> > > > 
> > > > IIUC, merging into the same ioend during the submission stage doesn't
> > > > seem to cause any problems.
> > 
> > Got it since the flag is set later. I was thinking we want to quickly
> > issue the ordered IO to wake up the waiters and not waste time trying to
> > merge it and hence we wanted to use that flag.
> > 
> > > > 
> > > > > 
> > > > > Secondly, I don't think boundary is the right flag here. It ensures
> > > > > that everything before the ordered iomap gets submitted and the ordered
> > > > > iomap starts a new ioend. This can still keep getting merged with the
> > > > > newer ioends untils we decide to submit the IO, which can delay waking
> > > > > up the waiters. If we really want the "no merge" behavior, we'll have to
> > > > > do something like [1] (Check the 2 NOMERGE flag patches).
> > > > 
> > > > Yeah, IOMAP_IOEND_BOUNDARY appears to be just a one-way barrier and
> > > > still cannot prevent merging. I missed this, thank you for pointing this
> > > > out. However, I think perhaps we should change iomap_ioend_can_merge()
> > > > to check the iomap_ioend->io_private. Something like:
> > > > 
> > > > 	if (ioend->io_private || next->io_private)
> > >              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >              ioend->io_private != next->io_private
> > 
> > I guess if the purpose is to just not lose the flag, then boundary seems
> > to work for because we only lose the flag if ordered ioend backward
> > merges to a prev one. Flag is retained if we forward merge. Which
> > boundary seems to take care of.
> > 
> Yes, IOMAP_IOEND_BOUNDARY is indeed worked currently as it prevents flag
> loss. However, from the perspective of the iomap infrastructure, I
> believe it is still necessary to add the ioend->io_private !=
> next->io_private check. Because ioends with different io_private values
> should not be merged, as this carries the risk of potentially losing
> io_private or even memory leaks. With this check in iomap, we would no
> longer need IOMAP_IOEND_BOUNDARY.

I agree that even outside this patchset it seems like a sane thing to
do.
> 
> > However, if we want to avoid merges so we can quickly issue IO and wake
> > up the waiters then the above change looks good. Also, if this is the
> > reason we'd also want to have this during submission stage so the flag
> > setting will probs have to move to ->wirteback_range()
> 
> Yes. Issuing ordered I/O as soon as possible is beneficial as it reduces
> the latency of sync file range. Suppose when we are syncing data beyond
> the ordered range, the background writeback process has already started
> committing and bundled the ordered range into a large ioend (up to
> IOEND_BATCH_SIZE folios), then this sync operation will indeed
> experience significant latency. However, for other non-sync scenarios,
> there should be little benefit.
 
 Yes that's true.

> 
> But I'm not sure if this is strictly necessary, because in the existing
> implementation, issuing ordered I/O via data=ordered mode works the same
> way — it also doesn't issue ordered I/O as soon as possible, and still
> has to wait when encountering concurrent background writeback. So I
> think we can keep the current implementation for now and see user
> feedback to decide whether further optimization is needed.

I agree!

Thanks,
ojaswin
> 
> Cheers,
> Yi.
