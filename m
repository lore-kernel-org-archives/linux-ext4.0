Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F4A2E54B6
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 01:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788919088; cv=none; b=OBM0ESfuYS3orULbZiQjZQBSjwrHUswZktv5sCmSH83ku3+q3VcFsLFopoXprOw8ENbS5lSqHcwYEHmWfGnxlZD3a3SCZBYSlKKwpXgOHViFjqQV1IasCrk+QIF1IG9ahwlUl+OR0Via7hNU2j6RBu8J3AEl/P37L3ASRLqWvl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788919088; c=relaxed/simple;
	bh=sSaOC3RMQpEAoi/tUtWl5k6u3vd21pOoB62DXkEtCwU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tDWbRE+pg2hmLZwK6ZcoKG6VWiDI+HGCNst3FnLlGI+6BDq2VaUIqojfAwPb2iEEFEuWmjrPYO3vXs3ADPBSeyKrEcyRQCoarxLl6OgYDLWJ/bF+hpj1hthrUBDdZCOquDde88IwWFrw990e/ch8te5AypYt3kJtMFVQSfVen80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b1a3f01d2aso6893513eaf.1
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2026 18:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788919085; x=1789523885;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FTxv5B5+0rtjKxwaRNbRnXbFZjpXsC6bsbxidR6GHDQ=;
        b=i90NqUCVBm5l/LmIPLqux/vfH+fpFpgxt+MTvpKk270UcuRc89Rt+58Or1T/H3X6VS
         eBp/gNDjNNcxH5wxcJJtbUvh26PvYvzPjBgo4ZxgVzQc8ddQ+ufRVPe6Yxw8zLiY5rUq
         o5FYu4GDXvtEWYBV4R7S+AnSDIVQsh4Bs/lLX4aRG88Vhya35hsbdTLSQlmO0RJ9Hxzc
         3d7DXTcHAUYfNbMsazO/yJeZoME16ML1HGT3qdcWvjYr0JLLO8+dKmQgHGM4UW1JO5aP
         XuJKzealmoVkXvZjzJ8wnlfnE4lMk7vm6Vq1VxsZ6dWog6UYI1R250HkfN6DQp1rabF+
         U9GQ==
X-Forwarded-Encrypted: i=1; AKwUvBwfpyi2Tb9xgkxcQYkQa6z5c8jXJBELy3FxghxEY+5YcY2tSC6FoOnxFpMi/S5kZ4CLq3xXWSvU0tey@vger.kernel.org
X-Gm-Message-State: AFuF++lUQ1ojnBDdacDIup9HAGDThlcJaZoxXh8bVPyr99NGDy5d6qyY
	6Rqr+XzkM0q8jCtzF2fHeiW/CsrhMZOgQWLsYQXDBQEAm7nwbtnsaPWZ7E5CV6Kl2/ZKCKjyiGe
	8k1XQCD5fgX/Ch7nCC7n8v6SLUjEKIDBTqD8TjE8YmYY7GaPDcbPYBo2KfpY=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1890:b0:6b1:c40d:635c with SMTP id
 006d021491bc7-6b6fb8d5a72mr19913124eaf.15.1788919084967; Tue, 08 Sep 2026
 18:58:04 -0700 (PDT)
Date: Tue, 08 Sep 2026 18:58:04 -0700
In-Reply-To: <b191cba9-d863-4bfc-8729-be60cf66f1d7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa0bd2c.6e6c5f9e.28f11f.001d.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
From: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

TD (C) 2007 Red Hat, Inc.
[    9.051564][    T1] QNX4 filesystem 0.2.3 registered.
[    9.065214][    T1] qnx6: QNX6 filesystem 1.0.0 registered.
[    9.075912][    T1] fuse: init (API version 7.45)
[    9.091183][    T1] orangefs_debugfs_init: called with debug mask: :none=
: :0:
[    9.106914][    T1] orangefs_init: module version upstream loaded
[    9.113002][    T1] JFS: nTxBlock =3D 6145, nTxLock =3D 49167
[    9.142915][    T1] SGI XFS with ACLs, security attributes, realtime, sc=
rub, repair, quota, no debug enabled
[    9.170468][    T1] 9p: Installing v9fs 9p2000 file system support
[    9.185644][    T1] NILFS version 2 loaded
[    9.188849][    T1] befs: version: 0.9.3
[    9.193115][    T1] ocfs2: Registered cluster interface o2cb
[    9.206206][    T1] ocfs2: Registered cluster interface user
[    9.216419][    T1] OCFS2 User DLM kernel interface loaded
[    9.265973][    T1] gfs2: GFS2 installed
[    9.298657][    T1] ceph: loaded (mds proto 32)
[    9.320185][    T1] NET: Registered PF_ALG protocol family
[    9.324663][    T1] async_tx: api initialized (async)
[    9.345185][    T1] Key type asymmetric registered
[    9.349130][    T1] Asymmetric key parser 'x509' registered
[    9.353465][    T1] Asymmetric key parser 'pkcs8' registered
[    9.365187][    T1] Key type pkcs7_test registered
[    9.376596][    T1] Block layer SCSI generic (bsg) driver version 0.4 lo=
aded (major 239)
[    9.396528][    T1] io scheduler mq-deadline registered
[    9.400698][    T1] io scheduler kyber registered
[    9.415450][    T1] io scheduler bfq registered
[    9.420059][    T1] raid6: skipped pq benchmark and selected avx512x4
[    9.442033][  T127] kworker/u4:1 (127) used greatest stack depth: 26984 =
bytes left
[    9.524259][    T1] ACPI: \_SB_.GSIE: Enabled at IRQ 20
[    9.565511][    T1] pcieport 0000:00:04.0: PME: Signaling with IRQ 25
[    9.578930][    T1] pcieport 0000:00:04.0: AER: enabled with IRQ 26
[    9.601450][    T1] input: Power Button as /devices/platform/LNXPWRBN:00=
/input/input0
[    9.629341][    T1] ACPI: button: Power Button [PWRF]
[   10.450014][    T1] ioatdma: Intel(R) QuickData Technology Driver 5.00
[   10.532357][    T1] ACPI: \_SB_.GSIF: Enabled at IRQ 21
[   10.629521][    T1] ACPI: \_SB_.GSIH: Enabled at IRQ 23
[   10.892841][  T270] kworker/u4:1 (270) used greatest stack depth: 26960 =
bytes left
[   11.809081][    T1] N_HDLC line discipline registered with maxframe=3D40=
96
[   11.830246][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enab=
led
[   11.849727][    T1] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D =
115200) is a 16550A
[   11.999300][    T1] Non-volatile memory driver v1.3
[   12.037071][    T1] usbcore: registered new interface driver xillyusb
[   12.058150][    T1] ACPI: bus type drm_connector registered
[   12.091068][    T1] [drm] Initialized vgem 1.0.0 for vgem on minor 0
[   12.105742][    T1] usbcore: registered new interface driver udl
[   12.112516][    T1] [drm] pci: virtio-vga detected at 0000:00:01.0
[   12.125337][    T1] virtio-pci 0000:00:01.0: vgaarb: deactivate vga cons=
ole
[   12.186303][    T1] Console: switching to colour dummy device 80x25
[   12.194466][    T1] [drm] features: -virgl +edid -resource_blob -host_vi=
sible
[   12.194482][    T1] [drm] features: -context_init -blob_alignment
[   12.230560][    T1] [drm] number of scanouts: 1
[   12.233893][    T1] [drm] number of cap sets: 0
[   12.255974][    T1] ------------[ cut here ]------------
[   12.260092][    T1] [PLANE:36:plane-1] pixel format with alpha exposed b=
ut blend mode not setup
[   12.260107][    T1] WARNING: drivers/gpu/drm/drm_mode_config.c:873 at dr=
m_mode_config_validate+0x1c6a/0x1e60, CPU#0: swapper/0/1
[   12.275683][    T1] Modules linked in:
[   12.279250][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[   12.285867][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), =
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.293265][    T1] RIP: 0010:drm_mode_config_validate+0x1cab/0x1e60
[   12.298167][    T1] Code: 0f 85 ae 00 00 00 4d 8d 77 10 8b 6d 00 4c 89 f=
0 48 c1 e8 03 80 3c 18 00 74 08 4c 89 f7 e8 7d a5 a3 fc 49 8b 16 4c 89 ef 8=
9 ee <67> 48 0f b9 3a eb 05 e8 89 54 32 fc 49 bd 00 00 00 00 00 fc ff df
[   12.312441][    T1] RSP: 0000:ffffc900001af450 EFLAGS: 00010246
[   12.316951][    T1] RAX: 1ffff11000030e08 RBX: dffffc0000000000 RCX: fff=
f88801ceb0000
[   12.322637][    T1] RDX: ffff88801f5b27a0 RSI: 0000000000000024 RDI: fff=
fffff9085b000
[   12.328653][    T1] RBP: 0000000000000024 R08: ffffffff8ec2b347 R09: 1ff=
ffffff1d85668
[   12.334503][    T1] R10: dffffc0000000000 R11: fffffbfff1d85669 R12: dff=
ffc0000000000
[   12.340419][    T1] R13: ffffffff9085b000 R14: ffff888000187040 R15: fff=
f888000187030
[   12.346250][    T1] FS:  0000000000000000(0000) GS:ffff88808c2e6000(0000=
) knlGS:0000000000000000
[   12.352727][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.357998][    T1] CR2: ffff88801af19000 CR3: 000000000eb46000 CR4: 000=
0000000352ef0
[   12.363905][    T1] Call Trace:
[   12.366455][    T1]  <TASK>
[   12.368581][    T1]  ? __pfx_autoremove_wake_function+0x10/0x10
[   12.372972][    T1]  drm_dev_register+0x7c/0xd80
[   12.376503][    T1]  virtio_gpu_probe+0x1cb/0x290
[   12.380071][    T1]  virtio_dev_probe+0xdf6/0x10c0
[   12.383655][    T1]  ? up_write+0x19d/0x4a0
[   12.386865][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   12.390829][    T1]  ? driver_sysfs_add+0x1fe/0x210
[   12.394687][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   12.398721][    T1]  really_probe+0x254/0xae0
[   12.402015][    T1]  __driver_probe_device+0x1e8/0x360
[   12.406009][    T1]  driver_probe_device+0x4f/0x240
[   12.413118][    T1]  __driver_attach+0x339/0x600
[   12.416808][    T1]  bus_for_each_dev+0x23b/0x2c0
[   12.420389][    T1]  ? __pfx___driver_attach+0x10/0x10
[   12.424449][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[   12.428383][    T1]  ? do_raw_spin_unlock+0x4d/0x200
[   12.431965][    T1]  bus_add_driver+0x345/0x670
[   12.435503][    T1]  driver_register+0x23a/0x320
[   12.438896][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   12.443320][    T1]  virtio_gpu_driver_init+0x96/0x110
[   12.447202][    T1]  do_one_initcall+0x250/0x870
[   12.450824][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   12.455195][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[   12.459086][    T1]  ? __pfx___schedule+0x10/0x10
[   12.462702][    T1]  ? __pfx___schedule+0x10/0x10
[   12.466316][    T1]  ? _raw_spin_unlock_irqrestore+0x30/0x80
[   12.470553][    T1]  ? __pfx___schedule+0x10/0x10
[   12.474166][    T1]  ? irqentry_exit+0x218/0x910
[   12.477695][    T1]  ? lockdep_hardirqs_on+0x7b/0x110
[   12.481598][    T1]  ? irqentry_exit+0x218/0x910
[   12.485220][    T1]  ? trace_irq_disable+0x3b/0x140
[   12.488882][    T1]  ? parameq+0xd6/0x170
[   12.492000][    T1]  ? next_arg+0x4a0/0x5e0
[   12.495249][    T1]  ? parameq+0x14d/0x170
[   12.498246][    T1]  ? parse_args+0x9c3/0xad0
[   12.501454][    T1]  ? rcu_is_watching+0x16/0xb0
[   12.505007][    T1]  do_initcall_level+0x10a/0x1a0
[   12.508580][    T1]  ? kernel_init+0x22/0x1d0
[   12.511816][    T1]  do_initcalls+0x59/0xa0
[   12.515060][    T1]  kernel_init_freeable+0x29d/0x3e0
[   12.518828][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.522466][    T1]  kernel_init+0x22/0x1d0
[   12.525706][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.529224][    T1]  ret_from_fork+0x514/0xb70
[   12.532504][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[   12.536233][    T1]  ? __switch_to+0xc89/0x1420
[   12.539759][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.543298][    T1]  ret_from_fork_asm+0x1a/0x30
[   12.546840][    T1]  </TASK>
[   12.549044][    T1] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[   12.554149][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[   12.556740][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), =
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.556740][    T1] Call Trace:
[   12.556740][    T1]  <TASK>
[   12.556740][    T1]  vpanic+0x56d/0xa60
[   12.556740][    T1]  ? __pfx__printk+0x10/0x10
[   12.556740][    T1]  ? __pfx_vpanic+0x10/0x10
[   12.556740][    T1]  ? is_bpf_text_address+0x292/0x2b0
[   12.556740][    T1]  ? is_bpf_text_address+0x26/0x2b0
[   12.556740][    T1]  panic+0xc5/0xd0
[   12.556740][    T1]  ? __pfx_panic+0x10/0x10
[   12.556740][    T1]  ? ret_from_fork_asm+0x1a/0x30
[   12.556740][    T1]  __warn+0x315/0x4c0
[   12.556740][    T1]  ? drm_mode_config_validate+0x1c6a/0x1e60
[   12.556740][    T1]  ? drm_mode_config_validate+0x1c6a/0x1e60
[   12.556740][    T1]  __report_bug+0x276/0x570
[   12.556740][    T1]  ? blocking_notifier_chain_register+0x50/0xc0
[   12.556740][    T1]  ? drm_mode_config_validate+0x1c6a/0x1e60
[   12.556740][    T1]  ? __pfx___report_bug+0x10/0x10
[   12.556740][    T1]  ? blocking_notifier_chain_register+0x6b/0xc0
[   12.556740][    T1]  report_bug_entry+0x19b/0x290
[   12.556740][    T1]  ? drm_mode_config_validate+0x1cab/0x1e60
[   12.556740][    T1]  ? drm_mode_config_validate+0x1cb0/0x1e60
[   12.556740][    T1]  handle_bug+0xce/0x200
[   12.556740][    T1]  exc_invalid_op+0x1a/0x50
[   12.556740][    T1]  asm_exc_invalid_op+0x1a/0x20
[   12.556740][    T1] RIP: 0010:drm_mode_config_validate+0x1cab/0x1e60
[   12.556740][    T1] Code: 0f 85 ae 00 00 00 4d 8d 77 10 8b 6d 00 4c 89 f=
0 48 c1 e8 03 80 3c 18 00 74 08 4c 89 f7 e8 7d a5 a3 fc 49 8b 16 4c 89 ef 8=
9 ee <67> 48 0f b9 3a eb 05 e8 89 54 32 fc 49 bd 00 00 00 00 00 fc ff df
[   12.556740][    T1] RSP: 0000:ffffc900001af450 EFLAGS: 00010246
[   12.556740][    T1] RAX: 1ffff11000030e08 RBX: dffffc0000000000 RCX: fff=
f88801ceb0000
[   12.556740][    T1] RDX: ffff88801f5b27a0 RSI: 0000000000000024 RDI: fff=
fffff9085b000
[   12.556740][    T1] RBP: 0000000000000024 R08: ffffffff8ec2b347 R09: 1ff=
ffffff1d85668
[   12.556740][    T1] R10: dffffc0000000000 R11: fffffbfff1d85669 R12: dff=
ffc0000000000
[   12.556740][    T1] R13: ffffffff9085b000 R14: ffff888000187040 R15: fff=
f888000187030
[   12.556740][    T1]  ? __pfx_autoremove_wake_function+0x10/0x10
[   12.556740][    T1]  drm_dev_register+0x7c/0xd80
[   12.556740][    T1]  virtio_gpu_probe+0x1cb/0x290
[   12.556740][    T1]  virtio_dev_probe+0xdf6/0x10c0
[   12.556740][    T1]  ? up_write+0x19d/0x4a0
[   12.556740][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   12.556740][    T1]  ? driver_sysfs_add+0x1fe/0x210
[   12.556740][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   12.556740][    T1]  really_probe+0x254/0xae0
[   12.556740][    T1]  __driver_probe_device+0x1e8/0x360
[   12.556740][    T1]  driver_probe_device+0x4f/0x240
[   12.556740][    T1]  __driver_attach+0x339/0x600
[   12.556740][    T1]  bus_for_each_dev+0x23b/0x2c0
[   12.556740][    T1]  ? __pfx___driver_attach+0x10/0x10
[   12.556740][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[   12.556740][    T1]  ? do_raw_spin_unlock+0x4d/0x200
[   12.556740][    T1]  bus_add_driver+0x345/0x670
[   12.556740][    T1]  driver_register+0x23a/0x320
[   12.556740][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   12.556740][    T1]  virtio_gpu_driver_init+0x96/0x110
[   12.556740][    T1]  do_one_initcall+0x250/0x870
[   12.556740][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   12.556740][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[   12.556740][    T1]  ? __pfx___schedule+0x10/0x10
[   12.556740][    T1]  ? __pfx___schedule+0x10/0x10
[   12.556740][    T1]  ? _raw_spin_unlock_irqrestore+0x30/0x80
[   12.556740][    T1]  ? __pfx___schedule+0x10/0x10
[   12.556740][    T1]  ? irqentry_exit+0x218/0x910
[   12.556740][    T1]  ? lockdep_hardirqs_on+0x7b/0x110
[   12.556740][    T1]  ? irqentry_exit+0x218/0x910
[   12.556740][    T1]  ? trace_irq_disable+0x3b/0x140
[   12.556740][    T1]  ? parameq+0xd6/0x170
[   12.556740][    T1]  ? next_arg+0x4a0/0x5e0
[   12.556740][    T1]  ? parameq+0x14d/0x170
[   12.556740][    T1]  ? parse_args+0x9c3/0xad0
[   12.556740][    T1]  ? rcu_is_watching+0x16/0xb0
[   12.556740][    T1]  do_initcall_level+0x10a/0x1a0
[   12.556740][    T1]  ? kernel_init+0x22/0x1d0
[   12.556740][    T1]  do_initcalls+0x59/0xa0
[   12.556740][    T1]  kernel_init_freeable+0x29d/0x3e0
[   12.556740][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.556740][    T1]  kernel_init+0x22/0x1d0
[   12.556740][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.556740][    T1]  ret_from_fork+0x514/0xb70
[   12.556740][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[   12.556740][    T1]  ? __switch_to+0xc89/0x1420
[   12.556740][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.556740][    T1]  ret_from_fork_asm+0x1a/0x30
[   12.556740][    T1]  </TASK>
[   12.556740][    T1] Kernel Offset: disabled
[   12.556740][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOAMD64=3D'v1'
GOARCH=3D'amd64'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build1726682488=3D/tmp/go-build -gno-record-gc=
c-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mo=
d'
GOMODCACHE=3D'/syzkaller/jobs/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.26.0'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at 680aa3e19b5
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3D680aa3e19b52574eca8bcba3c41aa18235367abe -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20260907-094615"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3D680aa3e19b52574eca8bcba3c41aa18235367abe -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20260907-094615"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D680aa3e19b52574eca8bcba3c41aa18235367abe -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20260907-094615"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"680aa3e19b52574eca8bcba3c41aa18235=
367abe\"
/usr/bin/ld: /tmp/ccLyACCI.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D16bcf125580000


Tested on:

commit:         796aa054 io_uring/rw: end write accounting from ->ki_c..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.g=
it io_uring-7.3
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D780bb9a5c10069a=
1
dashboard link: https://syzkaller.appspot.com/bug?extid=3D2eb3d983669d3e49d=
4fa
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-=
1~exp1~20260613092250.77), Debian LLD 22.1.8

Note: no patches were applied.
