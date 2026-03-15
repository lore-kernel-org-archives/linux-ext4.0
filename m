Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0964140DFAF
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 06:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773555811; cv=none; b=fnY3DICwZwzsBckv5GDN0GeJ5TJsmEMR+gvnUyi2wpAA24hLCRVTOLEmZAu6LgatuiD5y4AxwIEW0HRrAG1+XJwiOWsH8enpLfpW4MS16FIA9FHZyzWs49o1QOrIsoZLClM3JxpgalsWTuA8IT7TIXKElppSWb2Pih0SFJXQrpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773555811; c=relaxed/simple;
	bh=HZwfjMja0bx/AyN9qPswGy6E4Ob/q0XOgFkWhoosKf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFG8U8q0HoY794Dst3fIxZgwc2aoZrtKFQ5qFhHWtwHTsw78eJcbQ0smWELlQNP87VzEADNT9HaQOhAbkQyOl/C78dA3blJixj8DALLmD9xaeiPk71A9nW4gQNVrBDJOZETWsXAZYfBBe84jNXjPWyP+V8ubyMif7iivPF+n1zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SbUBe8Al; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SbUBe8Al"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62F0MEWT2617608;
	Sun, 15 Mar 2026 06:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Oj5OTTjs+LpJbO0cGb5iIx8gk9SEdi
	1t/d+/wxsVN2g=; b=SbUBe8AlT8hIYDUS5oa+Re7sgOj++WPYPXTEuMsi3pfm3d
	5f98zIz+kY6imeP0BZwcWABfdctTRquTHbK7qgMgXMGJKA9HHCvA4xcgql8coh/d
	UJOPYmKCEWiJcna/dzWcNSvKCr0fCLp70aODpH4hploR3neriw74qMcIU7+tfZxk
	z8KIfW7xptuMOXlexpKqArWkOcvT3WYT1Jpfc0RXKyNgVLjJ6mbu4nqAVY2pPIjU
	gt2izekxvJa+vsOejste0rmjohU/aCLbOxMZDp0q43EDGa0RKZ7j3zD5I0DsUSqV
	A/JO6rrhZq1VfkXNTs35H4RmNBhEisKJTbehb+Sw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyd3bbtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:23:16 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F1rIUK028708;
	Sun, 15 Mar 2026 06:23:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwkgk0heq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:23:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F6NDOj46989730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 06:23:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FF4320043;
	Sun, 15 Mar 2026 06:23:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 251BF20040;
	Sun, 15 Mar 2026 06:23:12 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 15 Mar 2026 06:23:11 +0000 (GMT)
Date: Sun, 15 Mar 2026 11:53:09 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v3 5/5] ext4: fix possible null-ptr-deref in
 mbt_kunit_exit()
Message-ID: <abZQTdGoqYQjzzoY@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-6-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314074903.1314851-6-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PbPyRyhd c=1 sm=1 tr=0 ts=69b65054 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=w-EAdWazFygmVnaBglcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 4Hc9jq5laBPXkCIpEVTKOPOxlsQ-9UfY
X-Proofpoint-GUID: 4Hc9jq5laBPXkCIpEVTKOPOxlsQ-9UfY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDA0NiBTYWx0ZWRfX6qNEo3c2y/Yq
 V8VOyAD4Y4DxCDEDvNDkPQ2DLdlY7SdDus8TVnpAbXj+N5Q67s8sgJ5w40qsDbHkBJWD2TNlqWf
 YELLbgqrnWORf9ZaOLZ9t+BnMAhRgc83JRi6NF2ymzD0/0nE0ZN1Ei98m8jqp4dvN7r9614VHn/
 Sfdr9v+R0n1+XDNAxfNqCJB8Dm27kp7SfteNL87uv1CM4Qbwl3xECsVTt6T6LvvU/16P1znIW9Z
 sl8Ulo1OtnHH74qyU7APH/F/ya1za8IU4ZQaJetJJfV1QfCSHTCD1TJpzJ1JyjLH5i3UUGFvTL8
 94VDTgGV1eslaYyLULgXrVwCb8QeNk6oUGl4h+JPoCNko3KxT2cx1quxOzlB2zkbTnrAXE3l+wP
 7VLcix+uwIxSQmeAtbOjVxXtw4U1UORCBNTVKPSO3ihiI4NU09XkKShjeGppmOI5l3rBY5ysbmE
 0HnNTXLlnvZ0EPCJO1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150046

On Sat, Mar 14, 2026 at 03:49:03PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> There's issue as follows:
>     # test_new_blocks_simple: failed to initialize: -12
> KASAN: null-ptr-deref in range [0x0000000000000638-0x000000000000063f]
> Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
> RIP: 0010:mbt_kunit_exit+0x5e/0x3e0 [ext4_test]
> Call Trace:
>  <TASK>
>  kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
>  kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
>  kthread+0x408/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
> 
> If mbt_kunit_init() init testcase failed will lead to null-ptr-deref.
> So add test if 'sb' is inited success in mbt_kunit_exit().
> 
> Fixes: 7c9fa399a369 ("ext4: add first unit test for ext4_mb_new_blocks_simple in mballoc")
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Hi Ye, looks good.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/mballoc-test.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index c75b91ae0cf0..90ed505fa4b1 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -362,7 +362,6 @@ static int mbt_kunit_init(struct kunit *test)
>  		return ret;
>  	}
>  
> -	test->priv = sb;
>  	kunit_activate_static_stub(test,
>  				   ext4_read_block_bitmap_nowait,
>  				   ext4_read_block_bitmap_nowait_stub);
> @@ -383,6 +382,8 @@ static int mbt_kunit_init(struct kunit *test)
>  		return -ENOMEM;
>  	}
>  
> +	test->priv = sb;
> +
>  	return 0;
>  }
>  
> @@ -390,6 +391,9 @@ static void mbt_kunit_exit(struct kunit *test)
>  {
>  	struct super_block *sb = (struct super_block *)test->priv;
>  
> +	if (!sb)
> +		return;
> +
>  	mbt_mb_release(sb);
>  	mbt_ctx_release(sb);
>  	mbt_ext4_free_super_block(sb);
> -- 
> 2.34.1
> 
