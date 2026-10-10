Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609AD36F8F9
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 04:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791608368; cv=none; b=Yvmy089qbwdlyW8fA/yrVXJlMTTbH5aFEnb7JwldgoNOeoXwcKCFDP65Jv4IRU6cC1HvP+DUDbdwuqch3OyHyzWkDvfXz3CaG3f9gU2hNVmM8WidJ/TzHSR50aHhG+MAQeghYPEzfm1PKBO3565AeiGKLMgOle7GTWSW+LAi8kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791608368; c=relaxed/simple;
	bh=2rdp7m3bJ4T9PCD3Munhreg/l5VHoEdxQ/PPaJ4Fz3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ff9yYZcid77+svv6AcDk6ry0PSNpFklmi71msxugB9dmrdzAk6QrTl3DZhBotkBVImdEmWSEisAXWWrGd+xj73SwEoorMm83GwJGZjpdqrOyJUA5GbEmnaCmeM1Ph1jGAtHknudJx6IV4VE1pVUlqg+T2VIk9GvgogQEuWFR2p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fuws3KJo; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fuws3KJo"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso108782a91.1
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 21:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791608367; x=1792213167; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vm+JPX0zlMDidpG2yBei0vOBYyCXOCTpBD+z4xlRLJk=;
        b=Fuws3KJoDxvXyszp1+5fbMs+GGm5VUI2D1vmL7FliZOUFrfdhMDOxaMyFbRdG6Jq/m
         RixHUjJth7yxFMiGcz4G5Uck5ai2Ezz9P7lJFmreIQmTIp7qNKJpnAlrjhI0fbUu3yZW
         eHWlGirW3SJ9wMqW2XmCtATasE21C/BCojEaQJKE8m1jkeM9C/hTIQQIGtypQVehqbxw
         aCrDsxZzoE06TnCjZmeFl4KROTGMLhA8I5DQc3Ni3Bc97jJ6NKjYNvqCWOBpZlsbn3XJ
         rdSk5fjW7wEOx67ahONgl1Pd1gHpQ8CZTbSmZD3FRSsSTWCbIfbt+xeOWjrV33lpE1qn
         sVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791608367; x=1792213167;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vm+JPX0zlMDidpG2yBei0vOBYyCXOCTpBD+z4xlRLJk=;
        b=s5N2+SU7vErNLscMFf0wz+x1MzsogzzsZLM22YkCBI7O9gIndydW4X7c+ZEJXy3HRV
         ixxpbVSbJjciS5X1XS/xMAv6pNidqkWTs/PwF9/fgEEFVK+sdtjzyHWqHYSBkDWg+IRK
         TfM1v0ldSvo0S3qY00mi9Y8fIG/hBbKhfeQ0peyxXASCFEfRXMBvGNB3s2T4/BfWftRq
         ebVCab5scnS4aY7IU5K3D4Scw03UuSCCBjXmiAtJH36sQmEsjzNUL2R4GhXQFLd24mvb
         rXHyzNxISF7bdMl++tWrvg/2O1BXOzaH4C1VHiqGnJ/Gq2WiwRgFD/Lem6gIsjstChaz
         NvCA==
X-Forwarded-Encrypted: i=1; AKwUvBy1J4YF9ixxFJZTllHjFi4lzitDEoms8nwxK1BAXnNg/UUweSqtA/BHZO94/9Y+G5Lq1k9DfVFHuP7I@vger.kernel.org
X-Gm-Message-State: AFq9FYLtB27bTY2oiSPOs0q1BFREOkm764IVPSvZYUlg2vgvv44MKl0o
	8p2UyMwF+sVAFkW5sQ0YOfrp0yj+ZnrrqELDiHWZ1A4o6XbhgqQXarDs4h9Zeg==
X-Gm-Gg: AYBFou1PfzVC2ylZS20c6Zuwzre3TjMPcCCTlZ7sMfxrNqKw8ykFkzoPG/xic8SuBtN
	GMwyk0U5NGtP8BBlKwyAJxzf7mK7ppCcQlOHwR+L/gZIjTcUkMoyAIZu2ETTnM+f0WCPPXCcIP/
	AvW0Cjkk153I/JVvnAj70sZuycNhvw/H4xVugG006vLdkMaGJCaWZdVculCHWTkFF/LSI7Ua1lk
	x4yczOso1wmwdPZjoMlrgJ1ejjRELT5W7i+S2nUqMQ7z4gSAchSR2FYhQwLOtz9sN9qNc4XNNLI
	D73+7UN/VJl0YpILUaDn6ToRinIzh6Oaq1U97HhfHv0jtzqg9tokL0sGnkjULBaB5tqdVN01wYf
	LyLh0dTgTKN/q6sSwORy+O6wBQwDiBminK0XutY1KktyqXFdrssWvNixmtmPwiRk+yrNxEZGuSP
	VdKkpCdXlkyvegjaSBMr83VRiAVwi0uBjs4zu2b9pjvs7ezBDC86TerVZF26TryVBP+wQxzRDsi
	2L+InaWKKusv/AjkLw=
X-Received: by 2002:a17:90b:2784:b0:3a8:1cc5:c1be with SMTP id 98e67ed59e1d1-3ab3a7a0ef0mr3424805a91.28.1791608366640;
        Fri, 09 Oct 2026 21:59:26 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab8a393666sm1203907a91.15.2026.10.09.21.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 21:59:26 -0700 (PDT)
Message-ID: <b1a31381-e71f-4826-9857-a369117c8094@gmail.com>
Date: Sat, 10 Oct 2026 12:59:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate or
 error
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-27-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165341@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165341@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:16 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] fs: missing DISKSIZE_GROW_PENDING clear during nlink > 0 eviction
> --
> 
> commit b90813716147a7864ab2f3a3c46c2814d0084c2b
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: clear DISKSIZE_GROW_PENDING on truncate or error
> 
> This commit clears the disksize-grow-pending state on various paths where a
> zeroed EOF block is discarded before writeback completes. It also adds a
> warning in destroy_inode to catch any inodes that missed clearing the state.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -266,6 +266,8 @@ void ext4_evict_inode(struct inode *inode)
>>   
>>   	if (ext4_should_order_data(inode))
>>   		ext4_begin_ordered_truncate(inode, 0);
>> +	if (ext4_inode_buffered_iomap(inode))
>> +		ext4_iomap_clear_disksize_pending(inode);
>>   	truncate_inode_pages_final(&inode->i_data);
> 
> [Severity: Medium]
> When an inode with nlink > 0 is evicted and still has dirty pages (such as
> during a forced unmount or after a failed sync_filesystem), ext4_evict_inode()
> logs a data loss warning and forcefully truncates the page cache using
> truncate_inode_pages_final() before jumping to the no_delete label.
> 
> Because the pages are discarded immediately without initiating writeback, the
> writeback error path is never invoked, meaning the
> EXT4_STATE_DISKSIZE_GROW_PENDING bit is never cleared.
> 
> Since the added state clearing logic is placed after the nlink > 0 block, does
> this bypass clearing the bit for those inodes entirely?

Under normal circumstances, it is already an unexpected state for an
inode with nlink > 0 to still have dirty folios left when it is evicted,
and in that case the "data will be lost" warning is already triggered,
so I think the later warning about the bit not being cleared is also
expected behavior. That said, if we feel the WARN_ON_ONCE() in
ext4_destroy_inode() is too heavy, it could indeed be considered for
removal, but for now I'd suggest keeping things as it is.

Thanks,
Yi.

> 
> [ ... ]
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1497,6 +1497,14 @@ static void ext4_destroy_inode(struct inode *inode)
>>   			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
>>   			 inode->i_ino, EXT4_I(inode),
>>   			 EXT4_I(inode)->i_reserved_data_blocks);
>> +
>> +	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
>> +	    !ext4_emergency_state(inode->i_sb) &&
>> +	    WARN_ON_ONCE(ext4_test_inode_state(inode,
>> +				EXT4_STATE_DISKSIZE_GROW_PENDING)))
> 
> [Severity: Medium]
> Can this assertion be reliably triggered when unmounting a filesystem while
> writeback is blocked or fails, since the pending bit is not cleared during
> nlink > 0 eviction? This might potentially crash systems with panic_on_warn
> enabled.
> 
>> +		ext4_msg(inode->i_sb, KERN_ERR,
>> +			 "Inode %llu (%p): EXT4_STATE_DISKSIZE_GROW_PENDING not cleared!",
>> +			 inode->i_ino, EXT4_I(inode));
>>   }
>>   
>>   static void ext4_shutdown(struct super_block *sb)
> 

