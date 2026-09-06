Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F3731280D
	for <linux-ext4@vger.kernel.org>; Sun,  6 Sep 2026 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788709684; cv=none; b=SndNCC+jKThIJmVS6hi3sK37F0aO80Ine7QZ6R8yTbFR/eqZ+zqkxTR0vCk6DZQG3QHjnw7W+T+F1Ag1ooTum/TG4vNBWg9XjCK/bhotfZ6n4KzoyJeR98hDDSGdnucx6tVoSOPrtQydwXwDb4uNRoB3P4+B/ffOmKkQH9AdfxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788709684; c=relaxed/simple;
	bh=azD0Yv0NDZz58sEbawmUhGNVr+OLjAiRRZ1bK8iIhyA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=o3w97rpHTSBlcuNslLYD5wc7ZejfP8s4qDLPIpWKaNGChpXH7LXuX5ACzHmlA9CilA7rcPlhqH/5MPOGbDf8s9xcrDy08AXcSwcV1cgshPZkHYqwWsLZu++qNbdgeY5ssMeu8Oc0mWYQxnhEwZHBWL0LmkAe6qDrt+sZzRe9NAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a17dafd042so3468722eaf.2
        for <linux-ext4@vger.kernel.org>; Sun, 06 Sep 2026 08:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788709681; x=1789314481;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yOSRmWYQfqtzA8X71XYRhJ++OZt5nqFcovSO3aa4pnU=;
        b=GLKns1zLsV6edqkCk5KBQeTjE0A6rFdPqQUyv8Sv4V4Q5WrRRm45Z+D2zfPanySBK4
         cO2105DJiGcu8ukp7W2QWCURNfeSprBMAWhny/nR6APSD4gl/gwjX4iiOIw8+4WUebbC
         DP6oAQfeWERbMLqPBGIQRhIr9iaTIFCmt627dyZf1j/vdofgp8MThHfpWlLBCrv6AuKr
         VkGT5w4zRcVR80kk1M05tkXC+yXeMdsspK9e53/p3GKXRDEnNFXlXDEApGVg0ts+TDDf
         /5J0YdT+rMVp92lS2c5Ceea5dp4sCVl27H8PdEkzUzGMvyyR+G7hyqQ+1n3UbErr0R6j
         zVQg==
X-Forwarded-Encrypted: i=1; AKwUvBwEKep/pJDC5nSn7O3MT3oiR5bWU8+1bQVMyl6HFBB/IlONCBtL/BIQI5/lFvg9eSm4fT+x6YfnzZWG@vger.kernel.org
X-Gm-Message-State: AFuF++lhU1MNX34BxJJ1c4vRJo9BFhoUC79NX2upHY4anI/SR2Q7U/Gi
	j9lE4QtogsABpIvdD43SIcr+BYWjaj2wWdRx+A8k4eMt/4bS/uLCd36bhOkfbUYabQojm9dDSBn
	Stwy0LaLUuRQNjNX0xX9UyglEj8lSR1z3pYbRpT+n9bVwv+6zu1rbquQx4t0=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f05:b0:6b1:62fd:3b4d with SMTP id
 006d021491bc7-6b6fcfdba21mr18778982eaf.21.1788709681710; Sun, 06 Sep 2026
 08:48:01 -0700 (PDT)
Date: Sun, 06 Sep 2026 08:48:01 -0700
In-Reply-To: <mrtuxxmd.ritesh.list@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9d8b31.a5e650b3.26d8a.001d.GAE@google.com>
Subject: Re: [syzbot] [ext4?] linux-next test error: general protection fault
 in __bh_submit
From: syzbot <syzbot+5a7a23af225c215902e7@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-next@vger.kernel.org, ritesh.list@gmail.com, sfr@canb.auug.org.au, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

                           **
[    1.781826][    T0] **                                                  =
    **
[    1.785372][    T0] ** Use hash_pointers=3Dalways to force this mode off=
      **
[    1.788229][    T0] **                                                  =
    **
[    1.791134][    T0] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTIC=
E   **
[    1.794147][    T0] ****************************************************=
******
[    1.800729][    T0] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPU=
s=3D2, Nodes=3D2
[    1.913042][    T0] allocated 167772160 bytes of page_ext
[    1.915801][    T0] Node 0, zone      DMA: page owner found early alloca=
ted 0 pages
[    1.933467][    T0] Node 0, zone    DMA32: page owner found early alloca=
ted 21251 pages
[    1.941240][    T0] Node 0, zone   Normal: page owner found early alloca=
ted 0 pages
[    1.955796][    T0] Node 1, zone   Normal: page owner found early alloca=
ted 19847 pages
[    1.959586][    T0] Kernel/User page tables isolation: enabled
[    1.963093][    T0] Dynamic Preempt: full
[    1.967309][    T0] Running RCU self tests
[    1.968917][    T0] Running RCU synchronous self tests
[    1.971348][    T0] rcu: Preemptible hierarchical RCU implementation.
[    1.973877][    T0] rcu: 	RCU lockdep checking is enabled.
[    1.975705][    T0] rcu: 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cp=
u_ids=3D2.
[    1.979019][    T0] rcu: 	RCU callback double-/use-after-free debug is e=
nabled.
[    1.981744][    T0] rcu: 	RCU debug extended QS entry/exit.
[    1.984219][    T0] 	All grace periods are expedited (rcu_expedited).
[    1.987289][    T0] 	Trampoline variant of Tasks RCU enabled.
[    1.989422][    T0] 	Tracing variant of Tasks RCU enabled.
[    1.991680][    T0] rcu: RCU calculated value of scheduler-enlistment de=
lay is 10 jiffies.
[    1.995031][    T0] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr=
_cpu_ids=3D2
[    1.998432][    T0] Running RCU synchronous self tests
[    2.000933][    T0] RCU Tasks: Setting shift to 1 and lim to 1 rcu_task_=
cb_adjust=3D1 rcu_task_cpu_ids=3D2.
[    2.195362][    T0] NR_IRQS: 4352, nr_irqs: 440, preallocated irqs: 16
[    2.198834][    T0] rcu: srcu_init: Setting srcu_struct sizes based on c=
ontention.
[    2.201284][    T0] clocksource: jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 19112604462750000 ns
[    2.206079][    T0] kfence: initialized - using 2097152 bytes for 255 ob=
jects at 0xffff88823be00000-0xffff88823c000000
[    2.211871][    T0] Console: colour VGA+ 80x25
[    2.213842][    T0] printk: console [ttyS0] enabled
[    2.213842][    T0] printk: console [ttyS0] enabled
[    2.217871][    T0] printk: legacy bootconsole [earlyser0] disabled
[    2.217871][    T0] printk: legacy bootconsole [earlyser0] disabled
[    2.222615][    T0] Lock dependency validator: Copyright (c) 2006 Red Ha=
t, Inc., Ingo Molnar
[    2.226003][    T0] ... MAX_LOCKDEP_SUBCLASSES:  8
[    2.227931][    T0] ... MAX_LOCK_DEPTH:          48
[    2.230174][    T0] ... MAX_LOCKDEP_KEYS:        8192
[    2.232343][    T0] ... CLASSHASH_SIZE:          4096
[    2.234359][    T0] ... MAX_LOCKDEP_ENTRIES:     1048576
[    2.236604][    T0] ... MAX_LOCKDEP_CHAINS:      1048576
[    2.239946][    T0] ... CHAINHASH_SIZE:          524288
[    2.241944][    T0]  memory used by lock dependency info: 106625 kB
[    2.244550][    T0]  memory used for stack traces: 8320 kB
[    2.246632][    T0]  per task-struct memory footprint: 1920 bytes
[    2.250233][    T0] mempolicy: Enabling automatic NUMA balancing. Config=
ure with numa_balancing=3D or the kernel.numa_balancing sysctl
[    2.255922][    T0] ACPI: Core revision 20260408
[    2.259621][    T0] APIC: Switch to symmetric I/O mode setup
[    2.262474][    T0] x2apic enabled
[    2.269220][    T0] APIC: Switched APIC routing to: physical x2apic
[    2.283082][    T0] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=3D-1=
 pin2=3D-1
[    2.286314][    T0] clocksource: tsc-early: mask: 0xffffffffffffffff max=
_cycles: 0x1fb63109b96, max_idle_ns: 440795265316 ns
[    2.291274][    T0] Calibrating delay loop (skipped) preset value.. 4399=
.99 BogoMIPS (lpj=3D21999980)
[    2.295562][    T0] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    2.298340][    T0] Last level dTLB entries: 4KB 64, 2MB 32, 4MB 32, 1GB=
 4
[    2.301356][    T0] mitigations: Enabled attack vectors: user_kernel, us=
er_user, guest_host, guest_guest, SMT mitigations: auto
[    2.306450][    T0] Speculative Store Bypass: Mitigation: Speculative St=
ore Bypass disabled via prctl
[    2.311274][    T0] Spectre V2 : Mitigation: IBRS
[    2.313098][    T0] RETBleed: Mitigation: IBRS
[    2.314913][    T0] ITS: Mitigation: Aligned branch/return thunks
[    2.317002][    T0] Spectre V2 : User space: Mitigation: STIBP via prctl
[    2.319854][    T0] MDS: Mitigation: Clear CPU buffers
[    2.321273][    T0] TAA: Mitigation: Clear CPU buffers
[    2.323137][    T0] MMIO Stale Data: Vulnerable: Clear CPU buffers attem=
pted, no microcode
[    2.326988][    T0] Spectre V1 : Mitigation: usercopy/swapgs barriers an=
d __user pointer sanitization
[    2.331280][    T0] Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on=
 context switch and VMEXIT
[    2.335963][    T0] Spectre V2 : Enabling IBPB for BPF
[    2.337974][    T0] Spectre V2 : mitigation: Enabling conditional Indire=
ct Branch Prediction Barrier
[    2.341320][    T0] active return thunk: its_return_thunk
[    2.343502][    T0] Spectre V2 : Spectre BHI mitigation: SW BHB clearing=
 on syscall and VM exit
[    2.347384][    T0] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floati=
ng point registers'
[    2.351279][    T0] x86/fpu: Supporting XSAVE feature 0x002: 'SSE regist=
ers'
[    2.353962][    T0] x86/fpu: Supporting XSAVE feature 0x004: 'AVX regist=
ers'
[    2.356774][    T0] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  2=
56
[    2.359625][    T0] x86/fpu: Enabled xstate features 0x7, context size i=
s 832 bytes, using 'standard' format.
[    2.363542][    T0] ------------[ cut here ]------------
[    2.365737][    T0] CPA detected W^X violation: 8000000000000023 -> 0000=
000000000023 range: 0xffffffffa0000000 - 0xffffffffa0000fff PFN 140600
[    2.371284][    T0] WARNING: arch/x86/mm/pat/set_memory.c:725 at __chang=
e_page_attr_set_clr+0x1d69/0x2820, CPU#0: swapper/0/0
[    2.376683][    T0] Modules linked in:
[    2.378262][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[    2.381273][    T0] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 07/24/2026
[    2.385137][    T0] RIP: 0010:__change_page_attr_set_clr+0x1d79/0x2820
[    2.388239][    T0] Code: 00 00 e8 ba 6c 4d 00 48 8b 4c 24 30 4c 8d 81 f=
f 0f 00 00 48 8d 3d 07 be 02 0f 48 8b b4 24 a0 00 00 00 4c 89 f2 4c 8b 4c 2=
4 50 <67> 48 0f b9 3a e9 8d 00 00 00 e8 88 6c 4d 00 4c 89 f8 48 c1 e8 03
[    2.391278][    T0] RSP: 0000:ffffffff8ea07820 EFLAGS: 00010293
[    2.401293][    T0] RAX: ffffffff817a6b66 RBX: 8000000140600023 RCX: fff=
fffffa0000000
[    2.404461][    T0] RDX: 0000000000000023 RSI: 8000000000000023 RDI: fff=
fffff907d2980
[    2.407438][    T0] RBP: ffffffff8ea07ad0 R08: ffffffffa0000fff R09: 000=
0000000140600
[    2.411273][    T0] R10: dffffc0000000000 R11: fffffbfff1d40ef4 R12: 800=
0000000000000
[    2.414650][    T0] R13: 0000000000000002 R14: 0000000000000023 R15: 800=
0000000000002
[    2.418017][    T0] FS:  0000000000000000(0000) GS:ffff888124cbf000(0000=
) knlGS:0000000000000000
[    2.421275][    T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.424161][    T0] CR2: ffff88823ffff000 CR3: 000000000eb48000 CR4: 000=
00000003506f0
[    2.428084][    T0] Call Trace:
[    2.429360][    T0]  <TASK>
[    2.431293][    T0]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[    2.434103][    T0]  ? __purge_vmap_area_lazy+0x964/0xb40
[    2.436630][    T0]  ? __pfx___change_page_attr_set_clr+0x10/0x10
[    2.439191][    T0]  ? __might_resched+0x71/0x4c0
[    2.441337][    T0]  ? down_read+0x2b9/0x320
[    2.443816][    T0]  change_page_attr_set_clr+0x398/0x11d0
[    2.447135][    T0]  ? __pfx_change_page_attr_set_clr+0x10/0x10
[    2.450043][    T0]  ? trace_kmalloc+0x2a/0xf0
[    2.451285][    T0]  set_memory_x+0xd6/0x110
[    2.453738][    T0]  ? __pfx_set_memory_x+0x10/0x10
[    2.456130][    T0]  apply_retpolines+0x8e9/0x15a0
[    2.459193][    T0]  ? events_sysfs_show+0xdd/0xf0
[    2.461280][    T0]  ? __pfx_apply_retpolines+0x10/0x10
[    2.464819][    T0]  ? events_sysfs_show+0xdd/0xf0
[    2.467699][    T0]  ? events_sysfs_show+0xec/0xf0
[    2.471274][    T0]  ? events_sysfs_show+0xe3/0xf0
[    2.473354][    T0]  ? unregister_die_notifier+0x43/0x50
[    2.475535][    T0]  ? __pfx_int3_selftest+0x10/0x10
[    2.477371][    T0]  alternative_instructions+0x3a/0x100
[    2.479281][    T0]  arch_cpu_finalize_init+0xb2/0x1f0
[    2.481279][    T0]  start_kernel+0x310/0x3e0
[    2.482865][    T0]  x86_64_start_reservations+0x24/0x30
[    2.485077][    T0]  x86_64_start_kernel+0x137/0x1b0
[    2.487088][    T0]  common_startup_64+0x13e/0x157
[    2.489518][    T0]  </TASK>
[    2.491278][    T0] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[    2.494734][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[    2.499193][    T0] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 07/24/2026
[    2.501258][    T0] Call Trace:
[    2.501258][    T0]  <TASK>
[    2.501258][    T0]  vpanic+0x56d/0xa70
[    2.501258][    T0]  ? __pfx__printk+0x10/0x10
[    2.501258][    T0]  ? __pfx_vpanic+0x10/0x10
[    2.501258][    T0]  ? is_bpf_text_address+0x292/0x2b0
[    2.501258][    T0]  ? is_bpf_text_address+0x26/0x2b0
[    2.501258][    T0]  panic+0xc5/0xd0
[    2.501258][    T0]  ? __pfx_panic+0x10/0x10
[    2.501258][    T0]  ? common_startup_64+0x13e/0x157
[    2.501258][    T0]  __warn+0x315/0x4c0
[    2.501258][    T0]  ? __change_page_attr_set_clr+0x1d69/0x2820
[    2.501258][    T0]  ? __change_page_attr_set_clr+0x1d69/0x2820
[    2.501258][    T0]  __report_bug+0x276/0x570
[    2.501258][    T0]  ? __change_page_attr_set_clr+0x1d69/0x2820
[    2.501258][    T0]  ? __pfx___report_bug+0x10/0x10
[    2.501258][    T0]  report_bug_entry+0x19b/0x290
[    2.501258][    T0]  ? __change_page_attr_set_clr+0x1d79/0x2820
[    2.501258][    T0]  ? __change_page_attr_set_clr+0x1d7e/0x2820
[    2.501258][    T0]  handle_bug+0xce/0x200
[    2.501258][    T0]  exc_invalid_op+0x1a/0x50
[    2.501258][    T0]  asm_exc_invalid_op+0x1a/0x20
[    2.501258][    T0] RIP: 0010:__change_page_attr_set_clr+0x1d79/0x2820
[    2.501258][    T0] Code: 00 00 e8 ba 6c 4d 00 48 8b 4c 24 30 4c 8d 81 f=
f 0f 00 00 48 8d 3d 07 be 02 0f 48 8b b4 24 a0 00 00 00 4c 89 f2 4c 8b 4c 2=
4 50 <67> 48 0f b9 3a e9 8d 00 00 00 e8 88 6c 4d 00 4c 89 f8 48 c1 e8 03
[    2.501258][    T0] RSP: 0000:ffffffff8ea07820 EFLAGS: 00010293
[    2.501258][    T0] RAX: ffffffff817a6b66 RBX: 8000000140600023 RCX: fff=
fffffa0000000
[    2.501258][    T0] RDX: 0000000000000023 RSI: 8000000000000023 RDI: fff=
fffff907d2980
[    2.501258][    T0] RBP: ffffffff8ea07ad0 R08: ffffffffa0000fff R09: 000=
0000000140600
[    2.501258][    T0] R10: dffffc0000000000 R11: fffffbfff1d40ef4 R12: 800=
0000000000000
[    2.501258][    T0] R13: 0000000000000002 R14: 0000000000000023 R15: 800=
0000000000002
[    2.501258][    T0]  ? __change_page_attr_set_clr+0x1d56/0x2820
[    2.501258][    T0]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[    2.501258][    T0]  ? __purge_vmap_area_lazy+0x964/0xb40
[    2.501258][    T0]  ? __pfx___change_page_attr_set_clr+0x10/0x10
[    2.501258][    T0]  ? __might_resched+0x71/0x4c0
[    2.501258][    T0]  ? down_read+0x2b9/0x320
[    2.501258][    T0]  change_page_attr_set_clr+0x398/0x11d0
[    2.501258][    T0]  ? __pfx_change_page_attr_set_clr+0x10/0x10
[    2.501258][    T0]  ? trace_kmalloc+0x2a/0xf0
[    2.501258][    T0]  set_memory_x+0xd6/0x110
[    2.501258][    T0]  ? __pfx_set_memory_x+0x10/0x10
[    2.501258][    T0]  apply_retpolines+0x8e9/0x15a0
[    2.501258][    T0]  ? events_sysfs_show+0xdd/0xf0
[    2.501258][    T0]  ? __pfx_apply_retpolines+0x10/0x10
[    2.501258][    T0]  ? events_sysfs_show+0xdd/0xf0
[    2.501258][    T0]  ? events_sysfs_show+0xec/0xf0
[    2.501258][    T0]  ? events_sysfs_show+0xe3/0xf0
[    2.501258][    T0]  ? unregister_die_notifier+0x43/0x50
[    2.501258][    T0]  ? __pfx_int3_selftest+0x10/0x10
[    2.501258][    T0]  alternative_instructions+0x3a/0x100
[    2.501258][    T0]  arch_cpu_finalize_init+0xb2/0x1f0
[    2.501258][    T0]  start_kernel+0x310/0x3e0
[    2.501258][    T0]  x86_64_start_reservations+0x24/0x30
[    2.501258][    T0]  x86_64_start_kernel+0x137/0x1b0
[    2.501258][    T0]  common_startup_64+0x13e/0x157
[    2.501258][    T0]  </TASK>
[    2.501258][    T0] Rebooting in 86400 seconds..


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
 -ffile-prefix-map=3D/tmp/go-build185907891=3D/tmp/go-build -gno-record-gcc=
-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
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
HEAD detached at 85995287a88
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3D85995287a888340d8818a8f3c43e2e89555eea21 -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20260902-115702"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3D85995287a888340d8818a8f3c43e2e89555eea21 -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20260902-115702"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D85995287a888340d8818a8f3c43e2e89555eea21 -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20260902-115702"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"85995287a888340d8818a8f3c43e2e8955=
5eea21\"
/usr/bin/ld: /tmp/cc6c4SOQ.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D138aecf9580000


Tested on:

commit:         af5f1280 Add linux-next specific files for 20260904
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dbb4a32c282cc2ec=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3D5a7a23af225c21590=
2e7
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-=
1~exp1~20260613092250.77), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D17fd51255800=
00

