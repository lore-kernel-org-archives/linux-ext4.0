Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3214369981;
	Tue,  2 Jun 2026 10:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780396014; cv=none; b=Z2bcay3fBLy38q6cxf6ct0sYBy85kH9Ss0GIVkQTAAbNWSK2sjRNLto3uPaczJBzegJoYGxAXlHNrhcDfvI+CP2IqFi/iBUEN8gi0Vg+0UA7k2hqON8/O+dsFfjnx/qWssbvELJ0rEGZAHyB+uqUtCzwsb+xGFofi9/CKY78yqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780396014; c=relaxed/simple;
	bh=MwlDZi2iKGVkeBWNtHSagby5Ga4firoZK2dVGFzD22I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEgRiB3zDtI/ylqzHqsK6PongrIhOxww4yjxdp0F5rXrpkWx1G0B66pPAyPZdPp5jZyUVn+CM1PXe96tAjuR1wvjgopLfQtsbm3AvBn3JF0ZHsgp4X4Thri8KeJhqSkO7ViTsUW1x/dqDjAwpwsK3yMmQr3oUB78yTpxPuTrW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZagVGgN1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZagVGgN1"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65263JUY1796433;
	Tue, 2 Jun 2026 10:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=MRaNn60ZAKYhm+11xCblO+Hnd8GOgS
	l3W9oyGCfQ+CQ=; b=ZagVGgN1EWUsbOlAjD6SF2W0egjN2b03wCYHDKKbwFm3/V
	wWV9QlqhvECW471MCfmuq1wF1zSglXFOfF9K6BB6EnBJKq6WyyjgabfPCOBG7chF
	85ZVNxffJqr1qgct8TT7obIqqNQ/+vStoyAEOct4lAhU7EmeP4dKwo+Ly5FeQrcQ
	hOBpdrkLyuyA9EfcK+vruAiEKf2i98GN+5P7Y7kYv0GQ8O16NN7WLPY2xkYltvwM
	JA3w6OFa9PFEhHmUR9VkVi/NUsN9mQLqnvNDzJ8X4++DXfwpDDj8o02ztcAZeBBK
	wP5gNr1rrajFn64qPordQjYtiiE+2tcMlUqGlgVA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqht4w3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 10:26:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 652AO9Ci031352;
	Tue, 2 Jun 2026 10:26:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4egcegjgmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 10:26:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 652AQFcn40305142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 10:26:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 882622004B;
	Tue,  2 Jun 2026 10:26:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11D2420043;
	Tue,  2 Jun 2026 10:26:12 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jun 2026 10:26:11 +0000 (GMT)
Date: Tue, 2 Jun 2026 15:56:09 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
Message-ID: <ah6vwa_MytxBN-Z8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-9-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: d_Ri6FMGLZ9SjP7n5BHUWbUsjVmdNMsJ
X-Authority-Analysis: v=2.4 cv=fv/sol4f c=1 sm=1 tr=0 ts=6a1eafca cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=qXLxl3cedWcfp2LA9c0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA5NiBTYWx0ZWRfX5l8hMzTB0dUy
 u8xt/BwxVnHCmFfIpMC/kFSkCneIctGr2OeJQrE1zqL5LayvaUZ0HF6ViprPF77VXKSDtDlUyGa
 GG++ATJVw+r8JX1ba4x4Pf3enBBrcPvMGyI/v4Iz+aZLmnKLZWUk+D2Arl3XElF2QluZeYBtnm2
 j/SCjd7Kfb9GVH4+gU6nMV/Oit82njxcV4nu+0UeIr7gKYUdXiql2iXmwRwyu+7CTb0GuCPcB5b
 xMtSUOjVS0YXunYjVVVhLbrvGkUoUCzqQ9lLucdPhoxESS3NYPgmnzdj58j3fTAynzt+N8Tt3kP
 siNA4lLqjcIceLUtkhPEcpWba/FehZdkS8wGFhIrgsGynSmXsPoQYmyH/GYZ+zu+fYERrxn9Tp1
 aiLdANbK96E4NOy3s7YOwZfPQD3l8cvkK+DSFdnE2+hgtmDe77+KwgrHBU2JRPk7I4Xs56z1CzY
 Qs3QVIuFXAcF2De5ukw==
X-Proofpoint-ORIG-GUID: 2hGv6OznHK1ZRgZimwtM1bF03wSomzmn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020096

On Mon, May 11, 2026 at 03:23:28PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce two new iomap_ops instances for ext4 buffered writes:
> 
>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>    ext4_da_map_blocks() to map delalloc extents.
>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>    ext4_iomap_get_blocks() to directly allocate blocks.
> 
> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
> validity.
> 
> Key changes and considerations:
> 
>  - Unwritten extents for new blocks (dioread_nolock always on)
>    Since data=ordered mode is not used to prevent stale data exposure in
>    the non-delayed allocation path, new blocks are always allocated as
>    unwritten extents.
> 
>  - Short write and write failure handling
>    a. Delalloc path: On short write or failure, the stale delalloc range
>       must be dropped and its space reservation released. Otherwise, a
>       clean folio may cover leftover delalloc extents, causing
>       inaccurate space reservation accounting.
>    b. Non-delalloc path: No cleanup of allocated blocks is needed on
>       short write.
> 
>  - Lock ordering reversal
>    The folio lock and transaction start ordering is reversed compared to
>    the buffer_head buffered write path. To handle this, the journal
>    handle must be stopped in iomap_begin() callbacks. The lock ordering
>    documentation in super.c has been updated accordingly.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

I went through this again and after our discussion the changes looks
okay. Just a small quesiton below but otherwise feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

> ---
>  fs/ext4/ext4.h  |   4 ++
>  fs/ext4/file.c  |  20 +++++-
>  fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext4/super.c |  10 ++-
>  4 files changed, 192 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1e27d73d7427..4832e7f7db82 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
>  int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>  				struct buffer_head *bh);
>  void ext4_set_inode_mapping_order(struct inode *inode);
> +int ext4_nonda_switch(struct super_block *sb);
>  #define FALL_BACK_TO_NONDELALLOC 1
>  #define CONVERT_INLINE_DATA	 2

<snip>

> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	return 0;
> +}
> +
> +static int ext4_iomap_buffered_write_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> +						  iomap, srcmap, false);
> +}
> +
> +static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> +						  iomap, srcmap, true);
> +}
> +
> +/*
> + * On write failure, drop the stale delayed allocation range and release
> + * its reserved space for both start and end blocks. Otherwise, we may
> + * leave a range of delayed extents covered by a clean folio, which can
> + * result in inaccurate space reservation accounting.
> + */
> +static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
> +				     loff_t length, struct iomap *iomap)
> +{
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
> +			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +}
> +
> +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
> +					    loff_t length, ssize_t written,
> +					    unsigned int flags,
> +					    struct iomap *iomap)
> +{
> +	loff_t start_byte, end_byte;
> +
> +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
> +	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))

Will we ever get IOMAP_F_NEW here? I think the da_write_begin() call
either creates a new IOMAP_DELALLOC extent or finds older ones which
won't have EXT4_MAP_NEW set

> +		return 0;
> +
> +	/* Nothing to do if we've written the entire delalloc extent */
> +	start_byte = iomap_last_written_block(inode, offset, written);
> +	end_byte = round_up(offset + length, i_blocksize(inode));
> +	if (start_byte >= end_byte)
> +		return 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
> +				     iomap, ext4_iomap_punch_delalloc);
> +	filemap_invalidate_unlock(inode->i_mapping);
> +	return 0;
> +}
