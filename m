Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9809D534443
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953227; cv=none; b=Wejlv3vyu5do9n1iQQM+hu4DuJ5SCXQR6spLfHLMn/7zlebTyRrktXPgUbrQjhsfR5CQZi3SV+RF0bs5Wk+DF6dd9UP7u0u/qLf3VOtA43tbqceklzXbHlRWzvErO8adjoT639NCSIUN0iYyzkGPdlMmjGtMxBPzTtywYAgZfpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953227; c=relaxed/simple;
	bh=sX4HLwpwQ7v5WYFTDvOIX+khmCd6ycKonZjj3PQuutk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Iz1wyFiEhNCQEtWcDvVmivi9/5lt5QVbAq5qQKYAhhWodQi2WtRa8pCaXDujiKGDNLbGALzlJnQJcJiFI4fyP9pajrWU0hPWhckkvxry1rdArPRv6H39ySdSUAUkfVKOnwxj5zFZeRLoCeaGjmsYsLJcq9vaYO+Xo5i+u/PHosU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e7624e584dso7219095a34.2
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 04:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788953224; x=1789558024;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vYqgfRQWM/2cIPA4POt7C74pbacB0heayByMxftypiU=;
        b=j+5+/90MiR8l4XzDECFw5kRKvBk6qkqtWu+aR9sGVsu/wSPgyT4K4Rpyva9TzIZK2U
         GnFwKKskNrPfDAa3QnE1PKS/dZbV1njD2jVQaBqiTfZso8dL39GE2D/B5diYH7YZOGKw
         Ma5QXt6xgYdvkHodpz+cUZ+VKRCnR3+Q1Cy7P3CLmNfe0aHdQAaCK6C8WMnpLUGVpxS6
         geN9yEAt0CuXBu0R9adMvQiINlttgQQj7xMRS/Y7xN2otopzLL1CHFUtIhfYrzbmHr9R
         cApAw5aaUPo6t6SpcFY5QnvrNbps4QnrR8foUFJ5YJjO8zdyRhzREjDs72ng0NvNngY0
         3lEA==
X-Forwarded-Encrypted: i=1; AKwUvBxL10uC4qjx9y58ToxXWvlaqUwp8xd2BdN7rQCkjgaI0/I0Pm1MfgdQTAQIf83tknBnJg/7OT1zeoD7@vger.kernel.org
X-Gm-Message-State: AFuF++n0kpnrcEVNKx7HzCIWFtr1aFywmUzJoN5FmMW1PVI/Wfst1KE1
	CpRdBy1WW1trgLl91zBUJy3pqN2K5ROebIg9ij2x0nwbmy+BSzVMbhKct35pIW/DnXCWBmQstnH
	iiILTMnZe6ZfdK84wa2UvQjoH/riHJ0DC0ml0jcKMSeearll9VuTkQM/DLFQ=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e916:0:b0:6a1:47c8:c86 with SMTP id
 006d021491bc7-6b6fb4e7a5fmr19197465eaf.10.1788953223961; Wed, 09 Sep 2026
 04:27:03 -0700 (PDT)
Date: Wed, 09 Sep 2026 04:27:03 -0700
In-Reply-To: <fdc957c4-2b98-4b76-9bce-06e4d27c233b@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa14287.6e6c5f9e.28f11f.0023.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
From: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

[    T1] jffs2: version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-2006 Red Hat, In=
c.
[    9.450006][    T1] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    9.454451][    T1] QNX4 filesystem 0.2.3 registered.
[    9.467839][    T1] qnx6: QNX6 filesystem 1.0.0 registered.
[    9.473957][    T1] fuse: init (API version 7.45)
[    9.493414][  T106] kworker/u4:1 (106) used greatest stack depth: 26960 =
bytes left
[    9.499661][    T1] orangefs_debugfs_init: called with debug mask: :none=
: :0:
[    9.517806][    T1] orangefs_init: module version upstream loaded
[    9.523522][    T1] JFS: nTxBlock =3D 6145, nTxLock =3D 49167
[    9.549727][    T1] SGI XFS with ACLs, security attributes, realtime, sc=
rub, repair, quota, no debug enabled
[    9.587305][    T1] 9p: Installing v9fs 9p2000 file system support
[    9.598431][    T1] NILFS version 2 loaded
[    9.601604][    T1] befs: version: 0.9.3
[    9.605491][    T1] ocfs2: Registered cluster interface o2cb
[    9.629421][    T1] ocfs2: Registered cluster interface user
[    9.648529][    T1] OCFS2 User DLM kernel interface loaded
[    9.683543][  T115] kworker/u4:2 (115) used greatest stack depth: 26504 =
bytes left
[    9.711809][    T1] gfs2: GFS2 installed
[    9.750240][    T1] ceph: loaded (mds proto 32)
[    9.783162][    T1] NET: Registered PF_ALG protocol family
[    9.798112][    T1] async_tx: api initialized (async)
[    9.802397][    T1] Key type asymmetric registered
[    9.817841][    T1] Asymmetric key parser 'x509' registered
[    9.822530][    T1] Asymmetric key parser 'pkcs8' registered
[    9.826906][    T1] Key type pkcs7_test registered
[    9.839159][    T1] Block layer SCSI generic (bsg) driver version 0.4 lo=
aded (major 239)
[    9.863479][    T1] io scheduler mq-deadline registered
[    9.867560][    T1] io scheduler kyber registered
[    9.878657][    T1] io scheduler bfq registered
[    9.888919][    T1] raid6: skipped pq benchmark and selected avx512x4
[    9.992971][    T1] ACPI: \_SB_.GSIE: Enabled at IRQ 20
[   10.028066][    T1] pcieport 0000:00:04.0: PME: Signaling with IRQ 25
[   10.059120][    T1] pcieport 0000:00:04.0: AER: enabled with IRQ 26
[   10.082251][    T1] input: Power Button as /devices/platform/LNXPWRBN:00=
/input/input0
[   10.101416][    T1] ACPI: button: Power Button [PWRF]
[   10.994864][    T1] ioatdma: Intel(R) QuickData Technology Driver 5.00
[   11.099208][    T1] ACPI: \_SB_.GSIF: Enabled at IRQ 21
[   11.203563][    T1] ACPI: \_SB_.GSIH: Enabled at IRQ 23
[   12.461571][    T1] N_HDLC line discipline registered with maxframe=3D40=
96
[   12.473979][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enab=
led
[   12.490839][    T1] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D =
115200) is a 16550A
[   12.596214][    T1] Non-volatile memory driver v1.3
[   12.619055][    T1] usbcore: registered new interface driver xillyusb
[   12.631909][    T1] ACPI: bus type drm_connector registered
[   12.646781][    T1] [drm] Initialized vgem 1.0.0 for vgem on minor 0
[   12.653751][    T1] usbcore: registered new interface driver udl
[   12.660228][    T1] [drm] pci: virtio-vga detected at 0000:00:01.0
[   12.665091][    T1] virtio-pci 0000:00:01.0: vgaarb: deactivate vga cons=
ole
[   12.690228][    T1] Console: switching to colour dummy device 80x25
[   12.699414][    T1] [drm] features: -virgl +edid -resource_blob -host_vi=
sible
[   12.699488][    T1] [drm] features: -context_init -blob_alignment
[   12.717375][    T1] [drm] number of scanouts: 1
[   12.721344][    T1] [drm] number of cap sets: 0
[   12.728666][    T1] ------------[ cut here ]------------
[   12.732715][    T1] [PLANE:36:plane-1] pixel format with alpha exposed b=
ut blend mode not setup
[   12.732728][    T1] WARNING: drivers/gpu/drm/drm_mode_config.c:873 at dr=
m_mode_config_validate+0x1c6a/0x1e60, CPU#0: swapper/0/1
[   12.747874][    T1] Modules linked in:
[   12.750657][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[   12.756989][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), =
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.764555][    T1] RIP: 0010:drm_mode_config_validate+0x1cab/0x1e60
[   12.769342][    T1] Code: 0f 85 ae 00 00 00 4d 8d 77 10 8b 6d 00 4c 89 f=
0 48 c1 e8 03 80 3c 18 00 74 08 4c 89 f7 e8 7d a5 a3 fc 49 8b 16 4c 89 ef 8=
9 ee <67> 48 0f b9 3a eb 05 e8 89 54 32 fc 49 bd 00 00 00 00 00 fc ff df
[   12.783031][    T1] RSP: 0000:ffffc900001af450 EFLAGS: 00010246
[   12.787445][    T1] RAX: 1ffff110000a2808 RBX: dffffc0000000000 RCX: fff=
f88801ceb0000
[   12.793083][    T1] RDX: ffff88801f5dd780 RSI: 0000000000000024 RDI: fff=
fffff9085b000
[   12.798984][    T1] RBP: 0000000000000024 R08: ffffffff8ec2b347 R09: 1ff=
ffffff1d85668
[   12.804669][    T1] R10: dffffc0000000000 R11: fffffbfff1d85669 R12: dff=
ffc0000000000
[   12.810525][    T1] R13: ffffffff9085b000 R14: ffff888000514040 R15: fff=
f888000514030
[   12.816240][    T1] FS:  0000000000000000(0000) GS:ffff88808c2e6000(0000=
) knlGS:0000000000000000
[   12.822827][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.827688][    T1] CR2: ffff88801af19000 CR3: 000000000eb46000 CR4: 000=
0000000352ef0
[   12.833506][    T1] Call Trace:
[   12.835839][    T1]  <TASK>
[   12.838056][    T1]  ? __pfx_autoremove_wake_function+0x10/0x10
[   12.842500][    T1]  drm_dev_register+0x7c/0xd80
[   12.845841][    T1]  virtio_gpu_probe+0x1cb/0x290
[   12.849449][    T1]  virtio_dev_probe+0xdf6/0x10c0
[   12.853176][    T1]  ? up_write+0x19d/0x4a0
[   12.856327][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   12.860356][    T1]  ? driver_sysfs_add+0x1fe/0x210
[   12.864021][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   12.867970][    T1]  really_probe+0x254/0xae0
[   12.871209][    T1]  __driver_probe_device+0x1e8/0x360
[   12.875197][    T1]  driver_probe_device+0x4f/0x240
[   12.878980][    T1]  __driver_attach+0x339/0x600
[   12.882501][    T1]  bus_for_each_dev+0x23b/0x2c0
[   12.886017][    T1]  ? __pfx___driver_attach+0x10/0x10
[   12.889911][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[   12.893969][    T1]  ? do_raw_spin_unlock+0x4d/0x200
[   12.897821][    T1]  bus_add_driver+0x345/0x670
[   12.901156][    T1]  driver_register+0x23a/0x320
[   12.904616][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   12.908997][    T1]  virtio_gpu_driver_init+0x96/0x110
[   12.912765][    T1]  do_one_initcall+0x250/0x870
[   12.916048][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   12.920425][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[   12.924224][    T1]  ? lapic_next_event+0x11/0x20
[   12.927996][    T1]  ? clockevents_program_event+0x491/0x630
[   12.932173][    T1]  ? __pfx___schedule+0x10/0x10
[   12.935834][    T1]  ? irqentry_exit+0x218/0x910
[   12.939393][    T1]  ? lockdep_hardirqs_on+0x7b/0x110
[   12.943214][    T1]  ? irqentry_exit+0x218/0x910
[   12.946613][    T1]  ? trace_irq_disable+0x3b/0x140
[   12.950297][    T1]  ? strlen+0x2e/0x70
[   12.953299][    T1]  ? next_arg+0x4a0/0x5e0
[   12.956477][    T1]  ? parameq+0x14d/0x170
[   12.959569][    T1]  ? parse_args+0x9c3/0xad0
[   12.962839][    T1]  ? rcu_is_watching+0x16/0xb0
[   12.966030][    T1]  do_initcall_level+0x10a/0x1a0
[   12.969717][    T1]  ? kernel_init+0x22/0x1d0
[   12.973025][    T1]  do_initcalls+0x59/0xa0
[   12.976142][    T1]  kernel_init_freeable+0x29d/0x3e0
[   12.980086][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.983647][    T1]  kernel_init+0x22/0x1d0
[   12.986760][    T1]  ? __pfx_kernel_init+0x10/0x10
[   12.990406][    T1]  ret_from_fork+0x514/0xb70
[   12.993692][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[   12.997415][    T1]  ? __switch_to+0xc89/0x1420
[   13.000914][    T1]  ? __pfx_kernel_init+0x10/0x10
[   13.004417][    T1]  ret_from_fork_asm+0x1a/0x30
[   13.007943][    T1]  </TASK>
[   13.010159][    T1] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[   13.015418][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[   13.017889][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), =
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   13.017889][    T1] Call Trace:
[   13.017889][    T1]  <TASK>
[   13.017889][    T1]  vpanic+0x56d/0xa60
[   13.017889][    T1]  ? __pfx__printk+0x10/0x10
[   13.017889][    T1]  ? __pfx_vpanic+0x10/0x10
[   13.017889][    T1]  ? is_bpf_text_address+0x292/0x2b0
[   13.017889][    T1]  ? is_bpf_text_address+0x26/0x2b0
[   13.017889][    T1]  panic+0xc5/0xd0
[   13.017889][    T1]  ? __pfx_panic+0x10/0x10
[   13.017889][    T1]  ? ret_from_fork_asm+0x1a/0x30
[   13.017889][    T1]  __warn+0x315/0x4c0
[   13.017889][    T1]  ? drm_mode_config_validate+0x1c6a/0x1e60
[   13.017889][    T1]  ? drm_mode_config_validate+0x1c6a/0x1e60
[   13.017889][    T1]  __report_bug+0x276/0x570
[   13.017889][    T1]  ? blocking_notifier_chain_register+0x50/0xc0
[   13.017889][    T1]  ? drm_mode_config_validate+0x1c6a/0x1e60
[   13.017889][    T1]  ? __pfx___report_bug+0x10/0x10
[   13.017889][    T1]  ? blocking_notifier_chain_register+0x6b/0xc0
[   13.017889][    T1]  report_bug_entry+0x19b/0x290
[   13.017889][    T1]  ? drm_mode_config_validate+0x1cab/0x1e60
[   13.017889][    T1]  ? drm_mode_config_validate+0x1cb0/0x1e60
[   13.017889][    T1]  handle_bug+0xce/0x200
[   13.017889][    T1]  exc_invalid_op+0x1a/0x50
[   13.017889][    T1]  asm_exc_invalid_op+0x1a/0x20
[   13.017889][    T1] RIP: 0010:drm_mode_config_validate+0x1cab/0x1e60
[   13.017889][    T1] Code: 0f 85 ae 00 00 00 4d 8d 77 10 8b 6d 00 4c 89 f=
0 48 c1 e8 03 80 3c 18 00 74 08 4c 89 f7 e8 7d a5 a3 fc 49 8b 16 4c 89 ef 8=
9 ee <67> 48 0f b9 3a eb 05 e8 89 54 32 fc 49 bd 00 00 00 00 00 fc ff df
[   13.017889][    T1] RSP: 0000:ffffc900001af450 EFLAGS: 00010246
[   13.017889][    T1] RAX: 1ffff110000a2808 RBX: dffffc0000000000 RCX: fff=
f88801ceb0000
[   13.017889][    T1] RDX: ffff88801f5dd780 RSI: 0000000000000024 RDI: fff=
fffff9085b000
[   13.017889][    T1] RBP: 0000000000000024 R08: ffffffff8ec2b347 R09: 1ff=
ffffff1d85668
[   13.017889][    T1] R10: dffffc0000000000 R11: fffffbfff1d85669 R12: dff=
ffc0000000000
[   13.017889][    T1] R13: ffffffff9085b000 R14: ffff888000514040 R15: fff=
f888000514030
[   13.017889][    T1]  ? __pfx_autoremove_wake_function+0x10/0x10
[   13.017889][    T1]  drm_dev_register+0x7c/0xd80
[   13.017889][    T1]  virtio_gpu_probe+0x1cb/0x290
[   13.017889][    T1]  virtio_dev_probe+0xdf6/0x10c0
[   13.017889][    T1]  ? up_write+0x19d/0x4a0
[   13.017889][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   13.017889][    T1]  ? driver_sysfs_add+0x1fe/0x210
[   13.017889][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   13.017889][    T1]  really_probe+0x254/0xae0
[   13.017889][    T1]  __driver_probe_device+0x1e8/0x360
[   13.017889][    T1]  driver_probe_device+0x4f/0x240
[   13.017889][    T1]  __driver_attach+0x339/0x600
[   13.017889][    T1]  bus_for_each_dev+0x23b/0x2c0
[   13.017889][    T1]  ? __pfx___driver_attach+0x10/0x10
[   13.017889][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[   13.017889][    T1]  ? do_raw_spin_unlock+0x4d/0x200
[   13.017889][    T1]  bus_add_driver+0x345/0x670
[   13.017889][    T1]  driver_register+0x23a/0x320
[   13.017889][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   13.017889][    T1]  virtio_gpu_driver_init+0x96/0x110
[   13.017889][    T1]  do_one_initcall+0x250/0x870
[   13.017889][    T1]  ? __pfx_virtio_gpu_driver_init+0x10/0x10
[   13.017889][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[   13.017889][    T1]  ? lapic_next_event+0x11/0x20
[   13.017889][    T1]  ? clockevents_program_event+0x491/0x630
[   13.017889][    T1]  ? __pfx___schedule+0x10/0x10
[   13.017889][    T1]  ? irqentry_exit+0x218/0x910
[   13.017889][    T1]  ? lockdep_hardirqs_on+0x7b/0x110
[   13.017889][    T1]  ? irqentry_exit+0x218/0x910
[   13.017889][    T1]  ? trace_irq_disable+0x3b/0x140
[   13.017889][    T1]  ? strlen+0x2e/0x70
[   13.017889][    T1]  ? next_arg+0x4a0/0x5e0
[   13.017889][    T1]  ? parameq+0x14d/0x170
[   13.017889][    T1]  ? parse_args+0x9c3/0xad0
[   13.017889][    T1]  ? rcu_is_watching+0x16/0xb0
[   13.017889][    T1]  do_initcall_level+0x10a/0x1a0
[   13.017889][    T1]  ? kernel_init+0x22/0x1d0
[   13.017889][    T1]  do_initcalls+0x59/0xa0
[   13.017889][    T1]  kernel_init_freeable+0x29d/0x3e0
[   13.017889][    T1]  ? __pfx_kernel_init+0x10/0x10
[   13.017889][    T1]  kernel_init+0x22/0x1d0
[   13.017889][    T1]  ? __pfx_kernel_init+0x10/0x10
[   13.017889][    T1]  ret_from_fork+0x514/0xb70
[   13.017889][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[   13.017889][    T1]  ? __switch_to+0xc89/0x1420
[   13.017889][    T1]  ? __pfx_kernel_init+0x10/0x10
[   13.017889][    T1]  ret_from_fork_asm+0x1a/0x30
[   13.017889][    T1]  </TASK>
[   13.017889][    T1] Kernel Offset: disabled
[   13.017889][    T1] Rebooting in 86400 seconds..


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
 -ffile-prefix-map=3D/tmp/go-build2768744602=3D/tmp/go-build -gno-record-gc=
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
/usr/bin/ld: /tmp/ccdJQzUC.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D164baa15580000


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
