Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147EC231839
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2026 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789136139; cv=none; b=SCRZxmXRwkkS5JN8GnEQxoYdDNRtgdQcl3PUt7ZygeqQ632z5Ebk4lBEA2/TT86n7i4jZDCtSK76I1P4nNCSx5aXKLGmP4r7WQlgIk8VsPnKSgJedBtHrB7mC0x5JLKOZ+RfuytS3mmVo2bwBPiU5F1IvCK+YIwXrAQuNZvS8BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789136139; c=relaxed/simple;
	bh=xTWrTtUkvF8Xwp+8XpIWHVKYzi6C3y8bcY3HPU01jDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pB+T0icmcFIXv9C/JuuGu6qb/nDfVasJWtUxv9rIsyoagstnT3X8e2+IjnViqiv6peG1NUiHXMUSrOLL7244ODs98oQEuqlauGW3BPQ8tyg72LiuY5BkONUV0tF0u+sJpkltOG8QvRAAA8V2cu/6j2dl0ezKln9zy8chEDG+CqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=omparzCk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="omparzCk"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BD1O0h1849393;
	Fri, 11 Sep 2026 14:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KRVNbRCGmNeySvSvVFutquUbtGvO3d
	asNw8n68WO4ew=; b=omparzCkc2s3qblOcnW/QYUbwBCDZIJjVbHvb+cDN77AAp
	RiOwLD2/VDugxcfZCiC0+MYdne0UO1g79HXMhbFie57zeSG5P1fQUHqFAe/x/XyA
	P0iTzAnnU14GAu1OFdwQfMNcZ1e0JsrIKMVDNdvMR4ZhfeVTi5As6K3sdGYYpQJz
	ohLGH74Ki9lb9kpXaTYvvmyEiNeqFLyNBjaczy65Pora0vELuop0+xZ2XMgkcBY0
	0qKY6gD+4y936m253YFMeWvT8gAYI6Ag17ZTSR8PQ6SQvVD2ArQCpd2Q7Kz+6vgm
	uBh9NpzmGrzu6DH9MDpFnWSOgKRZfZnnloDDC1eg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8pv0tu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 14:15:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68BCo7PE1647095;
	Fri, 11 Sep 2026 14:15:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvtfer26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 14:15:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68BEFBqG44040664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 14:15:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCBFE20043;
	Fri, 11 Sep 2026 14:15:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A082120040;
	Fri, 11 Sep 2026 14:15:09 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.241])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 11 Sep 2026 14:15:09 +0000 (GMT)
Date: Fri, 11 Sep 2026 19:45:07 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: set awu_max_opt to awu_max
Message-ID: <aqQM61h41Bvf2D00@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260910100829.2532894-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910100829.2532894-1-p.raghav@samsung.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa40cf3 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=hD80L64hAAAA:8
 a=VnNF1IyMAAAA:8 a=iD6DdYCTz8RvmU_FwZsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: qLP8FhA-wTOMoezaahbIEnw90aorqNOs
X-Proofpoint-GUID: 49reEoy6p8R2u7ZXYJzhNUkLFkqMJauL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDE5NiBTYWx0ZWRfX+rvEuCfjOwz8
 OqU1gFOl6GBCovH+SwfQj2ZLCMZvaNLA3O/O29SmZyyoqFDVFoyIzYM113mAuUN4A/KnO8mxd3C
 DkCwPYlGj40bbDgaohVoi4j0R86QX98=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDE5NiBTYWx0ZWRfXzUfEF2ooGXmb
 ZlkLcXS+lUZge+EvbTFj38vWVCJcycvtl3IRqljuILKlVVb2CJ3W/brQaVLaM4svvCdPVVYhKr3
 1KHSU4rVpycASQ4OUeMTqfuxEUE8dNKmTQRznpK0/aW9oo/br62tyziOiSAwJ2TV6zqKHOhzsYh
 ZZlp2pbPFtMwDymrW23I9dJ8auoWCVQLYu0ZxD1wp/2XdUiAzIeUkxCrKxWL1wxTq702tYDxAFH
 PMukHGnME6Q58CPb/qkzloThtN0LxlwB8VJIA7xWnb26uUb4cFnPg2F3RWGHaWVL5fRdKYyiAD9
 sRkKfXBKrl/D+Ozdb6o2+C1t29z9pMPUJSE3OeCWY5Gl+wmWwR3hdrql0wi7byyVcP4kJezOLCI
 jWQGwvwZHPRYoqQecyIwpVfOuv+JegBynpdCRMlmcS/l9W1wtolCrfwpIMhAaU3tDmbC0VJjv0i
 dWA+AFoxusP4hklIRVQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_04,2026-09-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110196

On Thu, Sep 10, 2026 at 12:08:29PM +0200, Pankaj Raghav wrote:
> commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
> added atomic write max optimal to statx. As XFS can support large atomic
> writes through SW, max_opt exposes the value that will be HW accelerated
> atomics.
> 
> As ext4 does not support SW atomics, set awu_max_opt to awu_max.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Hey Pankaj, I think 0 is allowed for backward compatibility as
highlighted in the commit you mentioned:
	...
	Masks STATX{_ATTR}_WRITE_ATOMIC can be used to get this new field. This is
  ok for older kernels which don't support this new field, as they would
  report 0 in this field (from zeroing in cp_statx()) already.
	...
	
But yeah sure, advertising it as awu_max is more clearer. 

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin


> ---
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..93056c971e74 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6304,7 +6304,8 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
>  			awu_max = sbi->s_awu_max;
>  		}
>  
> -		generic_fill_statx_atomic_writes(stat, awu_min, awu_max, 0);
> +		generic_fill_statx_atomic_writes(stat, awu_min, awu_max,
> +						 awu_max);
>  	}
>  
>  	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> 
> base-commit: d5ba62a0b130441bcabca59c2fd2d59e65360234
> -- 
> 2.51.2
> 
