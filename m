Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C658488233
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170149; cv=none; b=mxgE39YRP3jqaBJND73ofYQ27/11JqbH80EqxCWROfbDctwqtQOHESO6yqzfjzIdl6MeVaDSX3hZVcs0bxzfFE+8RPnb7plOr2IJLddK78DIvR8d898AvSmaigGlpkfELHgTWZye0xs6WpNWar0Ua73ODU4RFoGfHPtqwEnsxn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170149; c=relaxed/simple;
	bh=HnXHD4eCzhqj8X9po63c696u/Wzan3XtglkCCp7nZrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RS5ZXYHA/vg/vTZWS0Hly70KL7cQXeeH1uH3au8HQXfeeFVE2QJ0BwmUeT/cjDMuuUHRKNyFD9grOpN+e7R0zfrB3azYWS8Ts+f8yJUP6CDpz/VCkjmI1gGvxPazJEBbHqHY6H775J5C+26lR1O+DM5w7PqlgUi4EOcGYDQxt08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V3uCVbu5; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V3uCVbu5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790170136; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HnXHD4eCzhqj8X9po63c696u/Wzan3XtglkCCp7nZrc=;
	b=V3uCVbu5yXp243DAUoNxPs6npnmx9nhUZfFZGiKi9fPxSnu4lphie/ci7f+SeJ8vCvu/J/tAKiyU9EBlLp/+SVvRFKeHWiQmjNJbAnX6vfOiMVwYZvX2GjVE0Sptl7dE/7D4NOn7dqAKyZZyqVjpX3Tajwdq+mNBs3Wo1+4k/ys=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XBX9qlF_1790170135;
Received: from 30.221.148.48(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBX9qlF_1790170135 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 21:28:55 +0800
Message-ID: <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
Date: Wed, 23 Sep 2026 21:28:54 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
To: Alberto Garcia <berto@igalia.com>, Theodore Ts'o <tytso@mit.edu>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <arPIrtWTXUTwqxFC@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/9/23 20:40, Alberto Garcia wrote:
> On Wed, Sep 23, 2026 at 08:12:03PM +0800, Baokun Li wrote:
>>> 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
>> Is it valid to enable encrypt at mount time?
> Good question, I always understood that it was allowed and tune2fs
> certainly doesn't forbid it (compare with casefold):
>
> https://github.com/tytso/e2fsprogs/blob/v1.47.4/misc/tune2fs.c#L1599
>
> Berto


If enabling encryption on a mounted ext4 fs is allowed,
I think the current change is fine.

Ted, Eric - would either of you know the details here?


Regards,
Baokun


