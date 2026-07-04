Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B137204C
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jul 2026 02:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783132879; cv=none; b=iHoSq2N/rWa6uEt3VFqlfsDUt0MPg30hrJSBoj0H5kVJ5PoTO1O1frkVu5JNNyN/Pt0a62DPveReo3tO59ZreqKb9TcXx0EjOfakoYF15oOiqyeyVRYgh3AJ9aOqGEYE22srSNCuI+N6R3BQI+NNW0PPseE39Hd5yFKu6/BiK6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783132879; c=relaxed/simple;
	bh=In50wwWSl2rHmgF4kD4pKojGMbP9s6j3Hfecexqn42Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PwB3aMQXhNU6m5cZmdVNDHRx2pJzhV+RE3HUGK3iTBt8iPIhKElrSp7xhQUiuMULqs5gS3pOquPk9rSZu8D/I6jVyW15ziCbw0wWSu+Ij2EHFC54HDO9aaCE2Grafq7rmslTgd5nB3w16mYscId0QJA7KuZnvQl8jS2+KZkxK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dxg6DIAo; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxg6DIAo"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cace91f112so8790515ad.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2026 19:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783132876; x=1783737676; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TgLYx5dOTEuq1RUBUPRZubsR2s0SWsqbosupOkeKrDo=;
        b=dxg6DIAoRjgtobT0ZP5BDB8we7mPiYPpT5S0+bnauvcoV0dElABjIN06hSsCYOWa6d
         BdfR8UpIkp8qhoJFmnT2L8pDfV/eiNaHUHMa3OGCmFdgM3MhqnnHAlXmIVrNsVCsGauQ
         0cZLIEFUZL+cZFTc+nBtGwd0LVyg63E6fHEVWdfQB+uPX1hkvShcxCNKtQ7tEhCUmvbb
         RPYxuNkpB3KZl6vbesvjOo83lrWazXQyjYO3oXUS/J+ZWdXI11b2ScHrlvUkzoZGkT2+
         INIo31p1HVItLYBUvjVxq0R5p11T5cqR30u8ja/UOee5Ix3qnY+Nj8BZBeuCupCke6vF
         0mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783132876; x=1783737676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TgLYx5dOTEuq1RUBUPRZubsR2s0SWsqbosupOkeKrDo=;
        b=QiuC/0airvWAZDxbQqfhlA/nOrLCxYBbZ1M9QPFuhzAjN5dbR7s07NMLHPusSKwWeW
         Wsg+THmtWaTu8KaroK+S+EKvE85rqZRc4JW5LGgAB8xeGWpYmnjlq/UfGKa8pziGp2la
         Zi8g+0FxsCYZ+OdJbZqt4d6hMYw1vtYSYChi9pHxmOcRYaZFvgsYlpghjg3e7X0Mky1N
         oPEADhAvNS0tZ1hZx4Xy6VpbYRHZcgNihdZTW1dov9XtsFae1px2iCHSTEy8vU4XHdb2
         hBtbywpfgK1DtolmostjF2M77Tu3pP72YlP4aqDHQyPcQSN6NhmsP5K/+Ya452P2JFhy
         ZKHA==
X-Forwarded-Encrypted: i=1; AHgh+RrORY3zSCjOmm/pcomQUXpHLL73bKCrhaA5ZTrjv/TIq6h3nwPITcgrWEyaIK8w4FesKOfrJOgYtST8@vger.kernel.org
X-Gm-Message-State: AOJu0YwOOIaSWUXIaaIbWmlOX+w/12Yv00Cf06a56I7hevXfedW/GM7D
	/E0fXSHh4J6h1b69X3LvXuWCvn0H+cYyv4xtaA2H07oWXV5sc3nLBrGG
X-Gm-Gg: AfdE7cngnyHo5cowODgQTYBXyGUprXDZq9qi3pIk69FRCQbdVXBba2uoSAKDt3VUMCt
	P2gz79LBcL4SsDsi9NcJgM8GUYJGK8BZyuiAFrzp6DqT9HY4Bzrpm2aio/RJCW5tt/5xf0ldzTH
	cVNQjBEudfeP0cIUDwxcyRxOdl/RmCJmiHsUgDAP6fdgtYwBeJZtZEFek5G5J/XSIGBsJCTjKia
	VWH1SagGeBUtjlKNvJolZWhXgCBysYnzA8ytPhgv797UOmKPFsNvuVAPlf7ZtTag0QDz6t2cg/O
	1Pf5xY5Jb70p+7rWS7luDjPSnIKGzfVO+fuNefRC2ERigICn4CvHv2R2hfyAC5NHocETnsf9Rvq
	J9eypeLB8Kmg7FlPUOj4zoA8nAQGz9v6IvKZfJ85IFUta8U7pGxrpRw72yOf3fmbbzGYuLV/6p2
	hZpxOJltl6FK0X7XJIlDtZPy8Z5aOqz4vcdXGLOFuzqT0=
X-Received: by 2002:a17:902:e892:b0:2c9:a5e9:c26e with SMTP id d9443c01a7336-2cbb76072d6mr15813255ad.13.1783132876249;
        Fri, 03 Jul 2026 19:41:16 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad789237bsm16621525ad.71.2026.07.03.19.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 19:41:16 -0700 (PDT)
Message-ID: <1ca78fed-fa2d-4cc6-8276-28b856ed64be@gmail.com>
Date: Sat, 4 Jul 2026 10:41:06 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: validate readdir offset before accessing dirent
To: Yao Kai <yaokai34@huawei.com>, linux-ext4@vger.kernel.org, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, chengzhihao1@huawei.com, liuyongqiang13@huawei.com,
 syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
References: <20260703015106.3570064-1-yaokai34@huawei.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260703015106.3570064-1-yaokai34@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/2026 9:51 AM, Yao Kai wrote:
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

Thanks for the fix patch. With Jan's suggestion incorporated, this looks
good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>   fs/ext4/dir.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 
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

