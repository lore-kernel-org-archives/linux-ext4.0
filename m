From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
Subject: Re: 3.10.9: EXT4-fs (sdb1): delayed block allocation failed for inode
 163315715 at logical offset 1 with max blocks 2 with error -5
Date: Wed, 28 Aug 2013 16:29:06 +0200
Message-ID: <521E0932.6000706@gmail.com>
References: <521DE3C1.8030304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"hughd@google.com" <hughd@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <521DE3C1.8030304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hugh,
  looks you are right person to ask per https://lkml.org/lkml/2012/8/23=
/9=20

What can I do now with my system? Is it so that for unknown reason (mis=
interpreted ACPI condition?)
/dev/sdb was stopped by SandyBridge and after an hour when shell redire=
cts of valgrind's STDOUT
and STDERR to a file filled up some kernel buffers (because could not w=
rite to /mnt/external)
the ext4 driver choked?

# cat /proc/sys/vm/laptop_mode
0
#

Have app-laptop/laptop-mode-tools-1.63-r2 on Gentoo Linux.

Thank you,
Martin

Martin MOKREJ=C5=A0 wrote:
> Hi,
>   I have been running two instances of valgrind on some application o=
n 3.10.9 kernel
> with a patch aiming to fix a BOS descriptor memleak (see linux-usb Su=
bject
> "[RFC v2] usbcore: compare and release one bos descriptor in usb_rese=
t_and_verify_device()"
> but I hope it is unrelated). I enabled in the kernel some extra check=
s for kernel
> sanity in Kernel hacking section (am looking for an answer why someth=
ing overwrites memory
> of my python-based application). Hence the valgrind and attempts to f=
ortify kernel a bit
> more (see attached diff since last known good .config).
>=20
>   Below I show when I early in the morning connected the external SAT=
A drive drive
> and that muich later, kernel suddenly lost ability to read/write the =
filesystem.
> I somewhat suspect that laptop-mode-tools (although configured to ign=
ore mouse/keyboard
> and usb-storage devices) somehow triggered the cause. However, still =
I would like to see
> that something happened at the SATA level.
>=20
>=20
> Aug 28 04:41:05 vostro kernel: [  248.268202] ata6: exception Emask 0=
x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
> Aug 28 04:41:05 vostro kernel: [  248.268205] ata6: irq_stat 0x000000=
40, connection status changed
> Aug 28 04:41:05 vostro kernel: [  248.268207] ata6: SError: { DevExch=
 }
> Aug 28 04:41:05 vostro kernel: [  248.268212] ata6: hard resetting li=
nk
> Aug 28 04:41:06 vostro kernel: [  249.009819] ata6: SATA link up 3.0 =
Gbps (SStatus 123 SControl 300)
> Aug 28 04:41:06 vostro kernel: [  249.010951] ata6.00: ATA-8: ST3000V=
X000-1CU166, CV22, max UDMA/133
> Aug 28 04:41:06 vostro kernel: [  249.010963] ata6.00: 5860533168 sec=
tors, multi 0: LBA48 NCQ (depth 31/32), AA
> Aug 28 04:41:06 vostro kernel: [  249.012058] ata6.00: configured for=
 UDMA/133
> Aug 28 04:41:06 vostro kernel: [  249.029823] ata6: EH complete
> Aug 28 04:41:06 vostro kernel: [  249.030376] scsi 5:0:0:0: Direct-Ac=
cess     ATA      ST3000VX000-1CU1 CV22 PQ: 0 ANSI: 5
> Aug 28 04:41:06 vostro kernel: [  249.032304] sd 5:0:0:0: [sdb] 58605=
33168 512-byte logical blocks: (3.00 TB/2.72 TiB)
> Aug 28 04:41:06 vostro kernel: [  249.032306] sd 5:0:0:0: [sdb] 4096-=
byte physical blocks
> Aug 28 04:41:06 vostro kernel: [  249.032623] sd 5:0:0:0: [sdb] Write=
 Protect is off
> Aug 28 04:41:06 vostro kernel: [  249.032625] sd 5:0:0:0: [sdb] Mode =
Sense: 00 3a 00 00
> Aug 28 04:41:06 vostro kernel: [  249.032755] sd 5:0:0:0: [sdb] Write=
 cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 28 04:41:06 vostro kernel: [  249.033850] sd 5:0:0:0: Attached sc=
si generic sg2 type 0
> Aug 28 04:41:06 vostro kernel: [  249.089816]  sdb: sdb1
> Aug 28 04:41:06 vostro kernel: [  249.091295] sd 5:0:0:0: [sdb] Attac=
hed SCSI disk
> Aug 28 04:42:51 vostro kernel: [  354.033592] EXT4-fs (sdb1): mounted=
 filesystem with ordered data mode. Opts: (null)
> Aug 28 09:46:39 vostro kernel: [18604.328975] ata6: exception Emask 0=
x10 SAct 0x0 SErr 0x4090000 action 0xe frozen
> Aug 28 09:46:39 vostro kernel: [18604.328985] ata6: irq_stat 0x004000=
40, connection status changed
> Aug 28 09:46:39 vostro kernel: [18604.328992] ata6: SError: { PHYRdyC=
hg 10B8B DevExch }
> Aug 28 09:46:39 vostro kernel: [18604.329007] ata6: hard resetting li=
nk
> Aug 28 09:46:39 vostro logger: ACPI event unhandled: ac_adapter AC 00=
000080 00000000
> Aug 28 09:46:39 vostro kernel: [18605.089011] ata6: SATA link down (S=
Status 0 SControl 300)
> Aug 28 09:46:40 vostro laptop-mode: Laptop mode
> Aug 28 09:46:40 vostro laptop-mode: enabled, active
> Aug 28 09:46:41 vostro logger: ACPI event unhandled: battery BAT0 000=
00080 00000001
> Aug 28 09:46:41 vostro kernel: [18607.033618] ata6: hard resetting li=
nk
> Aug 28 09:46:42 vostro kernel: [18607.336433] EXT4-fs (sdb1): re-moun=
ted. Opts: commit=3D600
> Aug 28 09:46:42 vostro kernel: [18607.381792] ata6: SATA link down (S=
Status 0 SControl 300)
> Aug 28 09:46:42 vostro kernel: [18607.381802] ata6: limiting SATA lin=
k speed to 1.5 Gbps
> Aug 28 09:46:44 vostro logger: Device 2-1.2 is blacklisted, skipping =
auto suspend.
> Aug 28 09:46:44 vostro logger: Device 2-1.2:1.0 is blacklisted, skipp=
ing auto suspend.
> Aug 28 09:46:45 vostro logger: Device 3-2.4 is blacklisted, skipping =
auto suspend.
> Aug 28 09:46:46 vostro logger: Device 3-2.4:1.0 is blacklisted, skipp=
ing auto suspend.
> Aug 28 09:46:47 vostro kernel: [18612.387982] ata6: hard resetting li=
nk
> Aug 28 09:46:47 vostro kernel: [18612.738408] ata6: SATA link down (S=
Status 0 SControl 310)
> Aug 28 09:46:47 vostro kernel: [18612.738418] ata6.00: disabled
> Aug 28 09:46:47 vostro kernel: [18612.738435] ata6: EH complete
> Aug 28 09:46:47 vostro kernel: [18612.738546] ata6.00: detaching (SCS=
I 5:0:0:0)
> Aug 28 09:46:47 vostro kernel: [18612.881503] sd 5:0:0:0: [sdb] Synch=
ronizing SCSI cache
> Aug 28 09:46:47 vostro kernel: [18612.882157] sd 5:0:0:0: [sdb]
> Aug 28 09:46:47 vostro kernel: [18612.882160] Result: hostbyte=3DDID_=
BAD_TARGET driverbyte=3DDRIVER_OK
> Aug 28 09:46:47 vostro kernel: [18612.882161] sd 5:0:0:0: [sdb] Stopp=
ing disk
> Aug 28 09:46:47 vostro kernel: [18612.882196] sd 5:0:0:0: [sdb] START=
_STOP FAILED
> Aug 28 09:46:47 vostro kernel: [18612.882197] sd 5:0:0:0: [sdb]
> Aug 28 09:46:47 vostro kernel: [18612.882198] Result: hostbyte=3DDID_=
BAD_TARGET driverbyte=3DDRIVER_OK
> Aug 28 09:46:47 vostro laptop-mode: Laptop mode
> Aug 28 09:46:47 vostro laptop-mode: enabled, active [unchanged]
> Aug 28 09:47:44 vostro kernel: [18669.259990] ehci-pci 0000:00:1a.0: =
PME# enabled
> Aug 28 09:50:01 vostro cron[6478]: (root) CMD (test -x /usr/sbin/run-=
crons && /usr/sbin/run-crons)
> Aug 28 09:56:08 vostro laptop-mode: Laptop mode
> Aug 28 09:56:08 vostro laptop-mode: enabled, active [unchanged]
> Aug 28 09:56:08 vostro logger: ACPI event unhandled: battery BAT0 000=
00080 00000001
> Aug 28 09:56:08 vostro laptop-mode: Laptop mode
> Aug 28 09:56:08 vostro laptop-mode: enabled, active [unchanged]
> Aug 28 09:56:08 vostro laptop-mode: Laptop mode
> Aug 28 09:56:08 vostro laptop-mode: enabled, not active
> Aug 28 09:56:09 vostro kernel: [19175.537671] NMI watchdog: enabled o=
n all CPUs, permanently consumes one hw-PMU counter.
> Aug 28 09:56:10 vostro kernel: [19176.076583] ehci-pci 0000:00:1a.0: =
BAR 0: set to [mem 0xf7f08000-0xf7f083ff] (PCI address [0xf7f08000-0xf7=
f083ff])
> Aug 28 09:56:10 vostro kernel: [19176.076590] ehci-pci 0000:00:1a.0: =
restoring config space at offset 0x3c (was 0x100, writing 0x10b)
> Aug 28 09:56:10 vostro kernel: [19176.076617] ehci-pci 0000:00:1a.0: =
restoring config space at offset 0x4 (was 0x2900000, writing 0x2900002)
> Aug 28 09:56:10 vostro kernel: [19176.089350] ehci-pci 0000:00:1a.0: =
PME# disabled
> Aug 28 09:56:10 vostro kernel: [19176.090810] ehci-pci 0000:00:1a.0: =
enabling bus mastering
> Aug 28 09:56:10 vostro kernel: [19176.090816] ehci-pci 0000:00:1a.0: =
setting latency timer to 64
> Aug 28 09:56:10 vostro logger: ACPI event unhandled: battery BAT0 000=
00080 00000001
> Aug 28 09:56:12 vostro laptop-mode: Laptop mode
> Aug 28 09:56:12 vostro laptop-mode: enabled, not active [unchanged]
> Aug 28 10:35:08 vostro laptop-mode: Laptop mode
> Aug 28 10:35:08 vostro laptop-mode: enabled, not active [unchanged]
> Aug 28 10:35:08 vostro logger: ACPI event unhandled: battery BAT0 000=
00080 00000001
> Aug 28 10:35:08 vostro laptop-mode: Laptop mode
> Aug 28 10:35:08 vostro laptop-mode: enabled, not active [unchanged]
>=20
>=20
> but later on, suddenly, without any other related message in between =
as far as I can see:
>=20
> Aug 28 11:47:39 vostro kernel: [25874.121506] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:47:39 vostro kernel: [25874.121510] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:47:39 vostro kernel: [25874.121575] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:47:39 vostro kernel: [25874.121577] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:06 vostro kernel: [25901.086360] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:06 vostro kernel: [25901.086363] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:06 vostro kernel: [25901.086423] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:06 vostro kernel: [25901.086425] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:06 vostro kernel: [25901.204905] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: rea=
ding directory lblock 0
> Aug 28 11:48:06 vostro kernel: [25901.207692] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: rea=
ding directory lblock 0
> Aug 28 11:48:09 vostro kernel: [25904.225075] EXT4-fs error (device s=
db1): ext4_wait_block_bitmap:466: comm kworker/u8:4: Cannot read block =
bitmap - block_group =3D 19937, block_bitmap =3D 653262849
> Aug 28 11:48:09 vostro kernel: [25904.225087] EXT4-fs (sdb1): delayed=
 block allocation failed for inode 163315715 at logical offset 1 with m=
ax blocks 2 with error -5
> Aug 28 11:48:09 vostro kernel: [25904.225089] EXT4-fs (sdb1): This sh=
ould not happen!! Data will be lost
> Aug 28 11:48:12 vostro kernel: [25907.013801] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.013805] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.013871] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.013873] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.015685] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.015687] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.015714] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.015716] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.015733] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.015734] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.018138] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.018140] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.018157] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:12 vostro kernel: [25907.018159] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:12 vostro kernel: [25907.018906] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: rea=
ding directory lblock 0
> Aug 28 11:48:13 vostro kernel: [25908.368826] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.368829] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:13 vostro kernel: [25908.368859] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.368860] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:13 vostro kernel: [25908.368878] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.368879] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:13 vostro kernel: [25908.369287] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.369290] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:13 vostro kernel: [25908.369307] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.369308] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:13 vostro kernel: [25908.370318] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.370320] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:13 vostro kernel: [25908.370338] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:13 vostro kernel: [25908.370339] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:14 vostro kernel: [25909.243747] EXT4-fs error (device s=
db1): ext4_wait_block_bitmap:466: comm kworker/u8:4: Cannot read block =
bitmap - block_group =3D 19937, block_bitmap =3D 653262849
> Aug 28 11:48:14 vostro kernel: [25909.243759] EXT4-fs (sdb1): delayed=
 block allocation failed for inode 163315715 at logical offset 3 with m=
ax blocks 1 with error -5
> Aug 28 11:48:14 vostro kernel: [25909.243761] EXT4-fs (sdb1): This sh=
ould not happen!! Data will be lost
> Aug 28 11:48:14 vostro kernel: [25909.641975] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:14 vostro kernel: [25909.641978] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:48:14 vostro kernel: [25909.642007] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: com=
m memcheck-amd64-: unable to read itable block
> Aug 28 11:48:14 vostro kernel: [25909.642008] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
>=20
>=20
> [cut]
>=20
> Aug 28 11:49:29 vostro kernel: [25984.053680] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:49:29 vostro kernel: [25984.053757] EXT4-fs error (device s=
db1): __ext4_get_inode_loc:4039: inode #55836687: block 223346720: comm=
 memcheck-amd64-: unable to read itable block
> Aug 28 11:49:29 vostro kernel: [25984.053758] EXT4-fs error (device s=
db1) in ext4_reserve_inode_write:4973: IO failure
> Aug 28 11:49:29 vostro kernel: [25984.082439] EXT4-fs error (device s=
db1): ext4_wait_block_bitmap:466: comm memcheck-amd64-: Cannot read blo=
ck bitmap - block_group =3D 19937, block_bitmap =3D 653262849
> Aug 28 11:49:29 vostro kernel: [25984.082452] EXT4-fs (sdb1): delayed=
 block allocation failed for inode 55836688 at logical offset 1 with ma=
x blocks 3 with error -5
> Aug 28 11:49:29 vostro kernel: [25984.082453] EXT4-fs (sdb1): This sh=
ould not happen!! Data will be lost
> Aug 28 11:49:29 vostro kernel: [25984.082616] EXT4-fs error (device s=
db1): ext4_wait_block_bitmap:466: comm memcheck-amd64-: Cannot read blo=
ck bitmap - block_group =3D 374, block_bitmap =3D 12058630
> Aug 28 11:49:29 vostro kernel: [25984.082622] EXT4-fs (sdb1): delayed=
 block allocation failed for inode 55836687 at logical offset 1 with ma=
x blocks 243 with error -5
> Aug 28 11:49:29 vostro kernel: [25984.082623] EXT4-fs (sdb1): This sh=
ould not happen!! Data will be lost
> Aug 28 11:50:01 vostro cron[8131]: (root) CMD (test -x /usr/sbin/run-=
crons && /usr/sbin/run-crons)
> Aug 28 11:57:40 vostro kernel: [26476.360211] Aborting journal on dev=
ice sdb1-8.
> Aug 28 11:57:40 vostro kernel: [26476.360222] Buffer I/O error on dev=
ice sdb1, logical block 365985792
> Aug 28 11:57:40 vostro kernel: [26476.360223] lost page write due to =
I/O error on sdb1
> Aug 28 11:57:40 vostro kernel: [26476.360226] JBD2: Error -5 detected=
 when updating journal superblock for sdb1-8.
> Aug 28 11:57:55 vostro kernel: [26491.416007] EXT4-fs error (device s=
db1): __ext4_journal_start_sb:62: Detected aborted journal
> Aug 28 11:57:55 vostro kernel: [26491.416014] EXT4-fs (sdb1): Remount=
ing filesystem read-only
> Aug 28 11:57:55 vostro kernel: [26491.416017] EXT4-fs (sdb1): ext4_da=
_writepages: jbd2_start: 13312 pages, ino 55836687; err -30
>=20
> So kernel was trying for 10 minutes before it gave up?
>=20
> [cut, please of these repeated messages]
>=20
> Aug 28 12:56:31 vostro kernel: [30013.996669] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
> Aug 28 12:56:33 vostro kernel: [30015.310284] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
> Aug 28 12:56:33 vostro kernel: [30015.526548] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
> Aug 28 12:56:36 vostro kernel: [30018.490206] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
> Aug 28 12:56:36 vostro kernel: [30018.730504] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
> Aug 28 12:56:36 vostro kernel: [30018.898683] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
> Aug 28 12:56:42 vostro kernel: [30024.101650] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.101696] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.101729] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.102016] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.102175] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.102337] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.102494] EXT4-fs error (device s=
db1): ext4_find_entry:1309: inode #163315713: comm ls: reading director=
y lblock 0
> Aug 28 12:56:42 vostro kernel: [30024.103131] EXT4-fs warning (device=
 sdb1): __ext4_read_dirblock:908: error reading directory block (ino 16=
3315713, block 0)
>=20
>=20
> I could imagine valgrind took too much memory and maybe overwrote som=
e kernel structures? Or some of the new changes in .config?
>=20
> I ran two instances of: valgrind --leak-check=3Dfull --track-origins=3D=
yes --tool=3Dmemcheck --suppressions=3Dvalgrind-python.supp my_app_comp=
iled_by_cython_and_gcc [args]
>=20
> $ df -h
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/root       573G  533G   12G  98% /
> devtmpfs        7.8G     0  7.8G   0% /dev
> tmpfs           1.6G  3.0M  1.6G   1% /run
> shm             7.8G     0  7.8G   0% /dev/shm
> /dev/sdb1       2.7T  1.4T  1.3T  53% /mnt/external
> $ ls -la  /mnt/external
> ls: reading directory /mnt/external: Input/output error
> total 0
> $
>=20
> So, the target filesystem on the external disk should not be full.
>=20
> Any clues what I should look at? Few days ago memtest86+ went fine th=
rough all 16GB of RAM (Dell Vostro 3550). I do not know if the PCI/ACPI=
 change is related or not.=20
> Thank you,
> Martin
