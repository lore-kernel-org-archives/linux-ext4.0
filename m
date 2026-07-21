Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D136A03F
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2026 00:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784595267; cv=pass; b=mS/rXsda5myrkebe0iLIjqk90vjsvQAmV9o/l31wNtF0fvMbS/vle33dFsDulxxkbd36hrO5awzGBVBswXy6htHPrGQUt81EtvzIqlhBL8EtJw1hdKTsFYgGATwERbNIonFHkCsftmGZKs+euud2WK+2Avr8xrarB0BdAPCI/Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784595267; c=relaxed/simple;
	bh=MDkvc8BOnMUDPpW223Bn3VSqhVFBMVjv14WB+MqfG+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yw42/ZAV8AbeMo99xOy6Ycv8kHVvbKCgU+ealHgQaIBE5ZmjyaeRf9ixN0mOgOB/dVD4VATf+I9xMCO0IlzWhJqFFrcFOAPiQX8C/1uA6y5LBgFrss2oqYMnOmgNlzfG5fN4sesKwYgkp1lOnRzDVnvnmc3QnBUdzdTCYSdAreo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfCuvFe0; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfCuvFe0"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso10923903a91.2
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 17:54:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784595265; cv=none;
        d=google.com; s=arc-20260327;
        b=QT4nM5y/4aFJRLJUYpndxyx4WYfq0mogTgdI684A3Q5dn2bIrBHyi0WCIhq6I6eg80
         waM4m+yxYPmZwVs07uavly7h8T9YqABk0ooDFs51T3URuffimPO2k8SfzPOQKlQSzlHv
         w3+fuHnsLQfKu2rni0sMW3CpUnUbudRmUlxsgf7e0UsaRWlbCiJPfXh5dW+Pnn/lwxHZ
         cYTDUymbMjBKGGN6oyNuaeVveLDNSfpfnAndULnXhuhAS+xBIF89SFTKEAwytfhof9AX
         d1xtWreqvfpajDfBTWTh6ckaQWnfud5gQ8y6fB0SKl6oIh6wFG+WjKeU6Bn94MQQ7InY
         GM8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zQJ3rsl7/9TA95vAr0nNGzp9Xw+NYr3g8gQszj8kRVA=;
        fh=psoe+LJMpcHzwyQdDwDejm088n9HUTqo44i9gIJV2Is=;
        b=KGO1kCDwdv0MXt7TPUvn2lESH2V3oBOIIFcTx3oA5fG/nTHtYRKc3KaFnUYehQKbla
         NzBWgrkLK5g7OK8Z2UON2t6FOek+sRcwRbgcnO1/lvb2gVw+iD7edanKNMMUOUBJHpFG
         39Wwy8pHJ8TpD0pV5OdKVHfzIWn5DN/HfJdR0Et2cNJJ/A30CaxTfOUOdGzbAFmiajEJ
         nhqZM34BBiE5wtjfQl9mI+MnCIdVQT2wv1tNbwxQQCzPv+hLu4Y0H2PFqzcc5p8KtUQZ
         CfzOZCQ0YxJrGmtfbUn9eu2qxzZz0oFr9XNwyKppCdceaUD/U53RHoEEGCJ+xc9ovxRu
         B4PQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784595265; x=1785200065; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zQJ3rsl7/9TA95vAr0nNGzp9Xw+NYr3g8gQszj8kRVA=;
        b=bfCuvFe0Q/UThyjpt1LktKBT6R6n3RMZLgJ6Ijxr4g9vNo9nm2POQZmK+0zH46fyNt
         t8lHNrQTtUqOKhX+GiQBCH/N1BcjKtthKFrjJFfSZ0l6PbIay3P9SEa/yjtFiWq9suk1
         NOAFpuXRQXZpoTIhi/QRSCPwelLY8WQzWg6IYBTpI9Ec9dewtrYMWbDT7HYc9WjGiD2d
         0VOacuqeLpnCK84W7Y+oNsMOLH3q7YSZt5DD73lk2B52usIQ6Gq0/iupiJuQZYho7PZl
         qxPrJiICB8jaZU3g6jNHUnSkhHh0dT81IWqP1bbyI+la6pSPtsoP2S5x1844sjNe7m1X
         EhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784595265; x=1785200065;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zQJ3rsl7/9TA95vAr0nNGzp9Xw+NYr3g8gQszj8kRVA=;
        b=NRQSIzphK6mnBSC81da5wUYP6pudQPBHK3QBjUjIsM3mc765OQ7IWRYbUBtcJuru1G
         Fr8c84mcSRTaJngzextOhzSPCRAqwbYb18Lupy+lYKFpCVt3oBqvazBd0PiWuNWpyRxF
         t6BocNHZ8TuVHBcToWcqyzcv4WL+owiGFf7RdWDkwF0boJMBtsNJ+/+G3m1MNBVXgOAE
         KpJ1f5HyOl+/cz2ND9c8FY/cBEY6z5nLkRqD6GBns1eCwd4ktfnC/gxdY1QzpRdPNQGn
         wXK5H2Y+/GrEE9j4BcOiryy8RvS8oigbDrup8UFU1t58m3vgiInnGXa22bFJ6CPTNBkd
         cXBQ==
X-Forwarded-Encrypted: i=1; AHgh+RqD1NXiOESyoji/mR/IJq39fy1n55kp0xnssLfne45ulNPT0rLI2FmXL0y/dzyb2obO3vcBsNtH4p49@vger.kernel.org
X-Gm-Message-State: AOJu0YwUESUL/2fkXwbuQpz70QjctbHqGEyMSdgWSfifpOtR3BA1ew2x
	IlONqhlQS2tpecxHjrEIIrzy6LlrEdTZzLJxMvChBnWZLrYQPeQ4aHHwvr8/YgEFEXwGSN8lTgU
	Y9SmKlemcyeBt6/L6TokLAGIWPXhOeTI=
X-Gm-Gg: AfdE7ckRVgvJz3+AY5OsyFiRcnER1eFGMzcwhrddSS9cWXd1Ose4oeJ7Zw2TV8RCRGE
	4MuqC2PySCs10gUJz3FyuITnWSa89SVqfFkSKCZxuGN3mtBaj73IOmTNX8G/ImCFJm2p0/dE9JU
	myu0lIdhl0TIm7mBOtg5aZzG473sNo9thuIFB7bmGv2EFNz+2fta7fsI73dqNmlJyqGYC3V2e2E
	KECosAYW5VQ6qotFsZpyIaXy0Kvm0sSwO5eDBTsUZUa8K/+BGBzbjQZMhVAkHpKKwQ6ayVLl/Y0
	gCjSKR6EkD3IhLrdJJwwD8oxXL0d4Q==
X-Received: by 2002:a05:6a21:618e:b0:3c3:6f6c:aa21 with SMTP id
 adf61e73a8af0-3c3ad79241fmr15752265637.11.1784595265233; Mon, 20 Jul 2026
 17:54:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720065505.4019225-1-rafad900@gmail.com> <2AAF0DFB-2FD5-405B-8965-1C88AF6E2B98@dilger.ca>
In-Reply-To: <2AAF0DFB-2FD5-405B-8965-1C88AF6E2B98@dilger.ca>
From: =?UTF-8?Q?Rafael_Alejandro_D=C3=ADaz_Cruz?= <rafad900@gmail.com>
Date: Mon, 20 Jul 2026 17:54:13 -0700
X-Gm-Features: AUfX_myUZToK8Edz2Ktii5vwe2ip9ZlGHHK0b4nRbeKYVeU6OfszypANV-qffZQ
Message-ID: <CALp66yGW4cp1RjtSH4f3=KJpHJSW21PHifS9wn9+mL-HKoFjVw@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: fix race in ext4_mb_check_group_pa
To: Andreas Dilger <adilger@dilger.ca>
Cc: tytso@mit.edu, libaokun@linux.alibaba.com, jack@suse.cz, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I think I misinterpreted what was going on after the change in the first patch.
When making the change from atomic_t to refcount_t, I get this kernel
error while
testing on my x86 QEMU:
 ------------[ cut here ]------------
[   12.954674] refcount_t: addition on 0; use-after-free.
[   12.956476] WARNING: lib/refcount.c:25 at
refcount_warn_saturate+0x6a/0x90, CPU#0: dhcpcd-run-hook/229
[   12.959648] Modules linked in:
[   12.960735] CPU: 0 UID: 0 PID: 229 Comm: dhcpcd-run-hook Not
tainted 7.2.0-rc4-00001-g453fc8a20cd2-dirty #6 PREEMPT(lazy)
[   12.964446] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX,
arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.968371] RIP: 0010:refcount_warn_saturate+0x6a/0x90
[   12.969892] Code: 00 48 8d 3d b8 92 71 01 67 48 0f b9 3a e9 2e cd
ad 00 48 8d 3d b7 92 71 01 67 48 0f b9 3a e9 1d cd ad 00 48 8d 3d b6
92 71 01 <67> 48 0f b9 3a e9 0c cd ad 00 48 8d 3d b5 92 71 01 67 48 0f
b9 3a
[   12.975114] RSP: 0018:ffffb4c9c03a7838 EFLAGS: 00010246
[   12.976742] RAX: 0000000000000001 RBX: ffff8c96fdc32688 RCX: 0000000000000000
[   12.979085] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffffff8b703940
[   12.981349] RBP: ffff8c96848a1738 R08: 000000000000000c R09: 0000000000000200
[   12.983382] R10: ffff8c96848a1738 R11: 000000000000001f R12: ffff8c96848a3a10
[   12.985415] R13: 0000000000000000 R14: 0000000000000008 R15: ffff8c96848a3a48
[   12.987455] FS:  00007f2995026780(0000) GS:ffff8c9771c6f000(0000)
knlGS:0000000000000000
[   12.989751] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.991296] CR2: 00005593d8eb6640 CR3: 0000000001919000 CR4: 0000000000350ef0
[   12.992879] Call Trace:
[   12.993483]  <TASK>
[   12.993982]  ext4_mb_use_preallocated.constprop.0+0x346/0x3d0
[   12.995293]  ext4_mb_new_blocks+0x15b/0xe80
[   12.996246]  ? srso_return_thunk+0x5/0x5f
[   12.997178]  ? ext4_find_extent+0xc8/0x320
[   12.998117]  ext4_ext_map_blocks+0x3f1/0x17e0
[   12.999121]  ? srso_return_thunk+0x5/0x5f
[   13.000067]  ? mpage_prepare_extent_to_map+0x47d/0x4c0
[   13.001224]  ext4_map_create_blocks+0x40/0x170
[   13.002239]  ext4_map_blocks+0x193/0x3c0
[   13.003142]  ext4_do_writepages+0x7e7/0xf20
[   13.004109]  ? ext4_writepages+0xbb/0x180
[   13.004694]  ext4_writepages+0xbb/0x180
[   13.005275]  do_writepages+0xb6/0x150
[   13.005826]  filemap_writeback+0xa1/0xc0
[   13.006435]  ext4_release_file+0x6c/0xa0
[   13.007041]  __fput+0xe1/0x2b0
[   13.007503]  task_work_run+0x57/0x80
[   13.008046]  exit_to_user_mode_loop+0x139/0x4e0
[   13.008705]  ? srso_return_thunk+0x5/0x5f
[   13.009319]  do_syscall_64+0x42c/0x540
[   13.009878]  ? srso_return_thunk+0x5/0x5f
[   13.010477]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.011235] RIP: 0033:0x7f2995128887
[   13.011765] Code: 73 01 c3 48 8b 0d 89 55 0e 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 21 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 59 55 0e 00 f7 d8 64 89
02 b8
[   13.014433] RSP: 002b:00007ffe0ef0ac48 EFLAGS: 00000246 ORIG_RAX:
0000000000000021
[   13.015542] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 00007f2995128887
[   13.016591] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000000000000c
[   13.017635] RBP: 00005593d8ebbef0 R08: 0000000000000000 R09: 0000000000000000
[   13.018685] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   13.019737] R13: 0000000000000001 R14: 0000000000000000 R15: 00005593d8ebced0
[   13.020798]  </TASK>
[   13.021158] ---[ end trace 0000000000000000 ]---
After reading the code a little closer, I realized that pa_count is
intentionally decremented to 0.
This of course would trigger the warning above when using refcount_t
since it treats 0 as
"object is completely dead". I assumed it was because a lock was not
held and so I added the
locks around the atomic_inc(&cpa->pa_count);

The reference count is being dropped to 0 on purpose right?

-Rafael
