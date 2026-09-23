Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44E7513569
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 12:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165538; cv=none; b=SrEjUEntyi+mw7zeK/QKgxclpaomdpcY4lm2XGI4WeX+ChHYbqlm4qNIDXaqXVQPdqWQbgmb14rfS5v/HcZujcOrOX8i1tkeLdIn221WI7ARz3eS1m2oDE2FzPb35IOZP+6RfQNwFT/QkMzB3/NGA4LEi8l5CbonneW2G+cshw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165538; c=relaxed/simple;
	bh=3Rqcb8yeOHJJFd8vVDLWzxR4XLjr7YKQc03keoQTjt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=BxAc2Jgx4l/ZHGGYfB1F2+y6W8pc4rpwnSXMRLrs6jAbks2XWXXigJHyIfAnNXqUOFoWvQ+75U0Hj5oj/4O63WBW1UDlwMRdOUDe5fWsYUWzJy3izVbR/J3XBk/hAauc0vgylvud7azbWbw1eHUgagNBztPvStl+KLZt7Q7WJ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tmdHCr2m; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tmdHCr2m"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790165525; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r9r6M+9VV1/7b9nuTxX6JcRY7IDCqkMOqG3opFQRzCc=;
	b=tmdHCr2mud3KnpHXxqQBW1l0fTqlAKLQxCHMeLGSnsxHvnkt4TyIvYia1q6Htfeyxmuz5wewPFdnbecGZs0YELo3Vwvkgw7WX+hCvlQlEuLt0UDcZY1z+yUgeJKGkSTPZ4+8HOQleDtuTaxHpblwpwcoeNnVVGjaLegeKxxy4rc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XBX0ihY_1790165523;
Received: from 30.221.148.48(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBX0ihY_1790165523 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 20:12:04 +0800
Message-ID: <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
Date: Wed, 23 Sep 2026 20:12:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
To: Alberto Garcia <berto@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>
In-Reply-To: <arO0KE9_Jf8rNRwN@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/9/23 19:12, Alberto Garcia wrote:
> Hi,
>
> I'd like to report a bug in the ext4 code. I confirm that it happens
> with the latest stable kernel (7.2.7), but mainline (7.3-rc4) does not
> seem to be affected.
>
> The problem is very easy to reproduce:
>
> 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt


Is it valid to enable encrypt at mount time?


Regards,
Baokun



> 2) Create an empty directory and encrypt it (fscrypt encrypt /foo or whatever).
> 3) Write some data to it (head -c head -c 10M /dev/urandom > /foo/file.bin)
> 4) sync
>
> [   42.962615] BUG: kernel NULL pointer dereference, address: 0000000000000028
> [   42.965440] #PF: supervisor read access in kernel mode
> [   42.967480] #PF: error_code(0x0000) - not-present page
> [   42.969475] PGD 0 P4D 0 
> [   42.970460] Oops: Oops: 0000 [#1] SMP NOPTI
> [   42.972141] CPU: 0 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 7.2.7-vanilla #2 PREEMPT(lazy) 
> [   42.975502] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   42.977650] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
> [   42.978499] RIP: 0010:ext4_finish_bio+0xf8/0x400
> [   42.979452] Code: 38 00 00 00 00 48 8b 44 24 08 4c 01 f8 48 89 04 24 48 83 7b 18 00 0f 84 d7 02 00 00 41 0f b6 7d 1a 40 84 ff 0f 85 7d 02 00 00 <4c> 8b 63 28 45 31 f6 49 8d 44 24 5c 48 89 c7 48 89 44 24 20 e8 6f
> [   42.982351] RSP: 0018:ffffd0290006bd40 EFLAGS: 00010246
> [   42.983090] RAX: 0000000000001000 RBX: 0000000000000000 RCX: 000fffffc0000201
> [   42.984204] RDX: fffff64a40226f00 RSI: fffff64a400afcc0 RDI: 0000000000000000
> [   42.985203] RBP: 0000000000001000 R08: 0000000000001000 R09: ffffffff8a49cb8a
> [   42.986203] R10: 0000000000001fff R11: ffff8b4f81926200 R12: ffff8b4f8521b540
> [   42.987213] R13: ffff8b4f81927f00 R14: 0000000000000001 R15: 0000000000000000
> [   42.988351] FS:  0000000000000000(0000) GS:ffff8b507105e000(0000) knlGS:0000000000000000
> [   42.989478] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   42.990292] CR2: 0000000000000028 CR3: 000000000bcb9000 CR4: 0000000000350ef0
> [   42.991291] Call Trace:
> [   42.991709]  <TASK>
> [   42.992042]  ext4_release_io_end+0x55/0x120
> [   42.992650]  ext4_end_io_end+0x4c/0xe0
> [   42.993194]  ext4_end_io_rsv_work+0xaa/0x100
> [   42.993807]  process_one_work+0x19e/0x370
> [   42.994382]  worker_thread+0x1a6/0x310
> [   42.994925]  ? __pfx_worker_thread+0x10/0x10
> [   42.995806]  kthread+0xe4/0x120
> [   42.996313]  ? __pfx_kthread+0x10/0x10
> [   42.996856]  ret_from_fork+0x2b1/0x340
> [   42.997397]  ? __pfx_kthread+0x10/0x10
> [   42.997941]  ret_from_fork_asm+0x1a/0x30
> [   42.998505]  </TASK>
>
> The problem does not happen if you unmount the filesystem after
> setting the encryption feature, and then mount it again.
>
> The cause seems to be that encryption does not support large folios,
> but after commit 709f0f1f1bf5c ("ext4: add checks for large folio
> incompatibilities when BS > PS") this is only checked at mount time,
> so enabling encryption on a mounted fs bypasses this check.
>
> This solves the crash for me, but I suppose that it also needs an
> additional check to decide whether encryption can be enabled on a
> filesystem (i.e. if sb->s_blocksize > PAGE_SIZE).
>
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5287,7 +5287,8 @@ void ext4_set_inode_mapping_order(struct inode *inode)
>  	if (!min_order && !S_ISREG(inode->i_mode))
>  		return;
>  
> -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) ||
> +	    ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT))
>  		max_order = min_order;
>  
>  	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
>
> Regards,
>
> Berto


