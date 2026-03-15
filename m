Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9240DFA7
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 06:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773555151; cv=none; b=uVOCjauxWVpnGbgM4kZRW3vFtG918n7pPks2y9ixACrljJ25IKi8zzRPvkVqHg3Qmggo9WV4eKUQYRNuiaj/nGvAbe445ho5T9K8Z5Oe65SbaKT1gy5fbtV0lSpjZwStlTbJnXeDqbabwAUrL0FgfqCbcty/Jkjj2grA95hRYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773555151; c=relaxed/simple;
	bh=1teZGRoEbgEelHl4GzmQ8VTqgWlNsJZMfNaweQsJs4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nn5JP7Mv2unozs+tV0jUDM7AD/+5p23yb1IfLQMcEhIPqrJHABS4fFR/LFH3zCtlMapWw9VUGBCRo8RBI7rtRKY7yg8tRwrpgJ6iGq7Mqlq8XH0mKKDx/8FotlQMsrGUB6mbp/JW+aRlkzGgiDNqNbroLT/JFWLW1BoXXH+PcK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aCpihAJh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aCpihAJh"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62F2v9bk3233341;
	Sun, 15 Mar 2026 06:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Ju2tP7ZRDJd1sZrYvFPR0gNGrfhjIy
	J+tByvFhA2ThI=; b=aCpihAJhsRHixJIsOaXu2cDkWISc3jZ00nUsfoUz25r/NF
	l+X6nWe6r1XraV6bbdFkKWbl/YvcSewDo63Zk/sMdDOjXlsSV0a98ZAEVBhvA3Wt
	Pl2rp1pwg1bzGFpH+hFtcfQvRk48pq03trKXF5pp5KrG9RBiv3vVFSrd+72tlMxD
	WAWo34/9aPeWaIwh8Ax1z2sH/J2RdJJ5jLBusuCZjVKzWa0zNpq16naOBzBETrm9
	8lytKvjqOKz7Eu4MrcZYJlWn+Y9WfYbCFV7WbTxi7v5T+4yROnF8gjWbhOqdhAmW
	ZPygcBgRc+yFRtgxer9dH43bBX8gVvSQVUP7UjAQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvy64bc9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:12:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F2gO1x032333;
	Sun, 15 Mar 2026 06:12:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwm7jgdfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 06:12:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F6CEbS13566368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 06:12:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E81A720043;
	Sun, 15 Mar 2026 06:12:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A831120040;
	Sun, 15 Mar 2026 06:12:12 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.251])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 15 Mar 2026 06:12:12 +0000 (GMT)
Date: Sun, 15 Mar 2026 11:42:10 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v3 3/5] ext4: fix the error handling process in
 extents_kunit_init).
Message-ID: <abZNuoGIOV1zgZNk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-4-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314074903.1314851-4-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d8X8AIzjQUvlda8lCRgeg0ozlZmJQoMp
X-Proofpoint-GUID: d8X8AIzjQUvlda8lCRgeg0ozlZmJQoMp
X-Authority-Analysis: v=2.4 cv=KYnfcAYD c=1 sm=1 tr=0 ts=69b64dc0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=M_5DJM6ivVKPHfYAEW8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDA0NiBTYWx0ZWRfX2k76Dl2W9HBU
 u6cUnh2qR2rrNCDCEV+W1gWh2W8I7JU9SjruTFuMm9cKHstMd7NeyTDr0l8VQJuHC5O3Xt/Ii+X
 bEYa9jB9Z3wNZYgzjjlAnsYR3wBKSdk9pRA/1HC8k39nhzsQbE1OB4TxkwQdoGCSiEESQ63MAwW
 amRgJ0X7zyO5uw0V8+v1NqBAhRvJ+lQODcdxUY9w/oxgz3wXBV2FGdNhDoo2V9vc2CTjNRT63d7
 RVOz+UMnIR1Y3h7iyzNn089GKHoDKrIEl4WSG8n2i8abew0UpMecapHohTPihOCuzzB2F5xxCsS
 gVKRZCmf/vrTN1CFhNNHNFSQNDIgsGZOCpdgqdfCxCE2x9eWVEEa1jWT07clm42zXNbrV/Gc1kU
 ZuDH2ScRdUoXKFVYmtodJFjW8ZiH0IJ+mOWf7Q8m/mpdUf2Lw4CAych2fYeYxK87w9J82JM8ys9
 yU+0KAL1FLBg4rCFI5A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150046

On Sat, Mar 14, 2026 at 03:49:01PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> The error processing in extents_kunit_init() is improper, causing
> resource leakage.
> Reconstruct the error handling process to prevent potential resource
> leaks
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Looks good,

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/extents-test.c | 44 ++++++++++++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 3d4663d99eb1..543236a31e13 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -225,33 +225,37 @@ static int extents_kunit_init(struct kunit *test)
>  		(struct kunit_ext_test_param *)(test->param_value);
>  	int err;
>  
> -	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
> -	if (IS_ERR(sb))
> -		return PTR_ERR(sb);
> -
> -	sb->s_blocksize = 4096;
> -	sb->s_blocksize_bits = 12;
> -
>  	sbi = kzalloc_obj(struct ext4_sb_info);
>  	if (sbi == NULL)
>  		return -ENOMEM;
>  
> +	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
> +	if (IS_ERR(sb)) {
> +		kfree(sbi);
> +		return PTR_ERR(sb);
> +	}
> +
>  	sbi->s_sb = sb;
>  	sb->s_fs_info = sbi;
>  
> +	sb->s_blocksize = 4096;
> +	sb->s_blocksize_bits = 12;
> +
>  	if (!param || !param->disable_zeroout)
>  		sbi->s_extent_max_zeroout_kb = 32;
>  
>  	/* setup the mock inode */
>  	k_ctx.k_ei = kzalloc_obj(struct ext4_inode_info);
> -	if (k_ctx.k_ei == NULL)
> -		return -ENOMEM;
> +	if (k_ctx.k_ei == NULL) {
> +		err = -ENOMEM;
> +		goto out_deactivate;
> +	}
>  	ei = k_ctx.k_ei;
>  	inode = &ei->vfs_inode;
>  
>  	err = ext4_es_register_shrinker(sbi);
>  	if (err)
> -		return err;
> +		goto out_deactivate;
>  
>  	ext4_es_init_tree(&ei->i_es_tree);
>  	rwlock_init(&ei->i_es_lock);
> @@ -267,8 +271,10 @@ static int extents_kunit_init(struct kunit *test)
>  	inode->i_sb = sb;
>  
>  	k_ctx.k_data = kzalloc(EXT_DATA_LEN * 4096, GFP_KERNEL);
> -	if (k_ctx.k_data == NULL)
> -		return -ENOMEM;
> +	if (k_ctx.k_data == NULL) {
> +		err = -ENOMEM;
> +		goto out_deactivate;
> +	}
>  
>  	/*
>  	 * set the data area to a junk value
> @@ -313,6 +319,20 @@ static int extents_kunit_init(struct kunit *test)
>  	up_write(&sb->s_umount);
>  
>  	return 0;
> +
> +out_deactivate:
> +	kfree(k_ctx.k_ei);
> +	k_ctx.k_ei = NULL;
> +
> +	kfree(k_ctx.k_data);
> +	k_ctx.k_data = NULL;
> +
> +	if (sbi->s_es_shrinker)
> +		ext4_es_unregister_shrinker(sbi);
> +	deactivate_locked_super(sb);
> +	kfree(sbi);
> +
> +	return err;
>  }
>  
>  /*
> -- 
> 2.34.1
> 
