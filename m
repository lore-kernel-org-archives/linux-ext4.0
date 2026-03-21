Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1F83451CD
	for <linux-ext4@vger.kernel.org>; Sat, 21 Mar 2026 07:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774079679; cv=none; b=jZ0IMt30xhHAIvca3Uf6149rhF0hPacZJcGKd+rIFkMOId1KxTUCWh1wkkw39Ab3Dkn3t3KIM3e3IO2tuGOTeA3twsS3YXSSyXLUiM6waoanHAqTxdl01XEol2dc7OFpZIyOcdzYW1HLmlpHZBCEu1KTj9Sd3+odQ5qZk3EqgfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774079679; c=relaxed/simple;
	bh=/vElXNQap9qGYr7wfAOaf4YhAPAtqtxN6TRzLofbguQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+yDIxPfUx7KQQqETMStArS/sFt0vwqF82n9QY0lnUVdyjryGiAYy2uwRqzonI/vVkCgWMDIkuTNhJz3+TYKZ23hmuyMdEjes9SMrKy84tGsu9zt+xbyuq5I/s/RrOXJWfMnU7o9N5mWnvNR5yrzW32H6Gy76CT55XtWrQzfQBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NUJGylXs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NUJGylXs"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62L6BZEO203621;
	Sat, 21 Mar 2026 07:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QjhmRkArDfsdLSaWMXHqPSQo7ey9yM
	YnFdkuoxe5M/E=; b=NUJGylXsWhNipgpxoQMBOuCMqDdV9V5a9o/Ev2XMM38nCs
	oNlU2nHh/O0EJU9JUcFB3DhvLWLcS665s2IDlXHJNdIN4WS08PjSHEyuKg+4bwET
	KdE4y9jIQHu7soKSZfNW0HAxV9TXd1MGe643Lvgc7CNCXuzZRAU0bkfowhkRbN/y
	bYvSo/WfXO/VC8xAm3lCoMSij1aSHETIvxUDX07qXxpjhadonZi5ZOo6vbhxPVam
	HTLO4c2G4GwA9ke2M25LgfBwFc5yKQci5uY2tBAEEYGNT/uMz6ahyH8RNjy5WNjg
	cKYVfgRByR4bDU7wv5+wqDuSaqppisiG4EL+yHDQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktugdx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 07:54:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62L447wL016261;
	Sat, 21 Mar 2026 07:54:22 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwm7kas8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 07:54:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62L7sL6x45547886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 21 Mar 2026 07:54:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1044320040;
	Sat, 21 Mar 2026 07:54:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C62CA2004E;
	Sat, 21 Mar 2026 07:54:19 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.28.253])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 21 Mar 2026 07:54:19 +0000 (GMT)
Date: Sat, 21 Mar 2026 13:24:17 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v4 2/5] ext4: call deactivate_super() in
 extents_kunit_exit()
Message-ID: <ab5OqT_I5AupcZv_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260319125434.333117-1-yebin@huaweicloud.com>
 <20260319125434.333117-3-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319125434.333117-3-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: agJXdk8GP_ojl2sh2pTKTju1YyITgktf
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69be4eaf cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=aa_CFb9_W_bAjS73nHQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDA2MiBTYWx0ZWRfXx+RNuUYW/tdK
 m3ERgOkG9/JDY3YVRTJgwgUF3WnBU9+0q8rN7v2oRKavuPHD2NZlI5lMDKe2XGl/PFQHWhODhVg
 czFrsf31gfCTIVb3K4WJfjJB5+1pQcEuK3KxrXbUjJYyjm4QlkKDmLN8rS5BlM+h+2bEBt7k1yx
 dqUDqwGmKD1XFnKGh8rFFDICRvaUD3NZ7Kxjo67dIr4iI3uLTgIcKkyhTZstO9odSLr1wSyE0fI
 9M0Kjo9qhQPZSGJmgR+opgcY75UM9+bPkdXtCeHVLyfM/e3CLqO+LIHOvf6bil/8uUOHVjfcnew
 LKgpeTkox+D7iaqSW3UYiHVzMOPsLPO4W0swHd1jJF9oI9uA7FJsqEKw6V9Ze4VLYgQTd7l+PZM
 X5sFqAPG3OIS9jODoCvQBlWD+rDGP0VYGVWyrk3Tv5BIIkOVShmU1n3T4iSjZv+vll8FI+ovRF/
 5e4TipJ8tqC284Sl+hw==
X-Proofpoint-GUID: agJXdk8GP_ojl2sh2pTKTju1YyITgktf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210062

On Thu, Mar 19, 2026 at 08:54:31PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Call deactivate_super() is called in extents_kunit_exit() to cleanup
> the file system resource.
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/ext4/extents-test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 82c59291e045..3d4663d99eb1 100644
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

Looks good now, thanks for taking care of this.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin
> 
