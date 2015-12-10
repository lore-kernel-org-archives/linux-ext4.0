From: Borislav Petkov <bp@alien8.de>
Subject: Re: ext4/jbd splat in 4.4-rc4+
Date: Thu, 10 Dec 2015 17:27:33 +0100
Message-ID: <20151210162733.GA6587@pd.tnic>
References: <20151210140404.GA3049@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151210140404.GA3049@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 10, 2015 at 03:04:04PM +0100, Borislav Petkov wrote:
> Hi guys,
> 
> I'm getting this nasty splat in ext4 land while booting kernels in
> qemu/kvm. Last time it happened while injecting NMIs in the guest using
> the qemu monitor, this time too. Any ideas?
> 
> Sadly, rIP is gone so I can't really pinpoint the problem but someone
> might have an idea.
> 
> Last time it happened, the box froze solid, this time it was barely
> alive so that I was able to suck dmesg out before it crashes completely.
> 
> Any suggestions appreciated.

Hmm, got a second one, again during injecting NMIs in the guest, the
*host* exploded like this. And this time not in ext4 which would mean,
some corruption is happening.

Paolo, any ideas? What happens when I do "nmi" in qemu's monitor, why
does it corrupt the host?

Lemme test plain rc4 in the guest...

[ 3405.741284] kvm: zapping shadow pages for mmio generation wraparound
[ 3451.874613] kvm: zapping shadow pages for mmio generation wraparound
[ 4493.572305] kvm: zapping shadow pages for mmio generation wraparound
[ 4519.739695] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 4519.751390] IP: [<          (null)>]           (null)
[ 4519.760275] PGD 0 
[ 4519.766054] Oops: 0010 [#1] PREEMPT SMP 
[ 4519.773785] Modules linked in: tun sha256_ssse3 sha256_generic drbg binfmt_misc ipv6 vfat fat fuse dm_crypt dm_mod kvm_amd kvm irqbypass crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd fam15h_power k10temp amd64_edac_mod edac_mce_amd amdkfd amd_iommu_v2 radeon acpi_cpufreq
[ 4519.809462] CPU: 4 PID: 32028 Comm: qemu-system-x86 Not tainted 4.4.0-rc4+ #1
[ 4519.820667] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[ 4519.834710] task: ffff880423715e00 ti: ffff88040f3a8000 task.ti: ffff88040f3a8000
[ 4519.846340] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[ 4519.857998] RSP: 0018:ffff88040f3abe38  EFLAGS: 00010286
[ 4519.867492] RAX: ffff880423715e00 RBX: 0000000000000286 RCX: 0000000000000001
[ 4519.867494] RDX: ffff8804237164e0 RSI: 0000000000000000 RDI: ffff880423715e01
[ 4519.867496] RBP: ffff88040f3abe90 R08: 0000000000000000 R09: 0000000000000000
[ 4519.867497] R10: 0000000000000000 R11: 0000000000000007 R12: 0000000000000000
[ 4519.867498] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
[ 4519.867501] FS:  00007ff557300700(0000) GS:ffff88042ce00000(0000) knlGS:0000000000000000
[ 4519.867503] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4519.867505] CR2: 0000000000000000 CR3: 000000040f018000 CR4: 00000000000406e0
[ 4519.867506] Stack:
[ 4519.867511]  ffffffff811ac675 ffff880400000000 0000000000000000 0000000000000286
[ 4519.867515]  000000000f3abe78 ffffffff81a3c1e0 ffff8804288616c0 0000000000000009
[ 4519.867519]  0000000000000000 0000000000004000 00007ff5572ffab0 ffff88040f3abed8
[ 4519.867520] Call Trace:
[ 4519.867529]  [<ffffffff811ac675>] ? __fget+0x5/0x210
[ 4519.867535]  [<ffffffff811ac6c4>] __fget+0x54/0x210
[ 4519.867540]  [<ffffffff811ac675>] ? __fget+0x5/0x210
[ 4519.867545]  [<ffffffff810a6a42>] ? trace_hardirqs_on_caller+0xf2/0x210
[ 4519.867551]  [<ffffffff811ac8e9>] __fget_light+0x29/0x90
[ 4519.867562]  [<ffffffff811ac963>] __fdget+0x13/0x20
[ 4519.867565]  [<ffffffff811a0bbf>] SyS_ioctl+0x2f/0x90
[ 4519.867571]  [<ffffffff816e2d5b>] entry_SYSCALL_64_fastpath+0x16/0x6f
[ 4519.867579] Code:  Bad RIP value.
[ 4519.867581] RIP  [<          (null)>]           (null)
[ 4519.867583]  RSP <ffff88040f3abe38>
[ 4519.867584] CR2: 0000000000000000
[ 4519.867655] ---[ end trace faf028eac08ef3a3 ]---

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
