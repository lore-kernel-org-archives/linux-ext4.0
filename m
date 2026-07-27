Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C538E3FDC1A;
	Mon, 27 Jul 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153611; cv=none; b=RVZwfizFtRTJtJTqNJAaGKNHOBmV+NH1WB3SXn3JPIrwysJJTpEG+VhydTFiyCiK76r72krQQh+guC8O8BUSMPkXR9EoeIUAkfgpLmxrQjKOvZUHxcARNxq6w+cfEq3prZy9iDfNiYQmMBivqqYqwWYymk33Hkga2jT0HN28d1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153611; c=relaxed/simple;
	bh=j6vKu4CIxdZ0LpGFoGTdIPj5UU6mrIWyjJhIVmDxFns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fxY4kCSyKNrYSrDjSfatptfihRHMX4SK/unVgL37X2cqMgPT3QkMhWfX7akCr+/Hdam0uBw8WP5Q6CJDcRQmEcg0+808Sa22kmzRz+iLYFvlP/YrEG8ueEre93HaaoC2ektRgfPdyyUCpBRrX5RvyZgoCijCEv8p4rHzhE9YnSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EstICuHz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EstICuHz"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAITWV061267;
	Mon, 27 Jul 2026 11:59:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xcfrmT
	YorGgkkroibKOXlS091zqrRlz1MCMqTnhEFJ8=; b=EstICuHzGlucFjmTGs4Drs
	xRXpKw72Rf2TnJjgTeha4TH7jxJ/b0F2nGUTssfJyxLw0tlglIvswlbgBWFFJbUG
	2naZnSI5ZWKDSKdsZVzr+tj7RvEB4h59ziQO7gvcqiA3cB4ImaQoIppsNZrnva46
	06JZfBL19ckBlHZkTOwvib6bFyt4/rrsdMvJ/5QVpwLmzE0AbDKKXYHcr4H9Y6w0
	a09UvKGEIfSBfrt/Q/p8b+zz/928EhcpTngkwkN3CjmzAekNqQ5RLUsWolB72gLK
	s5TQ1leeLQGjfRA1j1YnXf15S8VbDRarZvGeEOAqEnk87zGrXVY1RN/VOtMfGKtw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyc7thd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 11:59:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66RBuJGV024486;
	Mon, 27 Jul 2026 11:59:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5xvygb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 11:59:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66RBxosg50659732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 11:59:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9D6F200E8;
	Mon, 27 Jul 2026 11:59:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12B2E200E3;
	Mon, 27 Jul 2026 11:59:48 +0000 (GMT)
Received: from [9.124.222.41] (unknown [9.124.222.41])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jul 2026 11:59:47 +0000 (GMT)
Message-ID: <77364e40-f193-4a35-b26f-5c4252315650@linux.ibm.com>
Date: Mon, 27 Jul 2026 17:29:45 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Content-Language: en-GB
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: sW6kU5n69u8QtGJtTW0YMmX3GYyn4cAr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDExNiBTYWx0ZWRfX7sl8nWPqBFaP
 yCa4BM4MevWgez3MMPGu57TayYX65xtW139xKTFl7sVTdLgMV59YnYpJLfq3MK/6uvenrkodZd4
 NMf8faU+Cio8fuhAOL54FMYDXKGvSk93yRAmF9kWzlrYQf7SEIPlNhyOQfDko3LSkRfL183R2H4
 BK4suFTHL3PZYNI6cPGRiHA/SvvWPQEdN3zwEJAKH36GbZxhvDZGgrp/rPqO+0XrZyirVBkllf9
 46t1MU584MdnwxboJ02LcTZZvLrwWddvEpis78tKk+krGsof6DSRhtrT6//XkMY26WRzL3I/GR3
 yDVx45Umy7dkuhJprYsnXKpoIneDb5vlikVltLtCiXfwP8M1Ul6+h7/riq+pLT5yuSCa7+bGO2g
 C5WHw4hGs6ESxZ8Cu+N/fuaFXJmvjqMqmsYHf6KixYvLi6xfb1FSgyOFHl+tohuKNZ++Uyz25rX
 UUr2aboMv11qJYg9l1w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDExNiBTYWx0ZWRfX/NIoIbyFhtPm
 gilr2iXXjmq7CRlyy3DsgyT6mimyuO/lTLQL/AY3cj851O1u4I93TKUCRhTu+eDvL1v3vu4oIFO
 iG9VOzMZs5OInM76uxQbjcsBNt72Acc=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a67483a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=H1dnbxNIaJ1ru_3gy30A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: PlefV3gRwdckOe6cEd7BtPWdVpDYE7kt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1011 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270116

On 23/07/26 2:26 pm, Ojaswin Mujoo wrote:
> Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> flag. This is because the newly created inode ends up with the following:
> 
>    __ext4_new_inode()
>      ext4_set_inode_flags(init=true) // sets S_DAX
>        fscrypt_set_context()
>          ext4_set_context()
>            ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
>                                                doesn't clears S_DAX
>        ext4_set_aops
>          inode->i_mapping->a_ops = &ext4_dax_aops;
> 
> Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> silently ends up bypassing encryption completely. This is reflected in
> multiple xfstests failures like generic/548. To fix this, ensure we disable
> S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> is safe to change DAX state there because ext4_set_aops() later can
> correctly detect S_DAX unset and assign the correct aops.
> 
> The fix was actually the intended behavior however it seemed to have
> silently changed in 043546e46dc7.
> 
> Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> Reported-by: Disha Goel <disgoel@linux.ibm.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---

Thanks for the fix patch Ojaswin. This fixes the issue I reported.

Tested on a -o dax=always ext4 filesystem on ppc64le with the following
xfstests configuration:

FSTYP=ext4
MOUNT_OPTIONS="-o block_validity,dax"
MKFS_OPTIONS="-b 65536"

All failing encryption tests in the generic group now pass.

Tested-by: Disha Goel <disgoel@linux.ibm.com>

>   fs/ext4/crypto.c | 15 +++++++++++----
>   fs/ext4/inode.c  | 10 ++++++----
>   2 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> index f41f320f4437..2d409114e02e 100644
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>   {
>   	handle_t *handle = fs_data;
>   	int res, res2, credits, retries = 0;
> +	bool init = S_ISREG(inode->i_mode);
>   
>   	/*
>   	 * Encrypting the root directory is not allowed because e2fsck expects
> @@ -179,10 +180,16 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>   			ext4_clear_inode_state(inode,
>   					EXT4_STATE_MAY_INLINE_DATA);
>   			/*
> -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> -			 * S_DAX may be disabled
> +			 * Update inode->i_flags, S_ENCRYPTED will be enabled.
> +			 * If this is a regular inode, then we must be coming
> +			 * via __ext4_new_inode() as only new inodes can be
> +			 * encrypted, so we must set the init flag so
> +			 * S_DAX can be disabled. This is a bit fragile but
> +			 * seems like the easiest way to make sure we don't let
> +			 * the DAX flag linger when encryption is enabled as
> +			 * that result in writes silently bypassing encryption.
>   			 */
> -			ext4_set_inode_flags(inode, false);
> +			ext4_set_inode_flags(inode, init);
>   		}
>   		return res;
>   	}
> @@ -209,7 +216,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>   		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
>   		 * S_DAX may be disabled
>   		 */
> -		ext4_set_inode_flags(inode, false);
> +		ext4_set_inode_flags(inode, init);
>   		res = ext4_mark_inode_dirty(handle, inode);
>   		if (res)
>   			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..a57179655353 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5113,8 +5113,6 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
>   	unsigned int flags = EXT4_I(inode)->i_flags;
>   	unsigned int new_fl = 0;
>   
> -	WARN_ON_ONCE(IS_DAX(inode) && init);
> -
>   	if (flags & EXT4_SYNC_FL)
>   		new_fl |= S_SYNC;
>   	if (flags & EXT4_APPEND_FL)
> @@ -5129,8 +5127,12 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
>   	/* Because of the way inode_set_flags() works we must preserve S_DAX
>   	 * here if already set. */
>   	new_fl |= (inode->i_flags & S_DAX);
> -	if (init && ext4_should_enable_dax(inode))
> -		new_fl |= S_DAX;
> +	if (init) {
> +		if (ext4_should_enable_dax(inode))
> +			new_fl |= S_DAX;
> +		else
> +			new_fl &= ~S_DAX;
> +	}
>   
>   	if (flags & EXT4_ENCRYPT_FL)
>   		new_fl |= S_ENCRYPTED;

-- 
Regards,
Disha

