From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
Subject: 3.10.9: EXT4-fs (sdb1): delayed block allocation failed for inode
 163315715 at logical offset 1 with max blocks 2 with error -5
Date: Wed, 28 Aug 2013 13:49:21 +0200
Message-ID: <521DE3C1.8030304@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000002040909030103070009"
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000002040909030103070009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
  I have been running two instances of valgrind on some application on 3.10.9 kernel
with a patch aiming to fix a BOS descriptor memleak (see linux-usb Subject
"[RFC v2] usbcore: compare and release one bos descriptor in usb_reset_and_verify_device()"
but I hope it is unrelated). I enabled in the kernel some extra checks for kernel
sanity in Kernel hacking section (am looking for an answer why something overwrites memory
of my python-based application). Hence the valgrind and attempts to fortify kernel a bit
more (see attached diff since last known good .config).

  Below I show when I early in the morning connected the external SATA drive drive
and that muich later, kernel suddenly lost ability to read/write the filesystem.
I somewhat suspect that laptop-mode-tools (although configured to ignore mouse/keyboard
and usb-storage devices) somehow triggered the cause. However, still I would like to see
that something happened at the SATA level.


Aug 28 04:41:05 vostro kernel: [  248.268202] ata6: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
Aug 28 04:41:05 vostro kernel: [  248.268205] ata6: irq_stat 0x00000040, connection status changed
Aug 28 04:41:05 vostro kernel: [  248.268207] ata6: SError: { DevExch }
Aug 28 04:41:05 vostro kernel: [  248.268212] ata6: hard resetting link
Aug 28 04:41:06 vostro kernel: [  249.009819] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 28 04:41:06 vostro kernel: [  249.010951] ata6.00: ATA-8: ST3000VX000-1CU166, CV22, max UDMA/133
Aug 28 04:41:06 vostro kernel: [  249.010963] ata6.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Aug 28 04:41:06 vostro kernel: [  249.012058] ata6.00: configured for UDMA/133
Aug 28 04:41:06 vostro kernel: [  249.029823] ata6: EH complete
Aug 28 04:41:06 vostro kernel: [  249.030376] scsi 5:0:0:0: Direct-Access     ATA      ST3000VX000-1CU1 CV22 PQ: 0 ANSI: 5
Aug 28 04:41:06 vostro kernel: [  249.032304] sd 5:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Aug 28 04:41:06 vostro kernel: [  249.032306] sd 5:0:0:0: [sdb] 4096-byte physical blocks
Aug 28 04:41:06 vostro kernel: [  249.032623] sd 5:0:0:0: [sdb] Write Protect is off
Aug 28 04:41:06 vostro kernel: [  249.032625] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 28 04:41:06 vostro kernel: [  249.032755] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 28 04:41:06 vostro kernel: [  249.033850] sd 5:0:0:0: Attached scsi generic sg2 type 0
Aug 28 04:41:06 vostro kernel: [  249.089816]  sdb: sdb1
Aug 28 04:41:06 vostro kernel: [  249.091295] sd 5:0:0:0: [sdb] Attached SCSI disk
Aug 28 04:42:51 vostro kernel: [  354.033592] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
Aug 28 09:46:39 vostro kernel: [18604.328975] ata6: exception Emask 0x10 SAct 0x0 SErr 0x4090000 action 0xe frozen
Aug 28 09:46:39 vostro kernel: [18604.328985] ata6: irq_stat 0x00400040, connection status changed
Aug 28 09:46:39 vostro kernel: [18604.328992] ata6: SError: { PHYRdyChg 10B8B DevExch }
Aug 28 09:46:39 vostro kernel: [18604.329007] ata6: hard resetting link
Aug 28 09:46:39 vostro logger: ACPI event unhandled: ac_adapter AC 00000080 00000000
Aug 28 09:46:39 vostro kernel: [18605.089011] ata6: SATA link down (SStatus 0 SControl 300)
Aug 28 09:46:40 vostro laptop-mode: Laptop mode
Aug 28 09:46:40 vostro laptop-mode: enabled, active
Aug 28 09:46:41 vostro logger: ACPI event unhandled: battery BAT0 00000080 00000001
Aug 28 09:46:41 vostro kernel: [18607.033618] ata6: hard resetting link
Aug 28 09:46:42 vostro kernel: [18607.336433] EXT4-fs (sdb1): re-mounted. Opts: commit=600
Aug 28 09:46:42 vostro kernel: [18607.381792] ata6: SATA link down (SStatus 0 SControl 300)
Aug 28 09:46:42 vostro kernel: [18607.381802] ata6: limiting SATA link speed to 1.5 Gbps
Aug 28 09:46:44 vostro logger: Device 2-1.2 is blacklisted, skipping auto suspend.
Aug 28 09:46:44 vostro logger: Device 2-1.2:1.0 is blacklisted, skipping auto suspend.
Aug 28 09:46:45 vostro logger: Device 3-2.4 is blacklisted, skipping auto suspend.
Aug 28 09:46:46 vostro logger: Device 3-2.4:1.0 is blacklisted, skipping auto suspend.
Aug 28 09:46:47 vostro kernel: [18612.387982] ata6: hard resetting link
Aug 28 09:46:47 vostro kernel: [18612.738408] ata6: SATA link down (SStatus 0 SControl 310)
Aug 28 09:46:47 vostro kernel: [18612.738418] ata6.00: disabled
Aug 28 09:46:47 vostro kernel: [18612.738435] ata6: EH complete
Aug 28 09:46:47 vostro kernel: [18612.738546] ata6.00: detaching (SCSI 5:0:0:0)
Aug 28 09:46:47 vostro kernel: [18612.881503] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
Aug 28 09:46:47 vostro kernel: [18612.882157] sd 5:0:0:0: [sdb]
Aug 28 09:46:47 vostro kernel: [18612.882160] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Aug 28 09:46:47 vostro kernel: [18612.882161] sd 5:0:0:0: [sdb] Stopping disk
Aug 28 09:46:47 vostro kernel: [18612.882196] sd 5:0:0:0: [sdb] START_STOP FAILED
Aug 28 09:46:47 vostro kernel: [18612.882197] sd 5:0:0:0: [sdb]
Aug 28 09:46:47 vostro kernel: [18612.882198] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Aug 28 09:46:47 vostro laptop-mode: Laptop mode
Aug 28 09:46:47 vostro laptop-mode: enabled, active [unchanged]
Aug 28 09:47:44 vostro kernel: [18669.259990] ehci-pci 0000:00:1a.0: PME# enabled
Aug 28 09:50:01 vostro cron[6478]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons)
Aug 28 09:56:08 vostro laptop-mode: Laptop mode
Aug 28 09:56:08 vostro laptop-mode: enabled, active [unchanged]
Aug 28 09:56:08 vostro logger: ACPI event unhandled: battery BAT0 00000080 00000001
Aug 28 09:56:08 vostro laptop-mode: Laptop mode
Aug 28 09:56:08 vostro laptop-mode: enabled, active [unchanged]
Aug 28 09:56:08 vostro laptop-mode: Laptop mode
Aug 28 09:56:08 vostro laptop-mode: enabled, not active
Aug 28 09:56:09 vostro kernel: [19175.537671] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
Aug 28 09:56:10 vostro kernel: [19176.076583] ehci-pci 0000:00:1a.0: BAR 0: set to [mem 0xf7f08000-0xf7f083ff] (PCI address [0xf7f08000-0xf7f083ff])
Aug 28 09:56:10 vostro kernel: [19176.076590] ehci-pci 0000:00:1a.0: restoring config space at offset 0x3c (was 0x100, writing 0x10b)
Aug 28 09:56:10 vostro kernel: [19176.076617] ehci-pci 0000:00:1a.0: restoring config space at offset 0x4 (was 0x2900000, writing 0x2900002)
Aug 28 09:56:10 vostro kernel: [19176.089350] ehci-pci 0000:00:1a.0: PME# disabled
Aug 28 09:56:10 vostro kernel: [19176.090810] ehci-pci 0000:00:1a.0: enabling bus mastering
Aug 28 09:56:10 vostro kernel: [19176.090816] ehci-pci 0000:00:1a.0: setting latency timer to 64
Aug 28 09:56:10 vostro logger: ACPI event unhandled: battery BAT0 00000080 00000001
Aug 28 09:56:12 vostro laptop-mode: Laptop mode
Aug 28 09:56:12 vostro laptop-mode: enabled, not active [unchanged]
Aug 28 10:35:08 vostro laptop-mode: Laptop mode
Aug 28 10:35:08 vostro laptop-mode: enabled, not active [unchanged]
Aug 28 10:35:08 vostro logger: ACPI event unhandled: battery BAT0 00000080 00000001
Aug 28 10:35:08 vostro laptop-mode: Laptop mode
Aug 28 10:35:08 vostro laptop-mode: enabled, not active [unchanged]


but later on, suddenly, without any other related message in between as far as I can see:

Aug 28 11:47:39 vostro kernel: [25874.121506] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:47:39 vostro kernel: [25874.121510] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:47:39 vostro kernel: [25874.121575] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:47:39 vostro kernel: [25874.121577] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:06 vostro kernel: [25901.086360] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:06 vostro kernel: [25901.086363] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:06 vostro kernel: [25901.086423] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:06 vostro kernel: [25901.086425] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:06 vostro kernel: [25901.204905] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: reading directory lblock 0
Aug 28 11:48:06 vostro kernel: [25901.207692] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: reading directory lblock 0
Aug 28 11:48:09 vostro kernel: [25904.225075] EXT4-fs error (device sdb1): ext4_wait_block_bitmap:466: comm kworker/u8:4: Cannot read block bitmap - block_group = 19937, block_bitmap = 653262849
Aug 28 11:48:09 vostro kernel: [25904.225087] EXT4-fs (sdb1): delayed block allocation failed for inode 163315715 at logical offset 1 with max blocks 2 with error -5
Aug 28 11:48:09 vostro kernel: [25904.225089] EXT4-fs (sdb1): This should not happen!! Data will be lost
Aug 28 11:48:12 vostro kernel: [25907.013801] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.013805] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.013871] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.013873] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.015685] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.015687] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.015714] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.015716] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.015733] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.015734] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.018138] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.018140] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.018157] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:12 vostro kernel: [25907.018159] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:12 vostro kernel: [25907.018906] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: reading directory lblock 0
Aug 28 11:48:13 vostro kernel: [25908.368826] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.368829] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:13 vostro kernel: [25908.368859] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.368860] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:13 vostro kernel: [25908.368878] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.368879] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:13 vostro kernel: [25908.369287] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.369290] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:13 vostro kernel: [25908.369307] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.369308] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:13 vostro kernel: [25908.370318] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.370320] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:13 vostro kernel: [25908.370338] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:13 vostro kernel: [25908.370339] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:14 vostro kernel: [25909.243747] EXT4-fs error (device sdb1): ext4_wait_block_bitmap:466: comm kworker/u8:4: Cannot read block bitmap - block_group = 19937, block_bitmap = 653262849
Aug 28 11:48:14 vostro kernel: [25909.243759] EXT4-fs (sdb1): delayed block allocation failed for inode 163315715 at logical offset 3 with max blocks 1 with error -5
Aug 28 11:48:14 vostro kernel: [25909.243761] EXT4-fs (sdb1): This should not happen!! Data will be lost
Aug 28 11:48:14 vostro kernel: [25909.641975] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:14 vostro kernel: [25909.641978] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:48:14 vostro kernel: [25909.642007] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: comm memcheck-amd64-: unable to read itable block
Aug 28 11:48:14 vostro kernel: [25909.642008] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure


[cut]

Aug 28 11:49:29 vostro kernel: [25984.053680] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:49:29 vostro kernel: [25984.053757] EXT4-fs error (device sdb1): __ext4_get_inode_loc:4039: inode #55836687: block 223346720: comm memcheck-amd64-: unable to read itable block
Aug 28 11:49:29 vostro kernel: [25984.053758] EXT4-fs error (device sdb1) in ext4_reserve_inode_write:4973: IO failure
Aug 28 11:49:29 vostro kernel: [25984.082439] EXT4-fs error (device sdb1): ext4_wait_block_bitmap:466: comm memcheck-amd64-: Cannot read block bitmap - block_group = 19937, block_bitmap = 653262849
Aug 28 11:49:29 vostro kernel: [25984.082452] EXT4-fs (sdb1): delayed block allocation failed for inode 55836688 at logical offset 1 with max blocks 3 with error -5
Aug 28 11:49:29 vostro kernel: [25984.082453] EXT4-fs (sdb1): This should not happen!! Data will be lost
Aug 28 11:49:29 vostro kernel: [25984.082616] EXT4-fs error (device sdb1): ext4_wait_block_bitmap:466: comm memcheck-amd64-: Cannot read block bitmap - block_group = 374, block_bitmap = 12058630
Aug 28 11:49:29 vostro kernel: [25984.082622] EXT4-fs (sdb1): delayed block allocation failed for inode 55836687 at logical offset 1 with max blocks 243 with error -5
Aug 28 11:49:29 vostro kernel: [25984.082623] EXT4-fs (sdb1): This should not happen!! Data will be lost
Aug 28 11:50:01 vostro cron[8131]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons)
Aug 28 11:57:40 vostro kernel: [26476.360211] Aborting journal on device sdb1-8.
Aug 28 11:57:40 vostro kernel: [26476.360222] Buffer I/O error on device sdb1, logical block 365985792
Aug 28 11:57:40 vostro kernel: [26476.360223] lost page write due to I/O error on sdb1
Aug 28 11:57:40 vostro kernel: [26476.360226] JBD2: Error -5 detected when updating journal superblock for sdb1-8.
Aug 28 11:57:55 vostro kernel: [26491.416007] EXT4-fs error (device sdb1): __ext4_journal_start_sb:62: Detected aborted journal
Aug 28 11:57:55 vostro kernel: [26491.416014] EXT4-fs (sdb1): Remounting filesystem read-only
Aug 28 11:57:55 vostro kernel: [26491.416017] EXT4-fs (sdb1): ext4_da_writepages: jbd2_start: 13312 pages, ino 55836687; err -30

So kernel was trying for 10 minutes before it gave up?

[cut, please of these repeated messages]

Aug 28 12:56:31 vostro kernel: [30013.996669] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)
Aug 28 12:56:33 vostro kernel: [30015.310284] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)
Aug 28 12:56:33 vostro kernel: [30015.526548] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)
Aug 28 12:56:36 vostro kernel: [30018.490206] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)
Aug 28 12:56:36 vostro kernel: [30018.730504] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)
Aug 28 12:56:36 vostro kernel: [30018.898683] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)
Aug 28 12:56:42 vostro kernel: [30024.101650] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.101696] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.101729] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.102016] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.102175] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.102337] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.102494] EXT4-fs error (device sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directory lblock 0
Aug 28 12:56:42 vostro kernel: [30024.103131] EXT4-fs warning (device sdb1): __ext4_read_dirblock:908: error reading directory block (ino 163315713, block 0)


I could imagine valgrind took too much memory and maybe overwrote some kernel structures? Or some of the new changes in .config?

I ran two instances of: valgrind --leak-check=full --track-origins=yes --tool=memcheck --suppressions=valgrind-python.supp my_app_compiled_by_cython_and_gcc [args]

$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       573G  533G   12G  98% /
devtmpfs        7.8G     0  7.8G   0% /dev
tmpfs           1.6G  3.0M  1.6G   1% /run
shm             7.8G     0  7.8G   0% /dev/shm
/dev/sdb1       2.7T  1.4T  1.3T  53% /mnt/external
$ ls -la  /mnt/external
ls: reading directory /mnt/external: Input/output error
total 0
$

So, the target filesystem on the external disk should not be full.

Any clues what I should look at? Few days ago memtest86+ went fine through all 16GB of RAM (Dell Vostro 3550). I do not know if the PCI/ACPI change is related or not. 
Thank you,
Martin


--------------000002040909030103070009
Content-Type: application/mbox;
 name=".config.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename=".config.diff"

LS0tIC5jb25maWcuY3VycmVudAkyMDEzLTA4LTIzIDEwOjE5OjM3LjAwMDAwMDAwMCArMDIw
MAorKysgLmNvbmZpZwkyMDEzLTA4LTI3IDAwOjE4OjU3LjAwMDAwMDAwMCArMDIwMApAQCAt
MTA3LDExICsxMDcsMTUgQEAKICMKICMgQ1BVL1Rhc2sgdGltZSBhbmQgc3RhdHMgYWNjb3Vu
dGluZwogIwotQ09ORklHX1RJQ0tfQ1BVX0FDQ09VTlRJTkc9eQorIyBDT05GSUdfVElDS19D
UFVfQUNDT1VOVElORyBpcyBub3Qgc2V0CiAjIENPTkZJR19WSVJUX0NQVV9BQ0NPVU5USU5H
X0dFTiBpcyBub3Qgc2V0Ci0jIENPTkZJR19JUlFfVElNRV9BQ0NPVU5USU5HIGlzIG5vdCBz
ZXQKLSMgQ09ORklHX0JTRF9QUk9DRVNTX0FDQ1QgaXMgbm90IHNldAotIyBDT05GSUdfVEFT
S1NUQVRTIGlzIG5vdCBzZXQKK0NPTkZJR19JUlFfVElNRV9BQ0NPVU5USU5HPXkKK0NPTkZJ
R19CU0RfUFJPQ0VTU19BQ0NUPXkKKyMgQ09ORklHX0JTRF9QUk9DRVNTX0FDQ1RfVjMgaXMg
bm90IHNldAorQ09ORklHX1RBU0tTVEFUUz15CitDT05GSUdfVEFTS19ERUxBWV9BQ0NUPXkK
K0NPTkZJR19UQVNLX1hBQ0NUPXkKK0NPTkZJR19UQVNLX0lPX0FDQ09VTlRJTkc9eQogCiAj
CiAjIFJDVSBTdWJzeXN0ZW0KQEAgLTM5OSw3ICs0MDMsOCBAQAogIyBDT05GSUdfQ1JPU1Nf
TUVNT1JZX0FUVEFDSCBpcyBub3Qgc2V0CiBDT05GSUdfQ0xFQU5DQUNIRT15CiBDT05GSUdf
RlJPTlRTV0FQPXkKLSMgQ09ORklHX1g4Nl9DSEVDS19CSU9TX0NPUlJVUFRJT04gaXMgbm90
IHNldAorQ09ORklHX1g4Nl9DSEVDS19CSU9TX0NPUlJVUFRJT049eQorQ09ORklHX1g4Nl9C
T09UUEFSQU1fTUVNT1JZX0NPUlJVUFRJT05fQ0hFQ0s9eQogQ09ORklHX1g4Nl9SRVNFUlZF
X0xPVz02NAogQ09ORklHX01UUlI9eQogQ09ORklHX01UUlJfU0FOSVRJWkVSPXkKQEAgLTQ5
NCwyNSArNDk5LDIyIEBACiBDT05GSUdfQ1BVX0ZSRVFfR09WX0NPTU1PTj15CiBDT05GSUdf
Q1BVX0ZSRVFfU1RBVD15CiBDT05GSUdfQ1BVX0ZSRVFfU1RBVF9ERVRBSUxTPXkKLSMgQ09O
RklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1BFUkZPUk1BTkNFIGlzIG5vdCBzZXQKK0NPTkZJ
R19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRT15CiAjIENPTkZJR19DUFVfRlJF
UV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0UgaXMgbm90IHNldAotQ09ORklHX0NQVV9GUkVRX0RF
RkFVTFRfR09WX09OREVNQU5EPXkKKyMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX09O
REVNQU5EIGlzIG5vdCBzZXQKICMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX0NPTlNF
UlZBVElWRSBpcyBub3Qgc2V0CiBDT05GSUdfQ1BVX0ZSRVFfR09WX1BFUkZPUk1BTkNFPXkK
IENPTkZJR19DUFVfRlJFUV9HT1ZfUE9XRVJTQVZFPXkKIENPTkZJR19DUFVfRlJFUV9HT1Zf
VVNFUlNQQUNFPXkKIENPTkZJR19DUFVfRlJFUV9HT1ZfT05ERU1BTkQ9eQotIyBDT05GSUdf
Q1BVX0ZSRVFfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CitDT05GSUdfQ1BVX0ZSRVFf
R09WX0NPTlNFUlZBVElWRT15CiAKICMKICMgeDg2IENQVSBmcmVxdWVuY3kgc2NhbGluZyBk
cml2ZXJzCiAjCiBDT05GSUdfWDg2X0lOVEVMX1BTVEFURT15CiAjIENPTkZJR19YODZfUEND
X0NQVUZSRVEgaXMgbm90IHNldAotQ09ORklHX1g4Nl9BQ1BJX0NQVUZSRVE9eQotIyBDT05G
SUdfWDg2X0FDUElfQ1BVRlJFUV9DUEIgaXMgbm90IHNldAotIyBDT05GSUdfWDg2X1BPV0VS
Tk9XX0s4IGlzIG5vdCBzZXQKLSMgQ09ORklHX1g4Nl9BTURfRlJFUV9TRU5TSVRJVklUWSBp
cyBub3Qgc2V0CisjIENPTkZJR19YODZfQUNQSV9DUFVGUkVRIGlzIG5vdCBzZXQKICMgQ09O
RklHX1g4Nl9TUEVFRFNURVBfQ0VOVFJJTk8gaXMgbm90IHNldAogIyBDT05GSUdfWDg2X1A0
X0NMT0NLTU9EIGlzIG5vdCBzZXQKIApAQCAtNjQ1LDI3ICs2NDcsNyBAQAogQ09ORklHX1RD
UF9DT05HX0NVQklDPXkKIENPTkZJR19ERUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKICMgQ09O
RklHX1RDUF9NRDVTSUcgaXMgbm90IHNldAotQ09ORklHX0lQVjY9bQotIyBDT05GSUdfSVBW
Nl9QUklWQUNZIGlzIG5vdCBzZXQKLSMgQ09ORklHX0lQVjZfUk9VVEVSX1BSRUYgaXMgbm90
IHNldAotIyBDT05GSUdfSVBWNl9PUFRJTUlTVElDX0RBRCBpcyBub3Qgc2V0Ci0jIENPTkZJ
R19JTkVUNl9BSCBpcyBub3Qgc2V0Ci0jIENPTkZJR19JTkVUNl9FU1AgaXMgbm90IHNldAot
IyBDT05GSUdfSU5FVDZfSVBDT01QIGlzIG5vdCBzZXQKLSMgQ09ORklHX0lQVjZfTUlQNiBp
cyBub3Qgc2V0Ci0jIENPTkZJR19JTkVUNl9YRlJNX1RVTk5FTCBpcyBub3Qgc2V0Ci0jIENP
TkZJR19JTkVUNl9UVU5ORUwgaXMgbm90IHNldAotQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9U
UkFOU1BPUlQ9bQotQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9UVU5ORUw9bQotQ09ORklHX0lO
RVQ2X1hGUk1fTU9ERV9CRUVUPW0KLSMgQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9ST1VURU9Q
VElNSVpBVElPTiBpcyBub3Qgc2V0Ci1DT05GSUdfSVBWNl9TSVQ9bQotIyBDT05GSUdfSVBW
Nl9TSVRfNlJEIGlzIG5vdCBzZXQKLUNPTkZJR19JUFY2X05ESVNDX05PREVUWVBFPXkKLSMg
Q09ORklHX0lQVjZfVFVOTkVMIGlzIG5vdCBzZXQKLSMgQ09ORklHX0lQVjZfR1JFIGlzIG5v
dCBzZXQKLSMgQ09ORklHX0lQVjZfTVVMVElQTEVfVEFCTEVTIGlzIG5vdCBzZXQKLSMgQ09O
RklHX0lQVjZfTVJPVVRFIGlzIG5vdCBzZXQKKyMgQ09ORklHX0lQVjYgaXMgbm90IHNldAog
IyBDT05GSUdfTkVUV09SS19TRUNNQVJLIGlzIG5vdCBzZXQKICMgQ09ORklHX05FVFdPUktf
UEhZX1RJTUVTVEFNUElORyBpcyBub3Qgc2V0CiBDT05GSUdfTkVURklMVEVSPXkKQEAgLTcz
Nyw3ICs3MTksNiBAQAogIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1RJTUUgaXMgbm90
IHNldAogIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1UzMiBpcyBub3Qgc2V0CiBDT05G
SUdfSVBfVlM9bQotIyBDT05GSUdfSVBfVlNfSVBWNiBpcyBub3Qgc2V0CiAjIENPTkZJR19J
UF9WU19ERUJVRyBpcyBub3Qgc2V0CiBDT05GSUdfSVBfVlNfVEFCX0JJVFM9MTIKIApAQCAt
Nzg4LDEyICs3NjksNiBAQAogIyBDT05GSUdfSVBfTkZfTUFOR0xFIGlzIG5vdCBzZXQKICMg
Q09ORklHX0lQX05GX1JBVyBpcyBub3Qgc2V0CiAjIENPTkZJR19JUF9ORl9BUlBUQUJMRVMg
aXMgbm90IHNldAotCi0jCi0jIElQdjY6IE5ldGZpbHRlciBDb25maWd1cmF0aW9uCi0jCi0j
IENPTkZJR19ORl9ERUZSQUdfSVBWNiBpcyBub3Qgc2V0Ci0jIENPTkZJR19JUDZfTkZfSVBU
QUJMRVMgaXMgbm90IHNldAogIyBDT05GSUdfSVBfRENDUCBpcyBub3Qgc2V0CiBDT05GSUdf
SVBfU0NUUD1tCiAjIENPTkZJR19TQ1RQX0RCR19NU0cgaXMgbm90IHNldApAQCAtODIyLDcg
Kzc5Nyw2IEBACiAjIENPTkZJR19MQVBCIGlzIG5vdCBzZXQKICMgQ09ORklHX1BIT05FVCBp
cyBub3Qgc2V0CiBDT05GSUdfSUVFRTgwMjE1ND1tCi0jIENPTkZJR19JRUVFODAyMTU0XzZM
T1dQQU4gaXMgbm90IHNldAogIyBDT05GSUdfTUFDODAyMTU0IGlzIG5vdCBzZXQKICMgQ09O
RklHX05FVF9TQ0hFRCBpcyBub3Qgc2V0CiAjIENPTkZJR19EQ0IgaXMgbm90IHNldApAQCAt
OTgzLDcgKzk1Nyw3IEBACiAjIENPTkZJR19JTlRFTF9NSURfUFRJIGlzIG5vdCBzZXQKICMg
Q09ORklHX1NHSV9JT0M0IGlzIG5vdCBzZXQKIENPTkZJR19USUZNX0NPUkU9bQotQ09ORklH
X1RJRk1fN1hYMT1tCisjIENPTkZJR19USUZNXzdYWDEgaXMgbm90IHNldAogIyBDT05GSUdf
SUNTOTMyUzQwMSBpcyBub3Qgc2V0CiAjIENPTkZJR19BVE1FTF9TU0MgaXMgbm90IHNldAog
IyBDT05GSUdfRU5DTE9TVVJFX1NFUlZJQ0VTIGlzIG5vdCBzZXQKQEAgLTEwMjQsOCArOTk4
LDggQEAKICMgQWx0ZXJhIEZQR0EgZmlybXdhcmUgZG93bmxvYWQgbW9kdWxlCiAjCiAjIENP
TkZJR19BTFRFUkFfU1RBUEwgaXMgbm90IHNldAotIyBDT05GSUdfSU5URUxfTUVJIGlzIG5v
dCBzZXQKLSMgQ09ORklHX0lOVEVMX01FSV9NRSBpcyBub3Qgc2V0CitDT05GSUdfSU5URUxf
TUVJPXkKK0NPTkZJR19JTlRFTF9NRUlfTUU9eQogQ09ORklHX1ZNV0FSRV9WTUNJPW0KIENP
TkZJR19IQVZFX0lERT15CiAjIENPTkZJR19JREUgaXMgbm90IHNldApAQCAtMTU3MCw3ICsx
NTQ0LDcgQEAKICMgQ09ORklHX0kyQ19DSEFSREVWIGlzIG5vdCBzZXQKICMgQ09ORklHX0ky
Q19NVVggaXMgbm90IHNldAogIyBDT05GSUdfSTJDX0hFTFBFUl9BVVRPIGlzIG5vdCBzZXQK
LSMgQ09ORklHX0kyQ19TTUJVUyBpcyBub3Qgc2V0CitDT05GSUdfSTJDX1NNQlVTPXkKIAog
IwogIyBJMkMgQWxnb3JpdGhtcwpAQCAtMTYxNCw3ICsxNTg4LDcgQEAKICMgQ09ORklHX0ky
Q19ERVNJR05XQVJFX1BDSSBpcyBub3Qgc2V0CiAjIENPTkZJR19JMkNfRUcyMFQgaXMgbm90
IHNldAogIyBDT05GSUdfSTJDX0dQSU8gaXMgbm90IHNldAotIyBDT05GSUdfSTJDX0lOVEVM
X01JRCBpcyBub3Qgc2V0CitDT05GSUdfSTJDX0lOVEVMX01JRD15CiAjIENPTkZJR19JMkNf
T0NPUkVTIGlzIG5vdCBzZXQKICMgQ09ORklHX0kyQ19QQ0FfUExBVEZPUk0gaXMgbm90IHNl
dAogIyBDT05GSUdfSTJDX1BYQV9QQ0kgaXMgbm90IHNldApAQCAtMTg3Myw4ICsxODQ3LDcg
QEAKICMgQ09ORklHX1NFTlNPUlNfVzgzNzkxRCBpcyBub3Qgc2V0CiAjIENPTkZJR19TRU5T
T1JTX1c4Mzc5MkQgaXMgbm90IHNldAogIyBDT05GSUdfU0VOU09SU19XODM3OTMgaXMgbm90
IHNldAotQ09ORklHX1NFTlNPUlNfVzgzNzk1PW0KLSMgQ09ORklHX1NFTlNPUlNfVzgzNzk1
X0ZBTkNUUkwgaXMgbm90IHNldAorIyBDT05GSUdfU0VOU09SU19XODM3OTUgaXMgbm90IHNl
dAogIyBDT05GSUdfU0VOU09SU19XODNMNzg1VFMgaXMgbm90IHNldAogIyBDT05GSUdfU0VO
U09SU19XODNMNzg2TkcgaXMgbm90IHNldAogIyBDT05GSUdfU0VOU09SU19XODM2MjdIRiBp
cyBub3Qgc2V0CkBAIC0zMTIxLDcgKzMwOTQsNiBAQAogQ09ORklHX1NDSEVEU1RBVFM9eQog
IyBDT05GSUdfVElNRVJfU1RBVFMgaXMgbm90IHNldAogIyBDT05GSUdfREVCVUdfT0JKRUNU
UyBpcyBub3Qgc2V0Ci1DT05GSUdfU0xVQl9ERUJVR19PTj15CiAjIENPTkZJR19TTFVCX1NU
QVRTIGlzIG5vdCBzZXQKIENPTkZJR19IQVZFX0RFQlVHX0tNRU1MRUFLPXkKIENPTkZJR19E
RUJVR19LTUVNTEVBSz15CkBAIC0zMTc5LDcgKzMxNTEsNiBAQAogIyBDT05GSUdfTEFURU5D
WVRPUCBpcyBub3Qgc2V0CiBDT05GSUdfQVJDSF9IQVNfREVCVUdfU1RSSUNUX1VTRVJfQ09Q
WV9DSEVDS1M9eQogQ09ORklHX0RFQlVHX1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tTPXkKLSMg
Q09ORklHX0RFQlVHX1BBR0VBTExPQyBpcyBub3Qgc2V0CiBDT05GSUdfVVNFUl9TVEFDS1RS
QUNFX1NVUFBPUlQ9eQogQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkKIENPTkZJR19I
QVZFX0ZVTkNUSU9OX0dSQVBIX1RSQUNFUj15CkBAIC0zMjA5LDE2ICszMTgwLDI0IEBACiBD
T05GSUdfSEFWRV9BUkNIX0tHREI9eQogIyBDT05GSUdfS0dEQiBpcyBub3Qgc2V0CiBDT05G
SUdfSEFWRV9BUkNIX0tNRU1DSEVDSz15Ci0jIENPTkZJR19LTUVNQ0hFQ0sgaXMgbm90IHNl
dAorQ09ORklHX0tNRU1DSEVDSz15CisjIENPTkZJR19LTUVNQ0hFQ0tfRElTQUJMRURfQllf
REVGQVVMVCBpcyBub3Qgc2V0CisjIENPTkZJR19LTUVNQ0hFQ0tfRU5BQkxFRF9CWV9ERUZB
VUxUIGlzIG5vdCBzZXQKK0NPTkZJR19LTUVNQ0hFQ0tfT05FU0hPVF9CWV9ERUZBVUxUPXkK
K0NPTkZJR19LTUVNQ0hFQ0tfUVVFVUVfU0laRT02NAorQ09ORklHX0tNRU1DSEVDS19TSEFE
T1dfQ09QWV9TSElGVD01CitDT05GSUdfS01FTUNIRUNLX1BBUlRJQUxfT0s9eQorIyBDT05G
SUdfS01FTUNIRUNLX0JJVE9QU19PSyBpcyBub3Qgc2V0CiAjIENPTkZJR19URVNUX1NUUklO
R19IRUxQRVJTIGlzIG5vdCBzZXQKICMgQ09ORklHX1RFU1RfS1NUUlRPWCBpcyBub3Qgc2V0
CiAjIENPTkZJR19TVFJJQ1RfREVWTUVNIGlzIG5vdCBzZXQKIENPTkZJR19YODZfVkVSQk9T
RV9CT09UVVA9eQogQ09ORklHX0VBUkxZX1BSSU5USz15CiAjIENPTkZJR19FQVJMWV9QUklO
VEtfREJHUCBpcyBub3Qgc2V0Ci0jIENPTkZJR19ERUJVR19TVEFDS09WRVJGTE9XIGlzIG5v
dCBzZXQKK0NPTkZJR19ERUJVR19TVEFDS09WRVJGTE9XPXkKICMgQ09ORklHX1g4Nl9QVERV
TVAgaXMgbm90IHNldAotIyBDT05GSUdfREVCVUdfUk9EQVRBIGlzIG5vdCBzZXQKK0NPTkZJ
R19ERUJVR19ST0RBVEE9eQorQ09ORklHX0RFQlVHX1JPREFUQV9URVNUPXkKICMgQ09ORklH
X0RFQlVHX1NFVF9NT0RVTEVfUk9OWCBpcyBub3Qgc2V0CiAjIENPTkZJR19ERUJVR19OWF9U
RVNUIGlzIG5vdCBzZXQKICMgQ09ORklHX0RFQlVHX1RMQkZMVVNIIGlzIG5vdCBzZXQKQEAg
LTM0MzAsMTEgKzM0MDksMTEgQEAKIENPTkZJR19MWk9fREVDT01QUkVTUz15CiBDT05GSUdf
WFpfREVDPXkKIENPTkZJR19YWl9ERUNfWDg2PXkKLUNPTkZJR19YWl9ERUNfUE9XRVJQQz15
Ci1DT05GSUdfWFpfREVDX0lBNjQ9eQotQ09ORklHX1haX0RFQ19BUk09eQotQ09ORklHX1ha
X0RFQ19BUk1USFVNQj15Ci1DT05GSUdfWFpfREVDX1NQQVJDPXkKKyMgQ09ORklHX1haX0RF
Q19QT1dFUlBDIGlzIG5vdCBzZXQKKyMgQ09ORklHX1haX0RFQ19JQTY0IGlzIG5vdCBzZXQK
KyMgQ09ORklHX1haX0RFQ19BUk0gaXMgbm90IHNldAorIyBDT05GSUdfWFpfREVDX0FSTVRI
VU1CIGlzIG5vdCBzZXQKKyMgQ09ORklHX1haX0RFQ19TUEFSQyBpcyBub3Qgc2V0CiBDT05G
SUdfWFpfREVDX0JDSj15CiAjIENPTkZJR19YWl9ERUNfVEVTVCBpcyBub3Qgc2V0CiBDT05G
SUdfREVDT01QUkVTU19HWklQPXkK
--------------000002040909030103070009
Content-Type: text/plain; charset=us-ascii;
 name="lspci_vvv.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lspci_vvv.txt"

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gMm5kIEdlbmVyYXRpb24g
Q29yZSBQcm9jZXNzb3IgRmFtaWx5IERSQU0gQ29udHJvbGxlciAocmV2IDA5KQoJU3Vic3lz
dGVtOiBEZWxsIERldmljZSAwNGIzCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBh
ckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPlNFUlItIDxQ
RVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJQ2FwYWJpbGl0aWVzOiBbZTBdIFZlbmRvciBTcGVj
aWZpYyBJbmZvcm1hdGlvbjogTGVuPTBjIDw/PgoKMDA6MDIuMCBWR0EgY29tcGF0aWJsZSBj
b250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiAybmQgR2VuZXJhdGlvbiBDb3JlIFByb2Nl
c3NvciBGYW1pbHkgSW50ZWdyYXRlZCBHcmFwaGljcyBDb250cm9sbGVyIChyZXYgMDkpIChw
cm9nLWlmIDAwIFtWR0EgY29udHJvbGxlcl0pCglTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDA0
YjMKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglT
dGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+
VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5
OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgNDEKCVJlZ2lvbiAwOiBNZW1v
cnkgYXQgZjY4MDAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NE1dCglS
ZWdpb24gMjogTWVtb3J5IGF0IGUwMDAwMDAwICg2NC1iaXQsIHByZWZldGNoYWJsZSkgW3Np
emU9MjU2TV0KCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgZjAwMCBbc2l6ZT02NF0KCUV4cGFu
c2lvbiBST00gYXQgPHVuYXNzaWduZWQ+IFtkaXNhYmxlZF0KCUNhcGFiaWxpdGllczogWzkw
XSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiBm
ZWUwMTAwYyAgRGF0YTogNDFhMQoJQ2FwYWJpbGl0aWVzOiBbZDBdIFBvd2VyIE1hbmFnZW1l
bnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJKyBEMS0gRDItIEF1eEN1cnJlbnQ9
MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29m
dFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczog
W2E0XSBQQ0kgQWR2YW5jZWQgRmVhdHVyZXMKCQlBRkNhcDogVFArIEZMUisKCQlBRkN0cmw6
IEZMUi0KCQlBRlN0YXR1czogVFAtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogaTkxNQoKMDA6
MTYuMCBDb21tdW5pY2F0aW9uIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDYgU2Vy
aWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFtaWx5IE1FSSBDb250cm9sbGVyICMxIChyZXYg
MDQpCglTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDA0YjMKCUNvbnRyb2w6IEkvTy0gTWVtKyBC
dXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBp
bmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0g
RmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJv
dXRlZCB0byBJUlEgNDIKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjdmMGEwMDAgKDY0LWJpdCwg
bm9uLXByZWZldGNoYWJsZSkgW3NpemU9MTZdCglDYXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIg
TWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4
Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czog
RDAgTm9Tb2Z0UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJp
bGl0aWVzOiBbOGNdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0KwoJ
CUFkZHJlc3M6IDAwMDAwMDAwZmVlMDEwMGMgIERhdGE6IDQxYjEKCUtlcm5lbCBkcml2ZXIg
aW4gdXNlOiBtZWlfbWUKCjAwOjFhLjAgVVNCIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0
aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFtaWx5IFVTQiBFbmhhbmNlZCBI
b3N0IENvbnRyb2xsZXIgIzIgKHJldiAwNSkgKHByb2ctaWYgMjAgW0VIQ0ldKQoJU3Vic3lz
dGVtOiBEZWxsIERldmljZSAwNGIzCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBh
ckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJ
UlEgMTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjdmMDgwMDAgKDMyLWJpdCwgbm9uLXByZWZl
dGNoYWJsZSkgW3NpemU9MUtdCglDYXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVu
dCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0z
NzVtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1Nv
ZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6
IFs1OF0gRGVidWcgcG9ydDogQkFSPTEgb2Zmc2V0PTAwYTAKCUNhcGFiaWxpdGllczogWzk4
XSBQQ0kgQWR2YW5jZWQgRmVhdHVyZXMKCQlBRkNhcDogVFArIEZMUisKCQlBRkN0cmw6IEZM
Ui0KCQlBRlN0YXR1czogVFAtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogZWhjaS1wY2kKCjAw
OjFiLjAgQXVkaW8gZGV2aWNlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBIaWdoIERlZmluaXRpb24gQXVkaW8gQ29udHJvbGxlciAo
cmV2IDA1KQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwNGIzCglDb250cm9sOiBJL08tIE1l
bSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1B
Ym9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXpl
OiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDQ3CglSZWdpb24g
MDogTWVtb3J5IGF0IGY3ZjAwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXpl
PTE2S10KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJ
CUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTU1bUEgUE1FKEQwKyxE
MS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5h
YmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNjBdIE1TSTogRW5h
YmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVl
MDEwMGMgIERhdGE6IDQxNjIKCUNhcGFiaWxpdGllczogWzcwXSBFeHByZXNzICh2MSkgUm9v
dCBDb21wbGV4IEludGVncmF0ZWQgRW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5
bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1
cwoJCQlFeHRUYWctIFJCRS0gRkxSZXNldCsKCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENv
cnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZC0g
RXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAxMjgg
Ynl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNvcnJF
cnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJ
UG9ydCAjMCwgU3BlZWQgdW5rbm93biwgV2lkdGggeDAsIEFTUE0gdW5rbm93biwgTGF0ZW5j
eSBMMCA8NjRucywgTDEgPDF1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3
Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1D
bGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0K
CQlMbmtTdGE6CVNwZWVkIHVua25vd24sIFdpZHRoIHgwLCBUckVyci0gVHJhaW4tIFNsb3RD
bGstIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCglDYXBhYmlsaXRpZXM6IFsxMDAgdjFd
IFZpcnR1YWwgQ2hhbm5lbAoJCUNhcHM6CUxQRVZDPTAgUmVmQ2xrPTEwMG5zIFBBVEVudHJ5
Qml0cz0xCgkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtCgkJQ3RybDoJQXJi
U2VsZWN0PUZpeGVkCgkJU3RhdHVzOglJblByb2dyZXNzLQoJCVZDMDoJQ2FwczoJUEFUT2Zm
c2V0PTAwIE1heFRpbWVTbG90cz0xIFJlalNub29wVHJhbnMtCgkJCUFyYjoJRml4ZWQtIFdS
UjMyLSBXUlI2NC0gV1JSMTI4LSBUV1JSMTI4LSBXUlIyNTYtCgkJCUN0cmw6CUVuYWJsZSsg
SUQ9MCBBcmJTZWxlY3Q9Rml4ZWQgVEMvVkM9MDEKCQkJU3RhdHVzOglOZWdvUGVuZGluZy0g
SW5Qcm9ncmVzcy0KCQlWQzE6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBS
ZWpTbm9vcFRyYW5zLQoJCQlBcmI6CUZpeGVkLSBXUlIzMi0gV1JSNjQtIFdSUjEyOC0gVFdS
UjEyOC0gV1JSMjU2LQoJCQlDdHJsOglFbmFibGUrIElEPTEgQXJiU2VsZWN0PUZpeGVkIFRD
L1ZDPTIyCgkJCVN0YXR1czoJTmVnb1BlbmRpbmctIEluUHJvZ3Jlc3MtCglDYXBhYmlsaXRp
ZXM6IFsxMzAgdjFdIFJvb3QgQ29tcGxleCBMaW5rCgkJRGVzYzoJUG9ydE51bWJlcj0wZiBD
b21wb25lbnRJRD0wMCBFbHRUeXBlPUNvbmZpZwoJCUxpbmswOglEZXNjOglUYXJnZXRQb3J0
PTAwIFRhcmdldENvbXBvbmVudD0wMCBBc3NvY1JDUkItIExpbmtUeXBlPU1lbU1hcHBlZCBM
aW5rVmFsaWQrCgkJCUFkZHI6CTAwMDAwMDAwZmVkMWMwMDAKCUtlcm5lbCBkcml2ZXIgaW4g
dXNlOiBzbmRfaGRhX2ludGVsCgowMDoxYy4wIFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0
aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFtaWx5IFBDSSBFeHByZXNzIFJv
b3QgUG9ydCAxIChyZXYgYjUpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRy
b2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3At
IFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENh
cCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8
VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNo
ZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMywg
c3Vib3JkaW5hdGU9MDQsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAw
ZjAwMC0wMDAwMGZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGZmZjAwMDAwLTAwMGZmZmZm
CglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZmZmMDAwMDAt
MDAwMDAwMDAwMDBmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBh
ckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQ
RVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJl
c2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBE
aXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIEV4cHJlc3MgKHYyKSBSb290IFBv
cnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhh
bnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBG
TFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRh
bC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0g
QXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAx
MjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3Vw
cFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMxLCBTcGVlZCA1R1Qv
cywgV2lkdGggeDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDwxdXMsIEwxIDwxNnVzCgkJ
CUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwx
IEVuYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsay0KCQkJ
RXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0
YToJU3BlZWQgMi41R1QvcywgV2lkdGggeDAsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExB
Y3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0cmwtIE1S
TC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnLSBTdXJwcmlzZS0KCQkJU2xvdCAjMCwgUG93
ZXJMaW1pdCAxMC4wMDBXOyBJbnRlcmxvY2stIE5vQ29tcGwrCgkJU2x0Q3RsOglFbmFibGU6
IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0LSBIUElycS0gTGlua0No
Zy0KCQkJQ29udHJvbDogQXR0bkluZCBVbmtub3duLCBQd3JJbmQgVW5rbm93biwgUG93ZXIt
IEludGVybG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0g
Q21kQ3BsdC0gUHJlc0RldC0gSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQt
IExpbmtTdGF0ZS0KCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBF
cnJGYXRhbC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUt
CgkJUm9vdFN0YTogUE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCQlE
ZXZDYXAyOiBDb21wbGV0aW9uIFRpbWVvdXQ6IFJhbmdlIEJDLCBUaW1lb3V0RGlzKywgTFRS
LSwgT0JGRiBOb3QgU3VwcG9ydGVkIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0aW9uIFRp
bWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0sIExUUi0sIE9CRkYgRGlzYWJsZWQg
QVJJRndkLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBFbnRlckNv
bXBsaWFuY2UtIFNwZWVkRGlzLQoJCQkgVHJhbnNtaXQgTWFyZ2luOiBOb3JtYWwgT3BlcmF0
aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29tcGxpYW5jZVNPUy0KCQkJ
IENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEyOiBDdXJyZW50IERlLWVt
cGhhc2lzIExldmVsOiAtMy41ZEIsIEVxdWFsaXphdGlvbkNvbXBsZXRlLSwgRXF1YWxpemF0
aW9uUGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSwgRXF1YWxpemF0aW9uUGhhc2Uz
LSwgTGlua0VxdWFsaXphdGlvblJlcXVlc3QtCglDYXBhYmlsaXRpZXM6IFs4MF0gTVNJOiBF
bmFibGUtIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRkcmVzczogMDAwMDAwMDAg
IERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0ZW06IERlbGwgRGV2aWNl
IDA0YjMKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJ
CUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQx
LSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFi
bGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogcGNpZXBv
cnQKCjAwOjFjLjEgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gNiBTZXJpZXMvQzIw
MCBTZXJpZXMgQ2hpcHNldCBGYW1pbHkgUENJIEV4cHJlc3MgUm9vdCBQb3J0IDIgKHJldiBi
NSkgKHByb2ctaWYgMDAgW05vcm1hbCBkZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1
c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGlu
Zy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBG
YXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogNjQg
Ynl0ZXMKCUJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTA1LCBzdWJvcmRpbmF0ZT0wNiwg
c2VjLWxhdGVuY3k9MAoJSS9PIGJlaGluZCBicmlkZ2U6IDAwMDBlMDAwLTAwMDBlZmZmCglN
ZW1vcnkgYmVoaW5kIGJyaWRnZTogZmZmMDAwMDAtMDAwZmZmZmYKCVByZWZldGNoYWJsZSBt
ZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmMTEwMDAwMC0wMDAwMDAwMGYxMWZmZmZm
CglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFz
dCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6
IFBhcml0eS0gU0VSUi0gTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJ
UHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJTRVJSRW4tCglD
YXBhYmlsaXRpZXM6IFs0MF0gRXhwcmVzcyAodjIpIFJvb3QgUG9ydCAoU2xvdCspLCBNU0kg
MDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5j
eSBMMHMgPDY0bnMsIEwxIDwxdXMKCQkJRXh0VGFnLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3Rs
OglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBw
b3J0ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3At
CgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcwoJCURldlN0
YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRy
YW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzIsIFNwZWVkIDVHVC9zLCBXaWR0aCB4MSwgQVNQ
TSBMMHMgTDEsIExhdGVuY3kgTDAgPDUxMm5zLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJw
cmlzZS0gTExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0
IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQ
TS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9z
LCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZSsgQldNZ210KyBB
QldNZ210LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJ
bmQtIEhvdFBsdWctIFN1cnByaXNlLQoJCQlTbG90ICMxLCBQb3dlckxpbWl0IDEwLjAwMFc7
IEludGVybG9jay0gTm9Db21wbCsKCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0
LSBNUkwtIFByZXNEZXQtIENtZENwbHQtIEhQSXJxLSBMaW5rQ2hnLQoJCQlDb250cm9sOiBB
dHRuSW5kIFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNs
dFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0
KyBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlKwoJCVJv
b3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRF
bmEtIENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUg
UmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJCURldkNhcDI6IENvbXBsZXRp
b24gVGltZW91dDogUmFuZ2UgQkMsIFRpbWVvdXREaXMrLCBMVFItLCBPQkZGIE5vdCBTdXBw
b3J0ZWQgQVJJRndkLQoJCURldkN0bDI6IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1
MG1zLCBUaW1lb3V0RGlzLSwgTFRSLSwgT0JGRiBEaXNhYmxlZCBBUklGd2QtCgkJTG5rQ3Rs
MjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3BlZWRE
aXMtCgkJCSBUcmFuc21pdCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVy
TW9kaWZpZWRDb21wbGlhbmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1l
bXBoYXNpczogLTZkQgoJCUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0z
LjVkQiwgRXF1YWxpemF0aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBF
cXVhbGl6YXRpb25QaGFzZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0
aW9uUmVxdWVzdC0KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8x
IE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiAwMDAwMDAwMCAgRGF0YTogMDAwMAoJQ2Fw
YWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0
aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0g
RFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNj
b2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2Fs
ZT0wIFBNRS0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoKMDA6MWMuMyBQQ0kg
YnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNlcmllcyBDaGlwc2V0
IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgNCAocmV2IGI1KSAocHJvZy1pZiAwMCBb
Tm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3lj
bGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJC
LSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0g
REVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJ
TlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmlt
YXJ5PTAwLCBzZWNvbmRhcnk9MDksIHN1Ym9yZGluYXRlPTBhLCBzZWMtbGF0ZW5jeT0wCglJ
L08gYmVoaW5kIGJyaWRnZTogMDAwMGYwMDAtMDAwMDBmZmYKCU1lbW9yeSBiZWhpbmQgYnJp
ZGdlOiBmN2UwMDAwMC1mN2VmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9yeSBiZWhpbmQgYnJp
ZGdlOiAwMDAwMDAwMGZmZjAwMDAwLTAwMDAwMDAwMDAwZmZmZmYKCVNlY29uZGFyeSBzdGF0
dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJv
cnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFyaXR5LSBTRVJSLSBO
b0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlEaXNjVG1yLSBTZWNE
aXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFiaWxpdGllczogWzQw
XSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJCURldkNhcDoJTWF4
UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEg
PDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6
IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9y
ZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAx
MjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNv
cnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0Nh
cDoJUG9ydCAjNCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5j
eSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsg
QndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQt
IFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJX
SW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVy
ci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQrIEFCV01nbXQtCgkJU2x0Q2Fw
OglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3Vy
cHJpc2UtCgkJCVNsb3QgIzMsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50ZXJsb2NrLSBOb0Nv
bXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0g
Q21kQ3BsdC0gSFBJcnEtIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQgVW5rbm93biwg
UHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3RhOglTdGF0dXM6IEF0
dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIEludGVybG9jay0KCQkJ
Q2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0bDogRXJyQ29ycmVj
dGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0gQ1JTVmlzaWJsZS0K
CQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJRCAwMDAwLCBQTUVT
dGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBUaW1lb3V0OiBSYW5n
ZSBCQywgVGltZW91dERpcyssIExUUi0sIE9CRkYgTm90IFN1cHBvcnRlZCBBUklGd2QtCgkJ
RGV2Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVzIHRvIDUwbXMsIFRpbWVvdXREaXMt
LCBMVFItLCBPQkZGIERpc2FibGVkIEFSSUZ3ZC0KCQlMbmtDdGwyOiBUYXJnZXQgTGluayBT
cGVlZDogMi41R1QvcywgRW50ZXJDb21wbGlhbmNlLSBTcGVlZERpcy0KCQkJIFRyYW5zbWl0
IE1hcmdpbjogTm9ybWFsIE9wZXJhdGluZyBSYW5nZSwgRW50ZXJNb2RpZmllZENvbXBsaWFu
Y2UtIENvbXBsaWFuY2VTT1MtCgkJCSBDb21wbGlhbmNlIERlLWVtcGhhc2lzOiAtNmRCCgkJ
TG5rU3RhMjogQ3VycmVudCBEZS1lbXBoYXNpcyBMZXZlbDogLTMuNWRCLCBFcXVhbGl6YXRp
b25Db21wbGV0ZS0sIEVxdWFsaXphdGlvblBoYXNlMS0KCQkJIEVxdWFsaXphdGlvblBoYXNl
Mi0sIEVxdWFsaXphdGlvblBoYXNlMy0sIExpbmtFcXVhbGl6YXRpb25SZXF1ZXN0LQoJQ2Fw
YWJpbGl0aWVzOiBbODBdIE1TSTogRW5hYmxlLSBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0
LQoJCUFkZHJlc3M6IDAwMDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFs5MF0g
U3Vic3lzdGVtOiBEZWxsIERldmljZSAwNGIzCglDYXBhYmlsaXRpZXM6IFthMF0gUG93ZXIg
TWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4
Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czog
RDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJS2VybmVs
IGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0CgowMDoxYy40IFBDSSBicmlkZ2U6IEludGVsIENv
cnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFtaWx5IFBDSSBFeHBy
ZXNzIFJvb3QgUG9ydCA1IChyZXYgYjUpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkK
CUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdB
U25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFi
b3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAw
LCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFy
eT0wYiwgc3Vib3JkaW5hdGU9MGMsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdl
OiAwMDAwZjAwMC0wMDAwMGZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGY3ZDAwMDAwLWY3
ZGZmZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZmZm
MDAwMDAtMDAwMDAwMDAwMDBmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNF
UlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1BYm9y
dC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJT
dGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbNDBdIEV4cHJlc3MgKHYyKSBS
b290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRl
cywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0g
UkJFKyBGTFJlc2V0LQoJCURldkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5v
bi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50
RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVh
ZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnItIFVuY29yckVyci0gRmF0YWxFcnIt
IFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICM1LCBTcGVl
ZCA1R1QvcywgV2lkdGggeDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDw1MTJucywgTDEg
PDE2dXMKCQkJQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwKyBCd05vdC0KCQlMbmtDdGw6
CUFTUE0gTDEgRW5hYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21t
Q2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQt
CgkJTG5rU3RhOglTcGVlZCA1R1QvcywgV2lkdGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENs
aysgRExBY3RpdmUrIEJXTWdtdCsgQUJXTWdtdCsKCQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0
cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnLSBTdXJwcmlzZS0KCQkJU2xvdCAj
NCwgUG93ZXJMaW1pdCAxMC4wMDBXOyBJbnRlcmxvY2stIE5vQ29tcGwrCgkJU2x0Q3RsOglF
bmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0LSBIUElycS0g
TGlua0NoZy0KCQkJQ29udHJvbDogQXR0bkluZCBVbmtub3duLCBQd3JJbmQgVW5rbm93biwg
UG93ZXItIEludGVybG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQt
IE1STC0gQ21kQ3BsdC0gUHJlc0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFBy
ZXNEZXQtIExpbmtTdGF0ZSsKCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZh
dGFsLSBFcnJGYXRhbC0gUE1FSW50RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zp
c2libGUtCgkJUm9vdFN0YTogUE1FIFJlcUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGlu
Zy0KCQlEZXZDYXAyOiBDb21wbGV0aW9uIFRpbWVvdXQ6IFJhbmdlIEJDLCBUaW1lb3V0RGlz
KywgTFRSLSwgT0JGRiBOb3QgU3VwcG9ydGVkIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0
aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0sIExUUi0sIE9CRkYgRGlz
YWJsZWQgQVJJRndkLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiA1R1QvcywgRW50
ZXJDb21wbGlhbmNlLSBTcGVlZERpcy0KCQkJIFRyYW5zbWl0IE1hcmdpbjogTm9ybWFsIE9w
ZXJhdGluZyBSYW5nZSwgRW50ZXJNb2RpZmllZENvbXBsaWFuY2UtIENvbXBsaWFuY2VTT1Mt
CgkJCSBDb21wbGlhbmNlIERlLWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3VycmVudCBE
ZS1lbXBoYXNpcyBMZXZlbDogLTZkQiwgRXF1YWxpemF0aW9uQ29tcGxldGUtLCBFcXVhbGl6
YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBFcXVhbGl6YXRpb25QaGFz
ZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6
IEVuYWJsZS0gQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiAwMDAwMDAw
MCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogRGVsbCBEZXZp
Y2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAy
CgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCss
RDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVu
YWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2ll
cG9ydAoKMDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9D
MjAwIFNlcmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2
IGI1KSAocHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsg
QnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBw
aW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYt
IEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9y
dC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2
NCBieXRlcwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2
LCBzZWMtbGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYK
CU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxl
IG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZm
ZmYKCVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1m
YXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0
bDogUGFyaXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0K
CQlQcmlEaXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0K
CUNhcGFiaWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1T
SSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRl
bmN5IEwwcyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZD
dGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1
cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9v
cC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2
U3RhOglDb3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisg
VHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBB
U1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJw
cmlzZS0gTExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGstCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgwLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQt
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQtIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUtCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcyssIExUUi0sIE9CRkYgTm90IFN1
cHBvcnRlZCBBUklGd2QtCgkJRGV2Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVzIHRv
IDUwbXMsIFRpbWVvdXREaXMtLCBMVFItLCBPQkZGIERpc2FibGVkIEFSSUZ3ZC0KCQlMbmtD
dGwyOiBUYXJnZXQgTGluayBTcGVlZDogMi41R1QvcywgRW50ZXJDb21wbGlhbmNlLSBTcGVl
ZERpcy0KCQkJIFRyYW5zbWl0IE1hcmdpbjogTm9ybWFsIE9wZXJhdGluZyBSYW5nZSwgRW50
ZXJNb2RpZmllZENvbXBsaWFuY2UtIENvbXBsaWFuY2VTT1MtCgkJCSBDb21wbGlhbmNlIERl
LWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3VycmVudCBEZS1lbXBoYXNpcyBMZXZlbDog
LTMuNWRCLCBFcXVhbGl6YXRpb25Db21wbGV0ZS0sIEVxdWFsaXphdGlvblBoYXNlMS0KCQkJ
IEVxdWFsaXphdGlvblBoYXNlMi0sIEVxdWFsaXphdGlvblBoYXNlMy0sIExpbmtFcXVhbGl6
YXRpb25SZXF1ZXN0LQoJQ2FwYWJpbGl0aWVzOiBbODBdIE1TSTogRW5hYmxlKyBDb3VudD0x
LzEgTWFza2FibGUtIDY0Yml0LQoJCUFkZHJlc3M6IGZlZTAxMDBjICBEYXRhOiA0MTkxCglD
YXBhYmlsaXRpZXM6IFs5MF0gU3Vic3lzdGVtOiBEZWxsIERldmljZSAwNGIzCglDYXBhYmls
aXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xr
LSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxE
M2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNj
YWxlPTAgUE1FLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0CgowMDoxZC4wIFVT
QiBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNlcmllcyBD
aGlwc2V0IEZhbWlseSBVU0IgRW5oYW5jZWQgSG9zdCBDb250cm9sbGVyICMxIChyZXYgMDUp
IChwcm9nLWlmIDIwIFtFSENJXSkKCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ29u
dHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9v
cC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czog
Q2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9y
dC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJ
SW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDIzCglSZWdpb24gMDogTWVtb3J5IGF0
IGY3ZjA3MDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTFLXQoJQ2FwYWJp
bGl0aWVzOiBbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNs
ay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9Mzc1bUEgUE1FKEQwKyxEMS0sRDItLEQzaG90
KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAg
RFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNThdIERlYnVnIHBvcnQ6IEJBUj0xIG9m
ZnNldD0wMGEwCglDYXBhYmlsaXRpZXM6IFs5OF0gUENJIEFkdmFuY2VkIEZlYXR1cmVzCgkJ
QUZDYXA6IFRQKyBGTFIrCgkJQUZDdHJsOiBGTFItCgkJQUZTdGF0dXM6IFRQLQoJS2VybmVs
IGRyaXZlciBpbiB1c2U6IGVoY2ktcGNpCgowMDoxZi4wIElTQSBicmlkZ2U6IEludGVsIENv
cnBvcmF0aW9uIEhNNjcgRXhwcmVzcyBDaGlwc2V0IEZhbWlseSBMUEMgQ29udHJvbGxlciAo
cmV2IDA1KQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwNGIzCglDb250cm9sOiBJL08rIE1l
bSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8
TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglDYXBhYmlsaXRpZXM6
IFtlMF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uOiBMZW49MGMgPD8+CglLZXJuZWwg
ZHJpdmVyIGluIHVzZTogbHBjX2ljaAoKMDA6MWYuMiBTQVRBIGNvbnRyb2xsZXI6IEludGVs
IENvcnBvcmF0aW9uIDYgU2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFtaWx5IDYgcG9y
dCBTQVRBIEFIQ0kgQ29udHJvbGxlciAocmV2IDA1KSAocHJvZy1pZiAwMSBbQUhDSSAxLjBd
KQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwNGIzCglDb250cm9sOiBJL08rIE1lbSsgQnVz
TWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6KyBVREYtIEZh
c3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBCIHJv
dXRlZCB0byBJUlEgNDMKCVJlZ2lvbiAwOiBJL08gcG9ydHMgYXQgZjBiMCBbc2l6ZT04XQoJ
UmVnaW9uIDE6IEkvTyBwb3J0cyBhdCBmMGEwIFtzaXplPTRdCglSZWdpb24gMjogSS9PIHBv
cnRzIGF0IGYwOTAgW3NpemU9OF0KCVJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgZjA4MCBbc2l6
ZT00XQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCBmMDYwIFtzaXplPTMyXQoJUmVnaW9uIDU6
IE1lbW9yeSBhdCBmN2YwNjAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0y
S10KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxl
LSA2NGJpdC0KCQlBZGRyZXNzOiBmZWUwMTAwYyAgRGF0YTogNDFjMQoJQ2FwYWJpbGl0aWVz
OiBbNzBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJ
LSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xk
LSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0w
IFBNRS0KCUNhcGFiaWxpdGllczogW2E4XSBTQVRBIEhCQSB2MS4wIEJBUjQgT2Zmc2V0PTAw
MDAwMDA0CglDYXBhYmlsaXRpZXM6IFtiMF0gUENJIEFkdmFuY2VkIEZlYXR1cmVzCgkJQUZD
YXA6IFRQKyBGTFIrCgkJQUZDdHJsOiBGTFItCgkJQUZTdGF0dXM6IFRQLQoJS2VybmVsIGRy
aXZlciBpbiB1c2U6IGFoY2kKCjAwOjFmLjMgU01CdXM6IEludGVsIENvcnBvcmF0aW9uIDYg
U2VyaWVzL0MyMDAgU2VyaWVzIENoaXBzZXQgRmFtaWx5IFNNQnVzIENvbnRyb2xsZXIgKHJl
diAwNSkKCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ29udHJvbDogSS9PKyBNZW0r
IEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVw
cGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwLSA2Nk1Iei0gVURG
LSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1B
Ym9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJSW50ZXJydXB0OiBwaW4gQyByb3V0ZWQgdG8g
SVJRIDE4CglSZWdpb24gMDogTWVtb3J5IGF0IGY3ZjA1MDAwICg2NC1iaXQsIG5vbi1wcmVm
ZXRjaGFibGUpIFtzaXplPTI1Nl0KCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgZjA0MCBbc2l6
ZT0zMl0KCjA1OjAwLjAgRXRoZXJuZXQgY29udHJvbGxlcjogUmVhbHRlayBTZW1pY29uZHVj
dG9yIENvLiwgTHRkLiBSVEw4MTExLzgxNjgvODQxMSBQQ0kgRXhwcmVzcyBHaWdhYml0IEV0
aGVybmV0IENvbnRyb2xsZXIgKHJldiAwNikKCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRi
MwoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBW
R0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeCsKCVN0
YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6
IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVk
IHRvIElSUSA0NAoJUmVnaW9uIDA6IEkvTyBwb3J0cyBhdCBlMDAwIFtzaXplPTI1Nl0KCVJl
Z2lvbiAyOiBNZW1vcnkgYXQgZjExMDQwMDAgKDY0LWJpdCwgcHJlZmV0Y2hhYmxlKSBbc2l6
ZT00S10KCVJlZ2lvbiA0OiBNZW1vcnkgYXQgZjExMDAwMDAgKDY0LWJpdCwgcHJlZmV0Y2hh
YmxlKSBbc2l6ZT0xNktdCglDYXBhYmlsaXRpZXM6IFs0MF0gUG93ZXIgTWFuYWdlbWVudCB2
ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxKyBEMisgQXV4Q3VycmVudD0zNzVt
QSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRS
c3QrIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1
MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczog
MDAwMDAwMDBmZWUwMTAwYyAgRGF0YTogNDFkMQoJQ2FwYWJpbGl0aWVzOiBbNzBdIEV4cHJl
c3MgKHYyKSBFbmRwb2ludCwgTVNJIDAxCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDI1NiBieXRl
cywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw1MTJucywgTDEgPDY0dXMKCQkJRXh0VGFn
LSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgNDA5NiBieXRlcwoJCURldlN0YToJ
Q29yckVycisgVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxKyBBdXhQd3IrIFRyYW5z
UGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BN
IEwwcyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDw2NHVzCgkJCUNsb2NrUE0rIFN1cnBy
aXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQg
Ynl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BN
LSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3Ms
IFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFC
V01nbXQtCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBUaW1lb3V0OiBOb3QgU3VwcG9ydGVkLCBU
aW1lb3V0RGlzKywgTFRSLSwgT0JGRiBOb3QgU3VwcG9ydGVkCgkJRGV2Q3RsMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiA1MHVzIHRvIDUwbXMsIFRpbWVvdXREaXMtLCBMVFItLCBPQkZGIERp
c2FibGVkCgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29t
cGxpYW5jZS0gU3BlZWREaXMtCgkJCSBUcmFuc21pdCBNYXJnaW46IE5vcm1hbCBPcGVyYXRp
bmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBDb21wbGlhbmNlU09TLQoJCQkg
Q29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0YTI6IEN1cnJlbnQgRGUtZW1w
aGFzaXMgTGV2ZWw6IC02ZEIsIEVxdWFsaXphdGlvbkNvbXBsZXRlLSwgRXF1YWxpemF0aW9u
UGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSwgRXF1YWxpemF0aW9uUGhhc2UzLSwg
TGlua0VxdWFsaXphdGlvblJlcXVlc3QtCglDYXBhYmlsaXRpZXM6IFtiMF0gTVNJLVg6IEVu
YWJsZS0gQ291bnQ9NCBNYXNrZWQtCgkJVmVjdG9yIHRhYmxlOiBCQVI9NCBvZmZzZXQ9MDAw
MDAwMDAKCQlQQkE6IEJBUj00IG9mZnNldD0wMDAwMDgwMAoJQ2FwYWJpbGl0aWVzOiBbZDBd
IFZpdGFsIFByb2R1Y3QgRGF0YQoJCVVua25vd24gc21hbGwgcmVzb3VyY2UgdHlwZSAwMCwg
d2lsbCBub3QgZGVjb2RlIG1vcmUuCglDYXBhYmlsaXRpZXM6IFsxMDAgdjFdIEFkdmFuY2Vk
IEVycm9yIFJlcG9ydGluZwoJCVVFU3RhOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRP
LSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0g
QUNTVmlvbC0KCQlVRU1zazoJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRB
YnJ0LSBVbnhDbXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wt
CgkJVUVTdnJ0OglETFArIFNERVMrIFRMUC0gRkNQKyBDbXBsdFRPLSBDbXBsdEFicnQtIFVu
eENtcGx0LSBSeE9GKyBNYWxmVExQKyBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlDRVN0
YToJUnhFcnIrIEJhZFRMUC0gQmFkRExMUC0gUm9sbG92ZXItIFRpbWVvdXQtIE5vbkZhdGFs
RXJyKwoJCUNFTXNrOglSeEVyci0gQmFkVExQLSBCYWRETExQLSBSb2xsb3Zlci0gVGltZW91
dC0gTm9uRmF0YWxFcnIrCgkJQUVSQ2FwOglGaXJzdCBFcnJvciBQb2ludGVyOiAwMCwgR2Vu
Q2FwKyBDR2VuRW4tIENoa0NhcCsgQ2hrRW4tCglDYXBhYmlsaXRpZXM6IFsxNDAgdjFdIFZp
cnR1YWwgQ2hhbm5lbAoJCUNhcHM6CUxQRVZDPTAgUmVmQ2xrPTEwMG5zIFBBVEVudHJ5Qml0
cz0xCgkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtCgkJQ3RybDoJQXJiU2Vs
ZWN0PUZpeGVkCgkJU3RhdHVzOglJblByb2dyZXNzLQoJCVZDMDoJQ2FwczoJUEFUT2Zmc2V0
PTAwIE1heFRpbWVTbG90cz0xIFJlalNub29wVHJhbnMtCgkJCUFyYjoJRml4ZWQtIFdSUjMy
LSBXUlI2NC0gV1JSMTI4LSBUV1JSMTI4LSBXUlIyNTYtCgkJCUN0cmw6CUVuYWJsZSsgSUQ9
MCBBcmJTZWxlY3Q9Rml4ZWQgVEMvVkM9ZmYKCQkJU3RhdHVzOglOZWdvUGVuZGluZy0gSW5Q
cm9ncmVzcy0KCUNhcGFiaWxpdGllczogWzE2MCB2MV0gRGV2aWNlIFNlcmlhbCBOdW1iZXIg
MDEtMDAtMDAtMDAtNjgtNGMtZTAtMDAKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiByODE2OQoK
MDk6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIENlbnRyaW5v
IFdpcmVsZXNzLU4gMTAzMCBbUmFpbmJvdyBQZWFrXSAocmV2IDM0KQoJU3Vic3lzdGVtOiBJ
bnRlbCBDb3Jwb3JhdGlvbiBDZW50cmlubyBXaXJlbGVzcy1OIDEwMzAgQkdOCglDb250cm9s
OiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXAr
IDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRB
Ym9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUg
TGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDQ4
CglSZWdpb24gMDogTWVtb3J5IGF0IGY3ZTAwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFi
bGUpIFtzaXplPThLXQoJQ2FwYWJpbGl0aWVzOiBbYzhdIFBvd2VyIE1hbmFnZW1lbnQgdmVy
c2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJKyBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBN
RShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0g
UE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogW2QwXSBN
U0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAw
MDAwMGZlZTAxMDBjICBEYXRhOiA0MTcyCglDYXBhYmlsaXRpZXM6IFtlMF0gRXhwcmVzcyAo
djEpIEVuZHBvaW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQ
aGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDUxMm5zLCBMMSB1bmxpbWl0ZWQKCQkJRXh0VGFn
LSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRSsgRkxSZXNldCsKCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsgRkxS
ZXNldC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJ
RGV2U3RhOglDb3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXErIEF1eFB3
cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQgMi41R1QvcywgV2lkdGgg
eDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5IEwwIDw0dXMsIEwxIDwzMnVzCgkJCUNsb2NrUE0r
IFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBS
Q0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBD
bG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIu
NUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01n
bXQtIEFCV01nbXQtCglDYXBhYmlsaXRpZXM6IFsxMDAgdjFdIEFkdmFuY2VkIEVycm9yIFJl
cG9ydGluZwoJCVVFU3RhOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFi
cnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0K
CQlVRU1zazoJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhD
bXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wtCgkJVUVTdnJ0
OglETFArIFNERVMtIFRMUC0gRkNQKyBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBS
eE9GKyBNYWxmVExQKyBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlDRVN0YToJUnhFcnIr
IEJhZFRMUC0gQmFkRExMUC0gUm9sbG92ZXItIFRpbWVvdXQtIE5vbkZhdGFsRXJyKwoJCUNF
TXNrOglSeEVyci0gQmFkVExQLSBCYWRETExQLSBSb2xsb3Zlci0gVGltZW91dC0gTm9uRmF0
YWxFcnIrCgkJQUVSQ2FwOglGaXJzdCBFcnJvciBQb2ludGVyOiAwMCwgR2VuQ2FwLSBDR2Vu
RW4tIENoa0NhcC0gQ2hrRW4tCglDYXBhYmlsaXRpZXM6IFsxNDAgdjFdIERldmljZSBTZXJp
YWwgTnVtYmVyIDRjLTgwLTkzLWZmLWZmLTE1LWU2LWM3CglLZXJuZWwgZHJpdmVyIGluIHVz
ZTogaXdsd2lmaQoKMGI6MDAuMCBVU0IgY29udHJvbGxlcjogVGV4YXMgSW5zdHJ1bWVudHMg
VFVTQjczeDAgU3VwZXJTcGVlZCBVU0IgMy4wIHhIQ0kgSG9zdCBDb250cm9sbGVyIChyZXYg
MDIpIChwcm9nLWlmIDMwIFtYSENJXSkKCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJ
Q29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FT
bm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeCsKCVN0YXR1
czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAs
IENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRv
IElSUSAxNgoJUmVnaW9uIDA6IE1lbW9yeSBhdCBmN2QwMDAwMCAoNjQtYml0LCBub24tcHJl
ZmV0Y2hhYmxlKSBbc2l6ZT02NEtdCglSZWdpb24gMjogTWVtb3J5IGF0IGY3ZDEwMDAwICg2
NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPThLXQoJQ2FwYWJpbGl0aWVzOiBbNDBd
IFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMSsg
RDIrIEF1eEN1cnJlbnQ9MTAwbUEgUE1FKEQwKyxEMSssRDIrLEQzaG90KyxEM2NvbGQrKQoJ
CVN0YXR1czogRDAgTm9Tb2Z0UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1F
LQoJQ2FwYWJpbGl0aWVzOiBbNDhdIE1TSTogRW5hYmxlLSBDb3VudD0xLzggTWFza2FibGUt
IDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwMDAwMDAwMDAgIERhdGE6IDAwMDAKCUNhcGFi
aWxpdGllczogWzcwXSBFeHByZXNzICh2MikgRW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJ
TWF4UGF5bG9hZCAxMDI0IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgdW5saW1p
dGVkLCBMMSB1bmxpbWl0ZWQKCQkJRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQt
IFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBO
b24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFu
dEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJl
YWRSZXEgNTEyIGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJy
LSBVbnN1cHBSZXErIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3Bl
ZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwx
IDw2NHVzCgkJCUNsb2NrUE0rIFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3Rs
OglBU1BNIEwxIEVuYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29t
bUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0rIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50
LQoJCUxua1N0YToJU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RD
bGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBOb3QgU3VwcG9ydGVkLCBUaW1lb3V0RGlzKywgTFRSLSwgT0JGRiBOb3QgU3Vw
cG9ydGVkCgkJRGV2Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVzIHRvIDUwbXMsIFRp
bWVvdXREaXMtLCBMVFItLCBPQkZGIERpc2FibGVkCgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsg
U3BlZWQ6IDVHVC9zLCBFbnRlckNvbXBsaWFuY2UtIFNwZWVkRGlzLQoJCQkgVHJhbnNtaXQg
TWFyZ2luOiBOb3JtYWwgT3BlcmF0aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5j
ZS0gQ29tcGxpYW5jZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlM
bmtTdGEyOiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtNmRCLCBFcXVhbGl6YXRpb25D
b21wbGV0ZS0sIEVxdWFsaXphdGlvblBoYXNlMS0KCQkJIEVxdWFsaXphdGlvblBoYXNlMi0s
IEVxdWFsaXphdGlvblBoYXNlMy0sIExpbmtFcXVhbGl6YXRpb25SZXF1ZXN0LQoJQ2FwYWJp
bGl0aWVzOiBbYzBdIE1TSS1YOiBFbmFibGUrIENvdW50PTggTWFza2VkLQoJCVZlY3RvciB0
YWJsZTogQkFSPTIgb2Zmc2V0PTAwMDAwMDAwCgkJUEJBOiBCQVI9MiBvZmZzZXQ9MDAwMDEw
MDAKCUNhcGFiaWxpdGllczogWzEwMCB2Ml0gQWR2YW5jZWQgRXJyb3IgUmVwb3J0aW5nCgkJ
VUVTdGE6CURMUC0gU0RFUy0gVExQLSBGQ1AtIENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21w
bHQtIFJ4T0YtIE1hbGZUTFAtIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9sLQoJCVVFTXNrOglE
TFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9G
LSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlVRVN2cnQ6CURMUCsgU0RF
UysgVExQLSBGQ1ArIENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YrIE1hbGZU
TFArIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9sLQoJCUNFU3RhOglSeEVyci0gQmFkVExQLSBC
YWRETExQKyBSb2xsb3Zlci0gVGltZW91dC0gTm9uRmF0YWxFcnIrCgkJQ0VNc2s6CVJ4RXJy
LSBCYWRUTFAtIEJhZERMTFAtIFJvbGxvdmVyLSBUaW1lb3V0LSBOb25GYXRhbEVycisKCQlB
RVJDYXA6CUZpcnN0IEVycm9yIFBvaW50ZXI6IDAwLCBHZW5DYXArIENHZW5Fbi0gQ2hrQ2Fw
KyBDaGtFbi0KCUNhcGFiaWxpdGllczogWzE1MCB2MV0gRGV2aWNlIFNlcmlhbCBOdW1iZXIg
MDgtMDAtMjgtMDAtMDAtMjAtMDAtMDAKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiB4aGNpX2hj
ZAoK
--------------000002040909030103070009--
