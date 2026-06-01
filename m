Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05F63ECBC8;
	Mon,  1 Jun 2026 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780338883; cv=none; b=Q0z2yi5PAzeS634KuF5qIWQv2UvMioAVDO78LbGroeRYtqy+hh1XLfRsUwmpBS9KKqgJjLL4js/lr0O8nO16N6rI1OFhyFXpTYNqjLxz4kxyLuAqFqMj6WsD4GKx/FSh3wH8OUzqsWnu2QdTDgqG8Zv4xxXashJaH/DdsJG+Ozg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780338883; c=relaxed/simple;
	bh=Vb3QVncyXpEABKFZDbT0zP8yS34KsWKDgVkXhwZgQn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyOq2tUi1dl53K2tDZ5ifXUcyU+UGjyX+ZGiFzAMLrzAAvmhzVJaqCAMBxRaovbNtQxtzwORzSXY//Asd+2medI/m3Erp7ryLJlOnvplBeK+Tv+uJfGBz+jHYMixW32s2uLHQ1WzO6y3ol+0X0GmCJcpuPdtRvvNcNb84fbiZVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NmEgkEqP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NmEgkEqP"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651CxDQ3432511;
	Mon, 1 Jun 2026 18:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=CoS2t9FWQe3w6Tmvlkt4RmgXJtg2gw
	crfopRBOjVSXo=; b=NmEgkEqPUZ/raEb7gwxL+Os/synkosfteK5IgEkfHwsyPA
	z5ZjmW6YnRrN4yWz2nPSpKd9zEPCio5asZzgpGoEXKR46MRbjz+6alqDYYnWVvYV
	t7Tou+ZCuM1h+0/zxkR+W/dcjYRb86UD9Sxc/wcL1rJHve9PkTr3SCLgVQd6nMeG
	zhQjbqqYh+LrKJ+eXjGQi9UvE7xchVYuSDRyr8f8BFWKUJHvz7hcN3jTgpYsaHmo
	6kBT9uga1pS1rTY7kMkfkZOIyXtIghDOrdUqJytnCiEcBnI1QSBZdllKKCfkHLt7
	kfyDdG37HJTeuaoDknF2B2fJ4IKR4ivIVkDO+Tvg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqht1wnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 18:34:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 651IO5kw022587;
	Mon, 1 Jun 2026 18:34:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4egcwy78rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 18:34:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 651IY35U27787596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jun 2026 18:34:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 621762004B;
	Mon,  1 Jun 2026 18:34:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 459C320040;
	Mon,  1 Jun 2026 18:33:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.223.138])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jun 2026 18:33:58 +0000 (GMT)
Date: Tue, 2 Jun 2026 00:03:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yizhang089@gmail.com,
        yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <ah3QlCt8V-3kVzW8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <5d2b13b9-d5a0-47ce-876c-ab01070cbe49@huaweicloud.com>
 <81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: u2CXg1WEQKwXnIinaJkCrBKYLh5_jwdt
X-Authority-Analysis: v=2.4 cv=fv/sol4f c=1 sm=1 tr=0 ts=6a1dd09e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=i0EeH86SAAAA:8
 a=Ngc2ckDU2DJgTStnhh0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE3OSBTYWx0ZWRfX5YAPf/onJPpH
 ryfEYx56t9nch1ET1l1UriA6/m6sSKI2KQ8IqvmQ7nuaKQuznU5OqYQkcDb7yaG5CmHUqwug/zM
 HKXZNvY8NMFVx8SBDI5Fro88bXLiTq0I6Z9WdGQFw/o8O57UxZRXn7U8nZ0ZnA14oqB8cDx335p
 g4sPcFI4IVcxX+ci5Iketuwjwx1sKD5eweu9U/2nwkRkpCtY1D+eMxeQyZrYXuT8JVZ1+3yrIN0
 0TuQlRSpqtVlq/L1EWlkEqQ3yIoA0KFTPH+D0wzqcLdfD9U0zQYK5LsO6KBOZArUjdrDv4vqmGz
 Wi1M2ENXhAic9uY0Us3pm3PwXXJzb7l8UAxzCguEUbKD+J+IedUHUwdm/xB2MLEcd1b2E5JDkse
 XuBwy4S8WMmhpFeYO+CiYSYR+2WLWMBND4L2SlJDEFA5AuXqIfp+GU+yl9KXKSBzRyqB3cP0smF
 R6bGIqsvv2IFtzkiO0g==
X-Proofpoint-ORIG-GUID: aTyBLX-YjW489PZMRNTUVWscdGwZHoqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_05,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010179

On Sat, May 30, 2026 at 04:24:24PM +0800, Zhang Yi wrote:
> On 5/30/2026 3:22 PM, Zhang Yi wrote:
> > Hi, Ojaswin!
> > 
> > On 5/27/2026 11:58 PM, Ojaswin Mujoo wrote:
> >> On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
> >>> From: Zhang Yi <yi.zhang@huawei.com>
> >>>
> >>> For append writes, wait for ordered I/O to complete before updating
> >>> i_disksize. This ensures that zeroed data is flushed to disk before the
> >>> metadata update, preventing stale data from being exposed during
> >>> unaligned post-EOF append writes.
> >>>
> >>> Suggested-by: Jan Kara <jack@suse.cz>
> >>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >>> ---
> >>>  fs/ext4/ext4.h    | 11 +++++++
> >>>  fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
> >>>  fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
> >>>  fs/ext4/super.c   | 23 ++++++++++----
> >>>  4 files changed, 161 insertions(+), 13 deletions(-)
> >>>
> >>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >>> index 078feda47e36..9ce2128eea3e 100644
> >>> --- a/fs/ext4/ext4.h
> >>> +++ b/fs/ext4/ext4.h
> >>> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
> >>>  #ifdef CONFIG_FS_ENCRYPTION
> >>>  	struct fscrypt_inode_info *i_crypt_info;
> >>>  #endif
> >>> +
> >>> +	/*
> >>> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
> >>> +	 * and truncate-up operations. These parameters are used only in the
> >>> +	 * iomap buffered I/O path.
> >>> +	 */
> >>> +	ext4_lblk_t i_ordered_lblk;
> >>> +	ext4_lblk_t i_ordered_len;
> >>> +	wait_queue_head_t i_ordered_wq;
> >>>  };
> >>>  
> >>>  /*
> >>> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >>>  			     __u64 len, __u64 *moved_len);
> >>>  
> >>>  /* page-io.c */
> >>> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
> >>> +
> >>>  extern int __init ext4_init_pageio(void);
> >>>  extern void ext4_exit_pageio(void);
> >>>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> >>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >>> index e013aeb03d7b..11fb369efeb1 100644
> >>> --- a/fs/ext4/inode.c
> >>> +++ b/fs/ext4/inode.c
> >>> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
> >>>  {
> >>>  	struct iomap_ioend *ioend = wpc->wb_ctx;
> >>>  	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
> >>> +	ext4_lblk_t start, end, order_lblk, order_len;
> >>>  
> >>>  	/*
> >>>  	 * After I/O completion, a worker needs to be scheduled when:
> >>> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
> >>>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
> >>>  		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> >>>  
> >>> +	/*
> >>> +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
> >>> +	 * handling and must not be merged with regular I/O operations.
> >>> +	 */
> >>> +	order_len = READ_ONCE(ei->i_ordered_len);
> >>> +	if (order_len) {
> >>> +		/*
> >>> +		 * Pair with smp_store_release() in ext4_block_zero_eof().
> >>> +		 * Ensure we see the updated i_ordered_lblk that was written
> >>> +		 * before the release store to i_ordered_len.
> >>> +		 */
> >>> +		smp_rmb();
> >>> +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
> >>> +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
> >>> +		end = EXT4_B_TO_LBLK(ioend->io_inode,
> >>> +				     ioend->io_offset + ioend->io_size);
> >>> +
> >>> +		if (start <= order_lblk && end >= order_lblk + order_len) {
> >>
> >> Hi Zhang,
> >>
> >> I guess this check is enough cause ordered_lblk and ordered_len will
> >> always be  contained in a single block.
> > 
> > Yeah.
> > 
> >>
> >>> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> >>> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
> >>> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
> >>
> >> FWIU, we are wanting the ordered IO to not be merged and submitted asap
> >> since we want to wake up the waiters. Is there any other reason?
> > 
> > My original intention was to prevent the loss of the
> > EXT4_IOMAP_IOEND_ORDER_IO flag during worker processing triggered by I/O
> > completion, which could be caused by merging an ordered ioend with a
> > normal ioend.  In patch 19, we need to determine the flag to update
> > i_disksize to the correct position.

Ahh okay, we don't want the flag to be lost.

> > 
> >>
> >> Adding the boundary in ->writeback_submit() only affects
> >> iomap_ioend_can_merge() which happens after we have woken up the waiters
> >> and deferred the IO to the wq. We ideally want it affect
> >> iomap_can_add_to_ioend() ie we need to add IOMAP_F_BOUNDARY in
> >> ->writeback_range().
> > 
> > IIUC, merging into the same ioend during the submission stage doesn't
> > seem to cause any problems.

Got it since the flag is set later. I was thinking we want to quickly
issue the ordered IO to wake up the waiters and not waste time trying to
merge it and hence we wanted to use that flag. 

> > 
> >>
> >> Secondly, I don't think boundary is the right flag here. It ensures
> >> that everything before the ordered iomap gets submitted and the ordered
> >> iomap starts a new ioend. This can still keep getting merged with the
> >> newer ioends untils we decide to submit the IO, which can delay waking
> >> up the waiters. If we really want the "no merge" behavior, we'll have to
> >> do something like [1] (Check the 2 NOMERGE flag patches).
> > 
> > Yeah, IOMAP_IOEND_BOUNDARY appears to be just a one-way barrier and
> > still cannot prevent merging. I missed this, thank you for pointing this
> > out. However, I think perhaps we should change iomap_ioend_can_merge()
> > to check the iomap_ioend->io_private. Something like:
> > 
> > 	if (ioend->io_private || next->io_private)
>             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>             ioend->io_private != next->io_private

I guess if the purpose is to just not lose the flag, then boundary seems
to work for because we only lose the flag if ordered ioend backward
merges to a prev one. Flag is retained if we forward merge. Which
boundary seems to take care of.

However, if we want to avoid merges so we can quickly issue IO and wake
up the waiters then the above change looks good. Also, if this is the
reason we'd also want to have this during submission stage so the flag
setting will probs have to move to ->wirteback_range()

Regards,
Ojaswin


> 
> 
> > 		return false;
> > 
> > What do you think?
> > 
> > Thanks,
> > Yi.
> 
