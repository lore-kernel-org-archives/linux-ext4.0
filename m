Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F48441443E;
	Thu,  1 Oct 2026 06:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790834785; cv=none; b=RZgzyBo93ogm0kZ2s0CdMU9HfUKAWuL1AEr5ItN5L5BOxNaP+SF4mgxj/Hie0WCmRTTzzQHpd2KaGVx+CjqoFTUURkheQk0rZioVdPch1gUwSfK7MeTP/sfLmgg1mguatGl4Ij0LKOIwATaWMoaxu2XDXs6jgIdj9miVgPG+Dfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790834785; c=relaxed/simple;
	bh=b3dgIIBYNOSEAqfZH0eLwFejKciu3dCbUYZakCYCFhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LS9le7ZqDngLKn6c9oSTG6llArAC0Sy/i9gd4jP9/aokv+xP0Avhg5W1d1N43Tde6MAwE0cbHCrMv9+KKjtQFFkQ4JcSOZ/vZdDUpnfKIwghghRExFaCUJ5gskNmw1MYBPclhU8Ut7vwdRL0rkR4CBBD9RvCSlNDYjh35qq3yAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U8sip5Ue; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U8sip5Ue"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69145gQe756554;
	Thu, 1 Oct 2026 06:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wqKKXr
	C/rYuygbdlwZY8OyqMi5uBYenTp3C7M3+7xfE=; b=U8sip5Uex2tabYje8cGZzx
	1lp5GlN73bYVjpzdpuX62bR7fE8jW69IWQ71/FvjxW+zbiUDF0/WnQvXkHNZtVtU
	pIMrkAKpJ5hhGhtL6m7nlyV6ogYBhwEcP4TFCBcu982jc/7qxaCsdX24FoonUf/L
	WJPvBzIQt/6cSr7983KKp7qIntut0M58qwJaYlPrJ8HQdajW3JdtbIyKlPfVN5bv
	787CD0q6IBgunlZCquE6Tk8wpUwGbnWsG8kjlx/H5MQjVme0AOIEPDYLuAHTUdr2
	ByHuavqsoYva1RQxBnnupTRxRkSwfRXbXtisppMoUvMVCPRtfcftz0lLBr5yRD5Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5hkpq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 06:05:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6913lkMi306307;
	Thu, 1 Oct 2026 06:05:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0hfpfcpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 06:05:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 691655Ol50463012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 06:05:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71F1A2004B;
	Thu,  1 Oct 2026 06:05:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6A3420040;
	Thu,  1 Oct 2026 06:05:01 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.22.19])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Oct 2026 06:05:01 +0000 (GMT)
Date: Thu, 1 Oct 2026 11:36:26 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        ritesh.list@gmail.com, Zhang Yi <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] ext4: save converted extent before merging
Message-ID: <ar34I1lqLOg21Gkr@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAyNCBTYWx0ZWRfX2OC2AAte8eN8
 Di5m6ENVhJPx2FJy21jw+2/e0hAfBu3s5QbK2Rkv7Psv2A/R38vnesFMSBEzIrcb44Ffx8UKXWM
 pbBfKZtUFuM8YirGl63Yr5DVtIr2Zzc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAyNCBTYWx0ZWRfXw1iRGay5YlMc
 HTL2uo5cF47hhStvlXcjsN8WjGwz+RigxX1j55cMIBNh2DkfzSTH2SPfsnp6+8XLRKiBPM4yaNL
 wzmhZTgOd+ejTG/feNoaz3if9E+IFXapoaMvq60ilsf5SjYH+qrh00Lh1nsfuEMzttcL8Jw4kLN
 SXt/bWnYB4ZsDI6entTkDsQzvje5iCMf9K2WM5gwI0LszQOKBSCQF2jxeCNSXObJzYA4Zmch4X/
 1JQ6Arx+12pGrI6cAWPC0Mr3C3uis0tXpDZngVA8PFxUp1cVQUm/IyI245yJ/IEHgJkSrSGRIjZ
 JwTsLhc7TwSrnvt73YhHFPchwD9cvoMsH1MjP0a2N12mWDFI8PmLSXwqb60w7nzVw3PJSKX6Btf
 Wr7SLK+NHG8Ls0eL9O3GXNYRHsWz11j6wVCz0OkK6zvJIPsTQf3flKh+aQbv6nRf698yivvTTio
 kRPZ8JTtfkQO1uVFOqA==
X-Proofpoint-GUID: 3mSd04GD0V4bcPSl4oS2TBsW2DWhQl1s
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6abdf815 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=8nJEP1OIZ-IA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Dr-MpunZ58dE2yC-bqYA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-ORIG-GUID: xMM8G1sBR9p1-KwTshVmBbrBhPJOcRR4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010024

On Wed, Sep 30, 2026 at 01:45:17PM +0000, Jérémy Jean wrote:
> In ext4_split_convert_extents(), merging can release the leaf holding
> the extent pointed to by ex. The later extent status cache update can
> then dereference freed memory, causing a use-after-free. KASAN reports:
> 
>   BUG: KASAN: use-after-free in ext4_split_convert_extents.constprop.0+0xb98/0xc80
>   Read of size 2 at addr ff11000002547034 by task fixture/65
> 
> Save the converted extent before merging and use the copy for the cache
> update. This also avoids using the old extent slot after a merge with
> the left neighbour.
> 
> Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
> Cc: stable@kernel.org
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---

Hey Jeremy,

thanks for the fix. I'm working on a patch that has some more fixes in
this area but your fix looks good standalone.

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

>  fs/ext4/extents.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6..f5a3880 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3830,6 +3830,7 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
>  	ext4_lblk_t eof_block;
>  	ext4_lblk_t ee_block;
>  	struct ext4_extent *ex;
> +	struct ext4_extent converted_ex;
>  	unsigned int ee_len;
>  	int split_flag = 0, depth, err = 0;
>  	bool did_zeroout = false;
> @@ -3887,6 +3888,9 @@ convert:
>  		else if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)
>  			ext4_ext_mark_unwritten(ex);
>  
> +		/* Merging can move ex or release the leaf containing it. */
> +		converted_ex = *ex;
> +
>  		if (!(flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE))
>  		       /*
>  			* note: ext4_ext_correct_indexes() isn't needed here because
> @@ -3897,6 +3901,7 @@ convert:
>  		err = ext4_ext_dirty(handle, inode, path + depth);
>  		if (err)
>  			goto err;
> +		ex = &converted_ex;
>  	}
>  
>  	/* Lets update the extent status tree after conversion */
> -- 
> 2.47.3
> 
