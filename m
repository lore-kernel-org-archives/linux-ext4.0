Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13AB274B23;
	Wed, 27 May 2026 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779886663; cv=none; b=mOIsWwODj119dOsYayzqp+ncpYRsBZHrbg9oCJ1rucxL9cjCaufg1b6GNcEzcFkvH7iYeQI8Z9/JC0OTI9ytLQMM8WVE198WsCVNkxbtV/kPehvICTymMLIfExj2mCCko4eaOESgecUet2J88/lybkvSZYw7IOOMBvUrWYNcxm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779886663; c=relaxed/simple;
	bh=mEnr730FIetw3epKUXKDcC+RMyywq4bTMRwWXJuV3YM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgaj3xcEcjHVJj/mGmTxhW8UwWJ7IDaMxYa3miLRIqvPLr0CIc4LoJqS5s3NDZ4jhB596nNphZO5pVVpKofHw+bGzSWgG/9NbcijTeOrYlG6Yb5XoDmkbWh6+iB0ewRh7MXogbsyPx7IK9fo7znlTVNym6yriwmKpBMBum/RTPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g/g9LJDP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g/g9LJDP"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RBK7ts346072;
	Wed, 27 May 2026 12:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=37xzcsbpHuPg1Y+nn795ol4ZlMyEJ3
	XZzpsrmLDROPk=; b=g/g9LJDPURA0IYNBqKV1fS1wcBAerAT1s9jpOZd0aGYovC
	duwvfAAkhBGtU9i/PJNinfsFGRKwziSmgM3ABTTwPofytH9yWcfr3dY37LgSRIgr
	GzD3YJKfqwD4MMXb2eZXZvJt5v+c7YktodCEwGGmp3bpmVAPXA/8l9TJ4U3U4F8e
	89hmdIpoWT8zy6pcLSKNpLZRcVu+TP68a9mrxeVG2wo2Jmw9rwtmyu2lB8XLvHwf
	4ApRr11f2o97dP2yccaO9mmA46HTXbVlGlDk2ppNch64PZy2JNMm405OEOpdEErY
	m4bfac+6Y+fEQemrTK5ucEfyiQiFtoZ3/eCmiYCw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nuseky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 12:57:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64RCsk3I003061;
	Wed, 27 May 2026 12:57:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4edjrb31eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 12:57:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64RCuwRc41419072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 12:56:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0F9A2004B;
	Wed, 27 May 2026 12:56:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E88B20043;
	Wed, 27 May 2026 12:56:54 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.21.79])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 May 2026 12:56:53 +0000 (GMT)
Date: Wed, 27 May 2026 18:26:51 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 10/23] ext4: implement mmap path using iomap
Message-ID: <ahbqEziyQZLV_GoH@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-11-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-11-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDEyMyBTYWx0ZWRfX3BrRIE0MoOpF
 VqZu7JKWoaBPN9M6Eh5lu/Ws4geNZtydmze6x/wbYgGjgNZIf2ox8cApbw0nB7yZliQHl6tLywV
 dm491wOKXUaDpdHc8dmK0/tktHRchEoi2/yMTJmA4F/joDAvJVbFkIMNADTyY7O7EnI9asGbtHs
 J4OqDj+8R3bqPcBjHj3HveRmgdR1//umET2n2saSYj1l+19BFYG7Kfvccbc0aIAHJgPklMu3oxy
 ZSVu/ZiZjpBx/xXlbwK+kv/8n9j9fSPkozIs69kFL9wpVqLMEbbck4UUHHHi3g0TfVgvJCeWNXp
 UhOYbx0K3VPbUmrhnjVn9rmkAWPigDj4+IKNM2V7WtZp9Dw0Fe6fm/PZyfwgenTppB5cC46jybx
 SSK9UTwZ0Pkj/+AQIc0Ye3rMo1st0KW5vWvHfS4vJTEvk44oCRWycCz/uy/nLJ+9ixTL0w8ho15
 siJ6i7nSAPkRJcarkmg==
X-Authority-Analysis: v=2.4 cv=UtJT8ewB c=1 sm=1 tr=0 ts=6a16ea1e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=f4b4VZvygqwfF3xW4tMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: jmldLGCfQaP-KTw3n7o8oyxaI-P_YB9R
X-Proofpoint-GUID: JfoSiptbPEWmjw4MFkRXK-uBh11FMYBO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270123

On Mon, May 11, 2026 at 03:23:30PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce ext4_iomap_page_mkwrite() to implement the mmap iomap path
> for ext4. The heavy lifting is delegated to iomap_page_mkwrite(), which
> only requires ext4_iomap_buffered_write_ops and
> ext4_iomap_buffered_da_write_ops to allocate and map blocks.
> 
> Note that the lock ordering between folio lock and transaction start in
> this path is reversed compared to the buffer_head buffered write path.
> The lock ordering documentation in super.c has been updated accordingly.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> ---
>  fs/ext4/inode.c | 32 +++++++++++++++++++++++++++++++-
>  fs/ext4/super.c |  8 ++++++--
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a80195bd6f20..c6fe42d012fc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4020,7 +4020,7 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>  		return -ERANGE;
>  	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>  		return -EINVAL;
> -	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
> +	if (WARN_ON_ONCE(!(flags & (IOMAP_WRITE | IOMAP_FAULT))))
>  		return -EINVAL;
>  
>  	if (delalloc)
> @@ -4080,6 +4080,14 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>  	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
>  		return 0;
>  
> +	/*
> +	 * iomap_page_mkwrite() will never fail in a way that requires delalloc
> +	 * extents that it allocated to be revoked.  Hence never try to release
> +	 * them here.
> +	 */
> +	if (flags & IOMAP_FAULT)
> +		return 0;
> +
>  	/* Nothing to do if we've written the entire delalloc extent */
>  	start_byte = iomap_last_written_block(inode, offset, written);
>  	end_byte = round_up(offset + length, i_blocksize(inode));
> @@ -7191,6 +7199,23 @@ static int ext4_block_page_mkwrite(struct inode *inode, struct folio *folio,
>  	return ret;
>  }
>  
> +static vm_fault_t ext4_iomap_page_mkwrite(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	const struct iomap_ops *iomap_ops;
> +
> +	/*
> +	 * ext4_nonda_switch() could writeback this folio, so have to
> +	 * call it before lock folio.
> +	 */
> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
> +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
> +	else
> +		iomap_ops = &ext4_iomap_buffered_write_ops;
> +
> +	return iomap_page_mkwrite(vmf, iomap_ops, NULL);
> +}
> +
>  vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
> @@ -7213,6 +7238,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>  
>  	filemap_invalidate_lock_shared(mapping);
>  
> +	if (ext4_inode_buffered_iomap(inode)) {
> +		ret = ext4_iomap_page_mkwrite(vmf);
> +		goto out;
> +	}
> +
>  	err = ext4_convert_inline_data(inode);
>  	if (err)
>  		goto out_ret;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 51d87db53543..62bfe05a64bc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -100,8 +100,12 @@ static const struct fs_parameter_spec ext4_param_specs[];
>   * Lock ordering
>   *
>   * page fault path:
> - * mmap_lock -> sb_start_pagefault -> invalidate_lock (r) -> transaction start
> - *   -> page lock -> i_data_sem (rw)
> + * - buffer_head path:
> + *   mmap_lock -> sb_start_pagefault -> invalidate_lock (r) ->
> + *     transaction start -> folio lock -> i_data_sem (rw)
> + * - iomap path:
> + *   mmap_lock -> sb_start_pagefault -> invalidate_lock (r) ->
> + *     folio lock -> transaction start -> i_data_sem (rw)
>   *
>   * buffered write path:
>   * sb_start_write -> i_rwsem (w) -> mmap_lock
> -- 
> 2.52.0
> 
