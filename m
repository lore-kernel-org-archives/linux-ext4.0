Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949BA34750E;
	Wed, 27 May 2026 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887726; cv=none; b=aze9p5cuR0J9mfnceZLFIT88RnPhZqk4GhbzpYXIVQXd8eFuv4D0XTtgTJHMHTGyr1KfvZf4/KFx/1SEcz+zYO53SxklRh4n5Vjru9YqEUkhc/8eA/YAAGtsAnyLajtNnVN9iF2hpS5m0P7CY1evLXddXsAaPTJ5lz2jy4PRpmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887726; c=relaxed/simple;
	bh=Jm2pneVohwVy0yEiPXS4kBDWDp7CeKhsTOMS1RoMG1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9lB/PEuL6PfxG610FtAQIhN48AumWod7WJ+dYwU30Q6/w8RDyU4WbA7dr2wJitjl0fys6rfNy3FPMS/zkfzWv2Pnhbgwbc/1Vaua7d4KWcr4c8P9BrVSJ4YLOJNPvykJJVJ5MI8951iNsF4BRZBaXFy2ScbENUe5v5AE61ZDUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CtR7bHcT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CtR7bHcT"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RDDUiV3595371;
	Wed, 27 May 2026 13:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=sn8HExIJV+uioXCHBHmRXysmtN4ZMB
	2jO7HWMViOHRI=; b=CtR7bHcT53huKyqK0DHNOgmbsDbW2z5MSYd2PHKZratDBi
	TWtIc8LGvHqhyRZfw5v0ldf1Ng4Q3dGwYHUE0r2tuU4JZ+uXl4MyBoETdJrw//Kl
	S/z3Q/24stJB/fWwXmHth7YNm/CIw01D6tXUUPQ9TgqF5CzstMjK8UZYDpwbVzAW
	CzaxoGOaaLO2zK+YDwPMd9Hk6BESrIqXllNJFQbVeYoUXPhtFzPPi/ej1h7/DkBT
	c3tc4Qr2bLbi2p+d77/dDKZSmO+RunAOtLrsnMcb8ewJxwWkZhN0EC/YR9724y1p
	UMOJROw7Fft8BBoLBak4TkR9b/xRhx5sI7/E/w2w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4s2hdwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:14:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64RD98v6005071;
	Wed, 27 May 2026 13:14:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4edjrb348p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:14:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64RDEqOw50856288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 13:14:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D0D720043;
	Wed, 27 May 2026 13:14:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 088CD20040;
	Wed, 27 May 2026 13:14:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.21.79])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 May 2026 13:14:46 +0000 (GMT)
Date: Wed, 27 May 2026 18:44:43 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 16/23] ext4: disable online defrag when inode using
 iomap buffered I/O path
Message-ID: <ahbuQxLq9StWCzSx@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-17-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-17-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: _TS2aTRDYvvq3lksI0AMgpCQQHu1BWmV
X-Authority-Analysis: v=2.4 cv=Sq2gLvO0 c=1 sm=1 tr=0 ts=6a16ee4f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=ZvFAdT02YJFtCQ7zTEYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDEyOCBTYWx0ZWRfX+U1vWx7YB/mW
 kcW788LPsnHF21Sgad2xSVwwHkjP9ZE4QfZ92iG0I4rBE9p1lVRMXDN6m0zNL/J/2x32+4euL+W
 ifGP8/BG1JWa0S5DRo/AAOqVGvwtoLs9Ujckm6G+DHeLsVBfEqUgIFfVNpdM5XyqasBBluzGHZr
 uNu5h/qrsNuWN42S2/whUYMRGEnX42cPD+zxEYlNKuE2P9PX5Jcsqd319n3e1cEZNXGnQAbB6OA
 D6QnRqP3sMUz046dm7GRJTGIXCcLrTysN6ZGhEhPKBkuvRXD7HC91k3a611ZmLmt0W++cLE5tks
 U31xzl49W0GHVNxLc4Y4huYtnj90NfBd9esjuvZ9/TShdRfACZJzBkRvbYn7u+Gq8Mq2ZUa052Y
 OlTneqaJBRcbwbUIAeAK9FZHMSNVLQph/dxcN2ePJpRleCxcbB+H+/+p690xy5a/kS1dnqLZTXs
 bu7aq5cBsdHTZqXsEdw==
X-Proofpoint-ORIG-GUID: Wjuas53mjPm0mGxQx_wLlUoqyZ--IS2F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605270128

On Mon, May 11, 2026 at 03:23:36PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Online defragmentation does not currently support inodes using the
> iomap buffered I/O path. The existing implementation relies on
> buffer_head for sub-folio block management and data=ordered mode for
> data consistency, both of which are incompatible with the iomap path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> ---
>  fs/ext4/move_extent.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 3329b7ad5dbd..f707a1096544 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -476,6 +476,17 @@ static int mext_check_validity(struct inode *orig_inode,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	/*
> +	 * TODO: support online defrag for inodes that using the buffered
> +	 * I/O iomap path.
> +	 */
> +	if (ext4_inode_buffered_iomap(orig_inode) ||
> +	    ext4_inode_buffered_iomap(donor_inode)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Online defrag not supported for inode with iomap buffered IO path");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
>  		ext4_debug("ext4 move extent: suid or sgid is set to donor file [ino:orig %llu, donor %llu]\n",
>  			   orig_inode->i_ino, donor_inode->i_ino);
> -- 
> 2.52.0
> 
