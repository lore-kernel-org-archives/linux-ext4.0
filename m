Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8944C4F48;
	Wed, 30 Sep 2026 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771116; cv=none; b=FGoLh/EEZ3dpJew55c0UderSSNoQYrpC1SBLuhMtXyqy83YWaPan52+tqIlpU0JD9lu5jDG+L5K0rfb1Yz3KecMHklqPhRL1OtXu/C+mypDBz/CmNgx35OBmKBcjqpPF7c4JGoQyU8/uNc8yh8hrbW07OYQ5XDrbw1bUF7cKKgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771116; c=relaxed/simple;
	bh=gyquuLCav5FI+4Zu8a7IJQvc6hnRwO4H8m3und+syUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F363Zs7LqgiUgywE9cvFz8A7gGCUXdmLAnn4J9xvxuXwu3GEBE1R2zqJZJbBj9j2GOeaxickhb9fcaOLfCCGiQg0h7J/f1Nh6co6JJNOwxa6TO0oghk7hcvCVFovR8N5/L8Ec8edBFdcxMy9ciAfVY8G3B4qhzjFvJmgRVweSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OyKqlW3k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OyKqlW3k"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB5aac963022;
	Wed, 30 Sep 2026 12:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=IZ+CiHlFMkUEwF2p+4ptTgUPEAwu7U
	r12AVLNMkT3kY=; b=OyKqlW3kRiMPKrE7/AS30ZzU+UdDCMTTzot3AwQ9x+d/Gr
	X1FCzk/kxVPCWfBxaqsmj8soxI2borwkvkYRGOCBWcEdINrnlqzMRho8ciSYqAbI
	8x8wrXdb3gmnPweJXSYnp7P6p8XCo+ocFlb+Yet0H0nHJd82cOQ3zAHVtLSFt/tE
	ujv2IPSDv8YHdZDatMnGGiCV+CaO+Fp/kKpSB5dxIKzthR2GE0iX3tg+VGbJ6bTq
	YV8O3yfoW296KeCN3tacgJJRXabTIz+4HaaqVKcQEdNAF/6D0/uFM31ROWergBXU
	OBWKRm0sDv1lFyalaKNM2ZeKjhEToYne2IHg3mNQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qrcu2v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 12:24:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68UBHTgj3317190;
	Wed, 30 Sep 2026 12:24:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0hfpbrdx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 12:24:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68UCOJIb39715120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Sep 2026 12:24:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D04F720043;
	Wed, 30 Sep 2026 12:24:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B7252004B;
	Wed, 30 Sep 2026 12:24:14 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.112])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Sep 2026 12:24:13 +0000 (GMT)
Date: Wed, 30 Sep 2026 17:54:11 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 17/31] ext4: implement partial block zero range path
 using iomap
Message-ID: <arz_a9gLqzNHwNk4@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-18-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-18-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0OCBTYWx0ZWRfX9qZ9xC+FECz6
 D2UdRJm5oL/GAvT/zjY9WTzMGM//FNlTFQE4FFmzLRlORUvvwnupNq0cqTuCt8+49y8EreRTLwd
 oUaUPhW6nSiJeoy7+jigkYGfctIX3c4Drq6Pq6bbUEBSZ6jdav0woBDhrmgvoEiTbfp4zwuLkRs
 O3V+TPaoo67Thq//ID9lhRC00i/mi3EXJTJBZfyOZA5SSC8mEwlaZixXiqAw++hrY+oN3w3/O43
 Fgej1829uccC2SbLVVqGLuLcYUC0Sv/mPoWIIHj/Z1km6kfBf7ncvZNO9NnbW9FZZLK/Sri+NkX
 ZfxCkDldbf5Inh1Fx2/8AJQYdVqTfAua4aNa8wZSHz/gFcMpwDJNF4lthXEO0+KXh8FpTG8SbSx
 4UkDCDsd0irY1edyhFqnGPUo0y8JAkOvtm7BE4urkuatk01N5UtwHnHvJXvgavg9aZEm9cwAhgU
 fJAA4jxNi0pWXRj5+fA==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6abcff79 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=jtOtWbgMRdwqQSJcPHYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: DGmwEJlFpWDgHzxOTIGOMWfDWdi-mShl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0OCBTYWx0ZWRfX8iCpqZRTicuA
 s4KlBld0otGddPb3/mxNoIkJWiAYUpcgeHeexJ56BTaU/SJQUagj8AvqctxbCCTqS5N6vxF82mj
 KpyWNl9giZLyAhhzOxVIB12pMYdrxYk=
X-Proofpoint-GUID: GJth9UaY8KeCzF-5dwrOvAg1L2ILBOKF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609300048

On Thu, Sep 03, 2026 at 08:35:29PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
> infrastructure for ext4.
> 
> ext4_iomap_block_zero_range() calls iomap_zero_range() with
> ext4_iomap_zero_begin() as the callback. The callback locates the
> range and populates the iomap mapping. If the range is mapped,
> iomap_zero_iter() in the iomap core zeros the partial block
> directly. If the range is an unwritten extent within EOF, the
> callback collects a dirty folio batch via iomap_fill_dirty_folios()
> so that iomap_zero_iter() can zero those folios directly, bypassing
> a separate slow flush operation that would otherwise be needed to
> convert the unwritten extent.
> 
> Note that ext4_iomap_zero_begin() can race with concurrent writeback:
> after it queries an unwritten extent, writeback may convert it to
> written and complete on the folio before iomap_fill_dirty_folios() scans
> the range. The empty batch then makes iomap_zero_iter() skip zeroing,
> leaving stale on-disk data.
> 
>   zero_range                      writeback
>   ----------------------          ----------------------
>   ext4_block_zero_range()
>     iomap_zero_range()
>       iomap_iter()
>         ext4_iomap_zero_begin()
>           ext4_iomap_map_blocks()
>             -> extent is UNWRITTEN
>                                   ext4_convert_unwritten_extents_endio()
>                                     -> extent is converted to WRITTEN
>                                     -> folio is clean
>           iomap_fill_dirty_folios()
>             filemap_get_folios_dirty()
>             -> folio is clean, not added to batch
>           ext4_set_iomap() -> IOMAP_UNWRITTEN
>       iomap_zero_iter()
>         __iomap_get_folio() -> NULL (empty batch)
>         iomap_iter_advance_full()  <-- zeroing skipped
> 
>   [later read returns stale on-disk data]   <--   CORRUPTION

Hmm so I checked the xfs side of it and basically, in ext4, we check the
mapping under i_data_sem and then get the dirty/under-writeback folios
without the i_data_sem, that's what causes the race you pointed. In XFS,
we do the extent lookup and fill folios under the i_data_sem equivalent
lock. This ensures that the mapping is unwritten when iomap_fill_dirty_folio() 
is called, which means we will definitely find folios in it if they are
in dirty or locked or writeback state.

It'll be pretty intrusive to implement xfs's solution in ext4 so for now
this retry logic seems good. Further, i_es_seq is incremented before
writeback is cleared so if we find no dirty/writeback folio and the seq
count is same we can be sure that it will not have issues. So all in all
looks good. Feel free to all:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> 
> Therefore, we retry the extent lookup when iomap_fill_dirty_folios()
> adds nothing and the i_es_seq cookie captured at the first lookup has
> advanced, indicating the race actually occurred.
> 
> Other important constraints:
> 
> Zeroing out under an active journal handle can cause deadlock, as the
> lock/handle ordering is inconsistent with the iomap writeback path.
> Therefore, ext4_iomap_block_zero_range() must not be called under an
> active handle. In addition, for post-EOF zeroing, the caller cannot
> rely on data=ordered mode to persist the zeroed data before
> i_disksize is updated.
> 
> Subsequent patches will address this by deferring i_disksize update
> to i_size until after the zeroed data has been written back.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 88d9b48ee828..b876a8127d09 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4108,6 +4108,67 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> +static int ext4_iomap_zero_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
> +	struct ext4_map_blocks map;
> +	u8 blkbits = inode->i_blkbits;
> +	unsigned int iomap_flags;
> +	int ret;
> +
> +	ret = ext4_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
> +		return -EINVAL;
> +
> +again:
> +	ret = ext4_iomap_map_blocks(inode, offset, length, &map, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
> +	 * this bypasses the flush iomap uses to trigger extent conversion
> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
> +	 */
> +	iomap_flags = 0;
> +	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
> +		loff_t start = ((loff_t)map.m_lblk) << blkbits;
> +		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
> +		unsigned int count;
> +
> +		count = iomap_fill_dirty_folios(iter, &start, end,
> +						&iomap_flags);
> +		if ((start >> blkbits) < map.m_lblk + map.m_len)
> +			map.m_len = (start >> blkbits) - map.m_lblk;
> +
> +		/*
> +		 * This can be raced by a concurrent writeback that cleans
> +		 * the folio and converts the unwritten extent to written.
> +		 * Recheck the mapping after a folio lock round in
> +		 * iomap_fill_dirty_folios().
> +		 */
> +		if (count == 0 &&
> +		    map.m_seq != READ_ONCE(EXT4_I(inode)->i_es_seq))
> +			goto again;
> +	}
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	iomap->flags |= iomap_flags;
> +
> +	return 0;
> +}
> +
> +static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_zero_next, ext4_iomap_zero_begin);
> +
> +static const struct iomap_ops ext4_iomap_zero_ops = {
> +	.iomap_next = ext4_iomap_zero_next,
> +};
> +
>  /*
>   * Since we always allocate unwritten extents, there is no need for
>   * iomap_end to clean up allocated blocks on a short write.
> @@ -4569,6 +4630,48 @@ static int ext4_block_journalled_zero_range(struct inode *inode, loff_t from,
>  	return err;
>  }
>  
> +static int ext4_block_iomap_zero_range(struct inode *inode, loff_t from,
> +				       loff_t length, bool *did_zero,
> +				       bool *zero_written)
> +{
> +	int ret;
> +
> +	/*
> +	 * Zeroing out under an active handle can cause deadlock since
> +	 * the order of acquiring the folio lock and starting a handle is
> +	 * inconsistent with the iomap writeback procedure.
> +	 */
> +	if (WARN_ON_ONCE(ext4_handle_valid(journal_current_handle())))
> +		return -EINVAL;
> +
> +	/* The zeroing scope should not extend across a block. */
> +	if (WARN_ON_ONCE((from >> inode->i_blkbits) !=
> +			 ((from + length - 1) >> inode->i_blkbits)))
> +		return -EINVAL;
> +
> +	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS) &&
> +	    !(inode_state_read_once(inode) & (I_NEW | I_FREEING)))
> +		WARN_ON_ONCE(!inode_is_locked(inode) &&
> +			!rwsem_is_locked(&inode->i_mapping->invalidate_lock));
> +
> +	ret = iomap_zero_range(inode, from, length, did_zero,
> +			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
> +			       NULL);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * TODO: The iomap does not distinguish between different types
> +	 * of zeroing operations. So we always set zero_written whenever
> +	 * zeroing is performed, which may cause unnecessary folio
> +	 * flushing when zeroing occurs on delayed-allocated blocks.
> +	 */
> +	if (did_zero && zero_written)
> +		*zero_written = *did_zero;
> +
> +	return 0;
> +}
> +
>  /*
>   * Zeros out a mapping of length 'length' starting from file offset
>   * 'from'.  The range to be zero'd must be contained with in one block.
> @@ -4595,6 +4698,9 @@ static int ext4_block_zero_range(struct inode *inode,
>  	} else if (ext4_should_journal_data(inode)) {
>  		return ext4_block_journalled_zero_range(inode, from, length,
>  							did_zero);
> +	} else if (ext4_inode_buffered_iomap(inode)) {
> +		return ext4_block_iomap_zero_range(inode, from, length,
> +						   did_zero, zero_written);
>  	}
>  	return ext4_block_do_zero_range(inode, from, length, did_zero,
>  					zero_written);
> @@ -4655,6 +4761,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	 * concurrent writeback that updates i_disksize. And if such a race
>  	 * occurs, it means the previous unaligned EOF block has already been
>  	 * zeroed (if needed) and persisted to disk.
> +	 *
> +	 * TODO: In the iomap path, handle this by tracking the ordered range
> +	 * and updating i_disksize to i_size after the zeroed data has been
> +	 * written back.
>  	 */
>  	if (ext4_should_order_data(inode) &&
>  	    did_zero && zero_written && !IS_DAX(inode) &&
> -- 
> 2.52.0
> 
