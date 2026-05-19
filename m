Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21FF26CE32;
	Tue, 19 May 2026 05:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779168457; cv=none; b=gU1CsqJlQsme3OXdSuQ3XxW9qbOKDSS6En+z9F93RsZi1I9IAdmxYN3gWaeCvdi5bPq2R4vNR26GpI+U6bv8K4Q5hjjQMV/VGgN2wnDXLNL9FTg+9J0qVnzb/O+DOa3cliSCfHYwcCLzSCxuWto+PFkq7pR0qBS6zduqy9OzWxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779168457; c=relaxed/simple;
	bh=m/+ciBMHqRg6iC/PpzDfyMJadbRSdC62tYBUYjBN9+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtR4i2+0MDDnWFARaXcmQaV30+2WKKFpwwxCcs03HsyZU7CYSq1Z8OaGDx8oT7pwVd9BAAimBlqFv4Ssmsyncf0YMapYHIxxo9KUbqvCQ/ygSb6Lf8gStgnwK2LMXpPSl1P0fxaj4fWKmI/QcIxZBVMn3Twb0IYoyfkWwLXewUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pPobGNCC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pPobGNCC"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IG4Mat3300127;
	Tue, 19 May 2026 05:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wMuFJ7YFnR4VJ5K1YoIbmpQVZEn1oM
	v2us1dBHH22nE=; b=pPobGNCCdMJgZKXw1Ir2DFe+NIHGNkT/SU3ZI10TmViFDD
	zPWk5UHbYR3vntc7RklxV6JAqSn1V3h3Hpos3gTdRWCE+zOHjC6yFCaUMWhPAiPq
	uITUoFHF92u5H/GlYdNp8+13o99DlsCXUbr9k1WHmACi4Gn3X0ReIr2ldOVb9gXj
	aLwHbJCNx8rhCq0/6t22AZWkyIIWx4V2uXDcTLlDB5mDxHMN/GnDFNDbBI2hS4v+
	fiOYwzkLzey/1lbPCEGTzZFx9ITnIxisIbvUP00Z/rs7LwvV7+M491Mfx/nSGFuu
	dBw4pWe6rSucCUE53ZebvVxVmFpdS8a6g87Sx+Ug==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mkaew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 05:25:51 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J5OY2D024326;
	Tue, 19 May 2026 05:25:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739vs8kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 05:25:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J5Pmfr52494840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 05:25:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92DA120040;
	Tue, 19 May 2026 05:25:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3754120043;
	Tue, 19 May 2026 05:25:41 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.191])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 05:25:40 +0000 (GMT)
Date: Tue, 19 May 2026 10:54:34 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 01/23] ext4: simplify size updating in ext4_setattr()
Message-ID: <agv0Ehrk2t7EpW6w@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-2-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: lKYbcljLORpBuyyU_z3S0dKXNZP838pZ
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0bf460 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=3NWl43M1H4cGl_gAuZsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: JarRJJa-82URVMn6qgkqGRrGHkIEJv9Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA0NyBTYWx0ZWRfXyapmj49rG1gQ
 EuhQatZbd/pggu9NReGP9HbRwavi4V9OVs4iFUsS0kdR9Ezw0c0eVuLwWe1E/5FEc/EoQKQ2w42
 1y47Cg8WG/Njcq2w7EWUr2AgLjO6/ZeQXew4NjdDlxj6x+SHXHo84oUKnyHNDU7Vzdeid0lzF3b
 qLsnoCGlBLKHMLPNE34XWwmrgIcb0l1wMSWRGyjjhMr8spXBGN0/Dy3uRAF0heu3/SKjLfqWcC2
 oCoZYMeg66pTmSliU4vMU/Tpfe7NkuY0UO5eFUCwswa2HSluBm3lMAC3lYH0egi1Qk42XvX/PX3
 XleAth2UhIajcwHmsi5HGhJnnfR3AgLKPbzPs++pC6aTw8Z20Y4cBt3oML/9JPt7mqoLY7ioVZ2
 mFtMvouj4g0s2K6CQmt743YM0hy7TgtD+mDxgnXpWFRsTL6/l8BpCPXZv3d0ChspqmXFfoVvrHH
 SnUauORlrD4rUBIU8jQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1011 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190047

On Mon, May 11, 2026 at 03:23:21PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The logic for updating the file size in ext4_setattr() is currently
> somewhat messy. By directly entering the error-handling path after
> failing to add an orphan inode, the unnecessary recovery process
> involving old_disksize and the file size can be avoided.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

> ---
>  fs/ext4/inode.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..0751dc55e94f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5953,7 +5953,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (attr->ia_valid & ATTR_SIZE) {
>  		handle_t *handle;
>  		loff_t oldsize = inode->i_size;
> -		loff_t old_disksize;
>  		int shrink = (attr->ia_size < inode->i_size);
>  
>  		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> @@ -6037,6 +6036,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  			if (ext4_handle_valid(handle) && shrink) {
>  				error = ext4_orphan_add(handle, inode);
>  				orphan = 1;
> +				if (error)
> +					goto out_handle;
>  			}
>  
>  			if (shrink)
> @@ -6052,23 +6053,18 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
>  					inode->i_sb->s_blocksize_bits);
>  
> -			down_write(&EXT4_I(inode)->i_data_sem);
> -			old_disksize = EXT4_I(inode)->i_disksize;
> -			EXT4_I(inode)->i_disksize = attr->ia_size;
> -
>  			/*
>  			 * We have to update i_size under i_data_sem together
>  			 * with i_disksize to avoid races with writeback code
> -			 * running ext4_wb_update_i_disksize().
> +			 * updating disksize in mpage_map_and_submit_extent().
>  			 */
> -			if (!error)
> -				i_size_write(inode, attr->ia_size);
> -			else
> -				EXT4_I(inode)->i_disksize = old_disksize;
> +			down_write(&EXT4_I(inode)->i_data_sem);
> +			i_size_write(inode, attr->ia_size);
> +			EXT4_I(inode)->i_disksize = attr->ia_size;
>  			up_write(&EXT4_I(inode)->i_data_sem);
> -			rc = ext4_mark_inode_dirty(handle, inode);
> -			if (!error)
> -				error = rc;
> +
> +			error = ext4_mark_inode_dirty(handle, inode);
> +out_handle:
>  			ext4_journal_stop(handle);
>  			if (error)
>  				goto out_mmap_sem;
> -- 
> 2.52.0
> 
