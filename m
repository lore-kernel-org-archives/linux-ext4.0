Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A63351C3B;
	Mon, 28 Sep 2026 10:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790590928; cv=none; b=Zz6xHWQ5nRKosx1bJALGtzhL1+MeTbm3/dKukZOVOKaewkZSruLorTqYHIJVPYhRrYj+0UH1lqRUS9zDJ7hy05D9PTHrb6ij7fWfUzkefLkB7Lh+MWho1GzPnudJIafhyhQI4YTkURyAxjOllSMyJYmckEZRe1jFbi2EoOCrXLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790590928; c=relaxed/simple;
	bh=uVRYWRetMVDLgbMLivyX+0D95h4/EvA4hayvcJIgujI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0/G/MRdywaLdjql52Atkjugl3nHBcNeopToGsTNS4dpIhGr1hp4CCBNDV6kLtBh+UsO1TFiUM0m8zSnbrQsdoyBByQNbHAfhIH77yEz1N1MTlGuekRTHHGXSMdpwlnmBMOZmZzEgmNQ/VizP3ZgWSysC5L3bcPlOmMKYkdb/gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gk78jVUM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gk78jVUM"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9Zfsg801968;
	Mon, 28 Sep 2026 10:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=42n2KTSFzQ2c0e8hup3itMbfDJzMY0
	tDaAd0BZ0wisA=; b=Gk78jVUM0D7eCuYLq5w87SQt6l4K03/euukvrzKNBa95Og
	Dh9Jxi4ZJetbLhRqKei4UgYwcxuLiDqQn9i7+OTQxIs8F2nV5fOzirKq1wLdwLRt
	FpiNerUnHDAjCOdRdlkTR2kNbu8A6AVEw6TYREaqIBCcMq79bBfkmNHQCAFQuAg6
	jSUtiZbq3UJ0mtMn6ydxbqTZyO43zMdNwrtjnnMtfUvAeqVzhhAuL5x+04wyRN12
	s2s2NbJCE71FnPDl8BAVvm/lHzaS7TwOx5v6MjFflGUjNoH/313U4mlF+Gohl/EG
	6iWxZj9A37vW+nIxJ1jaOgFf0SbgNt3Z2UxF3cnQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j50qse-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:21:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9HeEb4136587;
	Mon, 28 Sep 2026 10:21:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsvhcqct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:21:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SALR9315794558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 10:21:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49B552004B;
	Mon, 28 Sep 2026 10:21:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 005AE20040;
	Mon, 28 Sep 2026 10:21:22 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 10:21:21 +0000 (GMT)
Date: Mon, 28 Sep 2026 15:51:18 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 08/31] ext4: avoid unnecessary transaction in
 ext4_map_blocks() for unwritten extents
Message-ID: <aro_npJ95b4Nf978@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-9-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-9-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0MCBTYWx0ZWRfXzcVktDZTwDnK
 5asKdY4vnlBIQGjuoO/v5pspla/3Aq8Cw1BG62oSjYnycWML2tyVYcvAVC2DjuzT+B9DnUa22iS
 3FDSRy86zu2htRX6P/gwQjyIHrlLaAM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0MCBTYWx0ZWRfX8AmCfDjjuGSb
 6Ml73spcLxxlEyo+5bOczo8lbe33LcO4NR6CbVquxajaCP6/7GAOFOG2XIf4uHWlAyDzUXjR/eF
 WoxNUpcA3b1RKNrLNMzDpoOCNkGUZr2OztJNfa4RKSsqU+OHQvntzMaBYXgouav6CnHX/YiVdff
 4rfCJo/I0qFXW3OfEc4mTK5azcCUGr5lrp2tViGEKBdsDGZEGIxkc52azYt5j2tEZHu11YvZ0Pf
 RtFSofArge/VIG3iis+WN8412UqzbPGCsQJKf9+GpxyU9wLRdKyNIsz09wCkTOO0EDbEqoNhCEb
 i5PuxxEplziL2hAIomTM0StHHxpnxEU0Ls4eNsvA/Obl869rX79tDmggXEOtka52FgaK5BWqzab
 PcqL9iCEPlTqBH8Xu3SVW+7PSwmy0z52WEQQL0j/Od27SaAWZaOayTSJzwQnGCsGm5PMUfJgl+s
 NiLgv6KaUJdvpF9KzYw==
X-Proofpoint-GUID: 95CUtjtgQ3nwP6EjspzCAK7m1riRIuCd
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6aba3fab cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=aWqQkjiijrM5delGkE4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: oXABs_Ul6pnF5jifYJKlST-LtTSZtSfx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280040

On Thu, Sep 03, 2026 at 08:35:20PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When ext4_map_blocks() finds an unwritten extent in the extent cache and
> the caller is willing to accept unwritten extents without conversion,
> there is no need to start a journal transaction since no metadata update
> is required. This avoids unnecessary transaction overhead in the
> upcoming iomap writeback path when overwriting already-allocated
> unwritten extents.
> 
> One thing to be careful about, as the comment in ext4_map_blocks()
> states, if the flags contain EXT4_GET_BLOCKS_CREATE, the function will
> mark @map as mapped.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Yeahh, I had something similar in one of my WIP branches :)

Thanks for taking care of this. Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/inode.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c9dea4ca5caf..7a5c74af8ff3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -809,14 +809,23 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	 * Note that if blocks have been preallocated
>  	 * ext4_ext_map_blocks() returns with buffer head unmapped
>  	 */
> -	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
> +	if (retval > 0) {
>  		/*
> -		 * If we need to convert extent to unwritten
> -		 * we continue and do the actual work in
> -		 * ext4_ext_map_blocks()
> +		 * If we need to convert written extent to unwritten or
> +		 * convert unwritten extent to written, continue and do
> +		 * the actual work in ext4_ext_map_blocks().
>  		 */
> -		if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
> +		if (map->m_flags & EXT4_MAP_MAPPED &&
> +		    !(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
>  			goto out_handle;
> +		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
> +		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
> +		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
> +			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
> +			map->m_flags |= EXT4_MAP_MAPPED;
> +			goto out_handle;
> +		}
> +	}
>  
>  	if (!handle) {
>  		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> -- 
> 2.52.0
> 
