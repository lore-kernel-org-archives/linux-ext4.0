Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792727030;
	b=INWYw2VgxysS0NDfBDX5WbkGVhGOa63CY69G2DE54wY0xrf/cV+G7s4jXzNAfVF3fBUu
	 NEJNwLUn7cmYzvlfuRrlqt+ewOpIftM1PMUdjFottWIfAjBr4Nsr/hn5Bm6MU5vkTZrEh
	 TObrSjmRyDixhAaaVJQRhE8jH3BALVW/oHHIqojdPQJkD9E8W9BeS5h2z8XUH8yxQxRzC
	 l+/mA0diQwu8v3tDt8wuQlPZUxSAIqMxg/A7QT/vVh8us0iC55zEycmMtgSjv40lnMO7Q
	 6jhNrNjlUZViH6cXsU2VSSKWr8wmlTf946tGk/1KcDEljYTk3eU6ybQSTEKfQCzCy7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792727030;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=6G0+vRbNzu44af59yjeJcszY1vwSJY8LZ/VKcohLElY=;
	b=1CoExkaI7DH078rObx/175DOHqjcAM02Sos8Havkhyz00/JBKyYPY9vOVv9d/yX2UrXJ
	 N2Xq+dxA8bG0q4gYzAIPtUpUHqxXYJHPBZY+vBy8Ask2Zkj9yo1M8sMX3bP8OponEZ5+N
	 qCz2gVtzOQl4w08IrPsZxcuCNRM6UCu94p9jkZhwCxH84MMKiqYaqaYOvtFMq8Sexc0ts
	 8gIrTl3o+JB9qrr2OFD0jOCB8sVWRELIq7EMqx8Hgeg5qmtujv2XtBEfNjNc5ccC7gAX0
	 IDyUrbTnhMY04KoyDUM4COJPg7zFtfGYjCyMtYRjlznX/A0/KUfk3zNMzizh4s1o0Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oNmBCFhm;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00001606A319;
	Fri, 23 Oct 2026 03:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00001606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oNmBCFhm
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1EHij4011184;
	Fri, 23 Oct 2026 03:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6G0+vRbNzu44af59yjeJcszY1vwSJY
	8LZ/VKcohLElY=; b=oNmBCFhmSWumA5X0+ZBPneasDC9boSOZxNGW5MjqFXyaGg
	Mh+e5MJOLcQlpvuLC16ADNrF/mHZGCGrN0NRlEYW8arWc3iKlUteGigHTIGFeRRA
	tN/zJaIjqlsSlu/Y9MSsS32dbEztk87ntbGLn2VLEGjDsgYSakAtriVuJgkjZG7b
	gdi/nRy2VJhUo1TPu55CqKE+QNFA2sHHRL+9/vfrj9kVSyxbRE3hi/0HRzQ+/SFx
	IgNeqWV0tmEOus0kI1su8SiGFXQ8peA/g8weSQoKqJf8rvz+kPw+ZvROzLphcBiD
	R5WQtJhl8hMa0mNuYaTT/M7d8ho7k6mVKxU+3oWw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bu53v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:43:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1JtRn165622;
	Fri, 23 Oct 2026 03:43:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hefssb2dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:43:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69N3hYem47513874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 03:43:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D555D20043;
	Fri, 23 Oct 2026 03:43:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89CC320040;
	Fri, 23 Oct 2026 03:43:32 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.17.104])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 23 Oct 2026 03:43:32 +0000 (GMT)
Date: Fri, 23 Oct 2026 09:16:21 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>, Ye Bin <yebin10@huawei.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
Message-ID: <atrYjeSXogEnUBJG@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
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
In-Reply-To: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Z35kNbcocHAHZxCpBNS-b7mmnWp-JHw_
X-Proofpoint-ORIG-GUID: tpbFI48vCHlVzDh3L_v8gqoks7lxqaJI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAxMiBTYWx0ZWRfX28uD9uDqDyEp
 fuJaZKriTtktGDfPWEEsFjRzGCrStx7RnNrlRDDnFLcH/I/XsgPR4bk0IW89/tJ9PBdba8S7Bu4
 BuvWOiCYg0/LadwvUMm9+g9P0pNWCqw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAxMiBTYWx0ZWRfX/W/KLdn7FVRd
 85pUDURIVOt9edOKsalfwBcreFqFiREtETTWN+Xi1vSmiAf+1/pfSguPVkJrrD28EhTtCP99UHy
 UCZ+3icbPQrxse2zyu2U92gawmWVbQyyibm1cvKjJTv9zbFC1l5e8z4GkbftcPRps6ogKu0y6Aj
 PUCef5sbicq4eDQqdMwCJodK0+nZ+yJNQERrpMdGjZ2JfYWcGgdBfoMu+4oWc3Igx9aqYQyGVh3
 A6zOdAL/tLN3zkrB3VVHwWlbvbxiGNaYI5D5wSL1nydta8XSAL+hurOFqNGDIwf83trvq1DpYCD
 dVmXWAKuxaBX8t8mod+OPWN/rkqD6WH1Ej4kjUGtZ9qitIJQpWa7qw3ZjjKBp/+1r3hInrIzQXa
 fAfauV0RLu0kNcqY/azeyUME8bnasvmBKKtN+eMuSSSenn7x1/c2WW8uzOporVaxiU437iisias
 LWtfBIaq3rG5zvfDaKw==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6adad7e9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=SRrdq9N9AAAA:8 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8
 a=ozi8al-SNXDmhG0Np4AA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230012

On Thu, Sep 24, 2026 at 01:09:28PM +0530, Ojaswin Mujoo wrote:
> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:
> 
> >> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>    declared. Should it be static?
> 
> Fix this by declaring it as static.
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/
> Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Hi Ted,

A gentle ping on this small fix.

Regards,
ojaswin

> ---
>  fs/ext4/extents-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index bd7795a82607..9669b2197fca 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -48,7 +48,7 @@
>  #define EXT_DATA_LBLK 10
>  #define EXT_DATA_LEN 3
>  
> -struct kunit_ctx {
> +static struct kunit_ctx {
>  	/*
>  	 * Ext4 inode which has only 1 unwrit extent
>  	 */
> -- 
> 2.55.0
> 
