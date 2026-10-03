Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9F226B2D2;
	Sat,  3 Oct 2026 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791041529; cv=none; b=nCCXR5Blany6SWQLop+I/i4rQJrMWFszn3yNvkZpiMjhYH9WUNLUwTime6F+n1h4q1IPJfQeIQh0ad+ou5UUOmToosU5FRmO5KTqh72CJ7Uwrcf0EuWpDFydMmvVOrldv439sR1O55E3Dc1K2KIF2H3FObgjeFNYLbPRqAlCm2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791041529; c=relaxed/simple;
	bh=MFmLvT77Mgu4kbHevUXpBG0j6PHP5aHmQ/20UkpSgd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHPVIfdSqVsfE+jt7wWFRMNmLCJjTJ2QvpQ2wnfVjOzpBeRa//H7ihJQ+X2B/f5NFMZmAdp8kjonPQUK2+amQfVCBcXs9oSoVLpQboqT1yBBzDFaCyzqORwaGUUUWndwiEAh7kxen3CdNaCgsQI3RqMsXcx8xO1WD34PC9zAqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jNG2PapK; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jNG2PapK"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791041523; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A/NIwPVTd5bPLlgHKr5rnTA2yn/oLfnJpor+eX2oCkQ=;
	b=jNG2PapKi2gfrqVqWPXk2hKv/1ynM+8BsK09ZRvuKYSOUN5ANO/3lDGhCvUswSmxm2lG229w8yaC2wg0wu7H4Vj9If/RC2BkL4qtnPPcWe2ZIu7eZpUvcJ6kVfRzl3VGUnJXiPrKG2zMCtdD/12lG2vXgao+sYgicfj14IYPmrk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XC0iAjb_1791041522;
Received: from 30.251.45.45(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XC0iAjb_1791041522 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 03 Oct 2026 23:32:02 +0800
Message-ID: <bb6a03a7-ab53-40e9-b22b-967ac75d1a7b@linux.alibaba.com>
Date: Sat, 3 Oct 2026 23:32:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix maximum orphan file size check
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Mikulas Patocka <mpatocka@redhat.com>, Zhang Yi <yi.zhang@huawei.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, stable@vger.kernel.org, libaokun@linux.alibaba.com
References: <20261002115040.2783654-2-jack@suse.cz>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20261002115040.2783654-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/2 19:50, Jan Kara wrote:
> Mikulas reported that e2fsprogs 1.47.4 with 1k fs blocksize by default
> creates orphan file of the size the kernel rejects. This is because that
> version of e2fsprogs creates 2MB file by default regardless of the block
> size and with 1k blocks that's more than the limit of 512 fs blocks.
> Fix the check to make kernel accept any file upto those 2MB regardless
> of the number of blocks.
>
> Fixes: 7c11c56eb32e ("ext4: align max orphan file size with e2fsprogs limit")
> CC: stable@vger.kernel.org
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Link: https://lore.kernel.org/all/e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@redhat.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks for fixing this.

The problem is only triggered by images created with the problematic
e2fsprogs: 1k-block filesystems between 512MiB and 2GiB, and 2k-block
filesystems between 2GiB and 4GiB.

A more thorough fix would be to rebuild the orphan file with tune2fs.
However, some instances may not get the chance to do that. So I think
it's good to keep the kernel compatible with both versions of
e2fsprogs. Feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/orphan.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index b4675aa7ea96..7394d04e0fd9 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -576,6 +576,7 @@ int ext4_init_orphan_info(struct super_block *sb)
>  	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
>  	struct ext4_orphan_block_tail *ot;
>  	ino_t orphan_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_orphan_file_inum);
> +	loff_t max_size;
>  
>  	if (!ext4_has_feature_orphan_file(sb))
>  		return 0;
> @@ -589,8 +590,13 @@ int ext4_init_orphan_info(struct super_block *sb)
>  	 * This is just an artificial limit to prevent corrupted fs from
>  	 * consuming absurd amounts of memory when pinning blocks of orphan
>  	 * file in memory.
> +	 *
> +	 * e2fsprogs 1.47.4 produces 2MB orphan files by default regardless
> +	 * of the number of blocks so that's where the second limit comes from.
>  	 */
> -	if (inode->i_size > (EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits)) {
> +	max_size = max(EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits,
> +		       2 << 20);
> +	if (inode->i_size > max_size) {
>  		ext4_msg(sb, KERN_ERR, "orphan file too big: %llu",
>  			 (unsigned long long)inode->i_size);
>  		ret = -EFSCORRUPTED;


