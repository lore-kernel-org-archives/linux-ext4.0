From: Hugh Dickins <hughd@google.com>
Subject: Re: 3.10.9: EXT4-fs (sdb1): delayed block allocation failed for inode
 163315715 at logical offset 1 with max blocks 2 with error -5
Date: Wed, 28 Aug 2013 20:12:29 -0700
Message-ID: <CANsGZ6aX1SrHswxRpa46ywjDALyR6X-f8CTi6e9ZO0Uf8k06Rw@mail.gmail.com>
References: <521DE3C1.8030304@gmail.com>
	<521E0932.6000706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
To: =?UTF-8?Q?Martin_MOKREJ=C5=A0?= <mmokrejs@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47582 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3H2DMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 23:12:31 -0400
Received: by mail-qc0-f175.google.com with SMTP id m4so4010750qcy.34
        for <linux-ext4@vger.kernel.org>; Wed, 28 Aug 2013 20:12:30 -0700 (PDT)
In-Reply-To: <521E0932.6000706@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 7:29 AM, Martin MOKREJ=C5=A0 <mmokrejs@gmail.co=
m> wrote:
> Hugh,
>   looks you are right person to ask per https://lkml.org/lkml/2012/8/=
23/9

Sorry, Martin, I'm not at all the right person to help on this, I
haven't a clue.
You've already Cc'ed linux-ext4, right, someone there may have a
suggestion for you.
Good luck!
Hugh

>
> What can I do now with my system? Is it so that for unknown reason (m=
isinterpreted ACPI condition?)
> /dev/sdb was stopped by SandyBridge and after an hour when shell redi=
rects of valgrind's STDOUT
> and STDERR to a file filled up some kernel buffers (because could not=
 write to /mnt/external)
> the ext4 driver choked?
>
> # cat /proc/sys/vm/laptop_mode
> 0
> #
>
> Have app-laptop/laptop-mode-tools-1.63-r2 on Gentoo Linux.
>
> Thank you,
> Martin
>
> Martin MOKREJ=C5=A0 wrote:
>> Hi,
>>   I have been running two instances of valgrind on some application =
on 3.10.9 kernel
>> with a patch aiming to fix a BOS descriptor memleak (see linux-usb S=
ubject
>> "[RFC v2] usbcore: compare and release one bos descriptor in usb_res=
et_and_verify_device()"
>> but I hope it is unrelated). I enabled in the kernel some extra chec=
ks for kernel
>> sanity in Kernel hacking section (am looking for an answer why somet=
hing overwrites memory
>> of my python-based application). Hence the valgrind and attempts to =
fortify kernel a bit
>> more (see attached diff since last known good .config).
>>
>>   Below I show when I early in the morning connected the external SA=
TA drive drive
>> and that muich later, kernel suddenly lost ability to read/write the=
 filesystem.
>> I somewhat suspect that laptop-mode-tools (although configured to ig=
nore mouse/keyboard
>> and usb-storage devices) somehow triggered the cause. However, still=
 I would like to see
>> that something happened at the SATA level.
>>
>>
>> Aug 28 04:41:05 vostro kernel: [  248.268202] ata6: exception Emask =
0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
>> Aug 28 04:41:05 vostro kernel: [  248.268205] ata6: irq_stat 0x00000=
040, connection status changed
>> Aug 28 04:41:05 vostro kernel: [  248.268207] ata6: SError: { DevExc=
h }
>> Aug 28 04:41:05 vostro kernel: [  248.268212] ata6: hard resetting l=
ink
>> Aug 28 04:41:06 vostro kernel: [  249.009819] ata6: SATA link up 3.0=
 Gbps (SStatus 123 SControl 300)
>> Aug 28 04:41:06 vostro kernel: [  249.010951] ata6.00: ATA-8: ST3000=
VX000-1CU166, CV22, max UDMA/133
>> Aug 28 04:41:06 vostro kernel: [  249.010963] ata6.00: 5860533168 se=
ctors, multi 0: LBA48 NCQ (depth 31/32), AA
>> Aug 28 04:41:06 vostro kernel: [  249.012058] ata6.00: configured fo=
r UDMA/133
>> Aug 28 04:41:06 vostro kernel: [  249.029823] ata6: EH complete
>> Aug 28 04:41:06 vostro kernel: [  249.030376] scsi 5:0:0:0: Direct-A=
ccess     ATA      ST3000VX000-1CU1 CV22 PQ: 0 ANSI: 5
>> Aug 28 04:41:06 vostro kernel: [  249.032304] sd 5:0:0:0: [sdb] 5860=
533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
>> Aug 28 04:41:06 vostro kernel: [  249.032306] sd 5:0:0:0: [sdb] 4096=
-byte physical blocks
>> Aug 28 04:41:06 vostro kernel: [  249.032623] sd 5:0:0:0: [sdb] Writ=
e Protect is off
>> Aug 28 04:41:06 vostro kernel: [  249.032625] sd 5:0:0:0: [sdb] Mode=
 Sense: 00 3a 00 00
>> Aug 28 04:41:06 vostro kernel: [  249.032755] sd 5:0:0:0: [sdb] Writ=
e cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> Aug 28 04:41:06 vostro kernel: [  249.033850] sd 5:0:0:0: Attached s=
csi generic sg2 type 0
>> Aug 28 04:41:06 vostro kernel: [  249.089816]  sdb: sdb1
>> Aug 28 04:41:06 vostro kernel: [  249.091295] sd 5:0:0:0: [sdb] Atta=
ched SCSI disk
>> Aug 28 04:42:51 vostro kernel: [  354.033592] EXT4-fs (sdb1): mounte=
d filesystem with ordered data mode. Opts: (null)
>> Aug 28 09:46:39 vostro kernel: [18604.328975] ata6: exception Emask =
0x10 SAct 0x0 SErr 0x4090000 action 0xe frozen
>> Aug 28 09:46:39 vostro kernel: [18604.328985] ata6: irq_stat 0x00400=
040, connection status changed
>> Aug 28 09:46:39 vostro kernel: [18604.328992] ata6: SError: { PHYRdy=
Chg 10B8B DevExch }
>> Aug 28 09:46:39 vostro kernel: [18604.329007] ata6: hard resetting l=
ink
>> Aug 28 09:46:39 vostro logger: ACPI event unhandled: ac_adapter AC 0=
0000080 00000000
>> Aug 28 09:46:39 vostro kernel: [18605.089011] ata6: SATA link down (=
SStatus 0 SControl 300)
>> Aug 28 09:46:40 vostro laptop-mode: Laptop mode
>> Aug 28 09:46:40 vostro laptop-mode: enabled, active
>> Aug 28 09:46:41 vostro logger: ACPI event unhandled: battery BAT0 00=
000080 00000001
>> Aug 28 09:46:41 vostro kernel: [18607.033618] ata6: hard resetting l=
ink
>> Aug 28 09:46:42 vostro kernel: [18607.336433] EXT4-fs (sdb1): re-mou=
nted. Opts: commit=3D600
>> Aug 28 09:46:42 vostro kernel: [18607.381792] ata6: SATA link down (=
SStatus 0 SControl 300)
>> Aug 28 09:46:42 vostro kernel: [18607.381802] ata6: limiting SATA li=
nk speed to 1.5 Gbps
>> Aug 28 09:46:44 vostro logger: Device 2-1.2 is blacklisted, skipping=
 auto suspend.
>> Aug 28 09:46:44 vostro logger: Device 2-1.2:1.0 is blacklisted, skip=
ping auto suspend.
>> Aug 28 09:46:45 vostro logger: Device 3-2.4 is blacklisted, skipping=
 auto suspend.
>> Aug 28 09:46:46 vostro logger: Device 3-2.4:1.0 is blacklisted, skip=
ping auto suspend.
>> Aug 28 09:46:47 vostro kernel: [18612.387982] ata6: hard resetting l=
ink
>> Aug 28 09:46:47 vostro kernel: [18612.738408] ata6: SATA link down (=
SStatus 0 SControl 310)
>> Aug 28 09:46:47 vostro kernel: [18612.738418] ata6.00: disabled
>> Aug 28 09:46:47 vostro kernel: [18612.738435] ata6: EH complete
>> Aug 28 09:46:47 vostro kernel: [18612.738546] ata6.00: detaching (SC=
SI 5:0:0:0)
>> Aug 28 09:46:47 vostro kernel: [18612.881503] sd 5:0:0:0: [sdb] Sync=
hronizing SCSI cache
>> Aug 28 09:46:47 vostro kernel: [18612.882157] sd 5:0:0:0: [sdb]
>> Aug 28 09:46:47 vostro kernel: [18612.882160] Result: hostbyte=3DDID=
_BAD_TARGET driverbyte=3DDRIVER_OK
>> Aug 28 09:46:47 vostro kernel: [18612.882161] sd 5:0:0:0: [sdb] Stop=
ping disk
>> Aug 28 09:46:47 vostro kernel: [18612.882196] sd 5:0:0:0: [sdb] STAR=
T_STOP FAILED
>> Aug 28 09:46:47 vostro kernel: [18612.882197] sd 5:0:0:0: [sdb]
>> Aug 28 09:46:47 vostro kernel: [18612.882198] Result: hostbyte=3DDID=
_BAD_TARGET driverbyte=3DDRIVER_OK
>> Aug 28 09:46:47 vostro laptop-mode: Laptop mode
>> Aug 28 09:46:47 vostro laptop-mode: enabled, active [unchanged]
>> Aug 28 09:47:44 vostro kernel: [18669.259990] ehci-pci 0000:00:1a.0:=
 PME# enabled
>> Aug 28 09:50:01 vostro cron[6478]: (root) CMD (test -x /usr/sbin/run=
-crons && /usr/sbin/run-crons)
>> Aug 28 09:56:08 vostro laptop-mode: Laptop mode
>> Aug 28 09:56:08 vostro laptop-mode: enabled, active [unchanged]
>> Aug 28 09:56:08 vostro logger: ACPI event unhandled: battery BAT0 00=
000080 00000001
>> Aug 28 09:56:08 vostro laptop-mode: Laptop mode
>> Aug 28 09:56:08 vostro laptop-mode: enabled, active [unchanged]
>> Aug 28 09:56:08 vostro laptop-mode: Laptop mode
>> Aug 28 09:56:08 vostro laptop-mode: enabled, not active
>> Aug 28 09:56:09 vostro kernel: [19175.537671] NMI watchdog: enabled =
on all CPUs, permanently consumes one hw-PMU counter.
>> Aug 28 09:56:10 vostro kernel: [19176.076583] ehci-pci 0000:00:1a.0:=
 BAR 0: set to [mem 0xf7f08000-0xf7f083ff] (PCI address [0xf7f08000-0xf=
7f083ff])
>> Aug 28 09:56:10 vostro kernel: [19176.076590] ehci-pci 0000:00:1a.0:=
 restoring config space at offset 0x3c (was 0x100, writing 0x10b)
>> Aug 28 09:56:10 vostro kernel: [19176.076617] ehci-pci 0000:00:1a.0:=
 restoring config space at offset 0x4 (was 0x2900000, writing 0x2900002=
)
>> Aug 28 09:56:10 vostro kernel: [19176.089350] ehci-pci 0000:00:1a.0:=
 PME# disabled
>> Aug 28 09:56:10 vostro kernel: [19176.090810] ehci-pci 0000:00:1a.0:=
 enabling bus mastering
>> Aug 28 09:56:10 vostro kernel: [19176.090816] ehci-pci 0000:00:1a.0:=
 setting latency timer to 64
>> Aug 28 09:56:10 vostro logger: ACPI event unhandled: battery BAT0 00=
000080 00000001
>> Aug 28 09:56:12 vostro laptop-mode: Laptop mode
>> Aug 28 09:56:12 vostro laptop-mode: enabled, not active [unchanged]
>> Aug 28 10:35:08 vostro laptop-mode: Laptop mode
>> Aug 28 10:35:08 vostro laptop-mode: enabled, not active [unchanged]
>> Aug 28 10:35:08 vostro logger: ACPI event unhandled: battery BAT0 00=
000080 00000001
>> Aug 28 10:35:08 vostro laptop-mode: Laptop mode
>> Aug 28 10:35:08 vostro laptop-mode: enabled, not active [unchanged]
>>
>>
>> but later on, suddenly, without any other related message in between=
 as far as I can see:
>>
>> Aug 28 11:47:39 vostro kernel: [25874.121506] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:47:39 vostro kernel: [25874.121510] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:47:39 vostro kernel: [25874.121575] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:47:39 vostro kernel: [25874.121577] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:06 vostro kernel: [25901.086360] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:06 vostro kernel: [25901.086363] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:06 vostro kernel: [25901.086423] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:06 vostro kernel: [25901.086425] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:06 vostro kernel: [25901.204905] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: re=
ading directory lblock 0
>> Aug 28 11:48:06 vostro kernel: [25901.207692] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: re=
ading directory lblock 0
>> Aug 28 11:48:09 vostro kernel: [25904.225075] EXT4-fs error (device =
sdb1): ext4_wait_block_bitmap:466: comm kworker/u8:4: Cannot read block=
 bitmap - block_group =3D 19937, block_bitmap =3D 653262849
>> Aug 28 11:48:09 vostro kernel: [25904.225087] EXT4-fs (sdb1): delaye=
d block allocation failed for inode 163315715 at logical offset 1 with =
max blocks 2 with error -5
>> Aug 28 11:48:09 vostro kernel: [25904.225089] EXT4-fs (sdb1): This s=
hould not happen!! Data will be lost
>> Aug 28 11:48:12 vostro kernel: [25907.013801] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.013805] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.013871] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315715: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.013873] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.015685] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.015687] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.015714] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.015716] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.015733] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.015734] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.018138] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.018140] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.018157] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:12 vostro kernel: [25907.018159] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:12 vostro kernel: [25907.018906] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm memcheck-amd64-: re=
ading directory lblock 0
>> Aug 28 11:48:13 vostro kernel: [25908.368826] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.368829] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:13 vostro kernel: [25908.368859] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.368860] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:13 vostro kernel: [25908.368878] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.368879] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:13 vostro kernel: [25908.369287] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.369290] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:13 vostro kernel: [25908.369307] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.369308] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:13 vostro kernel: [25908.370318] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.370320] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:13 vostro kernel: [25908.370338] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:13 vostro kernel: [25908.370339] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:14 vostro kernel: [25909.243747] EXT4-fs error (device =
sdb1): ext4_wait_block_bitmap:466: comm kworker/u8:4: Cannot read block=
 bitmap - block_group =3D 19937, block_bitmap =3D 653262849
>> Aug 28 11:48:14 vostro kernel: [25909.243759] EXT4-fs (sdb1): delaye=
d block allocation failed for inode 163315715 at logical offset 3 with =
max blocks 1 with error -5
>> Aug 28 11:48:14 vostro kernel: [25909.243761] EXT4-fs (sdb1): This s=
hould not happen!! Data will be lost
>> Aug 28 11:48:14 vostro kernel: [25909.641975] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:14 vostro kernel: [25909.641978] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:48:14 vostro kernel: [25909.642007] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #163315716: block 653262880: co=
mm memcheck-amd64-: unable to read itable block
>> Aug 28 11:48:14 vostro kernel: [25909.642008] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>>
>>
>> [cut]
>>
>> Aug 28 11:49:29 vostro kernel: [25984.053680] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:49:29 vostro kernel: [25984.053757] EXT4-fs error (device =
sdb1): __ext4_get_inode_loc:4039: inode #55836687: block 223346720: com=
m memcheck-amd64-: unable to read itable block
>> Aug 28 11:49:29 vostro kernel: [25984.053758] EXT4-fs error (device =
sdb1) in ext4_reserve_inode_write:4973: IO failure
>> Aug 28 11:49:29 vostro kernel: [25984.082439] EXT4-fs error (device =
sdb1): ext4_wait_block_bitmap:466: comm memcheck-amd64-: Cannot read bl=
ock bitmap - block_group =3D 19937, block_bitmap =3D 653262849
>> Aug 28 11:49:29 vostro kernel: [25984.082452] EXT4-fs (sdb1): delaye=
d block allocation failed for inode 55836688 at logical offset 1 with m=
ax blocks 3 with error -5
>> Aug 28 11:49:29 vostro kernel: [25984.082453] EXT4-fs (sdb1): This s=
hould not happen!! Data will be lost
>> Aug 28 11:49:29 vostro kernel: [25984.082616] EXT4-fs error (device =
sdb1): ext4_wait_block_bitmap:466: comm memcheck-amd64-: Cannot read bl=
ock bitmap - block_group =3D 374, block_bitmap =3D 12058630
>> Aug 28 11:49:29 vostro kernel: [25984.082622] EXT4-fs (sdb1): delaye=
d block allocation failed for inode 55836687 at logical offset 1 with m=
ax blocks 243 with error -5
>> Aug 28 11:49:29 vostro kernel: [25984.082623] EXT4-fs (sdb1): This s=
hould not happen!! Data will be lost
>> Aug 28 11:50:01 vostro cron[8131]: (root) CMD (test -x /usr/sbin/run=
-crons && /usr/sbin/run-crons)
>> Aug 28 11:57:40 vostro kernel: [26476.360211] Aborting journal on de=
vice sdb1-8.
>> Aug 28 11:57:40 vostro kernel: [26476.360222] Buffer I/O error on de=
vice sdb1, logical block 365985792
>> Aug 28 11:57:40 vostro kernel: [26476.360223] lost page write due to=
 I/O error on sdb1
>> Aug 28 11:57:40 vostro kernel: [26476.360226] JBD2: Error -5 detecte=
d when updating journal superblock for sdb1-8.
>> Aug 28 11:57:55 vostro kernel: [26491.416007] EXT4-fs error (device =
sdb1): __ext4_journal_start_sb:62: Detected aborted journal
>> Aug 28 11:57:55 vostro kernel: [26491.416014] EXT4-fs (sdb1): Remoun=
ting filesystem read-only
>> Aug 28 11:57:55 vostro kernel: [26491.416017] EXT4-fs (sdb1): ext4_d=
a_writepages: jbd2_start: 13312 pages, ino 55836687; err -30
>>
>> So kernel was trying for 10 minutes before it gave up?
>>
>> [cut, please of these repeated messages]
>>
>> Aug 28 12:56:31 vostro kernel: [30013.996669] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>> Aug 28 12:56:33 vostro kernel: [30015.310284] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>> Aug 28 12:56:33 vostro kernel: [30015.526548] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>> Aug 28 12:56:36 vostro kernel: [30018.490206] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>> Aug 28 12:56:36 vostro kernel: [30018.730504] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>> Aug 28 12:56:36 vostro kernel: [30018.898683] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>> Aug 28 12:56:42 vostro kernel: [30024.101650] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.101696] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.101729] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.102016] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.102175] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.102337] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.102494] EXT4-fs error (device =
sdb1): ext4_find_entry:1309: inode #163315713: comm ls: reading directo=
ry lblock 0
>> Aug 28 12:56:42 vostro kernel: [30024.103131] EXT4-fs warning (devic=
e sdb1): __ext4_read_dirblock:908: error reading directory block (ino 1=
63315713, block 0)
>>
>>
>> I could imagine valgrind took too much memory and maybe overwrote so=
me kernel structures? Or some of the new changes in .config?
>>
>> I ran two instances of: valgrind --leak-check=3Dfull --track-origins=
=3Dyes --tool=3Dmemcheck --suppressions=3Dvalgrind-python.supp my_app_c=
ompiled_by_cython_and_gcc [args]
>>
>> $ df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/root       573G  533G   12G  98% /
>> devtmpfs        7.8G     0  7.8G   0% /dev
>> tmpfs           1.6G  3.0M  1.6G   1% /run
>> shm             7.8G     0  7.8G   0% /dev/shm
>> /dev/sdb1       2.7T  1.4T  1.3T  53% /mnt/external
>> $ ls -la  /mnt/external
>> ls: reading directory /mnt/external: Input/output error
>> total 0
>> $
>>
>> So, the target filesystem on the external disk should not be full.
>>
>> Any clues what I should look at? Few days ago memtest86+ went fine t=
hrough all 16GB of RAM (Dell Vostro 3550). I do not know if the PCI/ACP=
I change is related or not.
>> Thank you,
>> Martin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
