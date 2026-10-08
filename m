Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1394503B;
	Thu,  8 Oct 2026 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440427; cv=none; b=JUdhRsXK5eTLUe/6ErupZlKNqTwGPHzC1lVqxwGKv5s+pRfkbQlMHHzsb/zenJ1BkVN7H83qBFmUgg6t1ofiVXYW2su+0PcBcLCjWv7Ksj27XojjIzBjhVdyAcT5JXb3vYrplHEFD+cn6w/1Ndkh3xU4Tpf5HnCvmhHixhPqRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440427; c=relaxed/simple;
	bh=30SAqPkiXwkok1B+xQ5u5QDt8LFUXBP0/6ewxf+qDB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIuxIQ8WI6Y5cCh5SqiuoIHt1HEekZXHJmZeDTwD5Elq2eqoMOUD3QpY1jU2E1DHgOrkHie1uRKPwLeZJgMp1f5eza6pU94iN9dOf7LvzcAHr/aOYGnK1q0EPgXWrJuS9yHEsvZBsi1/QEizE+NbU+why5m0+XR2LSjJrF7Vd98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WMFPiGGo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WMFPiGGo"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6984Zqi1346038;
	Thu, 8 Oct 2026 06:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XVM+0rWvnY8M0Iwb8C1H6g9B9Sp6D1
	quJ0AQdvNdxB4=; b=WMFPiGGoZV/a2bFafn1yugiU1P/iuDFvb/e3r1+LFwQ0BB
	mEp0U3ae0DxRnFiVFiugDtjBO3CbUXvKyjCVPwF1OdDWCnOu7+U8konooKdbIJWT
	bapUZ6enOyHUzyM6CDtZzZ+HhkjA3Iw2cgHJMy36hbWHa9+NMWGxuorqLsUwki/2
	98lUjLHwCu1tcIfgvuooBxsKv31qN1Hv70WkvUlKl92V2LaJdJDu8cCCMENZTRL3
	aa/DN2LlYA6dDj6UtoLtVQRs6gSYA9S0H9ZkcI35aqBrvhEb80pIfekI2b5vUBmG
	Q6p48BY8V8k7TlJd9XXFNb57tRVvVO75GjnWiBUA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjvhmv4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 06:19:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6984HbnG1678354;
	Thu, 8 Oct 2026 06:19:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5f3tvxdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 06:19:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6986JtLa52167124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 06:19:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8455620043;
	Thu,  8 Oct 2026 06:19:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C58220040;
	Thu,  8 Oct 2026 06:19:51 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.26.191])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  8 Oct 2026 06:19:51 +0000 (GMT)
Date: Thu, 8 Oct 2026 11:49:48 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: daejun7.park@samsung.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: don't cache unzeroed blocks as written after a
 failed zeroout
Message-ID: <asc2BOOFgO8Nupw7@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
 <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: z8VKRIVfMmZurponM3VXxrEtp7IRmlaB
X-Proofpoint-ORIG-GUID: reTZp4OnaABxQX_Yq9XC8E2f0GlQUCt6
X-Authority-Analysis: v=2.4 cv=FoOQbGrq c=1 sm=1 tr=0 ts=6ac7360e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=hD80L64hAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=LEktE2FlL8_m3Wk7YuYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAyNCBTYWx0ZWRfX+DFMwIvfoMyc
 rUZBhNohtcd2RRw58mRDtd1w69oVkokIewqP+Yi8u+v+LAln6YUX+crMSFub+tKbCLxrlpSs0qT
 BJmNLZvPLHCaqan9vJ19NBVnWNnhfog=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAyNCBTYWx0ZWRfX+jzOH61tMg4Y
 ezOENrQnj0Lo+dpiQ8xYHkKM2555bfxy2aLFh6EaDKB77zF1g1+XSbIqmKa74+z1ANFFQT1I+I/
 e9HFYGSC3WhJaSvXqwqApkyGKH9iXf7UA3IJiU8z6Cdx1zIyLEerLkUg52NQFIQnRBOKS8el5kh
 Wo0UuNSC3PYfhmzv8W4VPxZ1A/dG55TRyKnJBkrIq7uGylR/s3l6rcP3JanifNpCBXKu7JFhXRL
 /flwTvjnZB9gdjNXiH7WRN+jXgs6HYDdunuZMXEcDGBJRwIjemDJpBvmZ95hbM2Cd44dJBeHVkW
 Mgs7439AuFYhO3khpRJsQX9DadHxZj8gjMgsLvIEpzOWc+dMWaeNt4q5IHG8E4iCnIyGb225/Ik
 WWZklEAjllHmMHAD1w6W1L2Mkf3O09zcHbQYI3m3bU8atJ6yfhLUdxxoLeB6+PaHaMkoPKV9zvZ
 4+LGkr+Kg6MPHuPBjQQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080024

On Wed, Oct 07, 2026 at 09:41:20AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> ext4_ext_convert_to_initialized() may zero out the blocks before and
> after the range being written and convert them to written together with
> it, instead of splitting them off the unwritten extent. If
> ext4_ext_zeroout() fails for one side, it falls back to splitting the
> extent, so the blocks on that side stay unwritten in the extent tree.
> But zero_ex1 or zero_ex2 keeps its length, and ext4_zeroout_es() still
> inserts those blocks into the extent status tree as written.
> 
> Until that entry goes away, a read of those blocks returns whatever was
> on the disk before the extent was allocated. A write to them is mapped
> from the cache and goes in place without converting the extent, so its
> data would read back as zeroes once the entry is dropped. To reproduce
> on 4 KiB blocks with -o nodelalloc: fallocate 32 KiB, map the last seven
> blocks of that extent to dm-error, write the first block, restore the
> mapping and read the second block. It returns the old disk contents
> instead of zeroes.
> 
> Clear the length of an extent that could not be zeroed out, so that
> ext4_zeroout_es() skips it, as the comment at the out label intends.
> 
> Fixes: 308c57ccf431 ("ext4: if zeroout fails fall back to splitting the extent node")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Hi Daejun,

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

btw, did you catch this with some fstests? If not I think it would be
good to add a test for this. 

Regards
ojaswin

> ---
>  fs/ext4/extents.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 836396ea79..d65e30f3c1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3755,8 +3755,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  				ext4_ext_pblock(ex) + split_map.m_lblk +
>  				split_map.m_len - ee_block);
>  			err = ext4_ext_zeroout(inode, &zero_ex1);
> -			if (err)
> +			if (err) {
> +				zero_ex1.ee_len = 0;
>  				goto fallback;
> +			}
>  			split_map.m_len = *allocated;
>  		}
>  		if (split_map.m_lblk - ee_block + split_map.m_len <
> @@ -3769,8 +3771,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  				ext4_ext_store_pblock(&zero_ex2,
>  						      ext4_ext_pblock(ex));
>  				err = ext4_ext_zeroout(inode, &zero_ex2);
> -				if (err)
> +				if (err) {
> +					zero_ex2.ee_len = 0;
>  					goto fallback;
> +				}
>  			}
>  
>  			split_map.m_len += split_map.m_lblk - ee_block;
> 
> -- 
> 2.43.0
> 
> 
