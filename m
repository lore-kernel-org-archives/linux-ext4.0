From: Borislav Petkov <bp@alien8.de>
Subject: ext4/jbd splat in 4.4-rc4+
Date: Thu, 10 Dec 2015 15:04:04 +0100
Message-ID: <20151210140404.GA3049@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi guys,

I'm getting this nasty splat in ext4 land while booting kernels in
qemu/kvm. Last time it happened while injecting NMIs in the guest using
the qemu monitor, this time too. Any ideas?

Sadly, rIP is gone so I can't really pinpoint the problem but someone
might have an idea.

Last time it happened, the box froze solid, this time it was barely
alive so that I was able to suck dmesg out before it crashes completely.

Any suggestions appreciated.

Thanks.


[   46.189686] tun: Universal TUN/TAP device driver, 1.6
[   46.194791] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[ 8026.742308] kvm: zapping shadow pages for mmio generation wraparound
[ 8063.356952] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 8063.364839] IP: [<          (null)>]           (null)
[ 8063.369919] PGD 0 
[ 8063.371956] Oops: 0010 [#1] PREEMPT SMP 
[ 8063.375933] Modules linked in: tun sha256_ssse3 sha256_generic drbg binfmt_misc ipv6 vfat fat fuse dm_crypt dm_mod kvm_amd kvm irqbypass crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd amd64_edac_mod fam15h_power k10temp edac_mce_amd amdkfd amd_iommu_v2 radeon acpi_cpufreq
[ 8063.403458] CPU: 6 PID: 22875 Comm: qemu-system-x86 Not tainted 4.4.0-rc4+ #1
[ 8063.410607] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[ 8063.420538] task: ffff880323511780 ti: ffff8802aa0c0000 task.ti: ffff8802aa0c0000
[ 8063.428044] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[ 8063.435556] RSP: 0018:ffff8802aa0c3ac8  EFLAGS: 00010286
[ 8063.440878] RAX: ffff880323511780 RBX: 0000000000000286 RCX: 0000000000000004
[ 8063.448027] RDX: ffff880323511f08 RSI: 0000000000000000 RDI: ffff880323511701
[ 8063.455168] RBP: ffff8802aa0c3b20 R08: 0000000000000001 R09: 00023e9348964000
[ 8063.462310] R10: ffffffff825d5370 R11: 0000000000000000 R12: 0000000000000000
[ 8063.469451] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[ 8063.476602] FS:  00007f7e17c26700(0000) GS:ffff88042d200000(0000) knlGS:0000000000000000
[ 8063.484705] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8063.490459] CR2: 0000000000000000 CR3: 0000000414dff000 CR4: 00000000000406e0
[ 8063.497607] Stack:
[ 8063.499627]  ffffffff8126ebcf ffff880400000000 0000000000000000 0000000000000286
[ 8063.507114]  00000000aa0c3b08 ffff880427ac3750 ffff880425560000 ffff880427ac3720
[ 8063.514602]  ffff880425560028 0000000000000000 ffff88008e98fe00 ffff8802aa0c3bb0
[ 8063.522090] Call Trace:
[ 8063.524547]  [<ffffffff8126ebcf>] ? start_this_handle+0x10f/0x420
[ 8063.530655]  [<ffffffff8126ec30>] start_this_handle+0x170/0x420
[ 8063.536582]  [<ffffffff8126ebcf>] ? start_this_handle+0x10f/0x420
[ 8063.542682]  [<ffffffff8126e691>] ? new_handle+0x21/0x60
[ 8063.548004]  [<ffffffff8126f34c>] jbd2__journal_start+0xbc/0x290
[ 8063.554020]  [<ffffffff8121bf1e>] ? ext4_da_write_begin+0x12e/0x3c0
[ 8063.560301]  [<ffffffff812499f9>] __ext4_journal_start_sb+0xa9/0x1f0
[ 8063.566662]  [<ffffffff8121bf1e>] ext4_da_write_begin+0x12e/0x3c0
[ 8063.572798]  [<ffffffff81133f42>] generic_perform_write+0xc2/0x1a0
[ 8063.578987]  [<ffffffff811a9b45>] ? file_update_time+0x45/0xf0
[ 8063.584829]  [<ffffffff81135b38>] __generic_file_write_iter+0x198/0x1f0
[ 8063.591458]  [<ffffffff810a916a>] ? __lock_acquire+0x55a/0x1f80
[ 8063.597385]  [<ffffffff812100bd>] ext4_file_write_iter+0xfd/0x470
[ 8063.603486]  [<ffffffff811ac78e>] ? __fget+0x11e/0x210
[ 8063.608633]  [<ffffffff810a2cb4>] ? percpu_down_read+0x44/0x90
[ 8063.614476]  [<ffffffff8118d47d>] __vfs_write+0xad/0xe0
[ 8063.619709]  [<ffffffff8118dcd5>] vfs_write+0xb5/0x1a0
[ 8063.624857]  [<ffffffff8118e912>] SyS_write+0x52/0xc0
[ 8063.629919]  [<ffffffff816e2d5b>] entry_SYSCALL_64_fastpath+0x16/0x6f
[ 8063.636400] Code:  Bad RIP value.
[ 8063.639762] RIP  [<          (null)>]           (null)
[ 8063.644935]  RSP <ffff8802aa0c3ac8>
[ 8063.648428] CR2: 0000000000000000
[ 8063.659798] ---[ end trace a8175120fb0cb0d5 ]---
[ 8109.519651] sysrq: SysRq : HELP : loglevel(0-9) reboot(b) crash(c) show-all-locks(d) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) force-fb(V) show-blocked-tasks(w) dump-ftrace-buffer(z)

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
