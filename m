Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794484762;
	b=c3BU3VfxW709yxL23n7o6hH30S2258exD3RpX+SIpxJ8rbTNT+wYBz2frR58A5Hbma13
	 KPrf4rrDyNCJO3uNPD2UmTgfVrMA4QZfmMzfWWPEacGqixbM6RV+m3i8l82Coyb5pLFKH
	 5xiiyRiTakFf1wTitMkV15nLlK4QNWDolM0qipBuk8sl6uEiJcc8ZE/tqwO9IxZSt2lGG
	 48qUWg2hg+gGpOt9w5xRbq+poKyaBjPpCyI8bOdSCnmKuyaXLBSc7MEomrtunlZceVt5H
	 aVUA+QdeUHjV6bqGb9WwWgivdo2//nNYjddI9Zn9KnI77hEmB5eIDFX+mObGWl09PMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484762;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=8Exqu4NcRdV/N84WhnKHI+8tv0Q8pqFx+3FzcBJtyiQ=;
	b=0agEDB6SV2y8Ybk96Jl2CgMFym3l3oMam4XunKjeYkbdKOi3/3hr0+7WsX6I/0W7ilEl
	 UFwjlvDeShsZZnk8pOp2yopfPRx0nFhj6x1MFKtbGARL9ZRohqzjqBJgXgI/Dj8unTQZ2
	 N3iYtrxYD6uzbXXuOEKf4Ba4qmBSPuTMe1Oonkdy6Dg9OAOTyGRxxNrA+BDrq05I6BM9C
	 aTYjT8kMD3cJZLg9K6DLoH7KD8SbKHHSp+/BAY9+4gnpUg5TFB1VbP+GtfAQ7lMW5XBFA
	 elKgJED7eXPdNXQFh2MO9V3B3DQutj07BC3cScaN9ep2ZsjBkq7Liz7Y+GVoTZNQlBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B567B606A32E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 11:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B567B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-8615cc92488so306760a34.2
        for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 03:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484761; x=1795089561;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8Exqu4NcRdV/N84WhnKHI+8tv0Q8pqFx+3FzcBJtyiQ=;
        b=ElZpd0FEbpbpZQd6cVM+VkE5tEbO6TSYT2rjE4XIUrtujQ9lOQGEZH82qmCVrbAHyE
         qFK3ZKImZxOHsQCUSFYnYgwoI1rMNHZzN0PHEnSzpIXP8oO641/pP+tBTv5L5tdi3zbe
         cA4rY8dvh6TdFFoq/nPvuP4pq0Edr7UKCUBVt/F31MH8fVmoToK7eFl0vTFLlcOh522X
         IoU/GJqiBC9YJukeOKSRfZDJNgXvwfdEvhraExG7sFyZbeZkMjgvuLSc88azewEdHXHZ
         njjOejIWpzvoHE6Td5CSJNgQhSEW/mXJslSgWEK/JDPN3lBGS9Diefhchn9Qy1Rpeo+S
         HyLg==
X-Forwarded-Encrypted: i=1; AL+hErEvBJgOCr36FJIyWFfYQoYJ0wTBEyUeaERtjbJx7+td/VAC4mVZc92IUR5SCIoLv1eXaIZv0UbuJ6FQ@vger.kernel.org
X-Gm-Message-State: APuU4Z8ONl8VnItzfA3aBXCUg/GPxxv4ikSYWIR1m6XbW0At17vR9o9W
	/sVrew4Lb5QUu+qUOG/QigmNBl31vkE9zGkJkxeesHlupEqjbPw8O42QQSXLuczzHGeS9GFSaCw
	Am3+dAC+57YPUCmRdqnEtCcMjVTbxjlXY/82cQdQByTTqcXqEgfkh3brFDao=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a09:b0:53a:ad3c:17aa with SMTP id
 5614622812f47-56b98620830mr5072770b6e.55.1794484760823; Thu, 12 Nov 2026
 03:59:20 -0800 (PST)
Date: Thu, 12 Nov 2026 03:59:20 -0800
In-Reply-To: <20261112115906.17915-1-diasyzhangqing@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af5aa18.41d0a7c9.ab0b9.0108.GAE@google.com>
Subject: Re: [PATCH] ext4: wait for tail page commit before truncating a
 failed write
From: syzbot <syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com>
To: diasyzhangqing@gmail.com
Cc: adilger.kernel@dilger.ca, diasyzhang@tencent.com, diasyzhangqing@gmail.com, 
	jack@suse.cz, libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	tytso@mit.edu, yi.zhang@huawei.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> From: Qing Zhang <diasyzhang@tencent.com>
>
> In data=journal mode, a failed extending write can leave buffers beyond
> i_size attached to the committing transaction. When blocksize < PAGE_SIZE,
> invalidating these buffers in the partial tail folio returns -EBUSY,
> triggering a warning in ext4_journalled_invalidate_folio() and leaving
> invalidation incomplete.
>
> Call ext4_wait_for_tail_page_commit() before truncating the page cache
> in ext4_truncate_failed_write(), as is already done when shrinking a file
> via ext4_setattr(). The helper releases the folio lock before waiting
> for the commit to finish, then retries invalidation.
>
> Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
> Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
> Closes: https://syzbot.appspot.com/bug?extid=f111db4cb2acd44eb2f4
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
> ---
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

Patch testing via #syz test is temporarily disabled.
See https://github.com/google/syzkaller/issues/8122 for details.

>
>  fs/ext4/ext4.h    | 1 +
>  fs/ext4/inode.c   | 2 +-
>  fs/ext4/truncate.h |  2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f38fec3167fb..505ec38fa508 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3214,6 +3214,7 @@ int ext4_get_fc_inode_loc(struct super_block *sb, unsigned int ino,
>  extern int ext4_inode_attach_jinode(struct inode *inode);
>  extern int ext4_can_truncate(struct inode *inode);
>  extern int ext4_truncate(struct inode *);
> +extern void ext4_wait_for_tail_page_commit(struct inode *inode);
>  extern int ext4_break_layouts(struct inode *);
>  extern int ext4_truncate_page_cache_block_range(struct inode *inode,
>  						loff_t start, loff_t end);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 10cd85d4c721..f59c4a5b7561 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6845,7 +6845,7 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>   * buffers that are attached to a folio straddling i_size and are undergoing
>   * commit. In that case we have to wait for commit to finish and try again.
>   */
> -static void ext4_wait_for_tail_page_commit(struct inode *inode)
> +void ext4_wait_for_tail_page_commit(struct inode *inode)
>  {
>  	unsigned offset;
>  	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
> index ce84aa2786c7..c10e4ab4242e 100644
> --- a/fs/ext4/truncate.h
> +++ b/fs/ext4/truncate.h
> @@ -17,6 +17,8 @@ static inline void ext4_truncate_failed_write(struct inode *inode)
>  	 * We don't need to call ext4_break_layouts() because the blocks we
>  	 * are truncating were never visible to userspace.
>  	 */
>  	filemap_invalidate_lock(mapping);
> +	if (ext4_should_journal_data(inode))
> +		ext4_wait_for_tail_page_commit(inode);
>  	truncate_inode_pages(mapping, inode->i_size);
>  	ext4_truncate(inode);
>  	filemap_invalidate_unlock(mapping);
> -- 
> 2.43.0
>
