Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB32235AC10
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246440; cv=none; b=BQQYT1SMsPkIrC7ZynpCC1IqJdM70ChEB0A0wzdk6s8EUnghgRJAmFoTzJpz19cG8wg2AUTcxPQJUhs35t2mrIoabOi5z69VahiuyCJU6/R4SONZSRwjaGEk9abJOcPbouYoEIR/B7UZRcBzP/yYLEFG+YXOXCHFYLwJVwX/mLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246440; c=relaxed/simple;
	bh=FSLgcNhR63xwgAj1Si1tdhyqTO4l9kZvrf+fJg3WvwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=LCmA1BJBS6N1M1Fkq3gX4qmuzBhj+y7VhhjH0wat+JK6zDsY6lg0p2oUetahdNmZZFWToJkBCU+Foon/FWbOk5W1qeV0Dypbw06V9kZ93+8i9zuFK8C3gaDxwZymS85zDdbLaJXMJkGP18KwP+czTQNxaoeIhjKBhAuoQFIgMJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UQ0qrpt+; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UQ0qrpt+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773246429; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/i4Utr/4ueLuI8bfhvOpH2/fkcyCEb9lPqWNIE4e39o=;
	b=UQ0qrpt+jXKZKogN0EggPdREw7cxAYn6T6kdzoLSVPvZ7QDzLJMI9p8pqd1i2BEyWUdlGAYlZU8vENCnIBpR6cr0Qe1SvuhjNLfxdBN8Jeg3yPod3QJ3hWhOATBjACfLPH1ujcpQTxafUYjO1gxPljHz1hpMsIQxpOfAv2nj3SQ=
Received: from 192.168.3.86(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-kygQ7_1773246428 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Mar 2026 00:27:08 +0800
Message-ID: <d4d64000-6b55-449e-83bb-be438aaa5146@linux.alibaba.com>
Date: Thu, 12 Mar 2026 00:27:07 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix default orphan file size calculations
To: Theodore Ts'o <tytso@mit.edu>
References: <20260311141150.120724-1-tytso@mit.edu>
Content-Language: en-US
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
 libaokun@linux.alibaba.com
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260311141150.120724-1-tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 3/11/26 10:11 PM, Theodore Ts'o wrote:
> Due to missing parenthesis around the #defines for
> EXT4_{MAX,DEFAULT}_ORPHAN_FILE_SIZE, the default number of blocks
> assigned to the orphan file was calculated as 2 when the file system
> has more than 2**21 blocks:
>
>    % mke2fs  -t ext4 -Fq /tmp/foo.img 8191M
>    /tmp/foo.img contains a ext4 file system
>            created on Wed Mar 11 09:54:04 2026
>    % debugfs -R "extents <12>" /tmp/foo.img
>    debugfs 1.47.4 (6-Mar-2025)
>    Level Entries       Logical          Physical Length Flags
>     0/ 0   1/  1     0 -   510    9255 -    9765    511
>
>    % mke2fs  -t ext4 -Fq /tmp/foo.img 8192M
>    /tmp/foo.img contains a ext4 file system
>            created on Wed Mar 11 09:54:11 2026
>    % debugfs -R "extents <12>" /tmp/foo.img
>    debugfs 1.47.4 (6-Mar-2025)
>    Level Entries       Logical          Physical Length Flags
>     0/ 0   1/  1     0 -     1    9255 -    9256      2  <======
>
> In addition, looking at how the defaults was calculated, there were
> some unit mismatches where number of blocks was compared with number
> of bytes, and number of blocks divided by the blocksize.  As a result,
> the number of blocks was much larger than before when the file system
> blocksize was 1k, and much smaller than when the file system was 64k,
> which was a bit surprising.
>
> This caused a libblockdev regression test to fail when it created an
> ext4 file system using a 1k blocksize and had a size of 138240k.
> Before e2fsprogs 1.47.4, the size of the orphan file was 33k; but in
> e2fsprogs 1.47.4, the size of the orphan file became 135k.  This
> pushed the overhead just over 10%, which triggered the test failure.
>
> So simplify the calculation so that default of the orphan file ranges
> from 32 file system blocks and EXT4_DEFAULT_ORPHAN_SIZE, and avoids
> the use of the file system blocksize.
>
> Fixes: 6f03c698ef53 ("libext2fs: fix orphan file size > kernel limit with large blocksize")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---

Hi Ted,

I’m very sorry for introducing this issue. 

In fact, the patch that introduced it was not the latest version —
there was a later v3 that is consistent with the upstream kernel:

https://lore.kernel.org/linux-ext4/20251120135514.3013973-1-libaokun@huaweicloud.com/

I noticed the wrong version had been applied and sent you a private email
at the time, but it seems that message fell through the cracks. I then got
caught up with other things and unfortunately lost track of this as well.
My apologies.

Would it be possible to revert the patch that introduced the issue and
apply the v3 version instead? Alternatively, I can send a new patch that
includes both the revert and the v3 changes.


Thanks,
Baokun

>  lib/ext2fs/ext2fs.h |  4 ++--
>  lib/ext2fs/orphan.c | 12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d9df007c4..92da4d140 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1819,8 +1819,8 @@ errcode_t ext2fs_set_data_io(ext2_filsys fs, io_channel new_io);
>  errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io);
>  
>  /* orphan.c */
> -#define EXT4_MAX_ORPHAN_FILE_SIZE	8 << 20
> -#define EXT4_DEFAULT_ORPHAN_FILE_SIZE	2 << 20
> +#define EXT4_MAX_ORPHAN_FILE_SIZE	(8 << 20)
> +#define EXT4_DEFAULT_ORPHAN_FILE_SIZE	(2 << 20)
>  extern errcode_t ext2fs_create_orphan_file(ext2_filsys fs, blk_t num_blocks);
>  extern errcode_t ext2fs_truncate_orphan_file(ext2_filsys fs);
>  extern e2_blkcnt_t ext2fs_default_orphan_file_blocks(ext2_filsys fs);
> diff --git a/lib/ext2fs/orphan.c b/lib/ext2fs/orphan.c
> index 40b1c5c72..b894f2468 100644
> --- a/lib/ext2fs/orphan.c
> +++ b/lib/ext2fs/orphan.c
> @@ -218,18 +218,18 @@ out:
>  
>  /*
>   * Find reasonable size for orphan file. We choose orphan file size to be
> - * between 32 filesystem blocks and EXT4_DEFAULT_ORPHAN_FILE_SIZE, and not
> - * more than 1/fs->blocksize of the filesystem unless it is really small.
> + * between 32 filesystem blocks and EXT4_DEFAULT_ORPHAN_FILE_SIZE.
>   */
>  e2_blkcnt_t ext2fs_default_orphan_file_blocks(ext2_filsys fs)
>  {
>  	__u64 num_blocks = ext2fs_blocks_count(fs->super);
> -	e2_blkcnt_t blks = EXT4_DEFAULT_ORPHAN_FILE_SIZE / fs->blocksize;
> +	e2_blkcnt_t blks = num_blocks / 4096;
> +	e2_blkcnt_t max_blks = EXT4_DEFAULT_ORPHAN_FILE_SIZE / fs->blocksize;
>  
> -	if (num_blocks < 128 * 1024)
> +	if (blks < 32)
>  		blks = 32;
> -	else if (num_blocks < EXT4_DEFAULT_ORPHAN_FILE_SIZE)
> -		blks = num_blocks / fs->blocksize;
> +	if (blks > max_blks)
> +		blks = max_blks;
>  	return (blks + EXT2FS_CLUSTER_MASK(fs)) & ~EXT2FS_CLUSTER_MASK(fs);
>  }
>  
