Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840539448E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 04:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773291514; cv=none; b=Q7QNPsPMEl/HOJC4dAGcj1NbSoYce6PzI0aI3ffz5+Im6hO1hp33HCbjtj5mlH2UjOaxBO2dS+0J3GURPuI1f6vhgs1sGsmrER3BV/cFQFd6KScQOeLPZ3LKquh+P7P2XjEYiU+AKFydX+lP6IJkAf8d27sAFlvpc9enKePhME8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773291514; c=relaxed/simple;
	bh=8ybevqIcpBhlBRyhVYuP7IZUnd3QLRoZ8I4MqEfpnmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrdTWZYCdUQO7z6s8ArbWocl6kLmhENy0wIfr00ToGZGr9nyIvBOg5KXcdURYIsqG1RwCdFvTTflRUglEx/vAReyxe7iXp6EZaz8McpoYXV1cYBxvS4/CNUt0rnDaK+rg3c9XjcLGbKUbMEVT2dsw7gNmznY7UWDqvWHQPUJHk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GGjuzWWa; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GGjuzWWa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773291509; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gA/Yoe/Eu9Od7zkQHHWxZyJT+IFtsWiU/6utn/4hNOI=;
	b=GGjuzWWa/9hUQCGn0V9e2btUQZpqsEzh6h3eZRFh998Mk0+efMToYQF+uYCpbRIeKLTAZV42tf9MYj8ye8Vym+82CxOcAGibLxLjEUtsdOpwTiN/WCDTsx3d3ryj/qPpPURVsXfBy1zbH4v5Uq9Irb2nGYyMsVE71lzcvY4oPt8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X-n8s22_1773291508;
Received: from 30.221.147.203(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-n8s22_1773291508 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Mar 2026 12:58:28 +0800
Message-ID: <bb18fb00-3875-458d-9cf9-589d9cf56aef@linux.alibaba.com>
Date: Thu, 12 Mar 2026 12:58:28 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix default orphan file size calculations
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
 libaokun@linux.alibaba.com
References: <20260311141150.120724-1-tytso@mit.edu>
 <d4d64000-6b55-449e-83bb-be438aaa5146@linux.alibaba.com>
 <20260311172755.GA74864@macsyma-wired.lan>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260311172755.GA74864@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ted,

On 3/12/26 1:27 AM, Theodore Tso wrote:
> On Thu, Mar 12, 2026 at 12:27:07AM +0800, Baokun Li wrote:
>> In fact, the patch that introduced it was not the latest version —
>> there was a later v3 that is consistent with the upstream kernel:
> Hmm, I wonder why b4 didn't pick up the newer version of the patch.
> Maybe I screwed up and missed the -c option to "b4 am -c".
>
> The main difference between my proposed fix and your v3 patch is that
> if the user doesn't specify an explicit orphan file size, with the v3
> patch, it might max out to 8MB when the block size is 64k.  With my
> fix, it will max out to 2MB in those situations.  The user can
> explicitly specify a orphan file size as 8MB, but it makes the default
> to be 2MB.

Yes, but if we cap the maximum size at 8 MB, then the maximum orphan file
created with the previous default settings would be 512 blocks. On 64 KB
page-size systems, older mkfs versions could create a 64 KB-block ext4 fs
with a 32 MB orphan file, so that would break forward compatibility.

This is also why kernel commit 7c11c56eb32e ("ext4: align max orphan file
size with e2fsprogs limit") changed the limit to 512 blocks instead.
That at least preserves compatibility for filesystems created with the
default mkfs options.

>
> In retrospect, I think we went wrong when we capped the orphan file in
> terms of bytes instead of blocks in the kernel.  When the block size
> is 64k, 8MB is only 32 blocks.  When the block size is 4k, the orphan
> file size can be up to 512 blocks.  And the scalability is really a
> function of the number of blocks, not the number of bytes, since with
> the orphan file, we use a hash that maps the cpu number to a logical
> block number in orphan size.

Yes, limiting it by the number of blocks is simpler, and that is exactly
what kernel commit 7c11c56eb32e does.

>
> Now, most of the time, I suspect 32 blocks is plenty most of the time,
> since it's unlikely we'll have that many running processes trying to
> truncate files or something else that requires adding the inode to the
> oprhan file.
>
> So I thought about just using a default orphan inode size of 32 file
> system blocks.  I also thought about changing the kernel to allow size
> of the orphan file to be say, up to 256 blocks.  And also maybe
> allowing mke2fs and tune2fs to accept an extended options
> orphan_file_blocks which takes an argument denominated in blocks.
>
> Ultimately, though, *most* of the time, consuming 512MB on the orphan
> file inode if the file system is say, 2TB.  So I decided it wasn't
> worth the effort to change how things worked.  But if we were starting
> from scratch, I think we would have been better of doing things in
> terms of blocks, instead of bytes.
>
> But maybe we should go and make that change.  What do folks think?
>
I’d prefer reverting e2fsprogs commit 6f03c698ef53 and taking v3 instead.
It looks like the simplest fix for now, and it should still preserve some
compatibility.


Regards,
Baokun

