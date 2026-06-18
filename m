Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A333DEC2
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781821579; cv=none; b=S1Oizd1VguWlDA5C8sT1Ii3cszJi4zMogWzSve3S1mEK0X+u/BbavySz9+wFLn9dUUXUV+vaSmnFvsSw+l55SfNuUG/pcpl7vbdDzPSxGY5zUMXYLItpkXP4oy4+vCxx5i1MW+SSs+x9wNAoZlRuNSjwevBgRJ4449bTyAzuJxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781821579; c=relaxed/simple;
	bh=anIZVAxmOEqxKs3uKJnxCpEVkZ24UBgRCvIup3QmymE=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=NK/kghBrjzsZRtw9QtAxh5qnzM88dyv5b/Jpt4A1gWFbZW4pHgUHadZJFbVglGRkGFkgB5KMrTQM+F8zatxHvSfwUM8xT4CewmHsL+KL4NcdXr+mkkjPwDzEw/gciwOa4hQcz6YNkwtxAa6xsh0WH6anfgDGNCFrHSiU5WTLRLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTvOO6nQ; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTvOO6nQ"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-6cfe240fb75so36511137.2
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 15:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781821577; x=1782426377; darn=vger.kernel.org;
        h=from:mime-version:content-transfer-encoding:cc:to:subject:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5vFMNuS4kC5ZG980cm72kLIUg1BCDRbXAjxMwbJscc8=;
        b=OTvOO6nQr3tAZQXFeHEa36F81ki7wEoS5K7JOPxHyzNMw2FybWbVunGMjf/3Kyk6la
         J0b/vtHtsciXNY/pEofndWvpxfGvhVXa9z7nQiS6joPfevQp3OvZCHELqC3P56K/LYKN
         A/CsT5m/s/6avBzLxdCzeig0N28EEunOUYB/4fbbehLqBOiqQrRMk0U2iIbC2v8YfPe3
         sg6izRh3T4tbYCpxtsSxkYiEe8HJMozAglAS2SoaoF/O4VdITxJlsoeXGer6OaqrmThO
         PSs+sNTZRUNu2v+vlGycte6ubvLajCeRUUWSRLPLh6A+4DayjE8LOmHlP7XwGWNFy82l
         sjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781821577; x=1782426377;
        h=from:mime-version:content-transfer-encoding:cc:to:subject:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vFMNuS4kC5ZG980cm72kLIUg1BCDRbXAjxMwbJscc8=;
        b=NQPgzr2sauUelJRp0Xb/pvuSb1AYxxvmdwXAhS1eoH23dpLm1IlNNUZPv7WgMa8/x2
         uK2dhhEvLkQUdRMINxM9TC31LZih5Bvz0784Tadja18Y5QveEnxqSTyScakAR4zvANd2
         REazwSSrdO7SggHBJaMO/xba/7Vz+ROu7aIafQqjPFLUHl+Sf4xwBtT7l4swOfyzpaGf
         rmli3w/oJ0FSmo+rUFczgm89U9vpjv3vpE2Ui8dkeaiEbJa7iPcvwKyqg+BYNbpFSU2D
         5vD14qxmtvU9I1GL5F/n/baPI9KhSQgXRxvkXJcrWe9vZ6O7DZd25zCkhUxncG7QI+Rw
         1bkQ==
X-Forwarded-Encrypted: i=1; AFNElJ8lblurGhYCcN3cVN8nYXriCmUIJecpd6htYk2jaHIcur8iyNxUmRezvlDaWrEAVLScAeE2Ke1NH0vK@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9JMAS3ybCq8Da1esatksTAUMgAtfPnHQYbJIImQ1xbDn92vFS
	cystN1IaScOwQ0mkdTFtLMBCC8Lud6FXjYUK6f1xbreh7qNS19PDqLrt
X-Gm-Gg: AfdE7cm79jWKz20jg3avaXrKqdNvHpMnjveg2REWUfpPN35/NSPfDlK2QQlJUI0E237
	ndBs9P2pjuQzY3nnBpImUqXMemN2iZQscLiJcj3i8jN5Pba02Yk9SUVEF/4uweMSBM+0AVbaLoN
	jKLImSHHihU/aNdfoijEXPAqIh445Eo5q8NqBr8mltbUG3RmWFibpf3LeccK9YHiPXQW6/emry0
	5LfcLUMPguxwfYoBsfQ3FQ2samZaOgZQhxPxXjS6PG1bmbyD0LSswKMq2s6v1SH8skoAisciA7w
	eJfEpa1FFcPxtxkKzYUv9Z+Qr9chb5LbQ5fl3iUqAgho/D1iR08rdKktpwuaiHY2wz4RiZKp5h1
	VJGOl7CHkf3aJVMcs5QGudjQq8rVWrljP+pB3FC+b/fJAJMHGwc9TaQkeuHB6i2qMSM4De0SaG7
	T2p/+/9iWoYc+0G6ZhOvour86uXWxjLINNVZ7ShHuDhdXEgdPSzLWbiS16FITEoWwkxSggOU6k+
	tQD2P44OHcM
X-Received: by 2002:a05:6102:5093:b0:6d1:8f7:18a5 with SMTP id ada2fe7eead31-72a01125388mr439930137.1.1781821576617;
        Thu, 18 Jun 2026 15:26:16 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm673961241.5.2026.06.18.15.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 15:26:15 -0700 (PDT)
Message-ID: <6a347087.0732f964.365b7.af98@mx.google.com>
Date: Thu, 18 Jun 2026 15:26:15 -0700 (PDT)
Subject: WARNING: at ext4_check_map_extents_env, CPU: syz.NUM.NUM/ADDR
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: sanan.hasanou@gmail.com

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=173DLEAEPKPhhR1TcqofdnkLpdoK7PMFl>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

EXT4-fs (loop7): stripe (65535) is not aligned with cluster size (16), stripe is disabled
[EXT4 FS bs=1024, gc=1, bpg=131072, ipg=32, mo=a840e11d, mo2=0002]
------------[ cut here ]------------
WARNING: at ext4_check_map_extents_env+0x471/0x510 fs/ext4/inode.c:436, CPU#1: syz.7.16867/107084
Modules linked in:
CPU: 1 UID: 0 PID: 107084 Comm: syz.7.16867 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ext4_check_map_extents_env+0x471/0x510 fs/ext4/inode.c:436
Code: ff e9 89 fc ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 05 fd ff ff 4c 89 e7 e8 da d6 ae ff e9 f8 fc ff ff e8 60 a7 42 ff 90 <0f> 0b 90 e9 8a fc ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 25
RSP: 0018:ffffc900015376c8 EFLAGS: 00010283
RAX: ffffffff827faa70 RBX: 0000000000000000 RCX: 0000000000080000
RDX: ffffc900150f1000 RSI: 00000000000052eb RDI: 00000000000052ec
RBP: 0000000000000000 R08: ffff888034a03be7 R09: 1ffff1100694077c
R10: dffffc0000000000 R11: ffffed100694077d R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f2dfb24b6c0(0000) GS:ffff8880d99df000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2dfa45fb85 CR3: 0000000038fd7000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ext4_map_blocks+0x1e9/0x1540 fs/ext4/inode.c:721
 ext4_protect_reserved_inode fs/ext4/block_validity.c:168 [inline]
 ext4_setup_system_zone+0x872/0xa90 fs/ext4/block_validity.c:251
 __ext4_fill_super fs/ext4/super.c:5594 [inline]
 ext4_fill_super+0x534c/0x6390 fs/ext4/super.c:5791
 get_tree_bdev_flags+0x3fe/0x4c0 fs/super.c:1694
 vfs_get_tree+0x8e/0x290 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3760 [inline]
 do_new_mount+0x31f/0xd40 fs/namespace.c:3836
 do_mount fs/namespace.c:4159 [inline]
 __do_sys_mount fs/namespace.c:4348 [inline]
 __se_sys_mount+0x3a1/0x4b0 fs/namespace.c:4325
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x19a/0x7b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f2dfa3a559e
Code: 0f 1f 40 00 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2dfb24ae28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f2dfb24aec0 RCX: 00007f2dfa3a559e
RDX: 0000200000000080 RSI: 0000200000000040 RDI: 00007f2dfb24ae80
RBP: 0000200000000080 R08: 00007f2dfb24aec0 R09: 0000000000000011
R10: 0000000000000011 R11: 0000000000000246 R12: 0000200000000040
R13: 00007f2dfb24ae80 R14: 000000000000060c R15: 0000200000000180
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
