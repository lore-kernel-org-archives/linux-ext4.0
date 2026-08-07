Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D1B4B04B2
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 06:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786084698; cv=none; b=ISwnKhbyeJDEjyccJumJPZSCbPYmIhQvfJ3y6addmcznCME/3pt8nrOfawyThYbqsNcCwJb7KIXyjGn4+TlyQF92gJ79QTmQhYnYOSVxaZoZo4vWL+8YOLWh1NZTDPLi55HP8w7zfIAcWA7GuDrVLMOJGykDIKBXMVqBoG+fvPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786084698; c=relaxed/simple;
	bh=27rhu7BOA893E5zK9dyO+TWDyrloB7lXmH+d4qOTF8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8NbY+0+DkVT755JlU38pWwyYWjkhK71linVSE6yalbU15SmItJSjREkWOHohqLCnzTS0JnJYL5xoz1BCWUgHd1YvqsltIm1pBNIrrs6q58OFCZiZ8S/YxlUantt8qedEFDs2nkNSlqmHj7xYbD1PnzbjzcycdJvMFvvHweU2bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fUsoECa5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fUsoECa5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770IBx42277177;
	Fri, 7 Aug 2026 06:38:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=w1IWgZzF+wfgSbokIcmc/7ak63bwuw
	8noAvtGOs95p8=; b=fUsoECa5ak+XYJOVhiRyTCWXvdQqDTDPymLoCWZLLAvEjg
	bkRSfGGizIfthYNsM9girvAGPpiXMlSvVGgiNghAmYHphEEN8KDluuXwQpDt+v1g
	d6H9jvM0IxxglNc7DZq4wygqCYEP913Oq4hrHnRtsCtRrYSWHaj/ImakkKhK7NHk
	v3aMnqyx4icJAmNuoPVnxLSey3oZaQztOZDwyJlpCSVAKYUjo+enz1e+s0K2QUVz
	pX4B8uTcDaISB6QUhNRcJXsnxosekHYuwc/aZpWpbC8Ro42S+ODrb0pBOkIGmQE9
	gcyR9kDTvh5fqO46UpHzDj9faaNAgHfCuxrGv/gA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy01jmvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 06:38:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6776QPmF008104;
	Fri, 7 Aug 2026 06:37:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyxdcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 06:37:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6776bvZM49414636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 06:37:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D69E220043;
	Fri,  7 Aug 2026 06:37:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCB1320040;
	Fri,  7 Aug 2026 06:37:55 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.183])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Aug 2026 06:37:55 +0000 (GMT)
Date: Fri, 7 Aug 2026 12:07:52 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 3/3] ext4: Fix estimate extent index blocks in
 ext4_ext_index_trans_blocks()
Message-ID: <anV9QPd1RvK3qVUC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-6-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805153605.166545-6-jack@suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: dGnrrJUQ_P5mONfzFR8ipweQxrMcONnE
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA0NSBTYWx0ZWRfX7W3ovkwYpBMe
 +erlmUpjd6oJTGmTihi4QEVa7jW3dNIaP2VgqahdB4CXgsWVHZsCut0qyhLbhZZXsaUJll0mgL1
 CTsx5GkloypnOMOPgFRiEKkdr5GvXFc=
X-Proofpoint-ORIG-GUID: lUmXajqIs3Ej-zPMrYDKZe-lc-YRCndV
X-Authority-Analysis: v=2.4 cv=afNRWxot c=1 sm=1 tr=0 ts=6a757d49 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=ev3r3GgNMjcCU0iX744A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA0NSBTYWx0ZWRfX/dlwG3NPch/v
 16WaCihmnPd4o6UaT0Vo5WB/UZfkdVrjn76jTebXGmuf8Wz2p5+kV554zAWR4lgjMtYaArisTIH
 cFDPva+tlTVpx6wfvZ/C+C6rILY5Q16M+6wrf7DOfGfdEVqE19ukIsIfEud7E9/F/P1JN2SvhYz
 7OkFdX0zApJP++os29xUdWDZewMsN4/8qKvelxFylDH9fEfemqIaFnT6se24VgZDCKYiqEMDRrm
 8zaKIL7hWw1M3Kk84aiitLMXdJhxuqJoXXFs31tQBGqCW6vEgRkNSTBR+vGMlbQKP3sA/wLWZWw
 LQjBg9hI4qawcy95cYRxtH3+CZuFiRYyki4bmTaoFowf3x0XCnXwTdxgNrixY4Y9yhUhtNbNJpq
 D1Y2vcV+yZKdadhwadJih/sh8BlDlTb7GBfdE5JfI5LLmjdicTIFFTb4dHv25VjvxwG7kT21c/C
 mNezxjrZ3BsvH32ZQrA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070045

On Wed, Aug 05, 2026 at 05:35:49PM +0200, Jan Kara wrote:
> The estimate of the number of impacted extent tree index blocks could be
> one-too-low. If we modify say 2 extents, already two leaf index blocks

Hi Jan,

Its minor but just to be sure, by two "leaf index blocks" do you mean
the two leaf blocks that hold extents or the last index blocks which
hold pointers to leaf blocks?

> could be impacted, not just one the current estimate counts with. Fix
> the estimate.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/extents.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 44ab246a3176..713b2c098af5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2427,9 +2427,17 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
>  	 */
>  	if (extents <= 1)
>  		index = (EXT4_MAX_EXTENT_DEPTH * 2) + extents;
> -	else
> -		index = (EXT4_MAX_EXTENT_DEPTH * 3) +
> -			DIV_ROUND_UP(extents, ext4_ext_space_block(inode, 0));
> +	else {
> +		int ext_max = ext4_ext_space_block(inode, 0);
> +
> +		index = EXT4_MAX_EXTENT_DEPTH * 3;
> +		/*
> +		 * Modified extents need not start at the beginning of the
> +		 * leaf. Already two extents may need two leaf block
> +		 * modifications...
> +		 */
> +		index += DIV_ROUND_UP(extents + ext_max - 1, ext_max);
> +	}
>  
>  	return index;
>  }
> -- 
> 2.51.0
> 
