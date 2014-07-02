From: Matteo Croce <technoboy85@gmail.com>
Subject: Re: ext4: journal has aborted
Date: Wed, 2 Jul 2014 10:34:03 +0200
Message-ID: <CAFnufp2fs2BRNP+kvSs=sdC4uV2FEPizVXLg7WLTdPmxzeN21A@mail.gmail.com>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org>
 <53B2A47F.90903@samsung.com> <20140701155812.GD2775@thunk.org> <20140701163646.GA3126@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	David Jander <david@protonic.nl>, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38106 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaGBIeo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jul 2014 04:34:44 -0400
Received: by mail-ob0-f171.google.com with SMTP id nu7so11945111obb.16
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jul 2014 01:34:44 -0700 (PDT)
In-Reply-To: <20140701163646.GA3126@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Similar issue on an X86 router:

# dmesg
Initializing cgroup subsys cpu
Linux version 3.15.0-alix (root@alix) (gcc version 4.8.3 (Debian
4.8.3-2) ) #2 Mon Jun 9 16:54:44 CEST 2014
KERNEL supported cpus:
  AMD AuthenticAMD
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000000fffffff] usable
BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
Notice: NX (Execute Disable) protection missing in CPU!
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x10000 max_arch_pfn = 0x100000
initial memory mapped: [mem 0x00000000-0x017fffff]
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x0fc00000-0x0fffffff]
 [mem 0x0fc00000-0x0fffffff] page 2M
init_memory_mapping: [mem 0x08000000-0x0fbfffff]
 [mem 0x08000000-0x0fbfffff] page 2M
init_memory_mapping: [mem 0x00100000-0x07ffffff]
 [mem 0x00100000-0x003fffff] page 4k
 [mem 0x00400000-0x07ffffff] page 2M
256MB LOWMEM available.
  mapped low ram: 0 - 10000000
  low ram: 0 - 10000000
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  Normal   [mem 0x01000000-0x0fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009ffff]
  node   0: [mem 0x00100000-0x0fffffff]
On node 0 totalpages: 65439
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3999 pages, LIFO batch:0
  Normal zone: 480 pages used for memmap
  Normal zone: 61440 pages, LIFO batch:15
e820: [mem 0x10000000-0xffefffff] available for PCI devices
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64927
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.15.0-alix
root=/dev/sda1 ro console=ttyS0,115200 panic=1 init=/bin/systemd
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Initializing CPU#0
Memory: 255748K/261756K available (2409K kernel code, 151K rwdata,
628K rodata, 160K init, 236K bss, 6008K reserved)
virtual kernel memory layout:
    fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
    vmalloc : 0xd0800000 - 0xfffe3000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
      .init : 0xc1320000 - 0xc1348000   ( 160 kB)
      .data : 0xc125aaef - 0xc131ece0   ( 784 kB)
      .text : 0xc1000000 - 0xc125aaef   (2410 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:16 nr_irqs:16 16
CPU 0 irqstacks, hard=cf808000 soft=cf80a000
console [ttyS0] enabled
tsc: Fast TSC calibration using PIT
tsc: Detected 498.030 MHz processor
Calibrating delay loop (skipped), value calculated using timer
frequency.. 996.06 BogoMIPS (lpj=4980300)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
tlb_flushall_shift: -1
CPU: Geode(TM) Integrated Processor by AMD PCS (fam: 06, model: 0a,
stepping: 02)
Performance Events:
no APIC, boot with the "lapic" boot parameter to force-enable it.
no hardware sampling interrupt available.
Broken PMU hardware detected, using software events only.
Failed to access perfctr msr (MSR c0010004 is 0)
devtmpfs: initialized
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
PCI: PCI BIOS revision 2.10 entry at 0xfced9, last bus=0
PCI: Using configuration type 1 for base access
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Probing PCI hardware
PCI: root bus 00: using default resources
PCI: Probing PCI hardware (bus 00)
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
pci 0000:00:01.0: [1022:2080] type 00 class 0x060000
pci 0000:00:01.0: reg 0x10: [io  0xac1c-0xac1f]
pci 0000:00:01.2: [1022:2082] type 00 class 0x101000
pci 0000:00:01.2: reg 0x10: [mem 0xefff4000-0xefff7fff]
pci 0000:00:09.0: [1106:3053] type 00 class 0x020000
pci 0000:00:09.0: reg 0x10: [io  0x1000-0x10ff]
pci 0000:00:09.0: reg 0x14: [mem 0xe0000000-0xe00000ff]
pci 0000:00:09.0: supports D1 D2
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: [168c:0029] type 00 class 0x028000
pci 0000:00:0c.0: reg 0x10: [mem 0xe0040000-0xe004ffff]
pci 0000:00:0c.0: PME# supported from D0 D3hot
pci 0000:00:0f.0: [1022:2090] type 00 class 0x060100
pci 0000:00:0f.0: reg 0x10: [io  0x6000-0x6007]
pci 0000:00:0f.0: reg 0x14: [io  0x6100-0x61ff]
pci 0000:00:0f.0: reg 0x18: [io  0x6200-0x623f]
pci 0000:00:0f.0: reg 0x20: [io  0x9d00-0x9d7f]
pci 0000:00:0f.0: reg 0x24: [io  0x9c00-0x9c3f]
pci 0000:00:0f.2: [1022:209a] type 00 class 0x010180
pci 0000:00:0f.2: reg 0x20: [io  0xff00-0xff0f]
pci 0000:00:0f.2: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:0f.2: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:0f.2: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:0f.2: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:0f.4: [1022:2094] type 00 class 0x0c0310
pci 0000:00:0f.4: reg 0x10: [mem 0xefffe000-0xefffefff]
pci 0000:00:0f.4: PME# supported from D0 D3hot D3cold
pci 0000:00:0f.5: [1022:2095] type 00 class 0x0c0320
pci 0000:00:0f.5: reg 0x10: [mem 0xefffd000-0xefffdfff]
pci 0000:00:0f.5: PME# supported from D0 D3hot D3cold
pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
PCI: pci_cache_line_size set to 32 bytes
Switched to clocksource pit
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
TCP established hash table entries: 2048 (order: 1, 8192 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP: reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
futex hash table entries: 256 (order: -1, 3072 bytes)
msgmni has been set to 499
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered (default)
Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 921600) is a NS16550A
scsi0 : pata_cs5536
scsi1 : pata_cs5536
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata2: DUMMY
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc_cmos rtc_cmos: alarms up to one day, 114 bytes nvram
TCP: cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
rtc_cmos rtc_cmos: setting system clock to 2000-01-01 00:00:04 UTC (946684804)
ata1.00: CFA: , 20101012, max UDMA/100
ata1.00: 62537328 sectors, multi 0: LBA
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA                       2010 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 62537328 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda1): INFO: recovery required on readonly filesystem
EXT4-fs (sda1): write access will be enabled during recovery
Switched to clocksource tsc
EXT4-fs (sda1): orphan cleanup on readonly fs
EXT4-fs (sda1): 1 orphan inode deleted
EXT4-fs (sda1): recovery complete
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
devtmpfs: mounted
Freeing unused kernel memory: 160K (c1320000 - c1348000)
Write protecting the kernel text: 2412k
Write protecting the kernel read-only data: 632k
systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP +AUDIT
+SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
systemd[1]: Inserted module 'autofs4'
systemd[1]: Set hostname to <alix>.
random: systemd urandom read with 30 bits of entropy available
systemd[1]: Cannot add dependency job for unit
display-manager.service, ignoring: Unit display-manager.service failed
to load: No such file or directory. See system logs and 'systemctl
status display-manager.service' for details.
systemd[1]: Expecting device dev-ttyS0.device...
systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
systemd[1]: Started Forward Password Requests to Wall Directory Watch.
systemd[1]: Starting Syslog Socket.
systemd[1]: Listening on Syslog Socket.
systemd[1]: Starting Delayed Shutdown Socket.
systemd[1]: Listening on Delayed Shutdown Socket.
systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
systemd[1]: Starting Encrypted Volumes.
systemd[1]: Reached target Encrypted Volumes.
systemd[1]: Starting udev Kernel Socket.
systemd[1]: Listening on udev Kernel Socket.
systemd[1]: Starting udev Control Socket.
systemd[1]: Listening on udev Control Socket.
systemd[1]: Set up automount Arbitrary Executable File Formats File
System Automount Point.
systemd[1]: Starting Journal Socket.
systemd[1]: Listening on Journal Socket.
systemd[1]: Starting Syslog.
systemd[1]: Reached target Syslog.
systemd[1]: Mounted Huge Pages File System.
systemd[1]: Started Set Up Additional Binary Formats.
systemd[1]: Starting Create static device nodes in /dev...
systemd[1]: Starting Apply Kernel Variables...
systemd[1]: Starting Load Kernel Modules...
systemd[1]: Starting udev Coldplug all Devices...
systemd[1]: Starting Journal Service...
systemd[1]: Started Journal Service.
systemd[1]: Mounted POSIX Message Queue File System.
systemd[1]: Expecting device dev-sda2.device...
systemd[1]: Starting File System Check on Root Device...
cs5535-smb cs5535-smb: SCx200 device 'CS5535 ACB0' registered
cs5535-mfgpt cs5535-mfgpt: reserved resource region [io  0x6200-0x623f]
cs5535-mfgpt cs5535-mfgpt: 8 MFGPT timers available
cs5535-mfd 0000:00:0f.0: 5 devices registered.
systemd[1]: Started Create static device nodes in /dev.
systemd[1]: Started Apply Kernel Variables.
cs5535-mfgpt cs5535-mfgpt: registered timer 0
cs5535-clockevt: Registering MFGPT timer as a clock event, using IRQ 7
systemd[1]: Starting udev Kernel Device Manager...
systemd-udevd[317]: starting version 204
EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
cs5535-gpio cs5535-gpio: reserved resource region [io  0x6100-0x61ff]
via_rhine: v1.10-LK1.5.1 2010-10-09 Written by Donald Becker
via-rhine 0000:00:09.0 eth0: VIA Rhine III (Management Adapter) at
0xe0000000, 00:0d:b9:19:4c:bc, IRQ 10
via-rhine 0000:00:09.0 eth0: MII PHY found at address 1, status 0x7849
advertising 05e1 Link 0000
AMD Geode RNG detected
geode-aes: GEODE AES engine enabled.
cfg80211: Calling CRDA to update world regulatory domain
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
ohci-pci 0000:00:0f.4: OHCI PCI host controller
ohci-pci 0000:00:0f.4: new USB bus registered, assigned bus number 1
ohci-pci 0000:00:0f.4: irq 12, io mem 0xefffe000
ehci-pci: EHCI PCI platform driver
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci-pci 0000:00:0f.5: EHCI Host Controller
ehci-pci 0000:00:0f.5: new USB bus registered, assigned bus number 2
ehci-pci 0000:00:0f.5: irq 12, io mem 0xefffd000
cfg80211: World regulatory domain updated:
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp), (dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
ehci-pci 0000:00:0f.5: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xd0940000, irq=9
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp), (dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2300 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
Adding 858932k swap on /dev/sda2.  Priority:-1 extents:1 across:858932k
random: nonblocking pool is initialized
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
EXT4-fs error (device sda1): ext4_mb_generate_buddy:756: group 114,
24855 clusters in bitmap, 24856 in gd; block bitmap corrupt.
Aborting journal on device sda1-8.
EXT4-fs (sda1): Remounting filesystem read-only
# e2fsck -fy /dev/sda1
e2fsck 1.42.10 (18-May-2014)
/dev/sda1: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (6708644, counted=6708655).
Fix? yes

Free inodes count wrong (1752623, counted=1752627).
Fix? yes


/dev/sda1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda1: ***** REBOOT LINUX *****
/dev/sda1: 147917/1900544 files (0.1% non-contiguous), 893521/7602176 blocks

2014-07-01 18:36 GMT+02:00 Eric Whitney <enwlinux@gmail.com>:
> * Theodore Ts'o <tytso@mit.edu>:
>> On Tue, Jul 01, 2014 at 09:07:27PM +0900, Jaehoon Chung wrote:
>> > Hi,
>> >
>> > i have interesting for this problem..Because i also found the same problem..
>> > Is it Journal problem?
>> >
>> > I used the Linux version 3.16.0-rc3.
>> >
>> > [    3.866449] EXT4-fs error (device mmcblk0p13): ext4_mb_generate_buddy:756: group 0, 20490 clusters in bitmap, 20488 in gd; block bitmap corrupt.
>> > [    3.877937] Aborting journal on device mmcblk0p13-8.
>> > [    3.885025] Kernel panic - not syncing: EXT4-fs (device mmcblk0p13): panic forced after error
>>
>> This message means that the file system has detected an inconsistency
>> --- specifically, that the number of blocks marked as in use in the
>> allocation bbitmap is different from what is in the block group
>> descriptors.
>>
>> The file system has been marked to force a panic after an error, at
>> which point e2fsck will be able to repair the inconsistency.
>>
>> What's not clear is *how* the why this happened.  It can happen simply
>> because of a hardware problem.  (In particular, not all mmc flash
>> devices handle power failures gracefully.)  Or it could be a cosmic,
>> ray, or it might be a kernel bug.
>>
>> Normally I would chalk this up to a hardware bug, bug it's possible
>> that it is a kernel bug.  If people can reliably reproduce the problem
>> where no power failures or other unclean shutdowns were involved
>> (since the last time file system has been checked using e2fsck) then
>> that would be realy interesting.
>
> Hi Ted:
>
> I saw a similar failure during 3.16-rc3 (plus ext4 stable fixes plus msync
> patch) regression on the Pandaboard this morning.  A generic/068 hang
> on data_journal required a reboot for recovery (old bug, though rarer lately).
> On reboot, the root filesystem - default 4K, and on an SD card - went ro
> after the same sort of bad block bitmap / journal abort sequence.  Rebooting
> forced a fsck that cleared up the problem.  The target test filesystem was on
> a USB-attached disk, and it did not exhibit the same problems on recovery.
>
> So, it looks like there might be more than just hardware involved here,
> although eMMC/flash might be a common denominator.  I'll see if I can come up
> with a reliable reproducer once the regression pass is finished if someone
> doesn't beat me to it.
>
> Eric
>
>
>>
>> We should probably also change the message so the message is a bit
>> more understanding to people who aren't ext4 developers.
>>
>>                                       - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Matteo Croce
OpenWrt Developer
