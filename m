Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912452561A2
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774280522; cv=none; b=O5VG5COk2ZrrLVXpmZvaDbVERvnr5HPjq+QZ2bpn5jH4NvcqAVN46B5BDxhAjWOM8spSc3p3J8wAho1mFQ/FA2f0Jqj3qsDXhB6yqFDGXTPCH23IYTphujHgLJDdbINjcjEyOeG9pY7G+xEY45a6ng38N4IkoT6d2JzrxSgkKLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774280522; c=relaxed/simple;
	bh=G0iEyskgYFiJJiPSQ4A29LWYf606VVmNVt75ke+W7JI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:Cc:
	 In-Reply-To:Content-Type; b=oM3kzVGkCFGA45GhAcV3oE43yTYBeZUlHJSOj16MeXmnWa5webdATILEkTalOuHrSmalsnlV5kGr+uZDEx3MiglPVDbHGMGDL1T5c0RkRJ/3e42Fpn21tCt4D7YrHdpnZtI0deWLmgFAsmSNgtjzjHzcNvzNKYHBaH9pjIKbP/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOAIrZas; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOAIrZas"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ad4d639db3so12829835ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 08:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774280520; x=1774885320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YoImiZTZK9N2ji1T/Hu9es0UV7jPW/Nj0ifX24VqaCA=;
        b=YOAIrZasw2dFF8BiVnyWzRBiSEoUZpkroWlo/4nmXBLN40yHMA9vGZTYnwuiv5rSlO
         qQR1XxRu1dJdPm/JbDZR3aKpttrlXqNn1rnu8kUJFMlloEL+vQOHDazeKSKo1+l+PsqG
         4X2akiIy9wC1hx8W6e7cFtEXPlswCfq6mgFZcfC/qlXLrc1R5t0QiJi5t5xas/4ol9K2
         G85SMbG786gCmpTSVpB54BU9dH3gypEWC4lMZdtXSZ6kp9KV4dITyFFTa8mmcRWCctl3
         MyJO9ivMNmEVvneOZ9Ijyn9eZDkYg5Zn2kaCEW2+fI0KTtp6zklv7F6yoIHm3CxMEN4m
         Sauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774280520; x=1774885320;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoImiZTZK9N2ji1T/Hu9es0UV7jPW/Nj0ifX24VqaCA=;
        b=BFMJv/GhqG/km3jOlIpWIwA1TMKjhR4RRW7jl9rxqmlBaS6f1wACD/Xhwhm0AX8Uv8
         eA78g8kR+Arp+imLcMy1c4q3TxelPDd81dAzzLB+1gKsbAGRUHMgL3D+tL3PeHp9WssW
         bO9gWImYGSQW3HE2AgGlggNR2hj4zQSYKhkuM9zdmxD3RwHagHAgS0X8lChNfB/W/oh6
         tgoyAh9HwxsDpdqoRE5G9tg63dlqMVi38ZrHDTz/KUs3uGr6OOom1apD+0crkMhes3kS
         igDXqhazHknt6fiP7BMiRakHu8+8qyc9zICvq+Fs/bTUMdGnK+B1I2KO++U+vEAO0qpG
         RnGw==
X-Gm-Message-State: AOJu0Yy/7yrVINOOM1GbYTR1oIvCsHCyHGrKYk+TTkOc7zGNBdJEA1wT
	CSaPefFMVA+f/rtTFmXJjZh6VBwbD6mNsb5iboxahSKSDm4L4HdlAmSH
X-Gm-Gg: ATEYQzye2RjKFYJGh+/htTd5iUr5CwwB36rbXfXpupmjYE/XCP/FRWnc0uDzCub2Mlv
	6YQeI9VsCOLU5wHBgN13VHgf11IVFXLUgN8TGjI7QGcclf2arYOe5l2Lr7U5DtUc2Q5g4cN9KNS
	PJjiDsmch0V1YNzazVRzOYUCi79mEb8KO9aC18vXmf0bUHKZvHbO3QpZhAXCYB0sSNfmgMZMH9D
	Twd8MC2kX7KNyU93Oh58q8X1UGEb76DFsc/XNKQTv66VAXe8W+PpZm5xgiArGHKCLc/+hKz2zPj
	s7tytWEeuHMPkNVPy/iUwqQjox/vwO+vDV/kLvAUPGlFLiD7birV9sY5uTAWUesUGnu/uiSl3lX
	vs0CtWYHqjEi9VBxB3oXt66OEzGGkGugaaJNEzrjh9VdvOQDj70Bv/QUsRaV3zYyilSdRXiYqaJ
	N6uPph8eEhJy+O7lNvRbLBDp4m80k=
X-Received: by 2002:a17:902:ccd2:b0:2b0:5682:6973 with SMTP id d9443c01a7336-2b08273d0d4mr113011925ad.19.1774280519745;
        Mon, 23 Mar 2026 08:41:59 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08354bcf0sm119018765ad.33.2026.03.23.08.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 08:41:59 -0700 (PDT)
Message-ID: <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
Date: Mon, 23 Mar 2026 23:41:55 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Jain <anajain.sg@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
Content-Language: en-US
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Anand Jain <asj@kernel.org>
In-Reply-To: <20260323041624.GA11453@mac.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Thanks for the feedback. I'll try to address the points raised
here and in your earlier email [1].

  [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/

This work originally came out of a Btrfs issue where a cloned
filesystem ended up using a dynamically generated, mount-time
UUID for sb->s_uuid instead of the on-disk UUID. As a result,
OverlayFS (with index enabled) started failing mount-recycle
tests [2] for the cloned filesystem.


 [2]
https://lore.kernel.org/lkml/20251014015707.129013-1-andrealmeid@igalia.com/

While looking into that problem, I also noticed that different
filesystems derive f_fsid in inconsistent ways, and in practice
many of them base it on dev_t.

On the question of the 64-bit limit: although a 64-bit value
is not globally unique in the way a 128-bit UUID is, f_fsid
has historically been derived from dev_t. Since dev_t must be
unique within a running kernel instance, 64 bits are enough to
safely encode its effective ~32-bit dev_t without collisions.
The number of concurrently addressable block devices is also
bounded by the 12-bit major / 20-bit minor limits and
/proc/sys/fs/mount-max. IMO, within a single boot, 64 bits
should provide a collision-free identifier.

I've also submitted new test cases that validate expectations
around both sb->s_uuid and statfs::f_fsid here [3].

  [3] https://lore.kernel.org/fstests/cover.1774090817.git.asj@kernel.org/

> As I observed in [1] this leads to collisions when for removable block
> devices which can be used to mount different file systems.
>
> [1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/

I agree. A straightforward f_fsid = f(dev_t) will collide if a
removable device is swapped but ends up reusing the same dev_t.
Theoretically, I see this can be reproduced with XFS, and with
my current patchset on Ext4. That’s clearly a blocker, and I plan
to revise, btw Btrfs does well for this test scenario.

> And even as you've proposed to change
> things, it's not consistent across file systems.  In particular, your
> proposed solution mixes s_uuid into btrfs-patched, but not
> ext4-patched.  Why?

The discrepancy exists because Btrfs must distinguish subvolume
mounts as separate logical entities. For Btrfs, the derivation
requires f(s_uuid, root_id, dev_t) to ensure that two different
subvolumes on the same device report distinct f_fsid values.
For Ext4, a simpler f(s_uuid, dev_t) should suffice to ensure
both cross-device uniqueness and persistent across media swaps.


>> Place this change behind the new mount option "-o nouuid" for ABI
>> compatibility.
> 
> I *really* hate this mount option.  It's not at all obvious what it
> means for a system administrator who hasn't had the context of reading
> the e-mail discussion on this subject.
> 
> As I stated in [1], I think the f_fsid is a terrible interface that
> was promulgated by history, and future usage should be strongly
> discouraged, and the wise programmer won't use it because it has
> significant compatibility issues.
> 
> As such, my personal preference is that we not try to condition it on
> a mount option, which in all likelihood almost no one will use, and
> instead just change it so that we hash the file system's UUID and
> block device number together and use that for ext4's f_fsid.

The decision to gate this behind a mount option followed feedback
from Christoph Hellwig. The concern is binary compatibility:
applications that manually derive an ID based on existing behavior
might break if the kernel changes its derivation logic.

I agree that -o nouuid is a poor name. If we must keep the mount
option  for ABI stability, I am open to better nomenclature.

If we agree that f_fsid is already a problematic interface and
should simply be fixed without any special options for example by
always hashing the filesystem UUID together with the block device
number for Ext4, that would be my preference.

Thanks, Anand



