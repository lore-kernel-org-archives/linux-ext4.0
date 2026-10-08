Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A456A3A2576;
	Thu,  8 Oct 2026 03:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791428865; cv=none; b=Mlukfw45vakJ6IgHIhfmZCytyupuyFRn8vHi6XKvNa8VqN1xmHKN/VBTaW+JsBIR3yfdAQj0KMMkX7h+vISR0AFyuj0ApZu0n/Y94ELOAMMJNbu9UvK/l12BdCL0QRSPFp3/ZhZEeQvyddm/G4CZNgBffGY61VuDGVeLsfQCFWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791428865; c=relaxed/simple;
	bh=c8jKmi7ZazBoj/lnENXOjP7SB9T/3Da2xBMRYwf/DOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KVNrdDPnRNvP0YBsl3rvJP/u1M2xs2KoYXLYjXE/JnhGYi/HZZGKWZeC5UbgTNLEDCpIS09AnNra6UyWOOV1LOwZelDNSlLB/QhzVrKZ/65Lo2bx1OnEvKbviUpW4yqFZYON92TLwhypkKX7Gre81/5OQmMQAtKdkQc3qOG1VbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j0ZCB65tjzKHMLR;
	Thu,  8 Oct 2026 10:47:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9C6EC40777;
	Thu,  8 Oct 2026 10:47:52 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xypMBMdqvky3DA--.19944S3;
	Thu, 08 Oct 2026 10:47:52 +0800 (CST)
Message-ID: <dddbe2ac-df54-4421-a3c7-1afee4527b7c@huaweicloud.com>
Date: Thu, 8 Oct 2026 10:47:40 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix maximum orphan file size check
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
 Mikulas Patocka <mpatocka@redhat.com>, Baokun Li <libaokun1@huawei.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, stable@vger.kernel.org
References: <20261002115040.2783654-2-jack@suse.cz>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261002115040.2783654-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3xypMBMdqvky3DA--.19944S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFy7JryxKF1UtF13WFW8tFb_yoW8uryxpF
	y3Cw1rCayDXFyY9an7J3WxZryrZ3Wfu3yUuFya9w1jgr98Jrn2yFnrta4UWF4Dtr4kJr40
	gr4fKFy2va1UurJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/2/2026 7:50 PM, Jan Kara wrote:
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

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

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

