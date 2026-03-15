Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44523BCEE
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773555236; cv=none; b=ou6nlPtQl5YZFOSya4zXM0oCozNSCQKWtc8bRu1HW6xhsgqpDq1WScrDmG5hy5lIkZONFSqe/A1C6qKsui23mVr4KEWp84YPPEoM7XRsKs1h/PwvHhxaaF1uztS8STTFc3Cf0k3NndOZ4reTm8MnztbWkgA3tw5h5M5xoW2gp8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773555236; c=relaxed/simple;
	bh=7LkzBzi+bruRzfecqCg4BcUBQlb9PUMxrYwkixFN9mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xbt1sFzp0KYP5RH3xS3pnij/BEUTXUDJc8uJeTvGm371uMgmF3RTQXahv5vw0nsJMqtvSFXhYadWCJc2fTnb1x1XehSryh2kV3zACf3sJpwTolVBx0buGHDxe0qZFFf9uZUraH2y0VJ8OrFLVq10E6V4qmsFxl4tey8bvGGEi70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q35X97uE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q35X97uE"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62EMU41W2463658;
	Sun, 15 Mar 2026 06:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=epxZ3G9CcQ2IwOQ+fEXPEYg0nkZ9Ir
	fgZZIwV/lVCzU=; b=Q35X97uEVxNrytYSK3MbRgci7UDfI5Ul4vYlZRun9Re3P/
	wNJTceOlK7rsMDnLdiRCtj+agKSHQrEnozQOktKEj4FpQEQPUXZtKaEL6bSupvMN
	TmJyi7cz/8GxrWtgBUTntXUOnZKdsMSAUOjYbGmJoiZR47Rp1e5CtywZm3dJ9G5P
	ccFK6+YJ+cV+UXnycqM9bvkC37rbkqOJrf7+lfDZoxuQ0J7aOCViMu7+3NyyLOC4
	1KgeLUqJY3zs/DS0aTAg0zZbxw69faFpSADhqZh7JrOQFo8+N7WYB+VD5zFp0mbV
	iU5h13yeQRlipdiVG7q2RU4yHbTd2G2YPVAZeO8Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyau34jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:13:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F0bj8d014113;
	Sun, 15 Mar 2026 06:13:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwjcxrna7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:13:40 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F6DcSS7733676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 06:13:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5A3620043;
	Sun, 15 Mar 2026 06:13:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B8D220040;
	Sun, 15 Mar 2026 06:13:37 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 15 Mar 2026 06:13:37 +0000 (GMT)
Date: Sun, 15 Mar 2026 11:43:34 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v3 4/5] ext4: fix possible null-ptr-deref in
 extents_kunit_exit()
Message-ID: <abZODmzun0NQehyx@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-5-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314074903.1314851-5-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDA0NiBTYWx0ZWRfX8vhiZhujryQe
 74QKZ7wJ2X5jumEduv9eLI7pCXKshz9R8lyZJSAUs+kX1z7O01fa3Shj/w4tb6S/JoHiJxBehf4
 M9d9a9QBLvFD74Jt9+nFodxdQEyAWqQx8GJrr6cUjbp0uF3Waotfn8TJ+4PuG/X5AzyRaYuqp9O
 wvGd+yvvIvhuSD5eHcnRLwoR0AgwDNroXe7C4UBvSJlZhwGKzL2bwJO+adiKB1UiiRTt6Pt7C20
 doWSQR9/haX7RjRIV+j/xZyH7SdZSowdEkW0iqhXpYPXuc+UzoXMGwgdjYnGMal56bKH6ALIs+j
 2TA5bB0Lelbr/reSAt+9I57ydV3RqiC98Xp571dsJ0TvqLGposZQMhVIWMqb/qph6LVZVmdye0g
 J8mrNsZUq+Q9xmFogsSNDzg959SitqJAtEktuoGYowB1gH0J87pxklp7puN+3JP1UPVKLKDQnJY
 n3ZMgMYWbF5ta3938Kw==
X-Authority-Analysis: v=2.4 cv=GIQF0+NK c=1 sm=1 tr=0 ts=69b64e15 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=r-ZyBD4Gqz19HRYdJEAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: rdG8-wFb-sy_-Gg7MQhqW6ntmMf4393o
X-Proofpoint-GUID: rdG8-wFb-sy_-Gg7MQhqW6ntmMf4393o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150046

On Sat, Mar 14, 2026 at 03:49:02PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> There's issue as follows:
> KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
> Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
> RIP: 0010:extents_kunit_exit+0x2e/0xc0 [ext4_test]
> Call Trace:
>  <TASK>
>  kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
>  kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
>  kthread+0x408/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
> 
> Above issue happens as extents_kunit_init() init testcase failed.
> So test if testcase is inited success.
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 543236a31e13..6ae72986ca9c 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -142,9 +142,12 @@ static struct file_system_type ext_fs_type = {
>  
>  static void extents_kunit_exit(struct kunit *test)
>  {
> -	struct super_block *sb = k_ctx.k_ei->vfs_inode.i_sb;
> -	struct ext4_sb_info *sbi = sb->s_fs_info;
> +	struct ext4_sb_info *sbi;
>  
> +	if (!k_ctx.k_ei)
> +		return;
> +
> +	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
>  	ext4_es_unregister_shrinker(sbi);
>  	deactivate_super(sbi->s_sb);
>  	kfree(sbi);

Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> -- 
> 2.34.1
> 
