Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793682690;
	b=0DazbTqOz5xhYzp4/dg/C29aQTeh8PNS+FtsDaCwWbf3Ir4zxLcYiAUoCEMR2T8c+ehj
	 GKRKrGEdRa5QWg9KDHPJF6CASm+SAKcx5kKQjFAPKd12y9GYerV9f+KEMz25wBhG0mOKU
	 623lT7fosNEdrXE/j/Un3XSuItOfWequbFAnVVkCP+8rWpAj49caAhj2Q8DAjRmv313wm
	 OLo8iMk2g8viMmAw/v5P5YONAug0DjBMyiW1xHkWtC+9D6OdCmJ67LzNA+kJxvv1n/mPF
	 edfWnb8tMimMNVEdLoblUENi9onI9iZuAvOCWHH9ekMxdH6eI9tJq5TXLaENCl+/OkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793682690;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=j7vQDEKQmGcWvPJaz5e72XAn3awce25f7QO5l1L+IV0=;
	b=flE+CiE35y2ZgP/xfQIvehxiXndF9STxbHrW1jcKCb1ZSQQ1VmrR0K3wuRh/YcSyhG4G
	 uIwoS/tCw4I12CA1abg8CCqupO44PFoV/8XReAWU8c3ynVSH5CJPftL10tQMC+1wPI9n9
	 g+lkrqjDbqGFAnoZwgqeE5qq2vNsTAOAE754Xk7GGAfIHl41VkIzENOw6fr7s5pVC4AQN
	 Pv/XJjYDjwnd7kdGCrCoeVs70LCrAVBhTi6XryUdb5up0GIzWBAqevzaujth5Eyw5G3Xw
	 efcrpFyzt/uiOLRXsGnkcZVqP4Vn35kpJRe1o+5LP9r65Et3akkqhn3K67siZJehY+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=YmHu2zWc;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD34606A324;
	Tue,  3 Nov 2026 05:11:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CD34606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=YmHu2zWc
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A31iMlM236041;
	Tue, 3 Nov 2026 05:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=j7vQDEKQmGcWvPJaz5e72XAn3awce2
	5f7QO5l1L+IV0=; b=YmHu2zWcELr46SCzBTRBQGPX9RN3eVcG3XsZbMBdtUl30R
	5DXT1zlE3ZQP1smydFmgPbKNZoobHTK4MZ0yOnttgEMZa/P1j2PsXdFiHFEwXuh7
	DPGRYsF/dJEfSXmTTZauI568ZTCabh5rgNH3T/u9Y6AYj40aZnaYTUVabH4r5fUd
	jPFoTvAMfJK4VdDNTH+L+MC5xXsWHf/u438BdloGe2EjXKHxrSBDwkL0xtJSRRcd
	twfMKva33gDsfEr3I//MxN3GlFEeHxL1ZBAVzCT6n+oO+xq3BlDhqNMAdxR0qqay
	xgNNP9gJ6ojFX/dLLtKiOFsM5vqbv0JMNLqGVLDA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn5rhm1mw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 05:11:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A31o1JL623480;
	Tue, 3 Nov 2026 05:11:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hnvvfrrjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 05:11:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A35BDEa50528598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Nov 2026 05:11:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 138DD20043;
	Tue,  3 Nov 2026 05:11:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 957D42004B;
	Tue,  3 Nov 2026 05:11:09 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.27.56])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  3 Nov 2026 05:11:09 +0000 (GMT)
Date: Tue, 3 Nov 2026 10:41:06 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: report unwritten extent conversion failures as
 writeback errors
Message-ID: <auls6tGk1DAr-uTn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261015102943.74632-1-guolingxing@tju.edu.cn>
 <20261101102145.647496-1-guolingxing@tju.edu.cn>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101102145.647496-1-guolingxing@tju.edu.cn>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: SOj_O2UZAsWuD7SAr4RJPOH4R-C34hmo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDAxOCBTYWx0ZWRfX47pcEP3Xk023
 8OxjPGnmf7RSamZLb4ZVBhZT2V5tNgw5FBOJ3CZrOk1UIXmz7U9Xp72A+VACO4w7jDJTazCN3uW
 QAOxjesVUn1l/meHff3ow2jrJWKd86U=
X-Authority-Analysis: v=2.4 cv=LokHWXdc c=1 sm=1 tr=0 ts=6ae96cf4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=z4EYaZmNoVUiA4pjg24A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDAxOCBTYWx0ZWRfX9GkB26nBatIV
 V6uVidMitkwwEg1ErQF5AFv0WKhV7XBPFbinKPlnRtR557uwMJLzvcauE5jcaPfnFJ2GlmE7YRg
 8QpAgSGFPGVvsP9V98/hjIViV4mbJK0HeQP+6fv1Kdy36PPUhuuIblhTNcuVTZGYXZaSS0wg9sU
 e1F6yBBgdm9LEDqZ4t3vUkjGARkGwvjK/UHJ2jtLJeJCe02XFwN+ga132KFHf1KywH8GRSg3Db7
 LrOZTQDbIJ23kscMHdogNPaz1Z1qVnFD+ttPgFohcY7oSK2UQaJ3irZrE/IIAs8Uv5F44GHyl2h
 8H/mM4mg6vgC0wisEkkztnL7eQ0n/qiU2K34ydTv+/WRaCEOk6WjRd3k+FQ+37BvY3x3NnvlHMr
 Jp7FGjBS0VmqtdjJFVTzve3yULPaoajk5FbJQu+x/1GoVOewJ1yuMvJwp4wSXZz0gXgBoA1pEPQ
 4C/5gnPYrhGDJMTCMng==
X-Proofpoint-GUID: WTg2K7L-m-8lLPqRSOr4RtBAyAjuxAA-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_01,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030018

On Sun, Nov 01, 2026 at 10:21:45AM +0000, guolingxing wrote:
> When a data writeback bio completes successfully but the subsequent
> unwritten extent conversion fails, ext4_end_io_end() does not record
> the error in the inode's mapping writeback error state.
> 
> Bio failures are already recorded by ext4_end_bio(), but conversion
> failures are not. When the conversion is processed asynchronously,
> its return value is not propagated to userspace, so fsync() may
> return success despite the failed conversion.
> 
> Record conversion errors with mapping_set_error() before
> ext4_release_io_end() ends folio writeback and wakes waiters. This
> allows fsync() to observe the failure.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> Reviewed-by: Jan Kara <jack@suse.cz>

Yep, I noticed this recently when an endio failed during conversion in
prod but fsync went through :/ 

Thanks for fixing it, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
> Changes since v1:
> - Drop the incorrect Fixes tag. The conversion error was already lost
>   before commit b82e384c7bb9, as pointed out by Jan Kara.
> - Collect Reviewed-by from Jan Kara.
> 
>  fs/ext4/page-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 734d856a6d478..2701452fa65ca 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -192,6 +192,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
>  			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
>  	} else {
>  		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
> +		if (ret < 0)
> +			mapping_set_error(inode->i_mapping, ret);
>  	}
>  	if (ret < 0 && !ext4_emergency_state(sb) &&
>  	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
> -- 
> 2.34.1
> 
