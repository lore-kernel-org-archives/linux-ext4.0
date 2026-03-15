Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C709B21CA03
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 05:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773553271; cv=none; b=jE/uSMfY0tP9rBOPfrjzgH8ipWVxC1ByhSF9u8NszmWvbAQBcNwKn9stHfRkUNLpWRhyBlqIKAAX6zY7MqtR5LasWHztHA/W33KYuSlqzZFsdp/LMjv5vAGm5AyvfUsX5Teb4zwpyor7wZoUlKj0WNcotze8lxfWJBTlEUGsgr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773553271; c=relaxed/simple;
	bh=Zosl8RCGdad0/0vjItTzxHL7zmAZSvcoOq2TumQ0hls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIXm2G3Xq9zerwmYbs8cmhJHBKC/C6j30UWHK0mEiu4eVYinLo2T0dNQj8iR0UOK/EIUE0gSU+WYyg7SQ0uSV6a6jk0eZxV5X+GrRdUVp6s6wS1jnDtrByfytqGyU5zy6usHnYI0/+2r/PpDh9vbGlWvBKYKjfs8D7o8Pblku1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bzzgstrl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bzzgstrl"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62F2spEw2899325;
	Sun, 15 Mar 2026 05:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=FKIdcyi8ClgiJCr8SbMJL0sfrjk2YP
	swaG4AONP9dEM=; b=bzzgstrl+F8wd0GBzFP6eT4SheEi+BOEqOmq9Z8eUHcZIs
	KmxSgf2tgiJq0/Dx0kM6DiXiB9aYdii4T0McC214xzMbmV9xfGFNbhsbmObQylUd
	pUBR+EDIDuPW2ilYBqFO0o5IeRG8duHM0jQ0qIoJKL6jP+WrRojBhdUXnEaM7XDs
	YqRnPQLtbMiJazZXaWoCnpmLXfmfHeBxO7+vAkW2bfA+/gZp3qiARLpbXKZF/MPz
	Zl3ylzu+v4Gkf3oVCKqjD9Y/WCpguNvlTmakuVIJTvllSQoD6UELhpQy4TzHPS7U
	4P2Ul2oE0cnifgkUnsQ22F/zBEWpiPwoaZMHZEMQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyd3b9ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 05:40:52 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F0BSmR004585;
	Sun, 15 Mar 2026 05:40:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwj0s0mqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 05:40:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F5enAm50004440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 05:40:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 824262004E;
	Sun, 15 Mar 2026 05:40:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3DBD2004B;
	Sun, 15 Mar 2026 05:40:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 15 Mar 2026 05:40:47 +0000 (GMT)
Date: Sun, 15 Mar 2026 11:10:45 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v3 2/5] ext4: fix miss unlock 'sb->s_umount' in
 extents_kunit_init()
Message-ID: <abZGXZmbUew5J7XS@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-3-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314074903.1314851-3-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PbPyRyhd c=1 sm=1 tr=0 ts=69b64664 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=r-ZyBD4Gqz19HRYdJEAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 3BoZ0DifGu9lbFwv5Qsx9qQ0ic4W06Ig
X-Proofpoint-GUID: 3BoZ0DifGu9lbFwv5Qsx9qQ0ic4W06Ig
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDAzOCBTYWx0ZWRfX8ISSRTMjZfr7
 mASgCS2ylZT20p+NPRY1km2ZXUq51iRkqWkOvigCJHzK0Ly39E53mJeq1t2FQYM5oVfAgmDcRjh
 Id9zlekvytJnzqxnG9B6Cn/enaVpDUcfr9aVvKWQFyv3OuHX3h4wPFYhjcnrV4motmsl80UHUAQ
 drT4eL66FA50Y8+tsv/UYnAmwWkZH8A01mAS2SNC0C5yYqaT0zq73biJ7jYNUWgduYfovPSr62Q
 fjW2XoTiyqL/cpzWZtsRHMO8tkkF+8a3XedFfhyNpckTn6qBClNWSuRkuosMhvqftPbiwRd1X/L
 DJXEUJlBt1g2saBrk6S/T1Zcgprz48KtugQgpdBj/x++GA0fGr8afhswRZTPsaEpwqD+hgJbCo/
 Xzv08H8GqPN8RwOp5A0sY/pUCi3jkP+eLEljm0ksatz5ZY1BSZKkP+z851GIFAbHXi18L6MYAUo
 uL6nSERlM8hHbyGQAoA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150038

On Sat, Mar 14, 2026 at 03:49:00PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> There's warning as follows when do ext4 kunit test:
> WARNING: kunit_try_catch/15923 still has locks held!
> 7.0.0-rc3-next-20260309-00028-g73f965a1bbb1-dirty #281 Tainted: G            E    N
> 1 lock held by kunit_try_catch/15923:
>  #0: ffff888139f860e0 (&type->s_umount_key#70/1){+.+.}-{4:4}, at: alloc_super.constprop.0+0x172/0xa90
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x180/0x1b0
>  debug_check_no_locks_held+0xc8/0xd0
>  do_exit+0x1502/0x2b20
>  kthread+0x3a9/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
> 
> As sget() will return 'sb' which holds 's->s_umount' lock. However,
> "extents-test" miss unlock this lock.
> So unlock 's->s_umount' in the end of extents_kunit_init().
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index e3d23e3cda87..3d4663d99eb1 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -310,6 +310,8 @@ static int extents_kunit_init(struct kunit *test)
>  	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
>  	kunit_activate_static_stub(test, ext4_issue_zeroout,
>  				   ext4_issue_zeroout_stub);
> +	up_write(&sb->s_umount);
> +

Looks good, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Just make sure to put this before patch 1 (more info in review to patch
1)

Regards,
ojaswin

>  	return 0;
>  }
>  
> -- 
> 2.34.1
> 
