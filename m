Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDAD19E992
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 01:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969586; cv=none; b=CeAjwdgxRcmF4Ep5LYY6RAzVaWiafNXi73swqp0mOoNFbTEobyXTGkTMQNAUOkH8ybvMRf4U7bGkA82dPhPwPA5hLtY5z/Gxpa3sijmj91utlEaMsNwFAp3NJrBW4u0m4CUhIjftvXAKFWHV1yYWCyc2ZTbAS0caSoDUYbqOZ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969586; c=relaxed/simple;
	bh=xAXEJQ6zFvUmZTSm/NTD1FhLtmguA+9RMD2beNe/Dhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aRSFFIsHJe12nVRxF1arjgRmpPKIF2K/ipzxyzqy1Hr5MB835jJDIeZpYyJhkfgpmjcAAUXa9I3asJGC1d/5xA1Dy/XXLUEQEuYBeQbs5l1KX67l7BOxflvXZ0kLa4xe4l6+Dv9hAZnmsEfuaTr7/VdgmX2+7fYTsAIYDwGook8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=t24pF2yi; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="t24pF2yi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780969581; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VLsNSc9ihZvXS2mzoTjkX/upjEWneFchXK2MEKHy8fY=;
	b=t24pF2yix/Qcygwa3RHVaex+I4RTnnwufdX+SJ56vRNt9krOmw1ytOkHNa9/XAFctyPk+EWEv4qldGHlWn+RBAjfRccYEmSlsNEOr0eDq31yzgNR1AwfLqA+VGbVsCL9EPdFBZxwZ3XcOvKyC3LkgHp3jGuyWjikBejA34HfHqk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X4UVnaM_1780969580;
Received: from 30.221.147.173(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4UVnaM_1780969580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Jun 2026 09:46:20 +0800
Message-ID: <54cc03dd-5e23-4b91-b0b4-ce51f8391fa0@linux.alibaba.com>
Date: Tue, 9 Jun 2026 09:46:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: reject mount if inodes per group is not a
 multiple of inodes per block
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
 yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-4-libaokun@linux.alibaba.com>
 <097CFB85-3C4A-4BDF-829C-E6B2322386EC@dilger.ca>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <097CFB85-3C4A-4BDF-829C-E6B2322386EC@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/6/9 02:27, Andreas Dilger wrote:
> On Jun 8, 2026, at 05:11, Baokun Li <libaokun@linux.alibaba.com> wrote:
>> If s_inodes_per_group is not a multiple of s_inodes_per_block, the
>> division that computes s_itb_per_group truncates, reserving fewer blocks
>> for the inode table than needed.
>>
>> On a crafted filesystem image, this allows __ext4_get_inode_loc() to
>> compute a block offset beyond the inode table, reading unrelated data as
>> an inode structure.
>>
>> Add the missing divisibility check alongside the existing validation in
>> ext4_block_group_meta_init().
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
>> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Hi Andreas,

Thank you for your review!

> Looks good.  Is this also fixed/checked in e2fsprogs?  
Yes, a similar patchset adding analogous checks to e2fsprogs is also in
the works.
> There is really no reason *not* to use all the space in the last itable block for inodes.
>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca <mailto:adilger@dilger.ca>>

Indeed. Images created by mke2fs do not exhibit this issue; it only
occurs with certain crafted, malformed images. Thanks, Baokun

