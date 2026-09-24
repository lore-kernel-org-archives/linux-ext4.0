Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D2A391517;
	Thu, 24 Sep 2026 11:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790250213; cv=none; b=VLe+Ega615vhdsFKsfOt8Nx7bc+i3q5YbfQKJdA5ZL6tB/rz3TuW1xB9PKHrvE85SXPu9gigw+RwuiFjI85ejjY8YprwzYh6EK1JeUIYFVsxLOmEnkS3OF/INTFjpGcUWBj3El2Y4p/pMS9t9XnusrjBehkuSv1wzDqJoMcppCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790250213; c=relaxed/simple;
	bh=cAwZ+ZQMBB/nL3QgioPnI88TyuDdMW1BnM09HqAisL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWIwry6YfNfDfr14lesnDORzjaOzVT+y/98eFzdCz8eV0othIGLbb5UuMnsD5zCcozxBFad0LRacHbMcmtCXF/hM6cSlnzFuv7sxex16bofb20JiWniS2yKePPTihHD86vTO1DMfZwQBa9rzSIc1dyAL6bImBHAXPSi9EVRKjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C8A3n+Rv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C8A3n+Rv"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bpeL1179971;
	Thu, 24 Sep 2026 11:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=we0jkvkUU8b/DdDap1KvhZSR7n4MtY
	LdoWpJ1NLsn64=; b=C8A3n+RvjbHH/lOBdbUmEZvfUCvzcM0gWVtXA2O2HZUHcW
	U68+n1cfQVxo12f6Qf9Iph2ljk/RZlIygq2O3WErlKC+ZQkR9qtbqlP6dffpGk2a
	FvyAtASORqi0u8vrWhg4LpXV0gwVlNh8Wlmdh8sefZdevto4uKSeqobnNpiy7RFF
	WiKqY56YsbT3Tqi90IH48KhkIaD0YTr2qyYbWx4HXZuxwDSeHNASGz+J01Rnp0XQ
	0827fI7r+AsK68hUAeVU8w6+WBbYPtpnSq+y/TMmToBnDc5hc/ntf9V6wXH/63oI
	4IrtPdrqkHzfL83fZXuCt9zmfPSSfuixEN5n+2aQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1r3j4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:42:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68OAA5Ds1555028;
	Thu, 24 Sep 2026 11:42:40 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb8jwh5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:42:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68OBgcaI48234956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 11:42:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A9D620040;
	Thu, 24 Sep 2026 11:42:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71E5B2005A;
	Thu, 24 Sep 2026 11:42:34 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.215])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 24 Sep 2026 11:42:34 +0000 (GMT)
Date: Thu, 24 Sep 2026 17:12:31 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 04/31] ext4: set EXT4_MAP_NEW flag for delayed
 allocated blocks
Message-ID: <arUMp4UYXgPnVckT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-5-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: u6IeIG8v7wD-fpNEEgEeHlPQIqQ62hos
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0OCBTYWx0ZWRfX6uIoi0m5mY+2
 oZX0/IkhVbaZM0imsaS90GFS5sFQxz9CiLJGu0vs4X1Mn2LP2zTSuUoJ8fbWx1NifdJGi16Kpwb
 YxdPaId/q7UIDAa/fPCChMAftY13SIVR4tsKSDIUmOwpztgPJsdQ3iAdJljZMJkqkhexK2/dvlC
 x8h4I89fWbbROvHnP2/cs9/f6j+n9RQP4c8RDfM6IJf3zR0Tlcdvg2M9kFgW0Ra5fVPIe9nxN/s
 LYYGM1y0Ab4m1art4WCzynkkSLk6tW0wzsJ2Y8lOGmrVbvCHGAlFgC5Qk8/CunNONM0X3k1DsZl
 leIlo+RLLFbriQ+eV38LhWQ//K/mFPHHs2b+8+yQpcSX6ssJVoEA736jFFuAZ7nVMN2V7tIkBYm
 FIiVjhikVi7WRziPaWHGYfsTv0GhwuuhtFHB3DbHmKHB9Oh5c8dtN9+eJeTE/cZfjlALUQ6316Y
 X+FuK4j16vPLORbYTJQ==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab50cb1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=AiHppB-aAAAA:8 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8 a=7t1WT2wCRtn_2FsIMTsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0OCBTYWx0ZWRfX7hSXUTkMfUut
 Zhi9PhAzVN4K1QfEcF5xJfgdxb4RKYXbfQFdPin7xeHMuaHcx36JTzgFn39s2hdYNOsysPoIhbX
 uznlV9S145+Ldhas5wbtE1fRyQ6bEm0=
X-Proofpoint-GUID: EqZRLwrqbjO5jhUOpkVHRFM8yPfFmO0H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240048

On Thu, Sep 03, 2026 at 08:35:16PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Set EXT4_MAP_NEW in ext4_da_map_blocks() to properly indicate that a
> new delayed allocation block has been inserted, allowing callers to
> distinguish newly created delayed extents from existing ones.
> 
> Currently, the buffer_head caller, ext4_da_get_block_prep(), does not
> consume this flag. It intercepts EXT4_MAP_DELAYED and returns early, and
> unconditionally calls set_buffer_new(bh) so EXT4_MAP_NEW is not used.
> The flag is prepared for the iomap buffered I/O path added later.
> 
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4fc0d331c49d..84991fe99071 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1990,7 +1990,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  		}
>  	}
>  
> -	map->m_flags |= EXT4_MAP_DELAYED;
> +	map->m_flags |= EXT4_MAP_DELAYED | EXT4_MAP_NEW;

Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

>  	retval = ext4_insert_delayed_blocks(inode, map->m_lblk, map->m_len);
>  	if (!retval)
>  		map->m_seq = READ_ONCE(EXT4_I(inode)->i_es_seq);
> -- 
> 2.52.0
> 
