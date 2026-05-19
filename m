Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C137CD42;
	Tue, 19 May 2026 06:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779171006; cv=none; b=skHK072Anjyr1fVzltnu78gyTNDtk+4hGz7KoBXJn2hdUUxS6S9WE2t/RDPrA7CHl2SQaS7TKmpGavW28PWTdMW8FaqgF3Kj1hnxuJBjcAjTYHRyxSvtsHcZaDK8S6TvTHAF60DT/vT6b7McNjgef2Gepr3TAa0lTtBQhYLK23U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779171006; c=relaxed/simple;
	bh=kgXS0trJ/ZYRujdVg4H14UtjkIX5cAwulCXajTjtCCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvEiK3JuKoLA7a6s0izOsVcGcjOuw2yfFYLBFPYfx246OSUD17LK6AxeUTc0HrC6OPHnoxudvlkDsCWdQ8kM/sLEs2bJzVsK6zHJiC8Sqf62Cg1TGBOQtZYkhNC44GlImF273SNW2dygxapzdCM0X/7g55ZxDGLCsdfsXcBE1Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mVz5X1e4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mVz5X1e4"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IHU6RQ786951;
	Tue, 19 May 2026 06:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HbpSdB82UuMCFSHAnE2QpCj7Kf4S3p
	SzVjMoUmBbU2o=; b=mVz5X1e4XmoPc4eaOLzgvAmL+tDu8qU2n1coZkaGIcIXXH
	gwXYekJyYsf/3hm9bCGje7z4ZmWMZKWRf31vdWFy3EK4T/PAI70jH6xOc+/V8Ds/
	X1zRdD1X0eLUKSyOuLbos2vASoT5+FnXHMQwbjPAAb++ltzOyegC4AhPABQ8wcGg
	KoYGAt6liUj88JeN3h3OIGQJZRClwcPsDj+Oise9TPjiaNItjPu9X6M8fIKg1nAn
	Z/6wKoeCXD1s6Mj+bZwlXx1ZmPSG1Q71F60VwUMPZgMtaNvFFsfQh5SeT2gBwR4F
	lVpQap8f+YFokzogxa9apzPp783HgldliXno42mQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8au17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 06:09:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J69Jjj013395;
	Tue, 19 May 2026 06:09:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754g91wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 06:09:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J69KcK57016688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 06:09:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28EAB2004B;
	Tue, 19 May 2026 06:09:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5FD120043;
	Tue, 19 May 2026 06:09:16 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 06:09:16 +0000 (GMT)
Date: Tue, 19 May 2026 11:38:12 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 03/23] ext4: simplify error handling in ext4_setattr()
Message-ID: <agv-TF7_GUoslr5_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-4-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA1NyBTYWx0ZWRfX5aYlo5NisH3L
 xFQ4FtRSiZz1bEE6kZIZS2y7VGOV9WW23g5tQb4dQt2qhe75vZCCTHENIr/XSaiZb9onNKg3kmO
 +UuzTozA0JdyzItCrkkHjteBk/s/vnIRJOTcVOTByH61H8ab1Eb0oa0xKWlHW6O4sUWfMqflNGl
 qi9/FnZL6Fd1fBsamWS9MKr9zIqgPDAVaIRksjiTLhM9M5+DC1b7dGzrvqSWVJvKa8NziH2SkCl
 e40NDSSG9j5SDM9gWRs9vQ54VyI2u3wT+u21aqyYYF6FCirRLzhAqnHlVncZ1PYoqiYvpSg3+U9
 2w4i3A73G/msl2XNB41PeEUoOY1DPFG5srqN6a1Jsuav/jqsBAQP8n7PSp84R2GNS2RdV+dfh/T
 6nTYE7aWuoP9d7QEsW5LReWzMK97k5nZXTJfbI488fkiyAxJ6bRJSD3vj4RHNJfHSZ3Whrn8L/W
 MfTrFKoTKpfoOi8O/bg==
X-Proofpoint-GUID: 439GNBHzESATTpZpw3hsQ_LgwyIQ35yG
X-Proofpoint-ORIG-GUID: -hdDVd46NECFxOCaO68tRG5PBof7lZFd
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0bfe93 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=SlX1CYLIfBWmGlgmnfUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190057

On Mon, May 11, 2026 at 03:23:23PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Refactor the error handling in ext4_setattr() for better clarity:
> 
>  - Return directly on ext4_break_layouts() failure.
>  - Propagate ext4_truncate() errors using the existing error variable
>    and jump to the common 'err_out' label.
>  - Propagate posix_acl_chmod() errors also through the error variable,
>    as it theoretically does not return a non-fatal error.
> 
> With these changes, every error path either returns immediately or jumps
> to err_out. Consequently, the "if (!error)" condition guarding
> setattr_copy() and mark_inode_dirty() becomes unreachable for error
> cases. Remove this redundant check and the unused rc variable can be
> removed as well.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>


Looks good to me:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

> ---
>  fs/ext4/inode.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 35e958f89bd5..b1ef706987c3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5989,7 +5989,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> -	int error, rc = 0;
> +	int error;
>  	int orphan = 0;
>  	const unsigned int ia_valid = attr->ia_valid;
>  	bool inc_ivers = true;
> @@ -6102,10 +6102,10 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  
>  		filemap_invalidate_lock(inode->i_mapping);
>  
> -		rc = ext4_break_layouts(inode);
> -		if (rc) {
> +		error = ext4_break_layouts(inode);
> +		if (error) {
>  			filemap_invalidate_unlock(inode->i_mapping);
> -			goto err_out;
> +			return error;
>  		}
>  
>  		if (attr->ia_size > oldsize)
> @@ -6117,15 +6117,19 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		}
>  
>  		filemap_invalidate_unlock(inode->i_mapping);
> +		if (error)
> +			goto err_out;
>  	}
>  
> -	if (!error) {
> -		if (inc_ivers)
> -			inode_inc_iversion(inode);
> -		setattr_copy(idmap, inode, attr);
> -		mark_inode_dirty(inode);
> -	}
> +	if (inc_ivers)
> +		inode_inc_iversion(inode);
> +	setattr_copy(idmap, inode, attr);
> +	mark_inode_dirty(inode);
>  
> +	if (ia_valid & ATTR_MODE)
> +		error = posix_acl_chmod(idmap, dentry, inode->i_mode);
> +
> +err_out:
>  	/*
>  	 * If the call to ext4_truncate failed to get a transaction handle at
>  	 * all, we need to clean up the in-core orphan list manually.
> @@ -6133,14 +6137,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (orphan && inode->i_nlink)
>  		ext4_orphan_del(NULL, inode);
>  
> -	if (!error && (ia_valid & ATTR_MODE))
> -		rc = posix_acl_chmod(idmap, dentry, inode->i_mode);
> -
> -err_out:
> -	if  (error)
> +	if (error)
>  		ext4_std_error(inode->i_sb, error);
> -	if (!error)
> -		error = rc;
>  	return error;
>  }
>  
> -- 
> 2.52.0
> 
