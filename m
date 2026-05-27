Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C1403150;
	Wed, 27 May 2026 13:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887649; cv=none; b=eg5huHOgzAu56c6yiXyDAioEk0PBFQgGitTEuNlEq29QPThHGlk76qoc9r3J6pQoCUcA/tCKK5wtm6F3zUkOyfyTFJcM1IeCDwr8VDkaGZCfBl2vr1NANeX1vNbURIYmu2kZPQgD6Lf5JVfFudSb3DN4tcYIgzZGtrJBhE3XjA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887649; c=relaxed/simple;
	bh=fSwacII4LV4lGpI2BBhlDyZAyiiQ8kssXJNHHHZtKAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=px9DsN8xtodI9tDYikrdrQPEFKYkKMfX/Cur+DlEi5g53vZKOY//kAsJ3knd6uYLGK09cXroFzr6CH4NExqXnTUzzwnSU75ms/iuT4Qn8/XKFY/GDZFKBWbHCjA1A040SnObz+t7zD5d7rh/AitD80zERitIu6Dicv7dNFDuQnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hRHYr3Mv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hRHYr3Mv"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCaUCY346638;
	Wed, 27 May 2026 13:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HPtUAn3oyaLbsXkqO3IWjEuukx+mZn
	nYDyFXU2OjSRM=; b=hRHYr3MvlCtFXPsNh+fa6c/Sz3w66l21dLV6zJB4lbapzH
	ck24SsaQRzoalgooTCBn8O+oYoS/cfL/EI25CoCNqsS3rA4tlxZr33Yxy6XIu3UH
	eNYHLgU+KnFLohaC1zFd5aFRLChiwZ4+9udIpy21Zd0014zYAjczC9mEklUOnEI2
	b6TF/6FUw6AMqTZE8l5i/f8e540Sf/RhxtWpL9wBfKK2jmeUtqhxwtwZyEsLMzcz
	95yvnVC0COACUxYaPlqwkFs9lLAJJ+mic+879+5qwD9rE3HRylcWATTTcgMzrvyS
	ULdkwViNc7WC54Zb4vvz9x5RmHjVzT2zQj9IKC9A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nush89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:13:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64RD9Dp6021991;
	Wed, 27 May 2026 13:13:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4edjrbk49y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:13:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64RDDYY830015986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 13:13:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BE7B20043;
	Wed, 27 May 2026 13:13:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 654C720040;
	Wed, 27 May 2026 13:13:29 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.21.79])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 May 2026 13:13:29 +0000 (GMT)
Date: Wed, 27 May 2026 18:43:26 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
Message-ID: <ahbt9lyB5M7u8RNY@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-15-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-15-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDEyOCBTYWx0ZWRfXwE9UVIsqNjFF
 71ss0P9X+6nRaz+PbWSeU5xCCotRbilszFFev0ziI1L6RadrYW7EdEQ/gmkoNHExiv9ZkRsl4L4
 dblYuz9pQ8rbkVbChJHWGjt1XKuxaUZCMskFNnRPnRV8oMWqRKp1jWVsD4fWTEFNpvN1dI2pm1a
 12xQ5rHa5r4O+h9PkcCaETh6t96/JmMFzTaeumofFwQbUv/sff0VgWpagi0MDqFZehWyFIudYPG
 Elm+a4d72jo2sGmcDimM+RVFttQx4sQJ/qtb1NgwbBHFvBSvDgVVqgTpLX1/TyUC8fEYlzu9LTD
 EptZtLoqgB+/RFko3yJtUV0D/rR+sX6AHm+XBa88dgVUeGRO37bMGK+Dr9m5BlkX4AlLCTMc/x1
 x/j43dnLAGYlGgmhLoFy/jp7KZGAAo7UESobpCOz377Yhv7yMp6SmgiRS6wgrgo9X9svjkSEveO
 UxDYafNqqiNkTm8GEcw==
X-Authority-Analysis: v=2.4 cv=UtJT8ewB c=1 sm=1 tr=0 ts=6a16ee01 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=LB5iw6Uj1Savdfimc_AA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: wg6cTRaSSlu4hnG_RhUJhN1q8IwoW6Zj
X-Proofpoint-GUID: mUMkRHj3hz4zuO0M7EWNgIyfD6t9yu14
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270128

On Mon, May 11, 2026 at 03:23:34PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
> infrastructure for ext4.
> 
> ext4_iomap_block_zero_range() calls iomap_zero_range() with
> ext4_iomap_zero_begin() as the callback. The callback locates and zeros
> out either a mapped partial block or a dirty, unwritten partial block.
> 
> Important constraints:
> 
> Zeroing out under an active journal handle can cause deadlock, because
> the order of acquiring the folio lock and starting a handle is
> inconsistent with the iomap writeback path.
> 
> Therefore, ext4_iomap_block_zero_range():
> - Must NOT be called under an active handle.
> - Cannot rely on data=ordered mode to ensure zeroed data persistence
>   before updating i_disksize (for the cases of post-EOF append write,
>   post-EOF fallocate, and truncate up). In subsequent patches, we will
>   address this by synchronizing commit I/O but doesn't waiting for
>   completion, and updating i_disksize to i_size only after the zeroed
>   data has been written back.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good in itself. Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> ---
>  fs/ext4/inode.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c6fe42d012fc..e0dae2501292 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4101,6 +4101,51 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
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
> +	unsigned int iomap_flags = 0;
> +	int ret;
> +
> +	ret = ext4_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
> +		return -EINVAL;
> +
> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
> +	 * this bypasses the flush iomap uses to trigger extent conversion
> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
> +	 */
> +	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
> +		loff_t start = ((loff_t)map.m_lblk) << blkbits;
> +		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
> +
> +		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
> +		if ((start >> blkbits) < map.m_lblk + map.m_len)
> +			map.m_len = (start >> blkbits) - map.m_lblk;
> +	}
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	iomap->flags |= iomap_flags;
> +
> +	return 0;
> +}
> +
> +static const struct iomap_ops ext4_iomap_zero_ops = {
> +	.iomap_begin = ext4_iomap_zero_begin,
> +};
> +
>  /*
>   * Since we always allocate unwritten extents, there is no need for
>   * iomap_end to clean up allocated blocks on a short write.
> @@ -4616,6 +4661,47 @@ static int ext4_block_journalled_zero_range(struct inode *inode, loff_t from,
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
> +	 * TODO: The iomap does not distinguish between different types of
> +	 * zeroing and always sets zero_written if a zeroing operation is
> +	 * performed, which may result in unnecessary order operations.
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
> @@ -4642,6 +4728,9 @@ static int ext4_block_zero_range(struct inode *inode,
>  	} else if (ext4_should_journal_data(inode)) {
>  		return ext4_block_journalled_zero_range(inode, from, length,
>  							did_zero);
> +	} else if (ext4_inode_buffered_iomap(inode)) {
> +		return ext4_block_iomap_zero_range(inode, from, length,
> +						   did_zero, zero_written);
>  	}
>  	return ext4_block_do_zero_range(inode, from, length, did_zero,
>  					zero_written);
> @@ -4682,6 +4771,9 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	 * truncating up or performing an append write, because there might be
>  	 * exposing stale on-disk data which may caused by concurrent post-EOF
>  	 * mmap write during folio writeback.
> +	 *
> +	 * TODO: In the iomap path, handle this by updating i_disksize to
> +	 * i_size after the zeroed data has been written back.
>  	 */
>  	if (ext4_should_order_data(inode) &&
>  	    did_zero && zero_written && !IS_DAX(inode)) {
> -- 
> 2.52.0
> 
