Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0143E33993
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790242640; cv=none; b=PF66/HZNcG3+skZGQlhupsUWhmo5EQsCwCdU6H6QjnTYpWKImdYWVJtZr/K4/8tEEuZRbAperrXE0/Sl4A99xA4MRrqdA2ZrQXoZWGfjX5z4XwIPbEB1lCKFoPDHZpArdS7Fsuz5r2dSZypyMqZRZcXo9PgcIPYi78mQeQOtvp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790242640; c=relaxed/simple;
	bh=70TFsAFRbI1TuzaqNIADo3Zfc7ofFfEiP7yn9cQoyzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aFsN3uOTGXk1oVwhsti48TWSvOI2bL5hbztgxiKsToYqbG77V26KUmSJyGnr+wrSr8G4cN1B0qRJEDvOD8jFlITq4LkYpEXbjdv2ZcJutFCN3tG1pds6aU3tryK3BVMqDpK8V5ZEQLHhTRYesWgatzIysPkA51r8AMG16DgJBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmN19kJ8; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmN19kJ8"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d91ede8035so16779855ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790242637; x=1790847437; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FHoeQiU6kNP6O34S62q6U8XbBumTsi34UKnTIzqpmJA=;
        b=AmN19kJ8BsJ0X1DljsyziIWCsc6ZQRbMF7/wBuPlYkavSBK3IPgRFebvJhf80wLL+F
         OyGPRgX6AozROkkIveCZtmOp/j9Iq1FflgyO/mGv/tpSAm5AbhYmiQUQv20SKjBESdXn
         iySZrvkw4PjISx+SRvyblr4H+JyHQ0Yxtf9NosmK5PjHS91fL0g/sNQAEesf7n5AQ7DZ
         s8HMYRPg5mLE1OdBLwiqURYRAFsN8k/fGsYXQGGcXUzp6ea0qRNsNJLKKZaeNqsf/TgB
         SGlrbDb0I/0qjATkqgdBpaDAZupNm+fkTJ9W029gJB704vLlFWSqR5lpOxo5iqpSocbd
         lv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790242637; x=1790847437;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FHoeQiU6kNP6O34S62q6U8XbBumTsi34UKnTIzqpmJA=;
        b=ZafuqbCQsKbnAV+298+GXbtMfl88T5Aw3KcgzxOMefNu4U/YjLokKQS0+Zc/A8AGlI
         kC66n7vmaP3MkxE0l9NavGo2Rs/1m02lLoD7g6HQcAG+nbPFLgwaYWmsreYdEwbdwz8j
         3elAlDzKGGb4EZ9YGrsBevNTZ01mx7PGruFP+UlMV8GvOubO+cZQj/Hemu2Nho2brADt
         y8PTkoyph/QPET1/Qag9HwhP5QThBazmLlgL5r1zd/YgxTgsPO9Cm86pADjNOrrDbMYq
         dzxLODp44kSONbWex48foPM8ffDX32TlMbB0Ae4LPAZ0PpgAXgDAfZ406dNBG/iMBC65
         hOSA==
X-Forwarded-Encrypted: i=1; AKwUvBwj5wfDPWCvXaT9IaywTWUVFaxkHpP6rBYPMBw3oBU7bubVwkQ/zxWIB+aKuYiGxQMgrhjoXbq3lq0Q@vger.kernel.org
X-Gm-Message-State: AFuF++k21RuH4/BarCZvHxtagXZ0FvCC04TSBL+YNxoJlTA8y35P9Dk+
	Qhoqv+SBBqCpCeAWKiIih26/rsRm90CTPFdeoXgd6UlGFFvw7oLhLYLo
X-Gm-Gg: AYBFou3K//r1iNFTnlrdesV/0HItphq6Qz0TvD30V15/KfVjv2MtFXRxcCKRD/fBLgq
	gOv+vFfkJPzDAl6T/+IsebDCgiyYgsCc/k3Qy89TfmkK7akRYijqlmIJp0pbaopmOexO5/YuPgE
	RgrFY4nuJKeYI9NYUZ8eApCJUzUcW7GQbnySeuHFzl5w7kh9FqcXTAeTTCCEZV3pLBJzI8g4IvN
	erxWdiuWHzH0xm4irA3Ly/mgSfDyEW+DfrmOVfA5E8YQmWxbkgc9um8Z2iAbJFNaQutSxrPKO1h
	BKa3ZJM43Dp65BX/ANH0pGqoCu5+pP953t7CRoHQuC6GGqeigVJ+LtIIEmLWcJ78uQeEGvyRKsP
	Etgp98itoZ1ivC66synnlY3bwKoe1ERLjw9kuHx48fySDpv3a7rPVUCYpAC9dGffFZXe+9QS4dB
	D5dPXIi/kPk803Hwpq49cBiEAnb4U8C8iNeBmfWu2cqc3hpjeyushDWM7PDKXMTdSgtqzir9k/t
	ihrYVAj4fAkbfPAYGM/cg==
X-Received: by 2002:a17:903:3c67:b0:2ca:e19c:97b with SMTP id d9443c01a7336-2df7e24f3a5mr16150895ad.5.1790242637239;
        Thu, 24 Sep 2026 02:37:17 -0700 (PDT)
Received: from [10.192.33.43] ([43.224.245.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5169absm24501695ad.8.2026.09.24.02.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 02:37:16 -0700 (PDT)
Message-ID: <9a542b7e-bbb0-4c14-8760-f3aceaab39e2@gmail.com>
Date: Thu, 24 Sep 2026 17:37:08 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix race between inline dir conversion and folio
 read
To: Sandeep Dhavale <dhavale@google.com>, Theodore Ts'o <tytso@mit.edu>
Cc: kernel-team@android.com, stable@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, liuderong@xiaomi.com
References: <20260918025416.604297-1-dhavale@google.com>
From: liuderong <liuderong2022@gmail.com>
In-Reply-To: <20260918025416.604297-1-dhavale@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/18/2026 10:54 AM, Sandeep Dhavale wrote:
> Commit 90f097b1403f ("ext4: refactor the inline directory conversion and
> new directory codepaths") moved directory block initialization in
> ext4_convert_inline_data_nolock() into ext4_init_dirblock(), unlocking
> data_bh before setting BH_Uptodate.
>
> When block size is smaller than PAGE_SIZE, multiple buffer heads share a
> single block device folio. If a concurrent read on that folio runs via
> block_read_full_folio() while data_bh is unlocked and not uptodate, it
> locks data_bh and submits a disk read for the uninitialized block.
>
> Because ext4_init_dirblock() initializes bh->b_data without holding the
> buffer lock, the disk read races with and overwrites the initialized
> directory entries and checksum tail, corrupting the directory block:
>
>    EXT4-fs warning: ext4_dirblock_csum_verify:375: inode #...:
>      No space for directory leaf checksum. Please run e2fsck -D.
>    EXT4-fs error: __ext4_find_entry:1626: inode #...:
>      checksumming directory block 0
>
> To fix this, mark data_bh uptodate before unlocking it in
> ext4_convert_inline_data_nolock(), just like the regular file path
> does. Additionally, hold lock_buffer(bh) in ext4_init_dirblock() while
> populating the directory entries and checksum tail so any buffer
> modifications are properly serialized.
>
> Fixes: 90f097b1403f ("ext4: refactor the inline directory conversion and new directory codepaths")
> Cc: stable@vger.kernel.org
> Assisted-by: Antigravity:gemini-3.8-flash
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>
> ---
> Note:
> This issue was reported by an Android partner encountering kernel panics
> in ext4_dirblock_csum_verify() ("No space for directory leaf checksum")
> on 16KB page size kernels mounting a 4KB block size ext4 filesystem.
>
> We verified with a standalone reproducer that the race reproduces
> deterministically on Iteration 0 (< 1s) on both ARM64 (16KB page size,
> 4KB ext4 blocks) and upstream ext4-tree/dev on x86_64 (4KB page size,
> 1KB ext4 blocks), and confirmed that this patch resolves the issue.
I verified this patch on an MTK platform running Android 17 (kernel 
6.18) with 16KB page size and 4KB ext4 block size: the script can 
reliably reproduce the issue. After applying the patch, the issue no 
longer reproduces.
Reproduction log snippet:
EXT4-fs warning (device loop54): ext4_dirblock_csum_verify:375: inode 
#15: comm repro_issue2: No space for directory leaf checksum. Please run 
e2fsck -D.
EXT4-fs error (device loop54): __ext4_find_entry:1626: inode #15: comm 
repro_issue2: checksumming directory block 0

Tested-by: liuderong <liuderong@xiaomi.com>
>   fs/ext4/inline.c | 1 +
>   fs/ext4/namei.c  | 2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..0aa14cee3310 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1167,6 +1167,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
>   		error = ext4_handle_dirty_metadata(handle,
>   						   inode, data_bh);
>   	} else {
> +		set_buffer_uptodate(data_bh);
>   		unlock_buffer(data_bh);
>   		inode->i_size = inode->i_sb->s_blocksize;
>   		i_size_write(inode, inode->i_sb->s_blocksize);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3b9740c1c16d..6550102fb56b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2933,6 +2933,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
>   	if (ext4_has_feature_metadata_csum(inode->i_sb))
>   		csum_size = sizeof(struct ext4_dir_entry_tail);
>   
> +	lock_buffer(bh);
>   	de->inode = cpu_to_le32(inode->i_ino);
>   	de->name_len = 1;
>   	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
> @@ -2965,6 +2966,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
>   	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
>   	set_buffer_uptodate(bh);
>   	set_buffer_verified(bh);
> +	unlock_buffer(bh);
>   	return ext4_handle_dirty_dirblock(handle, inode, bh);
>   }
>   
