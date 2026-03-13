Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FA633859A
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 02:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773367217; cv=none; b=S7zF1KSP1KilLXNxTSYDDO4GZrPu6uPiHPIVEoyNkXSYiOTPbQLlquo1gvc3ziS+XKXVXvbuG/UTDhZ9jbAxzcNTTAKqeZIAetc/Lds8MRisSjTMl1/+NGKkdMyIezYe96bFrGrf6ZtijzaqSrzF5bOYC0sbGigLQyzUdQdX4k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773367217; c=relaxed/simple;
	bh=4bFmbOSm3xo4LeMxvM5gbq5AibQbeSHqanXzhJj61NA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LbH8wtIqCRawQY8RQvtCnPTR56LXFZLVVsUKH4Jv2OCNh6mkG/JK3jjIF2nZQmH46tuAqTn9mFGBxDMqNIFqpRfQATv74WaS73lzw9Lm5l+2m9ienbsUPYXE9dRjSiOzxC2jye6Ox5UYzRT9mdaSL7CTHYTnJXL9Cr9DA07Hne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=R3nWQ+YN; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="R3nWQ+YN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773367206; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3Uh7cNMtvTa6yEUn+B1uKQGFJM19u1vXOoYATnjligI=;
	b=R3nWQ+YNWYBEfYwXP9IyX55CpKy1yQBfyqKBZK+jo/Uyr/Cj/o/AZRRDKbPKx02WD5W51ctNPWoiKXMrTkIRgtB8CRRDPdAJAG0TQsPEUUKrT13cSJLPcs6tLmrrdvSCq4wHOd2GRMD+jHwgR0i4b4AoxIsb56ttZXuboGzdGmQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X-qJmnM_1773367204;
Received: from 30.221.146.216(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-qJmnM_1773367204 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 10:00:05 +0800
Message-ID: <2a047aeb-6db8-4be9-8908-b12632d5e632@linux.alibaba.com>
Date: Fri, 13 Mar 2026 10:00:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ext4: handle wraparound when searching for blocks for
 indirect mapped blocks
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Ext4 Developers List
 <linux-ext4@vger.kernel.org>, libaokun@linux.alibaba.com
References: <20260310122806.1277631-1-tytso@mit.edu>
 <5ce9dfe2-721e-4d20-9bd9-3560aa76888d@linux.alibaba.com>
 <20260312142345.GA4689@macsyma-wired.lan>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260312142345.GA4689@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/12/26 10:23 PM, Theodore Tso wrote:
> On Wed, Mar 11, 2026 at 10:38:20AM +0800, Baokun Li wrote:
>> Good spotting! ext4_find_goal() ensures that the goal block obtained for
>> indirect-block-based files will not exceed EXT4_MAX_BLOCK_FILE_PHYS.
>> However, on an ext4 filesystem where the two file formats are mixed,
>> it is indeed possible to get an excessively large goal group via stream
>> allocation.
> Well, I didn't spot it; an LLM AI noticed.  :-) Arguably I should have
> noticed it when doing my review, but I didn't.
>
>> Since the mixed-format case is quite rare, I think we can simply validate
>> start in ext4_mb_scan_groups() and reset it to 0 when it exceeds the limit,
>> like this:
> No, I don't think that's enough.  It's not just that we could have an
> excessively large goal group.  The goal group could also just be, say,
> 2**32 - 5.  If the next 5 groups are full, then when we do an
> optimized scan, we will end up beyond the 2**32 limit.  That's why we
> need to add some kidn of wraparound logic to *any* caller to
> ext4_get_allocation_groups_count().
>
IIUC, ngroups/end here only depend on filesystem size and whether the inode
is extent-based, and both should stay unchanged during block allocation.
So doing the check once at the beginning should be sufficient. Am I missing
anything?


Cheers,
Baokun

