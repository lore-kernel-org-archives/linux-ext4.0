Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDCB380FE3
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239156; cv=none; b=u6F2rSqw53p9hPlIASnIff68z+38nsKOZSroOELdtLU1VM+pn+NOORx71IoB3sye567A1K6Mso9X6yHlmTBZxZUOT6AqXVjzcCvrm3MxwFcTM0Q2iqktO0LD7fq6hLV5QBc6DPYDUZYslj3AHxTi17iHUUcRTtYTQ/SBi4hib/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239156; c=relaxed/simple;
	bh=8RqABrvlJokOUj6jhqU8frU6nTSmn/toVzxIzcthQNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aV7XxZLdFgTS+ZNHlvSehuN/qXP8CHA03qRrDD/PeYjxNHzHwC+a1e3xZyX8EvkXYSGCTcQcxdB+nDSx7vubiiT3OQFvMSJToPs/wlQQ2wpHoxRMwGjijl4hwSU1VnNGc2Sa6z3P80ZyxtSF9TTXzFG1Yins6sXp3gKu1URMRVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0VVDb3+; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0VVDb3+"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ceab75934dso28715765ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787239154; x=1787843954; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a7ZM3S7YxfSumzIgj8EPnrdkbPiZ22RqFoPFkb521tU=;
        b=Q0VVDb3+nYFdrjd4ZdtVrY0Eafa4FUQbI1IfjTpOFAMKgbLvdQwK7le3X/1mffYx3s
         8JgNWQULMjYeXGt/Ut6YsPcH/H+ERs+U46T53tEkri7+IbBm3ndUS+1jYyan0sqCzXAy
         31b7Kf0RvMj/sQdV86sgxMe2jZzqtXGzRBr2T6tFk8WKY6bfiOZB4mhhF98dRi4x/ZHk
         QxS+T7SCCb1iz2T8KTFWwzTbFE2XDRyGEVKFbSfYfvb3lLoskQukkJtC82zGuYTI97vX
         FqJnfQZR89b0jnyq9vuitjATs+D+c9DtjC2zXonRktu198t01hiM7ZCnoHkpK2kUNLi2
         k8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787239154; x=1787843954;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a7ZM3S7YxfSumzIgj8EPnrdkbPiZ22RqFoPFkb521tU=;
        b=JC+SxHeszzje75JWuT1xYXDg2X6hfEhLHbUi6d7ZOIQMajURn6zKUFhk3e4j1GRYO6
         B1gI06lBieVi8G0DWd0Pp5RjfpIiGD+airkrkEs//qoPRbIk26dMWnhlZXe9Ty44bI7a
         iELs/Fd4UJUDpKsjXQO3VGJQ1YpDVJSAwDQC9XUMDn9i7PTSnTOnp25xtCm9aMv0HkFu
         UNGuMMBpEhy3tQwfPI7crq1+A1MhxZQ654GFnNmZ5VMhRE1kPgKCXCuX0kiIVajLT3lM
         lygbseLDIxGPvkMAe/WrY6qxTPbLWsZRwd2B5Wyropv+vsQjlRklAE4AKw/mf9N+WJAg
         xAWA==
X-Forwarded-Encrypted: i=1; AHgh+RpzM5tuo85EmnfKZAo5J/pjtOLPKiu747JhSM8i6Z9I5YJZ1eVRUT0KhXwJNQ28TAz7r9hHY5WWyy6s@vger.kernel.org
X-Gm-Message-State: AFuF++mlNiMGsbgJM678wcw5YoHsaRf4MhG2zov2y0Xb8xHEvj40EL1n
	jl3CYjbRBsnYVKlTb+D+CN4SmT18Pf+xJWXE5rQTt0bMBeC7lYanQz8mp9dlJBwUQtE=
X-Gm-Gg: AR+sD10eFpebkGSJtchfhmk55sN2x2QzkEzbRz7Mi8+2/5eHMPQqVsLRa6Lp3t9aXay
	VLI/DXJe3+b2l4cWVIcGEA/V9Y+XHaPTbDQb529QfvREyAPlAtpP9W6uf6RczbJulj3WcWr+ehD
	VE1YJvZ6L/LNEq+CjQH2131wE4fJ4LnaF7WVBH7q6L4McmSNRJ0fo2ZCB3fFEv5oZOgjjhvuQkq
	WWL4u5mlKY5ccXXo7UHy9UJ6cbZjRbISbXrF7/XDqVWoJmM/bURgA/5uY1Y/3tgIjWtoAF+VVc6
	OzmgTZqRygPDWYAw5a2fCDEOaC6UJSjcUuVxUXYjtWNxM/G0kl26VskXcmLD9NrK58oMEveui8H
	taMJ3mTmrV11MeAqFoqFbFqtvrWIq5/8tMyeHOIn7tSQYV8OcjXuDw7z4IlrS7fqherbKJK7fuQ
	86GWiS10IgVq3thTYOHEuCV7QX6Ed4I0+iq7Z6u0BR6ArfZqKgTfCJML7HsFp1XdrWgXl8CftSe
	kuFJm/I
X-Received: by 2002:a17:903:b8c:b0:2cf:4c0f:5127 with SMTP id d9443c01a7336-2d5fd6a3fa5mr267331825ad.10.1787239154226;
        Thu, 20 Aug 2026 08:19:14 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3affeesm8394785ad.65.2026.08.20.08.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 08:19:13 -0700 (PDT)
Message-ID: <daa118a5-1efb-49dd-9038-49d0c0b351fc@gmail.com>
Date: Thu, 20 Aug 2026 23:18:59 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] ext4: orphan tracking after a failed truncate
To: Theodore Tso <tytso@mit.edu>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, Guanghui Yang <3497809730@qq.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_3E210B6E71105F311354D53C158A3A9E1E08@qq.com>
 <66vcv4ircw5mqadt4eki52hujmykrrsqp2cux4qvn37v6kzvs7@d7ys45emz3dr>
 <1537a281-aa34-49f8-87f1-e5f4fab8eb10@huaweicloud.com>
 <aoRhIeFzNqHg34jg@mit.edu>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <aoRhIeFzNqHg34jg@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/2026 9:48 PM, Theodore Tso wrote:
> On Tue, Aug 18, 2026 at 12:41:57PM -0500, Zhang Yi wrote:
>> I think we might want to add a small qualifier here: this is only expected
>> behavior under errors=continue. For the remount-ro case, we immediately
>> abort the journal to prevent writing out inconsistent metadata after an I/O
>> error, which helps contain the damage. So after journal replay, the file
>> system should still be able to maintain a consistent state.
> 
> Errors={continue,remount-ro,panic} only apply if the ext4_error()
> family is called.  The problem is that ext4_ext_remove_space(), which
> is called by ext4_ext_truncate() calls read_extent_tree_block() and if
> it returns an error, it returns EIO without actually calling
> ext4_error().  So the truncate system call will return EIO, with
> i_size set to zero, but with blocks beyond EOF still left allocated.
> 

I checked the code. Apart from the verity path, all callers
of ext4_truncate() already call ext4_handle_error() when it returns
an error. So it doesn't look like there's any issue with truncate
at the moment. So I suspect that Guanghui won't be able to reproduce
this issue in remount-ro mode, and I'd suggest that similar consistency
tests under fault injection scenarios should all be run in remount-ro
mode.

> As I menstioned, that's not _fatal_ in that case, since blocks beyond
> EOF can happen with fallocate(2) with FALLOC_FL_KEEP_SIZE.  But it
> could be a bit surprising, since truncate return an error, but the
> file was actually apparently truncated (or partially truncated, in any
> case).
> 

It seems we can't guarantee that the file being truncated is always
preallocated. If the blocks were already in written state, then after
we update i_disksize to 0 but there are still blocks left unreleased,
fsck will still complain, Did I get this right?

Best Regards
Yi.

> We could change it to call ext4_error() which would signal the system
> administrator would get a clear signal that she should run fsck, but
> in terms of bugs, it's not as serious as if the file system was left
> actually corrupted.
> 
> Cheers,
> 
> 					- Ted
> 

