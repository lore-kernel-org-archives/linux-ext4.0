Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1740A1DF254
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 05:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773553187; cv=none; b=sdU8Us7R7sK8xih9pmdzOuTvsjcdSediXEZ/tLQMLzSkksvtx7yYsflUG4UwbVhaaN5gqZYEqcXa2ZMepoz9D6QkHPnldlDlsqCPbwxOJgWqy9BSSnRVdC+RRWJJG4KZFkeW8AptQJecRXLR+CmVo1IXQdMgDpGk8o39ddZPoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773553187; c=relaxed/simple;
	bh=UEma0sMAzUo+7jZhmee/vFCEdC2Nb7D+V0GMK2oHB3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbM/vcscDWysd57aZ+ZY7pHGBG33Aw0SW1EBiM4YaWK/h4z4vUO2p607rFhHDNC/T1Vg5RqPkJwAhhu1t7sOlwGDJuqFJHodOe9lUUSPghsqiBCTL1JJ3H0teFoTvqL45j/sMZ3jnU3M4+R/JtyWVQ4Uf/27nBYXtZd0fgwx4X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nt+5VsNM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nt+5VsNM"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62F5F2If3489119;
	Sun, 15 Mar 2026 05:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=vdW0iU9Xq2qV5MWZl9OLoTGdcBswcm
	DVo/JVboukEt0=; b=nt+5VsNMnWZOnkpy6iReH1L/Qcf/Xf809tQr4lxdnJoKc9
	DXll+nTEyL007U6GY7UQWgqp8IN6N8Qlg+TVm6fTZ+0w2YQWy3QqWvj3m31S7zQ2
	FmWCuzpec4gS+SJQdwq2ORV68sX9MiRqt4VRIPhu1emvCLTLE4VYoTi3rClvjl6z
	9SV0m9/eGNthG8y/6OqYKZbJOjC3RhctTWypcd07EwqGvi4FDwi1iP1nhEDUaDQ7
	b3zmAZhEdrkZHGXwm9JK56n70bHCVW2lgPT8/MPs+KtgTdgLl7azqsE4lZubhR/5
	ie0tRFHfHQoOLIcP8foVF6hcQrt+ikpoylY3oaig==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvy64baaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 05:39:26 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F1JfvL015735;
	Sun, 15 Mar 2026 05:39:25 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwk0n0gcj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 05:39:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F5dMT856689058
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 05:39:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC77E2004B;
	Sun, 15 Mar 2026 05:39:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5924220043;
	Sun, 15 Mar 2026 05:39:21 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 15 Mar 2026 05:39:21 +0000 (GMT)
Date: Sun, 15 Mar 2026 11:09:18 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v3 1/5] ext4: call deactivate_super() in
 extents_kunit_exit()
Message-ID: <abZGBuItRfxDGe7m@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-2-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314074903.1314851-2-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ktzVQ0a1AnHg-GydoMv4ERhjcK5u9aV7
X-Proofpoint-GUID: ktzVQ0a1AnHg-GydoMv4ERhjcK5u9aV7
X-Authority-Analysis: v=2.4 cv=KYnfcAYD c=1 sm=1 tr=0 ts=69b6460e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=r-ZyBD4Gqz19HRYdJEAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDAzOCBTYWx0ZWRfX1umjAS+BxQiY
 obTGcBvHVBaUjjIqU7/6cRXjZYBMyYriDQRHUYH8+LifpcOWdGvUcZL4GgNYa0BZTqyKtxf3yD8
 hHmFKICf9inUAFoa9BCykHl3BtHHwm0OpfDEtFDyxhA+hyjMh8BGUbp1qV3JdUBa8Dojs4KtGhI
 QnRbvjADnp7GzVcmmx5j+8ivbjkkriGjqcYmteHQbMe/HZ6ZFYwvm69B0Ndj1ElKMchFJ6f50eu
 dnsq4Phz9R1wAoYjqRnWWhbO+4Ovs9ZGN5jyBExQHv54lpJbmlH+5Nt/w5v12u86Uhz6/1EvNjj
 Jy3JPooUcAZSQ+grF7FJ2afTMlxj5sPWZT1ds8qRWV1IM19kXlEW8wJ7FyzzlczfWuBOtwdT345
 J+Q5K25it2OxNUHZ6slcjGW8iw+Xe3SHZXIGNpTLQ6v5tWWqOe/WXJ6rlq7xpFgNglGjx+i8wtz
 Yv5m4VDD6CIlGxMZKFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150038

On Sat, Mar 14, 2026 at 03:48:59PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Call deactivate_super() is called in extents_kunit_exit() to cleanup
> the file system resource.
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 5496b2c8e2cd..e3d23e3cda87 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -146,6 +146,7 @@ static void extents_kunit_exit(struct kunit *test)
>  	struct ext4_sb_info *sbi = sb->s_fs_info;
>  
>  	ext4_es_unregister_shrinker(sbi);
> +	deactivate_super(sbi->s_sb);
>  	kfree(sbi);
>  	kfree(k_ctx.k_ei);
>  	kfree(k_ctx.k_data);
> -- 
> 2.34.1

Hi,

We need to keep this patch after Patch 2 because else there is a
deadlock:

extents_kunit_init()
  sget
    down_write(s_umount)
extents_kunit_exit()
  deactivate_super
    down_write(s_umount)

Regards,
ojaswin
