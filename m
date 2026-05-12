Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B6748125C;
	Tue, 12 May 2026 08:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778574028; cv=none; b=u1f6mLnC0Oc5C3bn75q/cJ4XRFFSR79YoWMV9MlRJTxEYatYHBLvhW27FG4KVor09oVkSfCmmK+54YPVhXHhDVftXTT/6SXCZrfivtE7RrJDvUAdAc9TRZldSgHEb65Htv4mR+JZc8NQZTgffZOFuITybJi75CFBPQ6nsUyf6PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778574028; c=relaxed/simple;
	bh=yvYPo9VSgabgjaGxzRk1BynRyMwK2qRQrZMMO7P2dGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=use0b0iFPNZlW5FqIo1yhyFCdtljRf+Huf5nCs4yxktpqDehAIoNFv0J0JAFOq1WoVzvO0uGKw9W7Mb5zqOZ61lIoHTUxdUcrQftWakdgURPI8jlsa+JYAeHwtIUbjZ/rokad1LJOwHz0sC7/F+bwCfqTsmKyvTgCBN7qXXbtAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gF8dR1JRkzKHLyH;
	Tue, 12 May 2026 16:19:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5CE7E4058F;
	Tue, 12 May 2026 16:20:15 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgA3_1q84gJqilgLCA--.57615S3;
	Tue, 12 May 2026 16:20:14 +0800 (CST)
Message-ID: <e5023ed1-573b-4c2d-9193-193f720191ad@huaweicloud.com>
Date: Tue, 12 May 2026 16:20:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: check for aborted handle in
 jbd2_journal_dirty_metadata()
To: Deepanshu Kartikey <kartikey406@gmail.com>, tytso@mit.edu, jack@suse.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
References: <20260507050605.50081-1-kartikey406@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260507050605.50081-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3_1q84gJqilgLCA--.57615S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr45WF47Gw43WFW5tryDGFg_yoWrAw1xpr
	W0kw15uryvv34UAr1xZF48ZrW09FyUAa4UGrZFkwn3Za15Gwn7KFWUtryq9F1qkryFg3WU
	XF1UC3WDGws0y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/7/2026 1:06 PM, Deepanshu Kartikey wrote:
> jbd2_journal_dirty_metadata() unconditionally dereferences
> handle->h_transaction at function entry to obtain the journal pointer:
> 
> 	transaction_t *transaction = handle->h_transaction;
> 	journal_t *journal = transaction->t_journal;
> 
> However, h_transaction may legitimately be NULL for an aborted handle.
> The is_handle_aborted() helper in include/linux/jbd2.h explicitly
> treats !h_transaction as one of the aborted states:
> 
> 	if (handle->h_aborted || !handle->h_transaction)
> 		return 1;
> 
> Every other entry point in fs/jbd2/transaction.c
> (jbd2_journal_get_{write,undo,create}_access, jbd2_journal_extend,
> jbd2_journal_restart, jbd2_journal_stop, etc.) guards against this
> with an is_handle_aborted() check before any dereference of
> h_transaction. jbd2_journal_dirty_metadata() was missing this guard.
> 
> This is reachable from ocfs2's xattr code. ocfs2_xa_set() intentionally
> falls through to ocfs2_xa_journal_dirty() even after
> ocfs2_xa_prepare_entry() fails, on the assumption that the buffer
> needs to be journaled to record any partial modifications (see the
> comment above the out_dirty label in fs/ocfs2/xattr.c). If the failure
> was caused by the journal being aborted -- e.g. an underlying I/O
> error during a sub-operation such as __ocfs2_remove_xattr_range() --
> the handle's h_transaction has been cleared by the abort path, and
> the unconditional deref in jbd2_journal_dirty_metadata() becomes a
> NULL deref.
> 
> Reproduced by syzbot with a crafted ocfs2 image where I/O against the
> loop device backing the mount is sabotaged via LOOP_SET_STATUS64
> between two setxattr() calls, causing the second setxattr (which
> truncates an external xattr value) to abort the journal mid-flight:
> 
>   Oops: general protection fault, probably for non-canonical
>         address 0xdffffc0000000000
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: jbd2_journal_dirty_metadata+0x4a/0xd30 fs/jbd2/transaction.c:1520
>   Call Trace:
>    ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
>    ocfs2_xa_journal_dirty fs/ocfs2/xattr.c:1483 [inline]
>    ocfs2_xa_set+0x15e3/0x2ec0 fs/ocfs2/xattr.c:2294
>    ocfs2_xattr_block_set+0x3e0/0x33c0 fs/ocfs2/xattr.c:3016
>    __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
>    ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
>    __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
>    ...
> 
> Fix by adding the standard is_handle_aborted() guard at the top of
> jbd2_journal_dirty_metadata() and returning -EROFS, matching the
> pattern used by every other entry point in this file.
> ocfs2_journal_dirty() already handles a non-zero return from
> jbd2_journal_dirty_metadata() correctly.
> 
> Reported-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=98f651460e558a21baae
> Tested-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Looks good to me. Thanks!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/jbd2/transaction.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..aa0be9e9c876 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1516,14 +1516,19 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
>   */
>  int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  {
> -	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	transaction_t *transaction;
> +	journal_t *journal;
>  	struct journal_head *jh;
>  	int ret = 0;
>  
> +	if (is_handle_aborted(handle))
> +		return -EROFS;
>  	if (!buffer_jbd(bh))
>  		return -EUCLEAN;
>  
> +	transaction = handle->h_transaction;
> +	journal = transaction->t_journal;
> +
>  	/*
>  	 * We don't grab jh reference here since the buffer must be part
>  	 * of the running transaction.

