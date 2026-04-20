Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5AE389DEC;
	Mon, 20 Apr 2026 09:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776676414; cv=none; b=bLEjPUMmYfntZBtcFHO8WcRbcklJ6TCI0fxnZ048DwJyCT2k/ICOaGiLWSbaqXGety+hNGC59kM0CkNwREhgEt40Hkt+liDNdZCNpMuedkO7NyL+/2cMtL3XvemBlb4F024q7qiUnMgEVJt7XgfvSeEtBHWtRRCN9Q/Cg6Ez1G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776676414; c=relaxed/simple;
	bh=UqCLQ1mMbNr6OtZi8hj08VXQ6gC0vPuLdqQcCGj6DgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcvzcC2ROuixIAm2ozz3Icb7i7Kf1MXtLC0ASNBqKAAH+qOWADLS55yzZJK3LE6iRXaboagGE2CQeQ+k/8M/Zn4fqYJOURhoBVK9Jz0EnH7dgpBXmgpNic4fCdm5VkIBSJA5DBUo7dwTqSFsCbIeye3wAtUOf5tBIromvhu8tfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kukk/ISI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kukk/ISI"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JMqbmd3300702;
	Mon, 20 Apr 2026 09:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ER5XzXUh6+u2WUu8/K7qmPakCwGfwk
	c587Aqhlz9wRY=; b=kukk/ISIMahYhBM0ubDoVl4h9IW94+ZukUZiSU3cxMAjAI
	gbV3wu1O3OxeAaJcM6Nm8/3g3o7PQfLN4z9NyezywVHa6tez4s+9ORD5HCtTV9fr
	fnu5LA6RKHbObXdQoEJh9reDxFoBKd3r4AKnP65ZpFR00nlIzQKAFzC1gLix4u4L
	dQfo6JTf4joidqDjJeQmK+Tv5AJ8ctwlSm+DugRXnR00yywa4hHkHt++c9HYrcBx
	hN3JW/8Nh+MgB0BWqUDib4m43cZHC6QcnXYgUQPTpvaOAmnfGr8NDNWDenX5bO7t
	wAsjz3OKftZJ+bAyIrH3TpFJ+/jom5uHNQzBB1kg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k4y26p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:13:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63K95FqE015274;
	Mon, 20 Apr 2026 09:13:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmm9pv8js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:13:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63K9DEGC23921042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 09:13:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 151E12004E;
	Mon, 20 Apr 2026 09:13:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F226820043;
	Mon, 20 Apr 2026 09:13:11 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 20 Apr 2026 09:13:11 +0000 (GMT)
Date: Mon, 20 Apr 2026 14:43:09 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Baolin Liu <liubaolin12138@163.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, wangguanyu@vivo.com,
        yi.zhang@huaweicloud.com, ritesh.list@gmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v2 v2 1/2] ext4: add blocks_allocated to mb_stats output
Message-ID: <aeXuJW-2ZWZwWWFQ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-2-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419063436.17999-2-liubaolin12138@163.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: zNou-LWy80lGbKKwQE7AqqwfUtae-24N
X-Proofpoint-ORIG-GUID: RsX_IQKszMgbeiPZ3jgEuRjGAlfX018l
X-Authority-Analysis: v=2.4 cv=VP7tWdPX c=1 sm=1 tr=0 ts=69e5ee2d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=xLPV0hCiKv225W59X5oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4NCBTYWx0ZWRfX7HosSU7INFAe
 06xLAaJBHM+flgSARv3E+4hsWJf96Bu0jhI6k1rpwxYxoZlahjvv+oZSDvja89WQ12i2B6JsAVC
 +jTunwq6LMUHLZ9nPneTE2F8CZxTZFqiTY7VeIqLEgtDPir/UsgdNecPqthdFsKJNWstHZ+Rrun
 IWx10cFL556c7hollp8++4NWTD5c6lkiEMc5dj16vQUOG5WDgxtQb6kOvx56YTCjLZ0UItwWi16
 Nr+Qawp0JqYDDLQYMGL1KzyB7fVC4pcO4qeDXGI2yLchpo9+9YqU5zcabcEMjxDA1RVu7Wsvqbm
 tJQEehb9nGWNtwn/oirm2s+9CNdDnajAc/ol0byz2wmR8qZUSstn8knY8vbeXJVH8lRctzo42C8
 GcB6xX89f72mekNdbiWOZ6ojMJO4cubDcHrvbcABrkpZeCe46gfWikaY8TQXizVQV1f53DlPAlF
 Hitegru/NTYiY1LVsLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200084

On Sun, Apr 19, 2026 at 02:34:35PM +0800, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> Add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats so that the
> reported statistics match the mballoc summary printed at unmount time.
> 
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> ---

Looks good,

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

>  fs/ext4/mballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..1e13ef62cb9d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3211,6 +3211,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
>  			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
>  		return 0;
>  	}
> +	seq_printf(seq, "\tblocks_allocated: %u\n",
> +		   atomic_read(&sbi->s_bal_allocated));
>  	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
>  	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
>  
> -- 
> 2.51.0
> 
