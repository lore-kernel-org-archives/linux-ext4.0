Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD53438BB
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781821485; cv=none; b=htS2pervJFObL1n1UAoKdTKIOU8TDcQa4PuxCQMWmGWakreBzjb6jur9QVeeMJuhYcRP9l3hatDoQTAAWNTIa3XoebX0iJiXZpUOFhq/D2XwdKahIuTDXP4slMASx6Ii3KXf/vtJKgElJiEFHB2+EfI4hfJRjM/ZRjEv9xaa5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781821485; c=relaxed/simple;
	bh=Dao5BSVe84DNgyxS7+ZtTDfWaW0v3fslvTy6SgVQsGo=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=RujDQbnamJN49uEmAH6v22NyTJT7IuTiflF7yaN8fuwC8EyvDCqUQzQNtycTOHpH6Ur/dcX7DTiA8NVskjVv4tyi0fFO3aGaYlfLTLg7PgCroleNjCHpSK9ol21OEup0LtZgPZDTRsdmNYrVdJuVI0xiACLkp9XWQ6CiWIm18bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nR0FbjEY; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nR0FbjEY"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-6ccaab9dc9fso47961137.0
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 15:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781821483; x=1782426283; darn=vger.kernel.org;
        h=from:mime-version:content-transfer-encoding:cc:to:subject:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K7HC/kZs2bun4A0D9tlpgUJBxIZf2KfxLiH+uO/w2g4=;
        b=nR0FbjEYr8NzZt+owHsxntnIwjjQ1wMMoXSTmygwzfohDXOx+Z/yr4pZcf5UGOcezk
         1q03BlQsmcKQOEzixLQHljH40nSxxQ39whV5WdshuZji3lClIuFYk87A8ugP7BEUxK1o
         7EH9DiUeRYon6iI1c/ujQsLxR/BGrBBO0UZ9SEd8svp65toT38NKZwJchTmKSH4cfOBo
         dQb5F97PTbqX7/EybIZdY6lV4xsvG6EW+WO6NK3w0OW7S995pMKydkdm2ZrxxhS9Q9G0
         eig+UwE5qRToKj2ZTvuHhY4Byu657PVIC1QNAFM40HKjKvJNCFXZWS5HzHPCmt/obrFV
         F3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781821483; x=1782426283;
        h=from:mime-version:content-transfer-encoding:cc:to:subject:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7HC/kZs2bun4A0D9tlpgUJBxIZf2KfxLiH+uO/w2g4=;
        b=kRXC86nEVF/di7F9vn4+hvfzdszSmd1Xy9J57bwiCzM/Py3BtndqS427eONDAkq59M
         E0U2Re4YOu1iDqhQUf+gd52Qxg7omIx2/G5912hKnPUfLakkl046+1CMZJdEfd0L7wg+
         Nx+cg/DxdeAaNXhnZPKyMgYcOcKAFsAbqohSKJ6KkAp8SKRj5JhdVwZhscMAGuqXhjTt
         FhUhZDvcgOnDVCYWfFLHPNiLPY5M58oPWhyNzTAIgnxCbGoxoyXe7HKZlPu01YJkmRMX
         1nemTQ1e9IPdseR/plVZqmKdxkZevKs+LWl3gbCNvJgaOLatOhfbR7hCZpE0mQ1GHzG0
         TvnQ==
X-Forwarded-Encrypted: i=1; AFNElJ9iH/X2qQmiV/jt7uh3VcKdpafH7ko/olGffn6aAgKv/lCU66+6FThAZo3GENrk4srtkrxs4+zJPIyY@vger.kernel.org
X-Gm-Message-State: AOJu0YxhmHo8DwHX+DYypOTpHHfgXBaaneXv2dUPuPjjSKtYhY7CbcqB
	hUNEsD7bVfnFzZXQ7XadqWnV4mlHqPr4x4rjm32w0YSEn47zx9xse2WBnflrEgyG
X-Gm-Gg: AfdE7ckW1hLchbviA4Lu3/0e3RsmSMimioMh+2Xf8nH6X2lj2b5Vkwv/LxomjP/Y084
	qzAWL7gwEBjN7kGtKzV26WMX4imDSWsZ3AhKh8SAEbRiF0q3lmiAMgeGbphsBEAfsJbjQuVOQha
	EQgw9eaRf+2fc6WvRHoU6dq8VUiSV2keFE18MMC3Wvuv6W00AukcZNRb6f5A36ZWR11rqytDPWQ
	SKeJ65n0zNCP0mdm4TicmpuS9mQvoeA1L/nyqyeW4rYSuLYhKvBYhpf7hCXofk5FmzRcgCL/LJH
	8LbDJg3ohssmMa/rRMn5BQ/znMWtMRrG5r+dolilrlaNEpkH/JGJATpNCXj0VKNN2W2JjfYtccr
	y78/3LcrO93pOKCzfznzu+6gKlFpJw5J9bziWAqOGzOLN4lyLoEFBPHeHqFwbT4+8t0LtfXFS8s
	am8v/MvAiBIBneSsxVvBem9U6qxJnpLiIaERCVQH8v2IqpY7JBXGxYrAAcLG+RtvFU86fdbM1nw
	4qIGPja3co9
X-Received: by 2002:a05:6102:3e8a:b0:634:11ac:12ca with SMTP id ada2fe7eead31-72a042b49eemr500513137.5.1781821482680;
        Thu, 18 Jun 2026 15:24:42 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-72a366e038csm441372137.8.2026.06.18.15.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 15:24:40 -0700 (PDT)
Message-ID: <6a347028.d133b7cb.2a669a.5815@mx.google.com>
Date: Thu, 18 Jun 2026 15:24:40 -0700 (PDT)
Subject: WARNING: at ext4_check_map_extents_env, CPU: syz.NUM.NUM/NUM
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
Reproducer: <https://drive.google.com/open?id=1_mGsSS7wCRfk8qXdMEw08C6S49PejwXr>
Thank you!

Best regards,
Sanan Hasanov

EXT4-fs (loop0): stripe (65535) is not aligned with cluster size (16), stripe is disabled
[EXT4 FS bs=1024, gc=1, bpg=131072, ipg=32, mo=a840e11d, mo2=0002]
------------[ cut here ]------------
WARNING: at ext4_check_map_extents_env+0x471/0x510 fs/ext4/inode.c:436, CPU#0: syz.0.1217/21399
Modules linked in:
CPU: 0 UID: 0 PID: 21399 Comm: syz.0.1217 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ext4_check_map_extents_env+0x471/0x510 fs/ext4/inode.c:436
Code: ff e9 89 fc ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 05 fd ff ff 4c 89 e7 e8 da d6 ae ff e9 f8 fc ff ff e8 60 a7 42 ff 90 <0f> 0b 90 e9 8a fc ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 25
RSP: 0018:ffffc90002ce76c8 EFLAGS: 00010287
RAX: ffffffff827faa70 RBX: 0000000000000000 RCX: 0000000000080000
RDX: ffffc900019f5000 RSI: 00000000000030b1 RDI: 00000000000030b2
RBP: 0000000000000000 R08: ffff888017201637 R09: 1ffff11002e402c6
R10: dffffc0000000000 R11: ffffed1002e402c7 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fbe746086c0(0000) GS:ffff8880d98df000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe495821940 CR3: 00000000683d9000 CR4: 00000000000006f0
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
RIP: 0033:0x7fbe737a559e
Code: 0f 1f 40 00 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbe74607e28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fbe74607ec0 RCX: 00007fbe737a559e
RDX: 0000200000000080 RSI: 0000200000000040 RDI: 00007fbe74607e80
RBP: 0000200000000080 R08: 00007fbe74607ec0 R09: 0000000000000011
R10: 0000000000000011 R11: 0000000000000246 R12: 0000200000000040
R13: 00007fbe74607e80 R14: 000000000000060c R15: 0000200000000180
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
