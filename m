Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BFF368D52
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 04:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791781107; cv=none; b=FJRLO7Zl2k1Yft2kFem6fBUHHuzKYVJ4HR01dBeWQcEZcFhgsa3x4sA5epsNMs278FuJt1A6hiXlFX7RRyb2QGhlU40WT6yxPx7f3AMYQg+T60/Se+ftbRexiFT0vvZsw+duvar8xd3bADw3+yLD1AuFkjNets06LLXA9lPUVCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791781107; c=relaxed/simple;
	bh=/88gb4xXx/ct8SYmwoUN77gPHy7bOsWujBs+78VQ+YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RXkk4A+gCImQDI6o+5X2xPL+Xfa68dG+sh+Sefcewo4JvfYyZNWbHvJzjvty6sZ36dnld4oCDbOH6+0GNT7nnSm3dALQ4S1UKO3Xjxw0Rh8i43tdEPzYd8Y089e1UnlVlGkQUu+rL08CGZFKxxg0o0fJ0RoYCv2W1JJqHD5srXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqD2Rtoe; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqD2Rtoe"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cd3310348d2so1491646a12.1
        for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2026 21:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791781105; x=1792385905; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NhfckbeXLIpMxAPyiq6IgFMQs1IKyfPcAZ69OLh1xDE=;
        b=KqD2RtoeYW4jMt6Gt9L6/8Y7Iuig4FYtAUxvBpr5WU4LcMBK8nOy9Vzlb0oGG3/Eri
         8qXV4e6fWDqTyZNcLNdIJF/RCFULRhi1SzEWTuHs+HvJ0rlQJt46ka7mFG7Sogo/AA+Y
         Q/IKU/5zVyuTJFIwqECRZkdrO2m0il+D2um1cV9z0LZOppmeOF6L4XclnwSkb4JkEAFK
         +2cgRKVlVknBsmMYsemUFeeebV8+BTdW2eQdvRjxBqixlslliMV6YuGkmIRfbVp3FLX2
         tNFWpvAmY4ITqfrhsfVXvErRilw64FC7sVlk+IG+Tm7sgtzJZyTbHPMy0Yn+h1/hbBgK
         qTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791781105; x=1792385905;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NhfckbeXLIpMxAPyiq6IgFMQs1IKyfPcAZ69OLh1xDE=;
        b=tSmJNubIhBbjGC0tWjwvXlwan0XPaiGEKAzogxDCKvshJzMBXD7oR1QULP8pI4TIrD
         7SqTV6A/kv9fCjjjlDEZdUhn0RzZqHujal7qQn+qnCLBGQSmjMrNRhgaTbn+CBDSSs9+
         yo36mRluBQ9bg/NvDkzqcf46WZPlM4ptGYi69DYvQPFG0c1FkYasfJrSFrZq77zPg8SH
         AMzYhRwoQOOy3nUvMKbvilw7rtgK/0VPVB14kJBkm8xQkeBypnZ1FJl7M7K6wZ2KWJ2I
         z+WIV3GSNox9aNDKDD/AW2bYw/50oIiV5IpsGdlhWICiDlr2N1nPwH/jry6UlPIeAeL9
         qufg==
X-Forwarded-Encrypted: i=1; AKwUvBxTtOEAuurQxtaymxRle6CHGJUSaYSCQ2C01vw3Eujsm4ry0Tn2/Sv5vLc8dJt+lMWXOztIlm8QcN29@vger.kernel.org
X-Gm-Message-State: AFq9FYKMNjzxGpDAjao1TvXnJtnP075//Wpor7OxqBHGei2UtBNgscLR
	Dpl5iLuXEfKp3o6fUe/j/7vaTFLxsNU0y5NjOKM20dkW+c2opXI4v07+
X-Gm-Gg: AYBFou2zUk9cD5Kv+Izv6C0LJcxj8X1sZTx8CuBU9QGpQ6sgvVDjOIrfi/f0MuFbxEV
	dvrGw9JU/OJ7j3ar9I5HhmOdIQhA+OQgqQUCAQpvJYYkqNmQ5TVxALuziItvFRcRgAQvpHfoRgH
	lKACaiKriqif2qqvS8e4rLf2uNyhp6EMp1geXGWqc59/zbOp+t+ht117RWcfBGIiFDJseuMcErN
	vxzaAEnvSmMSQ84cHkpvR1UpdZL0xmeyErXqCyMJAZXkxUGeG4FqRXs2Yt6AkhAFM+HT3PD294m
	hezbVKip7j4wC9yIG8/XMY+sYcSy3/jdsxsUN1nAAohWU40bhnjzmBgKGjz0fT4PBUVaRLClwqP
	ExWHXQh7xTG32JfYVUjff0CroB2ywtvk8KD8tKVCoXXyXAOLjRpt0HtkYF07FHMHonYw608MgP+
	KPhU34Z3e9BA9ldl+7Obt1/IEKbxYL6ehOZtcBUb9m0kVnJnyhRNjZGN4KMl7VD6LCVztOrOzoH
	jLSAakSVp9Oi2Doq2A=
X-Received: by 2002:a17:90a:d44d:b0:39b:5622:d645 with SMTP id 98e67ed59e1d1-3ab3a09d2e0mr5364614a91.0.1791781105353;
        Sun, 11 Oct 2026 21:58:25 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm14143895a91.16.2026.10.11.21.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 21:58:24 -0700 (PDT)
Message-ID: <df2b0776-00d9-4ac7-9d6d-316f86971c41@gmail.com>
Date: Mon, 12 Oct 2026 12:58:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [tytso-ext4:dev 21/41] fs/ext4/inode.c:4002:24: sparse: sparse:
 symbol 'ext4_iomap_buffered_read_ops' was not declared. Should it be static?
To: Theodore Tso <tytso@mit.edu>
Cc: kernel test robot <lkp@intel.com>, Zhang Yi <yi.zhang@huawei.com>,
 oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <202610082225.lcsAyIiF-lkp@intel.com>
 <5bac3071-5823-4714-8c39-662b91c927a3@gmail.com> <ask6HB-62-bUBb7u@mit.edu>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <ask6HB-62-bUBb7u@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/10/2026 3:03 AM, Theodore Tso wrote:
> On Fri, Oct 09, 2026 at 10:55:18AM -0500, Zhang Yi wrote:
>> Hi Ted, would it be okay to replace the current version with my v7 on
>> ext4 dev branch after I send it out?
> 
> Sure, no problem.  I took a quick look and it looks like there were
> one or two new Sashiko issues?  I'll give time for folks to take a
> look, and I'll rerun my tests on the v7 patch series, so I might not
> pull it in right away.
> 
> 						- Ted

Hi Ted,

I've gone through the Sashiko and syzbot reports one by one, and apart
from some pre-existing issues and false positives, no new regressions
were found. However, there are currently two nits in the code that need
adjustment:

  - The WARN_ON_ONCE() check in patch 8 is too heavy and is better
    removed, since it seems to expose some corner pre-existing issues in
    the buffer_head path and causes syzbot noise[1]. This syzbot report
    doesn't belong to the current series and may need to be addressed
    separately.

  - The tracepoint in patch 19 may print an uninitialized map->m_pblk
    during delalloc writes, so it needs to be initialized. I'd prefer to
    initialize it separately in ext4_da_map_blocks().

Since you've already started testing this series, and these two nits
aren't critical I think, I can send fix patches to address them
separately, or let me know if you'd prefer that I send a v8 instead.

[1] 
https://lore.kernel.org/linux-ext4/34423908-aceb-4c57-9502-7da10b12e4a4@huaweicloud.com/

Cheers,
Yi.
