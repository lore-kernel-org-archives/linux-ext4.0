Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D307B4503B;
	Thu,  8 Oct 2026 02:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791427435; cv=none; b=czJq1H4VfpxU0i2+cHMpHiZzGMkdm9AjaxHvrAoVL2JXyyVJ5kxmvgIg7RPiTm8ksQOI6jnut5SKqlfszgFd5IAgkHT64t9dVI4TkyroJok6JDIvQ7suCEuOQKhpPybpN+9vpKwrVcu+rJ2he09IC5sZrA+plHel+StodplOCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791427435; c=relaxed/simple;
	bh=AsjIKhr8xNW7IfbX2vbS4si8f3rhS9x5rxDuh/UNBxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pEKw0wqpk52lrp98fruW9jmD7lagVxAHfkI/pL8qaKthVIS9l312gV0D/n166Mf97jdI0CM5pMEBUBM9aIBCwJHVJ20eNByO8r8S0pFHqxmYFzFogHr5VqAdVR3hd0KNKCsOowm3cO+6vrMJYlFgg4b15+i8FCIT1bgoIFRKdHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xifM2OB9; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xifM2OB9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791427421; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q0FF2SeKg1bh3CoH0FEQjS2Yeuw6iX4vo4RREW53Gb0=;
	b=xifM2OB949T29aP2DoC4ost4LpzFQWP/lddmZ13OiXLfMWTUTq+RJ+M2MjHx+FIms+OHK3SFlNRCWAkpiyGt5DAfoY3yvC8DlmM2JE95HufVXkIH80LT3vJm/Yl2T3MyNQj5mBxFlwxUdgMnThLQjpNEwC4nz6AIDQyWb79EfC8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XCIaawL_1791427097;
Received: from 30.221.130.64(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCIaawL_1791427097 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 10:38:17 +0800
Message-ID: <55d33a36-cf59-4c37-8d2c-1ed176236052@linux.alibaba.com>
Date: Thu, 8 Oct 2026 10:38:17 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: do not accept rec_len 0 for block sizes below 64k
To: hengyul@cs.unc.edu
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261006111546.3252481-1-hengyul@cs.unc.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20261006111546.3252481-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/6 19:15, hengyul@cs.unc.edu wrote:
> From: Hengyu Liang <hengyul@cs.unc.edu>
>
> Commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
> conversion") made ext4_rec_len_from_disk() read a rec_len of 0 as "this
> entry covers the whole block" for every block size.
>
> However, this special value only exists for block sizes of 64k and
> more. With smaller blocks, a rec_len of 0 means that the directory
> block is corrupted. As of now, a directory block that has been
> overwritten with zeroes is treated as an empty block. The kernel no
> longer reports the corruption and can store new entries in that block,
> while e2fsck still reports the block as corrupted.
>
> The issue can be reproduced on a file system without metadata_csum:
>
>     mke2fs -q -t ext4 -b 1024 -O ^metadata_csum,^dir_index img 8M
>     mount -o loop img /mnt
>     mkdir /mnt/d
>     for i in $(seq 100); do touch /mnt/d/file_with_a_long_name_$i; done
>     umount /mnt
>     dd if=/dev/zero of=img bs=1024 count=1 conv=notrunc \
>         seek=$(debugfs -R "bmap d 1" img)
>     mount -o loop img /mnt
>     touch /mnt/d/new
>
> Before commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
> conversion"), the last command fails with "Structure needs cleaning".
> After that commit, it succeeds.
>
> This patch makes ext4_rec_len_from_disk() return the on-disk value
> unchanged when the block size is below 64k, as e2fsprogs does.
>
> Fixes: afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len conversion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Looks good, thanks for the fix!

The extended rec_len encoding is only needed for block sizes >= 64k,
so this matches what e2fsprogs does: ext2fs_get_rec_len() has had the
same "blocksize < 65536" check since commit a4fdf09414e0 ("libext2fs:
Don't use the extended rec_len encoding for standard file systems").

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>


> ---
>  fs/ext4/ext4.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..ab716a5ad6da 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2611,6 +2611,13 @@ ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
>  {
>  	unsigned len = le16_to_cpu(dlen);
>  
> +	/*
> +	 * Only blocks of 64k and more need the special encoding of rec_len.
> +	 * For smaller blocks 0 and EXT4_MAX_REC_LEN are not valid lengths
> +	 * and must not be taken for an entry that spans the whole block.
> +	 */
> +	if (blocksize < 65536)
> +		return len;
>  	if (len == EXT4_MAX_REC_LEN || len == 0)
>  		return blocksize;
>  	return (len & 65532) | ((len & 3) << 16);


