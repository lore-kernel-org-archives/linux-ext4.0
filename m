Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1236938DC4A
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786092066; cv=none; b=KkNllJwwEYUPcjrtswn7QIHb8DsKHAV+QDzrZgeAP/esyaDmvDzLfG09ZJAIeETlEyoRmwS1TI1a1osUsH7bmLVacPxFoLppS52o63qo5ZKwK6/Hfu0yUiKnbXlQOa3WN20puAFh5itzPDOLP3hnnwyh7nX0Mgic5w0DCj52eLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786092066; c=relaxed/simple;
	bh=bUjgqdqxDvNxXL3sAbiVQ7GYMgjbXsjjeBlg+0mCmxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fP0IdGiEcA+cCNLXrhoQ4r6hy3ha3giMCWcK00qrUG3NMRfYU/YJShdtBOpZLfjQyIMuRAjMrXgfHIpaQCBLYvHavzIWDY95w6Hj7bZoF8/t9mWJk0Kr8/Ws+CbNdGfuK1BFL9x8a7UuRXUXfwtvfOU/OJc+gxMUEyZSTB+F6rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=enlvdEvP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="enlvdEvP"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770JQgM2279525;
	Fri, 7 Aug 2026 08:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Ckdj++hE8Y8UQl5FGTRNZ3mKT4BD2M
	ylofP2VYjlmcY=; b=enlvdEvPzXVhZCdxg+uvQZsuezguw+w22Hr0OYap+qsPPC
	AnNpc0qe1ooRhG3L5cjD7WsEyAPZiAf1EH5azBp2E7umgiTi3bBeA/d2viopQWmN
	j0RTYRykLt7r58F/vVJPCVByqKCzte8SF2jX20bI8fLXuRXNsoYL9V31a5hVrULc
	5TGXT0/6HtLFgoTcb9q2wIzyqrf2/SlfQv3cGkjC2ygYlz7b2sUh9m3nDjiZFK05
	vxSpc9RopDRtqE40nUMgzJ0Vbf90S8Ahan4XjoBwjt+W3PDBDSI6/Y6hdyyjjFaR
	Jd5BeqKJY6jH6RhT4hO/m1PhFonQA6gegdEx/yXQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy01k200-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 08:40:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6778QG95008838;
	Fri, 7 Aug 2026 08:40:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qy3af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 08:40:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6778eiZa35127720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 08:40:45 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD5FE20043;
	Fri,  7 Aug 2026 08:40:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0F0A20040;
	Fri,  7 Aug 2026 08:40:42 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.183])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Aug 2026 08:40:42 +0000 (GMT)
Date: Fri, 7 Aug 2026 14:10:39 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 2/3] ext4: Fix transaction overflow during writeback
Message-ID: <anWaBzfPUle-MNBR@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-5-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805153605.166545-5-jack@suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: qSvznJXORckhCrWRxM2-v2YWJ-nOs7kX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA2MSBTYWx0ZWRfX11FRlKkLAqaR
 04x+ZUbbdcTpL7/VmPqr0R97nDnIah2nGv1Ahd0fbdQUjg2BtJW+nvuFqJIudc+kTQbY03BSNvP
 ftAIvYaQklXm77uhhqQ78xoTzttkcuE=
X-Proofpoint-ORIG-GUID: bIARjkVVKlF5L2QQJC3C_gyyLk6uSUqR
X-Authority-Analysis: v=2.4 cv=afNRWxot c=1 sm=1 tr=0 ts=6a759a10 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=zhYh9aUPHKH8fjOMFsoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA2MSBTYWx0ZWRfX7eyRbbOJ3Mo6
 iCgLl/Oj3YX/tHNNn1qG5rkVAaJ4agc6tixDrAEyUSQ6FQ2SiaiwsdtFKUsznNq4TnKj2+mzPdM
 1kTBAx2XivR17yZbicfF1iJgErOKtU8bG5IjloizTmkMDM2iwFkYxtS7V9VlSUKg5RvCn9qEyAh
 lBmolHESkjsSsmRQ0TiU5HvIyNEeiJ70Y4Qlkcb+KKmXVTcrL60jL72ntbSodIUZqq1iSA4wC2k
 1ZFSiRE40wIKKmXnp+HDCio2TYbyreGUO3y//ThxA4dHkiG058v9TdTNGBgCylRURLrpfVMIpqC
 uCTKL2843mS250/m90e1KHs2CX43DAQOko59EdWpraCjXWHtL+t+yQlubxeyrSf3Wo/sU+iR5Va
 vY1C0zngu3Nb6QPQP87nOBDJrR2WMlijWIdjTmuOxdlOpqZQ3Cftiul4teSx/fnt/O9vN5ss51q
 O5673IF5OxDVX6o6usw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070061

On Wed, Aug 05, 2026 at 05:35:48PM +0200, Jan Kara wrote:
> Commit 95ad8ee45cdb ("ext4: correct the reserved credits for extent
> conversion") was correct to note that we need to reserve enough credits
> for all extents possibly underlying a large folio. However it was too
> eager to reduce the number of reserved credits. Extent conversion may
> not only need to touch several leaf extent blocks, it may also need to
> split extents - for example a single large unwritten extent may need to
> be split into many small written ones in case of sparse folio dirtying.
> This can thus result not only in extent leaf modifications but also in a
> need to allocate new extent tree nodes. As a result the reserved
> transaction credits were not sufficient in some corner cases. Use
> ext4_meta_trans_blocks() for correct upper bound credit estimate.
> 
> Fixes: 95ad8ee45cdb ("ext4: correct the reserved credits for extent conversion")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f324a54f1dae..ddce319e53c5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2852,10 +2852,10 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
>  	if (ext4_should_dioread_nolock(inode)) {
>  		int bpf = ext4_journal_blocks_per_folio(inode);
>  		/*
> -		 * We may need to convert up to one extent per block in
> -		 * the folio and we may dirty the inode.
> +		 * We may need to convert up to one extent per block in the
> +		 * folio.
>  		 */
> -		rsv_blocks = 1 + ext4_ext_index_trans_blocks(inode, bpf);
> +		rsv_blocks = ext4_meta_trans_blocks(inode, bpf, bpf, 0);

Looks good Jan, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

>  	}
>  
>  	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
> -- 
> 2.51.0
> 
