Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0748D2D0292
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2026 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787369277; cv=none; b=kq5GRoqYRm/hSPY8+RzDzGGUI1Orw0QwPzAcZbhBJkteqKb8v6fX9G3qaGlsl3LX3PHxWGppA34BUfwy+i0VgJ9w61fHYd2YDPY5N46rHQ46Df3ASZThNul3WJUCxDoJRgCxFDwJU/QyjBYffmnYXotHSD0HgLvncHMwBeGj+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787369277; c=relaxed/simple;
	bh=r0rZITQKtQ0m93bjcwa195ZSrLZUfdfW1/mQ7LAgKJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SiwuMsSEJ58PpFRBBIdxpI13vT+x6QyirJmsgLQnXYMPkzlyOjycAfCKoVBh7s4fyi3FifuyzPoAreGbxCQtGW14ymwCBpQ/u4lu19IybPCNkoc2S74RT83Cf8+C3nfKufwbKKcym3Y0ntow64o7K0nQUvHWp23nYfW7KRXg3gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DtXZpump; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DtXZpump"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e08baf860so1779710a91.2
        for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2026 20:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787369275; x=1787974075; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LOks5Q+WseXHaYrxJ0Gn8dlCqtIA9nboyxrTjV4SPVE=;
        b=DtXZpumptNjUFJEcE55AFFDudCjZdeXxsAnkjT7VmJi+uycMOTy5k7ss3R3ElXtmuU
         GihGsJkn4zQSEvTPUbuugoYt9JqMuGsWCpt19b9611Nafdtv5pxxGPM0jYXXWu9/s2A2
         SW8b1Md7PhNJSScJwmdv2tdfOWEfeYS+yLmukTwHcvQwqHYK1ur/7MaViOUg2tz7h6Lh
         8eZTgTl/+xxXt/l5YxKF8HVHnqz9QFFH3HysJKEYzOIy77VtFZ8PE/v4UAGKbWvd6JDm
         D2HgRBbAIohldIHzbcvuMT0Itv5a+53/p3f22FM5JFZpcpLkMZ4hr0Vz2e4QNzyC3wAB
         Fugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787369275; x=1787974075;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOks5Q+WseXHaYrxJ0Gn8dlCqtIA9nboyxrTjV4SPVE=;
        b=DImY6bof1UaoUTOwnVM8/VNsZM/KEeqK7k2iw6QE4FQ3vQptJuAQBWSw48ovwQJRjp
         i4ujkDPxz9n6E9e4tNyb8YHqudgFvO/kVJuKNMSxNYpwQ8YwfsmLqDAynpovd1n/t3DM
         OnvLw5de0v71BWFV9F/xF3v0G3/Ev0VP5jLtnS49PN90GBVoZQsUtW/81QLtJK0Gb15P
         j54c6mmayR5N97U3eTQHg1IZWmloxHGzaK6YWn4dhTwf91fPCxCnKMlA5YoE7sgJPHVF
         5lZyUJgPFZdateXU2lUB5NDmSlvHgGsKWrHcOu6h8/8mczmmy2qHFupecCPl4155GvIe
         9pvQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro7+dbxGNl47ot210S37hbwydyvLcyR47voJCyhaHW0QjAVlPz/DTkdiLeKkZffcOfDRXhU3vfh79vv@vger.kernel.org
X-Gm-Message-State: AFuF++mXuC/cTLqR8svjyJCmxMrrbHYLVXMNOLGhKTNvm7+arzgcM7K/
	ly1p69f6+1RJtOqdc2fF8RdQmpM78iUO0K4ATVi13Gdm0toZ8Fud8nydPrSk3J2GTho=
X-Gm-Gg: AR+sD12qJc+FjzrfgDIqtExyPtjZp3PEzaCH1awlHWFWqX8knmw6PP9EFBL77krERwW
	wS4LrTcWxRI+7nZ8MgGl0hNcf3bCg4YZIDCyMemJbYfZZI7ac0M0y1X0/+QA629XJLldY8FBrCA
	H4DdsO7vmbNCN7Kf0f1aY6orjfLCW2n/EkgGwaEuyR+rVC5IIAPrS0WIhHydmxTlPh2EgMVZ0ic
	Hy7jWuLkcVYFNLezwEaIpLMNvYrp06nz+Jo780S4ke9fmEf8dmW0Iueq4qry06Ul8mzO5ewMLuN
	oCPXJzYFg+FqKSiy9VuZaFLMJmDF7TiX2lZoCV4tqGXZX6ZLAA2+wMKws7cGCea9JRoZDSqQmIc
	kSGV/7iDo9q0c//RZY0qjcRWLEPR2e5r08TSkQxTdylBBN/gKgdRKfP5B4o7DUbCBLj6dPwU+pb
	a/I6hL4nDP91h4oonXceNY5bZNfcP766S07N6YVrkjQULXnUc4wjEX1XSlzg6jGgcJnuwEq78GH
	20gWp8r
X-Received: by 2002:a17:90b:3a8d:b0:395:4de0:b78f with SMTP id 98e67ed59e1d1-395dee528b7mr5092881a91.1.1787369275158;
        Fri, 21 Aug 2026 20:27:55 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4999471sm1154921a91.8.2026.08.21.20.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 20:27:54 -0700 (PDT)
Message-ID: <f99cb0f6-5a2d-4404-8799-6a67865e2965@gmail.com>
Date: Sat, 22 Aug 2026 11:27:25 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 29/32] ext4: add tracepoints for
 DISKSIZE_GROW_PENDING set, clear, and wait
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-30-yi.zhang@huaweicloud.com>
 <20260814101826.865151F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814101826.865151F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:18 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Sequence counter deadlock in tracepoint when called from softirq context on 32-bit SMP.
> --
> 
> --- Patch [29]: [PATCH -next v5 29/32] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait ---
> commit f14aeb9661220b55cf0eeb4ff49da9fa6a2a18ca
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
>      
> This commit adds trace events ext4_iomap_mark_disksize_pending(),
> ext4_iomap_clear_disksize_pending(), and ext4_iomap_wait_disksize_pending().
> These tracepoints track disksize-grow-pending state changes and waiting.
> 
>> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
>> index 69596a216dcb1..4539ef8e5f86c 100644
>> --- a/include/trace/events/ext4.h
>> +++ b/include/trace/events/ext4.h
> [ ... ]
>> +DECLARE_EVENT_CLASS(ext4_iomap_disksize_pending,
>> +	TP_PROTO(struct inode *inode),
>> +	TP_ARGS(inode),
>> +	TP_STRUCT__entry(
>> +		__field(dev_t, dev)
>> +		__field(u64, ino)
>> +		__field(loff_t, i_size)
>> +		__field(loff_t, i_disksize)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->dev = inode->i_sb->s_dev;
>> +		__entry->ino = inode->i_ino;
>> +		__entry->i_size = i_size_read(inode);
> 
> [Severity: High]
> Could this cause a sequence counter deadlock on 32-bit SMP architectures?
> 
> If a process executing i_size_write() is preempted by a block I/O completion
> hardware interrupt, and pending softirqs are executed on return from the
> interrupt, the softirq could call ext4_iomap_end_bio() in fs/ext4/page-io.c:
> 
> fs/ext4/page-io.c:ext4_iomap_end_bio() {
>          ...
>          if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
>                  ext4_iomap_clear_disksize_pending(ioend->io_inode);
>          ...
> }
> 
> This would trigger trace_ext4_iomap_clear_disksize_pending() which calls
> i_size_read() here in TP_fast_assign.
> 
> Since i_size_write() disables preemption but not softirqs, the seqcount
> would be odd. This would cause i_size_read() to spin indefinitely waiting
> for the interrupted i_size_write() to complete on the same CPU.
> 

Yeah, I'll remove the i_size check in the next version. It doesn't
look like we really need it.

Thanks,
Yi.

>> +		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
>> +	),
>> +	TP_printk("dev %d:%d ino %llu i_size %lld i_disksize %lld",
>> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
>> +		  __entry->ino, __entry->i_size, __entry->i_disksize)
>> +);
> 

