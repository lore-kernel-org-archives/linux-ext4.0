From: Sami Liedes <sami.liedes@iki.fi>
Subject: ext4: Use of uninitialized memory in error path w/ corrupted
 filesystem
Date: Mon, 7 May 2012 04:33:02 +0300
Message-ID: <20120507013301.GG13332@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="it/zdz3K1bH9Y8/E"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:49885 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab2EGBdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 May 2012 21:33:09 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q471X64i000494
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2012 04:33:06 +0300
Received: from smtp-1.hut.fi ([130.233.228.91])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 21441-445 for <linux-ext4@vger.kernel.org>;
 Mon,  7 May 2012 04:33:06 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q471X2mB000490
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2012 04:33:02 +0300
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--it/zdz3K1bH9Y8/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

When accessing corrupted ext4 filesystems on a mainline 3.3.4 kernel,
I can occasionally trigger a kmemcheck warning on use of uninitialized
memory. I don't quite know what the code should be doing, so I'll just
resort to describing what it seems to me to do :) I can also provide a
small test filesystem that triggers this if you think that would be
helpful (it again differs from a pristine filesystem by only one
bit...).

Here's the warning:

------------------------------------------------------------
[  138.712041] WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff880005052108)
[  138.713146] 00000000000000000000000000000000000000000000000001000000ad4eadde
[  138.714387]  u u u u i i i i u u u u u u u u i i i i i i i i i i i i i i i i
[  138.715636]                  ^
[  138.716032]
[  138.716233] Pid: 1435, comm: touch Not tainted 3.3.4 #6 Bochs Bochs
[  138.717054] RIP: 0010:[<ffffffff811db960>]  [<ffffffff811db960>] ext4_evict_inode+0x220/0x490
[  138.718142] RSP: 0018:ffff88000618fb48  EFLAGS: 00010206
[  138.718817] RAX: 0000000000000800 RBX: ffff880005052208 RCX: ffff88000606d698
[  138.719719] RDX: 000000008c02c810 RSI: 0000000000000000 RDI: ffff880005052208
[  138.720644] RBP: ffff88000618fb68 R08: 0000000000000000 R09: 0000000000000001
[  138.721542] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880005052398
[  138.722442] R13: ffffffff818227c0 R14: ffffffff818227c0 R15: ffff880006191000
[  138.723341] FS:  0000000000000000(0000) GS:ffffffff81c1d000(0063) knlGS:00000000f760a6c0
[  138.724376] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  138.725094] CR2: ffff880006758000 CR3: 0000000004979000 CR4: 00000000000006b0
[  138.725981] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.726870] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  138.727754]  [<ffffffff81106697>] evict+0xa7/0x1b0
[  138.728390]  [<ffffffff81107425>] iput+0x105/0x210
[  138.729003]  [<ffffffff81108961>] iget_failed+0x21/0x30
[  138.729668]  [<ffffffff811d7356>] ext4_iget+0x3d6/0x810
[  138.730333]  [<ffffffff811dfa75>] ext4_lookup+0xa5/0x120
[  138.731008]  [<ffffffff810f7a80>] d_alloc_and_lookup+0x40/0x80
[  138.731747]  [<ffffffff810f7dff>] __lookup_hash.part.27+0xbf/0xe0
[  138.732582]  [<ffffffff810f81f8>] lookup_hash+0x48/0x60
[  138.733246]  [<ffffffff810faf22>] do_last.isra.32+0x382/0x7f0
[  138.733974]  [<ffffffff810fb456>] path_openat+0xc6/0x380
[  138.734650]  [<ffffffff810fb74d>] do_filp_open+0x3d/0xa0
[  138.735328]  [<ffffffff810ecfc3>] do_sys_open+0xf3/0x1d0
[  138.736026]  [<ffffffff81138466>] compat_sys_open+0x16/0x20
[  138.736733]  [<ffffffff8171daf1>] sysenter_dispatch+0x7/0x2a
[  138.737453]  [<ffffffffffffffff>] 0xffffffffffffffff
...
[  138.772505] EXT4-fs error (device vdb): ext4_lookup:1044: inode #12: comm touch: deleted inode referenced: 1202
[  138.783665] EXT4-fs error (device vdb): ext4_lookup:1044: inode #12: comm touch: deleted inode referenced: 1202
------------------------------------------------------------

Here's my take on what is happening:

ext4_iget() called iget_locked(), which I assume called
ext4_alloc_inode(). ext4_alloc_inode() does not initialize i_flags of
the ext4_inode_info structure.

ext4_iget() only initializes i_flags after it has had two
opportunities to goto bad_inode:

------------------------------------------------------------
struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
{
        struct ext4_iloc iloc;
        struct ext4_inode *raw_inode;
        struct ext4_inode_info *ei;
        struct inode *inode;
...
        inode = iget_locked(sb, ino);
...
        ret = __ext4_get_inode_loc(inode, &iloc, 0);
        if (ret < 0)
                goto bad_inode;
        raw_inode = ext4_raw_inode(&iloc);
...
        if (inode->i_nlink == 0) {
                if (inode->i_mode == 0 ||
                    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) {
                        /* this inode is deleted */
                        ret = -ESTALE;
                        goto bad_inode;
                }
                /* The only unlinked inodes we let through here have
                 * valid i_mode and are being read by the orphan
                 * recovery code: that's fine, we're about to complete
                 * the process of deleting those. */
        }
        ei->i_flags = le32_to_cpu(raw_inode->i_flags);
...
bad_inode:
        brelse(iloc.bh);
        iget_failed(inode);
        return ERR_PTR(ret);
}
------------------------------------------------------------

iget_failed() calls iput(), which calls evict(), which in turn calls
ext4_evict_inode(), the point where the warning occured:

------------------------------------------------------------
[  138.717054] RIP: 0010:[<ffffffff811db960>]  [<ffffffff811db960>] ext4_evict_inode+0x220/0x490
------------------------------------------------------------

This is in ext4_inode_journal_mode() in fs/ext4/ext4_jbd2.h:279. What
I think happens is that ext4_evict_inode() calls
ext4_should_journal_data() for the inode:

------------------------------------------------------------
void ext4_evict_inode(struct inode *inode)
{
...
        if (inode->i_nlink) {
...
                if (ext4_should_journal_data(inode) &&
                    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
...
		}
...
	}

        if (!is_bad_inode(inode))
                dquot_initialize(inode);
...
}
------------------------------------------------------------

ext4_should_journal_data() in turn calls ext4_inode_journal_mode(),
accesses the i_flags variable in the ext4_inode_info structure that
contains the fs inode. However this variable has never been
initialized.

------------------------------------------------------------
static inline int ext4_inode_journal_mode(struct inode *inode)
{
...
        if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
            !test_opt(inode->i_sb, DELALLOC))
                return EXT4_INODE_JOURNAL_DATA_MODE;    /* journal data */
...
}
------------------------------------------------------------

The backtrace deciphered:

------------------------------------------------------------
[  138.717054] RIP: 0010:[<ffffffff811db960>]  [<ffffffff811db960>] ext4_evict_inode+0x220/0x490
	in ext4_evict_inode at fs/ext4/ext4_jbd2.h:279
...
[  138.727754]  [<ffffffff81106697>] evict+0xa7/0x1b0
	in evict at fs/inode.c:545
[  138.728390]  [<ffffffff81107425>] iput+0x105/0x210
	in iput at fs/inode.c:1427
[  138.729003]  [<ffffffff81108961>] iget_failed+0x21/0x30
	in iget_failed at fs/bad_inode.c:359
[  138.729668]  [<ffffffff811d7356>] ext4_iget+0x3d6/0x810
	in ext4_iget at fs/ext4/inode.c:3812
[  138.730333]  [<ffffffff811dfa75>] ext4_lookup+0xa5/0x120
	in ext4_lookup at fs/ext4/namei.c:1040
[  138.731008]  [<ffffffff810f7a80>] d_alloc_and_lookup+0x40/0x80
[  138.731747]  [<ffffffff810f7dff>] __lookup_hash.part.27+0xbf/0xe0
[  138.732582]  [<ffffffff810f81f8>] lookup_hash+0x48/0x60
[  138.733246]  [<ffffffff810faf22>] do_last.isra.32+0x382/0x7f0
[  138.733974]  [<ffffffff810fb456>] path_openat+0xc6/0x380
[  138.734650]  [<ffffffff810fb74d>] do_filp_open+0x3d/0xa0
[  138.735328]  [<ffffffff810ecfc3>] do_sys_open+0xf3/0x1d0
[  138.736026]  [<ffffffff81138466>] compat_sys_open+0x16/0x20
[  138.736733]  [<ffffffff8171daf1>] sysenter_dispatch+0x7/0x2a
[  138.737453]  [<ffffffffffffffff>] 0xffffffffffffffff
------------------------------------------------------------

Here's the entire dmesg output; you may wish to note that it has a
couple other kmemcheck warnings too. The first one in particular
happens before any filesystems have been mounted.

------------------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.4 (sliedes@lh) (gcc version 4.6.3 (Debian 4.6.3-5) ) #6 Sun May 6 21:24:04 EEST 2012
[    0.000000] Command line: root=/dev/vda console=ttyS0,115200n8 fstest.fstype=ext4 fstest.seed_start=0 fstest.seed_increment=1 fstest.repeat=1 fstest.hung_task_timeout=90 fstest.no_fuzz
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099c00 (usable)
[    0.000000]  BIOS-e820: 0000000000099c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000007ffd000 (usable)
[    0.000000]  BIOS-e820: 0000000007ffd000 - 0000000008000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7ffd max_arch_pfn = 0x400000000
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [ffff8800000fdaf0] fdaf0
[    0.000000] init_memory_mapping: 0000000000000000-0000000007ffd000
[    0.000000] ACPI: RSDP 00000000000fd990 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000007ffd7b0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000007ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000007ffd9b0 02589 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000007ffff40 00040
[    0.000000] ACPI: SSDT 0000000007ffd910 0009E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000007ffd830 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000007ffd7f0 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1c241c1, boot clock
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x00007ffd
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c24140
[    0.000000] Allocating PCI resources starting at 8000000 (gap: 8000000:f6ffc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32129
[    0.000000] Kernel command line: root=/dev/vda console=ttyS0,115200n8 fstest.fstype=ext4 fstest.seed_start=0 fstest.seed_increment=1 fstest.repeat=1 fstest.hung_task_timeout=90 fstest.no_fuzz
[    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 104748k/131060k available (7295k kernel code, 476k absent, 25836k reserved, 5740k data, 440k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour *CGA 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] Detected 3411.126 MHz processor.
[    0.008000] Calibrating delay loop (skipped) preset value.. 6822.25 BogoMIPS (lpj=13644504)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.048415] Mount-cache hash table entries: 256
[    0.131745] Initializing cgroup subsys cpuacct
[    0.132111] Initializing cgroup subsys devices
[    0.133386] Initializing cgroup subsys freezer
[    0.134646] Initializing cgroup subsys blkio
[    0.155721] CPU: Intel QEMU Virtual CPU version 1.0 stepping 03
[    0.158870] ACPI: Core revision 20120111
[    1.707133] Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
[    1.709241] kmemcheck: Initialized
[    1.736371] NMI watchdog disabled (cpu0): hardware events not enabled
[    1.745995] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.865997] NET: Registered protocol family 16
[    1.967105] ACPI: bus type pci registered
[    1.978763] dca service started, version 1.12.1
[    1.990048] PCI: Using configuration type 1 for base access
[    3.201704] bio: create slab <bio-0> at 0
[    3.238354] ACPI: Added _OSI(Module Device)
[    3.240446] ACPI: Added _OSI(Processor Device)
[    3.241259] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.242161] ACPI: Added _OSI(Processor Aggregator Device)
[    6.098537] ACPI: Interpreter enabled
[    6.099029] ACPI: (supports S0 S3 S5)
[    6.106378] ACPI: Using IOAPIC for interrupt routing
[    8.855026] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    8.866334] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    8.904007] PCI host bridge to bus 0000:00
[    8.904651] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    8.906230] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    8.928977] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    8.931026] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    9.535582]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
[   12.937003] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   12.967673] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   12.998644] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   13.029646] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   13.060815] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   13.112611] vgaarb: loaded
[   13.187884] SCSI subsystem initialized
[   13.255943] PCI: Using ACPI for IRQ routing
[   13.331681] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[   13.342213] Switching to clocksource kvm-clock
[   25.003552] FS-Cache: Loaded
[   25.012855] sched: RT throttling activated
[   25.022403] CacheFiles: Loaded
[   25.035926] pnp: PnP ACPI init
[   25.038513] ACPI: bus type pnp registered
[   25.629270] pnp: PnP ACPI: found 8 devices
[   25.630456] ACPI: ACPI bus type pnp unregistered
[   27.058258] NET: Registered protocol family 2
[   27.080754] IP route cache hash table entries: 1024 (order: 1, 8192 bytes)
[   27.212242] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[   27.221673] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[   27.223799] TCP: Hash tables configured (established 4096 bind 4096)
[   27.225401] TCP reno registered
[   27.226203] UDP hash table entries: 64 (order: 1, 10240 bytes)
[   27.246073] UDP-Lite hash table entries: 64 (order: 1, 10240 bytes)
[   27.295031] NET: Registered protocol family 1
[   27.300888] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   27.303126] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   27.306843] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   27.446233] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   27.592401] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   27.626101] VFS: Disk quotas dquot_6.5.2
[   27.636175] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   27.723035] DLM installed
[   27.799971] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   27.898356] NTFS driver 2.1.30 [Flags: R/W].
[   27.915806] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   27.921915] ROMFS MTD (C) 2007 Red Hat, Inc.
[   27.928781] QNX4 filesystem 0.2.3 registered.
[   27.964473] JFS: nTxBlock = 818, nTxLock = 6546
[   27.973616] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   28.058914] SGI XFS Quota Management subsystem
[   28.075371] NILFS version 2 loaded
[   28.076346] BeFS version: 0.9.3
[   28.080804] OCFS2 1.5.0
[   28.103901] ocfs2: Registered cluster interface o2cb
[   28.120627] ocfs2: Registered cluster interface user
[   28.121951] OCFS2 DLMFS 1.5.0
[   28.127072] OCFS2 User DLM kernel interface loaded
[   28.128337] OCFS2 Node Manager 1.5.0
[   28.182265] OCFS2 DLM 1.5.0
[   28.248058] Btrfs loaded
[   28.279973] GFS2 installed
[   28.281762] msgmni has been set to 204
[   28.366024] Refined TSC clocksource calibration: 3411.135 MHz.
[   28.368796] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   28.370635] io scheduler noop registered
[   28.371607] io scheduler deadline registered
[   28.379306] io scheduler cfq registered (default)
[   28.473215] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   28.476170] ACPI: Power Button [PWRF]
[   28.606389] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   28.710744] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   28.783234] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[   28.858796] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   28.919223] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   28.992447] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   29.153363] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   29.247006] Non-volatile memory driver v1.3
[   29.257765] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   29.258840] Hangcheck: Using getrawmonotonic().
[   29.276032] ramoops: platform device not found, using module parameters
[   29.292689] ramoops: The memory size and the record size must be non-zero
[   29.294194] ramoops: probe of ramoops failed with error -22
[   30.385291] brd: module loaded
[   31.004817] loop: module loaded
[   31.199596] WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (ffff880006702938)
[   31.201818] 0000000000000000000000000000000000000000000000000000000000000000
[   31.204106]  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u
[   31.206361]                                                  ^
[   31.207796]
[   31.208211] Pid: 1, comm: swapper Not tainted 3.3.4 #6 Bochs Bochs
[   31.209773] RIP: 0010:[<ffffffff815f15ef>]  [<ffffffff815f15ef>] blk_done+0x8f/0x120
[   31.211688] RSP: 0018:ffffffff81c20e58  EFLAGS: 00010086
[   31.213038] RAX: ffff880006702900 RBX: ffff880006728000 RCX: 0000000000000080
[   31.214788] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff810e8cdf
[   31.216555] RBP: ffffffff81c20e88 R08: 0000000000000001 R09: ffff8800067038c0
[   31.218310] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000086
[   31.220072] R13: ffff880006702900 R14: ffff880007893828 R15: ffffffff810b2e90
[   31.221838] FS:  0000000000000000(0000) GS:ffffffff81c1d000(0000) knlGS:0000000000000000
[   31.223827] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   31.225279] CR2: ffff880006620488 CR3: 0000000001c0c000 CR4: 00000000000006b0
[   31.227039] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   31.228812] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[   31.230565]  [<ffffffff815b34df>] vring_interrupt+0x2f/0x40
[   31.231964]  [<ffffffff8108bf3e>] handle_irq_event_percpu+0x5e/0x230
[   31.233566]  [<ffffffff8108c153>] handle_irq_event+0x43/0x70
[   31.234970]  [<ffffffff8108e69f>] handle_edge_irq+0x6f/0x110
[   31.236412]  [<ffffffff810035ad>] handle_irq+0x1d/0x30
[   31.237703]  [<ffffffff810034a2>] do_IRQ+0x52/0xd0
[   31.238899]  [<ffffffff8171c1b1>] ret_from_intr+0x0/0x19
[   31.240255]  [<ffffffff810b2e99>] sleep_on_page+0x9/0x10
[   31.241589]  [<ffffffff81718e21>] __wait_on_bit_lock+0x51/0xb0
[   31.243036]  [<ffffffff810b3901>] __lock_page+0x61/0x70
[   31.244364]  [<ffffffff810b3c98>] do_read_cache_page+0x158/0x180
[   31.245859]  [<ffffffff810b50f7>] read_cache_page_async+0x17/0x20
[   31.247370]  [<ffffffff810b5139>] read_cache_page+0x9/0x20
[   31.248331]  [<ffffffff8153b0eb>] read_dev_sector+0x2b/0x90
[   31.248867]  [<ffffffff8153bbf1>] msdos_partition+0x81/0x5c0
[   31.249407]  [<ffffffff8153b248>] check_partition+0xf8/0x210
[   31.249945]  [<ffffffff8153ae42>] rescan_partitions+0xb2/0x290
[   31.250515]  [<ffffffff81122633>] __blkdev_get+0x383/0x470
[   31.251203]  [<ffffffff8112276e>] blkdev_get+0x4e/0x320
[   31.251863]  [<ffffffff815389d5>] add_disk+0x3f5/0x490
[   31.252534]  [<ffffffff8170c21e>] virtblk_probe+0x497/0x53b
[   31.253236]  [<ffffffff815b2ba1>] virtio_dev_probe+0xe1/0x130
[   31.253953]  [<ffffffff815e5362>] driver_probe_device+0x72/0x190
[   31.254705]  [<ffffffff815e5523>] __driver_attach+0xa3/0xb0
[   31.255406]  [<ffffffff815e3b46>] bus_for_each_dev+0x56/0x90
[   31.256129]  [<ffffffff815e5659>] driver_attach+0x19/0x20
[   31.256808]  [<ffffffff815e44f8>] bus_add_driver+0x198/0x260
[   31.257518]  [<ffffffff815e5ec1>] driver_register+0x71/0x140
[   31.258232]  [<ffffffff815b2ceb>] register_virtio_driver+0x1b/0x30
[   31.259001]  [<ffffffff81ce372e>] init+0x59/0x83
[   31.259586]  [<ffffffff81cbdb6d>] do_one_initcall+0x78/0x136
[   31.260715]  [<ffffffff81cbdce9>] kernel_init+0xbe/0x138
[   31.280925]  vda: unknown partition table
[   31.515293]  vdb: unknown partition table
[   31.741586]  vdc: unknown partition table
[   31.851895] Loading iSCSI transport class v2.0-870.
[   32.537256] tun: Universal TUN/TAP device driver, 1.6
[   32.537904] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   32.583440] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   32.605779] serio: i8042 KBD port at 0x60,0x64 irq 1
[   32.607073] serio: i8042 AUX port at 0x60,0x64 irq 12
[   32.652135] mousedev: PS/2 mouse device common for all mice
[   32.725947] rtc_cmos 00:01: RTC can wake from S4
[   32.759953] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[   32.762077] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[   32.778546] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   32.913406] cpuidle: using governor ladder
[   32.913997] cpuidle: using governor menu
[   32.914493] padlock_sha: VIA PadLock Hash Engine not detected.
[   33.021978] TCP cubic registered
[   33.022888] Initializing XFRM netlink socket
[   33.026849] NET: Registered protocol family 17
[   33.036299] NET: Registered protocol family 15
[   33.052078] sctp: Hash tables configured (established 585 bind 512)
[   33.103720] Registering the dns_resolver key type
[   33.159060] registered taskstats version 1
[   33.195785] console [netcon0] enabled
[   33.196264] netconsole: network logging started
[   33.197989] rtc_cmos 00:01: setting system clock to 2012-05-06 23:40:39 UTC (1336347639)
[   33.323047] kjournald starting.  Commit interval 5 seconds
[   33.330690] EXT3-fs (vda): mounted filesystem with ordered data mode
[   33.332791] VFS: Mounted root (ext3 filesystem) readonly on device 254:0.
[   33.335083] Freeing unused kernel memory: 440k freed
[   33.335767] Write protecting the kernel read-only data: 12288k
[   33.338697] Freeing unused kernel memory: 880k freed
[   33.341920] Freeing unused kernel memory: 1352k freed
[  124.220003] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: errors=continue
[  138.712041] WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff880005052108)
[  138.713146] 00000000000000000000000000000000000000000000000001000000ad4eadde
[  138.714387]  u u u u i i i i u u u u u u u u i i i i i i i i i i i i i i i i
[  138.715636]                  ^
[  138.716032]
[  138.716233] Pid: 1435, comm: touch Not tainted 3.3.4 #6 Bochs Bochs
[  138.717054] RIP: 0010:[<ffffffff811db960>]  [<ffffffff811db960>] ext4_evict_inode+0x220/0x490
[  138.718142] RSP: 0018:ffff88000618fb48  EFLAGS: 00010206
[  138.718817] RAX: 0000000000000800 RBX: ffff880005052208 RCX: ffff88000606d698
[  138.719719] RDX: 000000008c02c810 RSI: 0000000000000000 RDI: ffff880005052208
[  138.720644] RBP: ffff88000618fb68 R08: 0000000000000000 R09: 0000000000000001
[  138.721542] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880005052398
[  138.722442] R13: ffffffff818227c0 R14: ffffffff818227c0 R15: ffff880006191000
[  138.723341] FS:  0000000000000000(0000) GS:ffffffff81c1d000(0063) knlGS:00000000f760a6c0
[  138.724376] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  138.725094] CR2: ffff880006758000 CR3: 0000000004979000 CR4: 00000000000006b0
[  138.725981] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.726870] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  138.727754]  [<ffffffff81106697>] evict+0xa7/0x1b0
[  138.728390]  [<ffffffff81107425>] iput+0x105/0x210
[  138.729003]  [<ffffffff81108961>] iget_failed+0x21/0x30
[  138.729668]  [<ffffffff811d7356>] ext4_iget+0x3d6/0x810
[  138.730333]  [<ffffffff811dfa75>] ext4_lookup+0xa5/0x120
[  138.731008]  [<ffffffff810f7a80>] d_alloc_and_lookup+0x40/0x80
[  138.731747]  [<ffffffff810f7dff>] __lookup_hash.part.27+0xbf/0xe0
[  138.732582]  [<ffffffff810f81f8>] lookup_hash+0x48/0x60
[  138.733246]  [<ffffffff810faf22>] do_last.isra.32+0x382/0x7f0
[  138.733974]  [<ffffffff810fb456>] path_openat+0xc6/0x380
[  138.734650]  [<ffffffff810fb74d>] do_filp_open+0x3d/0xa0
[  138.735328]  [<ffffffff810ecfc3>] do_sys_open+0xf3/0x1d0
[  138.736026]  [<ffffffff81138466>] compat_sys_open+0x16/0x20
[  138.736733]  [<ffffffff8171daf1>] sysenter_dispatch+0x7/0x2a
[  138.737453]  [<ffffffffffffffff>] 0xffffffffffffffff
[  138.740941] WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (ffff880006186578)
[  138.742023] 0200000000000000890000000903636f6e74726f6c4331000000000000000000
[  138.743264]  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u
[  138.744559]                                                  ^
[  138.745296]
[  138.745499] Pid: 3, comm: ksoftirqd/0 Not tainted 3.3.4 #6 Bochs Bochs
[  138.746348] RIP: 0010:[<ffffffff815f15ef>]  [<ffffffff815f15ef>] blk_done+0x8f/0x120
[  138.747259] RSP: 0018:ffffffff81c20e58  EFLAGS: 00010082
[  138.747754] RAX: ffff880006186540 RBX: ffff880006758000 RCX: 0000000000000080
[  138.748464] RDX: 00000000000002dd RSI: 000000000000000d RDI: ffffffff810e8cdf
[  138.749124] RBP: ffffffff81c20e88 R08: 0000000000000001 R09: ffff880004dabcc0
[  138.749781] R10: 0000000000000001 R11: 0000000000000125 R12: 0000000000000086
[  138.750439] R13: ffff880006186540 R14: ffff8800078a1d08 R15: 0000000000000002
[  138.751097] FS:  0000000000000000(0000) GS:ffffffff81c1d000(0000) knlGS:0000000000000000
[  138.751836] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  138.752369] CR2: ffff880006753c88 CR3: 0000000004979000 CR4: 00000000000006b0
[  138.753010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.753646] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  138.754281]  [<ffffffff815b34df>] vring_interrupt+0x2f/0x40
[  138.754797]  [<ffffffff8108bf3e>] handle_irq_event_percpu+0x5e/0x230
[  138.755383]  [<ffffffff8108c153>] handle_irq_event+0x43/0x70
[  138.755909]  [<ffffffff8108e69f>] handle_edge_irq+0x6f/0x110
[  138.757607]  [<ffffffff810035ad>] handle_irq+0x1d/0x30
[  138.758898]  [<ffffffff810034a2>] do_IRQ+0x52/0xd0
[  138.760118]  [<ffffffff8171c1b1>] ret_from_intr+0x0/0x19
[  138.761451]  [<ffffffff8105e00c>] finish_task_switch.constprop.68+0x7c/0xd0
[  138.763179]  [<ffffffff8171a905>] __schedule+0x2c5/0x5c0
[  138.764529]  [<ffffffff8171ac39>] schedule+0x39/0x50
[  138.765764]  [<ffffffff81039f3d>] run_ksoftirqd+0xed/0x120
[  138.767122]  [<ffffffff8105376d>] kthread+0x8d/0xa0
[  138.768366]  [<ffffffff8171d944>] kernel_thread_helper+0x4/0x10
[  138.769854]  [<ffffffffffffffff>] 0xffffffffffffffff
[  138.772505] EXT4-fs error (device vdb): ext4_lookup:1044: inode #12: comm touch: deleted inode referenced: 1202
[  138.783665] EXT4-fs error (device vdb): ext4_lookup:1044: inode #12: comm touch: deleted inode referenced: 1202
[  152.724312] WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff88000593c2c8)
[  152.730391] 00000000000000000000000000000000000000000000000001000000ad4eadde
[  152.731715]  u u u u i i i i u u u u u u u u i i i i i i i i i i i i i i i i
[  152.733979]                  ^
[  152.734737]
[  152.735122] Pid: 1555, comm: rm Not tainted 3.3.4 #6 Bochs Bochs
[  152.736654] RIP: 0010:[<ffffffff811db960>]  [<ffffffff811db960>] ext4_evict_inode+0x220/0x490
[  152.738732] RSP: 0018:ffff880004e67c98  EFLAGS: 00010206
[  152.740047] RAX: 0000000000000800 RBX: ffff88000593c3c8 RCX: ffff88000606d698
[  152.741771] RDX: 000000008c02c810 RSI: 0000000000000000 RDI: ffff88000593c3c8
[  152.743503] RBP: ffff880004e67cb8 R08: 0000000000000000 R09: 0000000000000001
[  152.745262] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000593c558
[  152.747014] R13: ffffffff818227c0 R14: ffffffff818227c0 R15: ffff880006191000
[  152.748786] FS:  0000000000000000(0000) GS:ffffffff81c1d000(0063) knlGS:00000000f75ab8d0
[  152.750776] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  152.752198] CR2: ffff880006753c88 CR3: 000000000496d000 CR4: 00000000000006b0
[  152.753936] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.755685] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  152.757503]  [<ffffffff81106697>] evict+0xa7/0x1b0
[  152.758718]  [<ffffffff81107425>] iput+0x105/0x210
[  152.759906]  [<ffffffff81108961>] iget_failed+0x21/0x30
[  152.761244]  [<ffffffff811d7356>] ext4_iget+0x3d6/0x810
[  152.762544]  [<ffffffff811dfa75>] ext4_lookup+0xa5/0x120
[  152.763865]  [<ffffffff810f7a80>] d_alloc_and_lookup+0x40/0x80
[  152.765353]  [<ffffffff810f7dff>] __lookup_hash.part.27+0xbf/0xe0
[  152.766875]  [<ffffffff810f81f8>] lookup_hash+0x48/0x60
[  152.768207]  [<ffffffff810fc33f>] do_unlinkat+0x9f/0x1c0
[  152.769530]  [<ffffffff810fc47d>] sys_unlinkat+0x1d/0x40
[  152.770852]  [<ffffffff8171daf1>] sysenter_dispatch+0x7/0x2a
[  152.772284]  [<ffffffffffffffff>] 0xffffffffffffffff
[  152.773516] WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (ffff880004940438)
[  152.775609] 02000000000000000200000002022e2e00000000000000000000000000000000
[  152.777870]  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u
[  152.780153]                                                  ^
[  152.781577]
[  152.781963] Pid: 1555, comm: rm Not tainted 3.3.4 #6 Bochs Bochs
[  152.783459] RIP: 0010:[<ffffffff815f15ef>]  [<ffffffff815f15ef>] blk_done+0x8f/0x120
[  152.785392] RSP: 0018:ffffffff81c20b80  EFLAGS: 00010086
[  152.786688] RAX: ffff880004940400 RBX: ffff880006758000 RCX: 0000000000000080
[  152.788446] RDX: 00000000000002e5 RSI: 000000000000000c RDI: ffffffff810e8cdf
[  152.790185] RBP: ffffffff81c20bb0 R08: 0000000000000001 R09: ffff880004941180
[  152.791919] R10: 0000000000000001 R11: 0000000000000125 R12: 0000000000000086
[  152.793684] R13: ffff880004940400 R14: ffffffff81c20cc8 R15: 0044b82fa09b5a53
[  152.795418] FS:  0000000000000000(0000) GS:ffffffff81c1d000(0063) knlGS:00000000f75ab8d0
[  152.797418] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  152.798829] CR2: ffff880006753c88 CR3: 000000000496d000 CR4: 00000000000006b0
[  152.800588] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.802326] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  152.804086]  [<ffffffff815b34df>] vring_interrupt+0x2f/0x40
[  152.805467]  [<ffffffff8108bf3e>] handle_irq_event_percpu+0x5e/0x230
[  152.807035]  [<ffffffff8108c153>] handle_irq_event+0x43/0x70
[  152.808457]  [<ffffffff8108e69f>] handle_edge_irq+0x6f/0x110
[  152.809858]  [<ffffffff810035ad>] handle_irq+0x1d/0x30
[  152.811137]  [<ffffffff810034a2>] do_IRQ+0x52/0xd0
[  152.812355]  [<ffffffff8171c1b1>] ret_from_intr+0x0/0x19
[  152.813677]  [<ffffffff81711189>] printk+0x3c/0x3e
[  152.814873]  [<ffffffff810259ec>] kmemcheck_error_recall+0xdc/0x1d0
[  152.816442]  [<ffffffff81025af5>] do_wakeup+0x15/0x50
[  152.817696]  [<ffffffff81039757>] tasklet_hi_action+0x67/0x110
[  152.819128]  [<ffffffff81039cec>] __do_softirq+0xac/0x210
[  152.820492]  [<ffffffff8171da3a>] call_softirq+0x1a/0x30
[  152.821807]  [<ffffffff81003665>] do_softirq+0xa5/0xe0
[  152.823088]  [<ffffffff8103a06e>] irq_exit+0x8e/0xb0
[  152.824338]  [<ffffffff810187fa>] smp_apic_timer_interrupt+0x5a/0x90
[  152.825917]  [<ffffffff8171d431>] apic_timer_interrupt+0x71/0x80
[  152.827407]  [<ffffffff81531397>] blk_queue_bio+0x297/0x3d0
[  152.828812]  [<ffffffff8152fd42>] generic_make_request+0xc2/0x100
[  152.830319]  [<ffffffff8152fdef>] submit_bio+0x6f/0xe0
[  152.831589]  [<ffffffff8111c323>] submit_bh+0xe3/0x110
[  152.832909]  [<ffffffff8111c77a>] __sync_dirty_buffer+0x4a/0xc0
[  152.834383]  [<ffffffff8111c7fe>] sync_dirty_buffer+0xe/0x10
[  152.835788]  [<ffffffff811f3ee8>] ext4_commit_super+0x158/0x1c0
[  152.837277]  [<ffffffff811f411e>] save_error_info+0x1e/0x30
[  152.838671]  [<ffffffff811f567e>] ext4_error_inode+0x5e/0x110
[  152.840134]  [<ffffffff811dfaba>] ext4_lookup+0xea/0x120
[  152.841465]  [<ffffffff810f7a80>] d_alloc_and_lookup+0x40/0x80
[  152.842922]  [<ffffffff810f7dff>] __lookup_hash.part.27+0xbf/0xe0
[  152.844466]  [<ffffffff810f81f8>] lookup_hash+0x48/0x60
[  152.845780]  [<ffffffff810fc33f>] do_unlinkat+0x9f/0x1c0
[  152.847107]  [<ffffffff810fc47d>] sys_unlinkat+0x1d/0x40
[  152.849143] EXT4-fs error (device vdb): ext4_lookup:1044: inode #12: comm rm: deleted inode referenced: 1202
[  198.778194] ACPI: Preparing to enter system sleep state S5
[  198.786389] Power down.
------------------------------------------------------------

	Sami

--it/zdz3K1bH9Y8/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPpyZNAAoJEKLT589SE0a0ObcP/0X+h2zlZ5kge+xTkoVhQrtx
vUQ6UqoXaExXLHbUxCkd8B9zSMlez/iB8EaE41ZEo1zYbIDP90StT+86P+TQ54Ol
mvf1YBHJcxRmTjPaa9GffArbIr0mWMJxzxqi3TDRkHjDHVwNU6ng/YfxvOxAhoiG
xNCCQiOKt6J2MvSpDjgd2yKa0uV2WrJ0h2FhdtjVEMMZuA2MO/rPzrHNvUl8nrt9
TIIOirZW4AOclBh7V4doLd40x4hJud6K6M18EOw4/p/Q1FnC17a8AQO2pRk1SJeY
zin78MHlMvVY4Tjerv4czDJV0bADAiB5YcIaZgN5slEP5Hvwf+FuhaDItCQ3zj3E
C3ff5sNs/NQEdO9UEEW8PTFKBDKrKU15lpvgYiPqEBLSYHgwI0ATnsNotts2l38Z
wgr2iDioaniJoNSpJut7FGddqN2QOXWkxbxl3/pTnZrPRnrN8rj3gmzIQYbzvD3L
qwDEcYWUGOjXsghXXw2+JdqgBTAdtRwV6q+irvh1E9+x2QTfrXwkWt0XKpv6wuhh
ubzGQwX9DCqq5WaGGUT+b50SnJ3c7X4Nkokcf4D3vDgQE1ictAFQbuLHcnXwnUnG
eEpJUwM+M8vX5DFr0JYQkGQWMdeVBijh8VPuOgz+bqbkN8Fxvcad5MdPC7wfNym8
lRYtB8atVO52e4m9a9Ir
=cQYN
-----END PGP SIGNATURE-----

--it/zdz3K1bH9Y8/E--
