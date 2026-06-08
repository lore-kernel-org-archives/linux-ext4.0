Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6554C25B08C
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 12:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780923223; cv=none; b=IrydW0TDkMUzROPoTIsrgiiEdEXAzKs2R2Ea14pVBa5snlgIsxPRO2jYjXcU7QXVcm5J7XfMn/BB4sgycsoiO6lMn3AWlfJgX6l1zsQZM8YQOsKbIHy/6pyKGvfEw5nfVnSBFk6fSfT2AqXU8hkGU6PC3Qh5B0xFIMYkwa0Q9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780923223; c=relaxed/simple;
	bh=ZMAd28BIWSoYiPNRQv3kZrH5Br8lkOJ9WB3d+gIjZ6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KpEcRr2pYeKKsLWijBN+0R8b0F+MXFBS6JvOHFfDxkQbvzoc4q4AQj++kwcNQu2cSEXS7Bp9dMgxZpbOvgT4wgUY0dMS6Hap+KfD9ddz2NsXeS8NZiLV3GtrKN4erGm6ueYDmkN1wGkVGnXhDfvmomsGV84tTUNv/45Ou99mC9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gYsQl3P1kzKHLtw
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 20:53:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 684ED4056B
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 20:53:37 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBHlzxMuyZqIJtEBA--.25960S3;
	Mon, 08 Jun 2026 20:53:34 +0800 (CST)
Message-ID: <a773f737-8c0a-4b48-ae26-9c96d28db3bb@huaweicloud.com>
Date: Mon, 8 Jun 2026 20:53:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] ext4: reject mount if clusters/inodes per group
 are not 8-aligned
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-2-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260608111150.827117-2-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHlzxMuyZqIJtEBA--.25960S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr4xur1ruw48JFyxZFy8AFb_yoW5Gr4Dpa
	yDAF13ur15Xryq9a1xGr92gF1Sg3WkGanrGrWI9r15ur9Fqa40gr95tFn0kF4DK3y8XF10
	q3W5ur47uFyfJ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/8/2026 7:11 PM, Baokun Li wrote:
> The block and inode bitmap checksums are computed over a whole number of
> bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
> ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
> length passed to ext4_chksum().
> 
> If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
> trailing fractional bits are excluded from the checksum.  Those bits are
> then unprotected, and any incremental csum update path that assumes a
> byte-aligned bitmap can compute a checksum inconsistent with the full
> recalculation, corrupting the on-disk bitmap checksum.
> 
> Reject such filesystems at mount time by adding the missing " & 7"
> alignment checks alongside the existing range validation.
> 
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%40linux.alibaba.com?part=10
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me. Thanks!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/super.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6a77db4d3124..3ddcb4a8d4db 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4472,8 +4472,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
>  		sbi->s_cluster_bits = 0;
>  	}
>  	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
> -	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
> -		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
> +	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
> +	    sbi->s_clusters_per_group & 7) {
> +		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
>  			 sbi->s_clusters_per_group);
>  		return -EINVAL;
>  	}
> @@ -5304,8 +5305,9 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
>  		return -EINVAL;
>  	}
>  	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
> -	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
> -		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
> +	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
> +	    sbi->s_inodes_per_group & 7) {
> +		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
>  			 sbi->s_inodes_per_group);
>  		return -EINVAL;
>  	}

