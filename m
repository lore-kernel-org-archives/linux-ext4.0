Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF5131355D;
	Fri,  3 Jul 2026 04:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783053142; cv=none; b=GX7RZA4/FDeLuFZiNs2yRaYIQU3PCldocEmzhabfjuezbJW84e5AuDRuPQtDJCkghBOXqMcCKQJP0ysDOkGFdbc3MQzICsKfe56/Eg9xmYyooJ1q3+MHfKw/ivPxbi6odVMlzVYRvY0EIP3KJJcSSJVcLESSQ8qQgBdsKx5IFyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783053142; c=relaxed/simple;
	bh=+vfMny8iQWNF2bpqNsMDQjrGHops71bmrWA5ibwzqhk=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pvCXEgnMcuEAqYkei+/w15OA1zk0t4+5nyutBTT0wAcW8pGQcrxRXw8ICGC/z1A+sRM9On5dXomEutDlGPciRMqgvOAzMfEoCMNDPXgifCkMTLDZTV/5OQQekf/dG0Blz79bX8lGp9I41HnFEVYKBSFepY9sfNpaXaj2+HNGAh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ugF+lHNd; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ugF+lHNd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zN6H3um3rHBIN6VOu/Rtc9l4/p3Gp9cG6ReZMncnnJg=;
	b=ugF+lHNdI0bEkTDG6JZBkC0oTnY74uMo/hRUJpYGc/aRn/vtR3D4PUnG1Gh/f/DREy7zrafOF
	CINRO52V1PQeEmTPnfVFE0XuY6sOnGaNfCgnpdUxADPSheKF4CFxcL6cX1YekC4V6FqAsW//CXN
	7NGsiQuFu8IvNjQ7fhYMzQE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gs0wf5zVwz1T50l;
	Fri,  3 Jul 2026 12:22:58 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 21B8C4056D;
	Fri,  3 Jul 2026 12:31:52 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 3 Jul 2026 12:31:50 +0800
Subject: Re: [PATCH] ext4: validate readdir offset before accessing dirent
To: Yao Kai <yaokai34@huawei.com>, <linux-ext4@vger.kernel.org>,
	<tytso@mit.edu>
CC: <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>,
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<liuyongqiang13@huawei.com>,
	<syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com>
References: <20260703015106.3570064-1-yaokai34@huawei.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <0161d800-e6fd-953d-9fc9-5df5db3dbed0@huawei.com>
Date: Fri, 3 Jul 2026 12:31:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260703015106.3570064-1-yaokai34@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemo200011.china.huawei.com (7.152.185.179)

ÔÚ 2026/7/3 9:51, Yao Kai Ð´µÀ:
> A corrupted directory can trigger the following KASAN report when
> ext4_readdir() resumes from an invalid position:
> 
>    BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x5ef/0x820
>    Read of size 2 at addr ffff88810a646000 by task repro_linear/509
> 
>    Call Trace:
>     <TASK>
>     dump_stack_lvl+0x53/0x70
>     print_report+0xd0/0x630
>     kasan_report+0xce/0x100
>     __ext4_check_dir_entry+0x5ef/0x820
>     ext4_readdir+0xcde/0x2b70
>     iterate_dir+0x1a1/0x520
>     __x64_sys_getdents64+0x12b/0x220
>     do_syscall_64+0xf9/0x540
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     </TASK>
> 
> KASAN reports use-after-free because the out-of-bounds access lands in an
> adjacent freed page. The directory buffer itself is still referenced.
> 
> ext4_dir_llseek() invalidates the directory cookie so that ext4_readdir()
> rescans directory entries from the start of the block. The rescan checks
> only the lower bound of rec_len before advancing. A corrupted rec_len can
> therefore place the offset where the block has insufficient space for a
> complete directory entry. The rescan itself may dereference that truncated
> entry, or the main loop may pass it to __ext4_check_dir_entry(). The latter
> reads de->rec_len before validating the range. For example:
> 
>    block offset  0                           4092  4096
>                  |---- de1.rec_len = 4092 -----|----|
>                                                 de2.inode
>                                                      | de2.rec_len
>                                                      ^ OOB, reported as UAF
> 
> de2 starts at offset 4092 in this 4 KiB block. Its four-byte inode fits in
> the block, but its rec_len starts at offset 4096 and crosses the boundary.
> 
> The minimum safe length is inode-dependent. Encrypted and casefolded
> directory entries need eight additional hash bytes, while a valid metadata
> checksum tail is only 12 bytes.
> 
> Cache the metadata checksum feature state and derive the minimum directory
> entry length from the on-disk format. Use it to bound both the rescan and
> the offset passed to the main loop. Report an offset in a truncated block
> tail and skip the remainder of the block, while continuing to accept an
> offset exactly at the block boundary.
> 
> Reported-by: syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5322c5c260eb44d209ed
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Signed-off-by: Yao Kai <yaokai34@huawei.com>
> ---
>   fs/ext4/dir.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 17edd678fa87..5c943d18882a 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -138,6 +138,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>   	struct buffer_head *bh = NULL;
>   	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
>   	struct dir_private_info *info = file->private_data;
> +	bool has_csum = ext4_has_feature_metadata_csum(sb);
>   
>   	err = fscrypt_prepare_readdir(inode);
>   	if (err)
> @@ -149,7 +150,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>   			return err;
>   
>   		/* Can we just clear INDEX flag to ignore htree information? */
> -		if (!ext4_has_feature_metadata_csum(sb)) {
> +		if (!has_csum) {
>   			/*
>   			 * We don't set the inode dirty flag since it's not
>   			 * critical that it gets flushed back to the disk.
> @@ -235,7 +236,10 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>   		 * dirent right now.  Scan from the start of the block
>   		 * to make sure. */
>   		if (!inode_eq_iversion(inode, info->cookie)) {
> -			for (i = 0; i < sb->s_blocksize && i < offset; ) {
> +			for (i = 0;
> +			     i <= sb->s_blocksize -
> +				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
> +			     i < offset;) {
>   				de = (struct ext4_dir_entry_2 *)
>   					(bh->b_data + i);
>   				/* It's too expensive to do a full
> @@ -257,6 +261,17 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>   			info->cookie = inode_query_iversion(inode);
>   		}
>   
> +		if (unlikely(offset < sb->s_blocksize &&
> +			     offset > sb->s_blocksize -
> +			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
> +			EXT4_ERROR_FILE(file, bh->b_blocknr,
> +					"bad entry in directory: %s - offset=%u, size=%lu",
> +					"directory entry too close to block end",
> +					offset, sb->s_blocksize);
> +			ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
> +			goto next_block;
> +		}
> +
>   		while (ctx->pos < inode->i_size
>   		       && offset < sb->s_blocksize) {
>   			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
> @@ -312,6 +327,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>   			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
>   						sb->s_blocksize);
>   		}
> +next_block:
>   		if ((ctx->pos < inode->i_size) && !dir_relax_shared(inode))
>   			goto done;
>   		brelse(bh);
> 

