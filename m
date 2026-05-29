Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084862E7383;
	Fri, 29 May 2026 06:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034543; cv=none; b=VvnwQou/oUo6lSzPUhgHEyiN+HnUj9uXimYHfrnfAcGaR1UEGdcqNtozFNoBU/wQH2S54e6AO3m7Z4q3FllyK6X64+O6lhZzCozcLCZkzM8iEEy6RQ8OteoW7g1yRgKSHjjma4g1mbTXQbAgJeZmIBOI89viEt9zEmhkw5sP3Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034543; c=relaxed/simple;
	bh=S/F0ovEUYzGRsK43Vwmg8u8Jc4EQygzK45BxL+pNFN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYEoQIqkDLYaxZp4XByZ2G90bfThzctTjVSnzag0drlYVA+bGUPcxmKlIqX1EYSEHY65t7Bv7rh+vKIbQkMh77OJPGHXdEeyJA1FM5FtCQNBBEEndf0N7Lql4ZjrDjMSdbBJCz4XZ2bSHCRLa8rPn2Be6eVmq5zF8rNpfOn6ylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BWQyYmWR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BWQyYmWR"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64SLlhlB1684655;
	Fri, 29 May 2026 06:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=AxJe3pRP7/XngqmdURDqLAMWLDITgp
	l2rmW21d4mvm4=; b=BWQyYmWRRDOqdDF1oz0R8HvMcsguSDQv8d9fiF0fJouM/8
	PHzoSjtZ7SCjE/IY8hLUIsFEHukybJBxwboLvuR3/A23m87zVtjZpoTzBmFQjt5e
	CzeT+Rbf85p16KL0sGwjOlAF2R8UPEDF/vOIjdNkpNWNEpsuU+96WhIrdPsXjaHH
	sD+kqU+wLusgmLvHNH4t2I4792gdOiK5T/LCVKyph6/u12eVriYgWjVi/5SJVLip
	ZsZJxvZcgxDNlXzTuT1u8T1SPk0SJBg02oqnvQi2TLYuWnY6yQ7fJKl7RdSqdJcO
	zyl0l5DB+YKSU6yOeptYZD2p88rn+uR9RHqUg5Dg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ee884evny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 06:02:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64T5s4av012130;
	Fri, 29 May 2026 06:02:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4edjrc3upq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 06:02:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64T6223157016618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 May 2026 06:02:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C32320040;
	Fri, 29 May 2026 06:02:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 654552004B;
	Fri, 29 May 2026 06:01:58 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.19.141])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 29 May 2026 06:01:58 +0000 (GMT)
Date: Fri, 29 May 2026 11:31:54 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Remove mention of PageWriteback
Message-ID: <ahkr0sybIQVdfYBQ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260526190805.341676-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526190805.341676-1-willy@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=fIYJG5ae c=1 sm=1 tr=0 ts=6a192bde cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=JfrnYn6hAAAA:8
 a=VnNF1IyMAAAA:8 a=y3F4KRkRb3-sBBmIC48A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: JkyitnMRKLknxZGhpyVeLSRfanknBhcg
X-Proofpoint-GUID: 8EN-jBmmP7dI9MLJ2Y0r4Y7xELPr0fBT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDA1MiBTYWx0ZWRfX6I3j1Pe9CaSx
 W7FIlBGY/Dn69lp/nIGDCd9nbheLevltr3/RdtXGuV9aI8ThTLpKWRdskIFwx/M9MIMj3lN8Wrp
 bULvsMPFUcJCBl2wyRSUZD94NlzPtF0ZcZr4vgKgbXmFGHCqGmiBbPPEEL/QBDvPApHvxK3fmmZ
 ADtbe9xT0d3swCOmSIDhsTyPLEXYa0cLmRklYM9T4pY8rsRVdqTxQkk5+91fNlIlfha0a6bKkpp
 PAV+v4d2BilIwMeVb5iUh174Zf6arW1fsBJEAHbbW6P1GgBV1/46d06Aons3y5t+sDNAo8l+1P1
 NisqSVX9EcLryKOkqcOsi5+XwJI6evAClFTU+UOZ0LzGNa1PNi9l6jsgLul01ZY89XKTWZsbVU7
 RzLdXjdUoIgvat0eNWQfPrc8AeWBffvB/eW4U0Pbi6cxoUaMK64vFRdyY4ijq9C+TKO+lwHTPd+
 rFHU77jH7pzRwoJNCpA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290052

On Tue, May 26, 2026 at 08:08:02PM +0100, Matthew Wilcox (Oracle) wrote:
> Update a comment to refer to the concept of writeback instead of the
> (now obsolete) detail of how it's implemented.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ext4/page-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index dc82e7b57e75..bc674aa4a656 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -168,7 +168,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
>   * written. On IO failure, check if journal abort is needed. Note that
>   * we are protected from truncate touching same part of extent tree by the
>   * fact that truncate code waits for all DIO to finish (thus exclusion from
> - * direct IO is achieved) and also waits for PageWriteback bits. Thus we
> + * direct IO is achieved) and also waits for writeback to complete. Thus we

Looks good,

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

>   * cannot get to ext4_ext_truncate() before all IOs overlapping that range are
>   * completed (happens from ext4_free_ioend()).
>   */
> -- 
> 2.47.3
> 
