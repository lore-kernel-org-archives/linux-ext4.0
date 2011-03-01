From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 1 Mar 2011 13:26:50 -0600
Message-ID: <BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Livingston, John A" <john.a.livingston@boeing.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore T'so" <tytso@thunk.org>
To: "615998@bugs.debian.org" <615998@bugs.debian.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Whoops, looks like the Debian bug-tracker lost the CC list somehow.  I believe I've got all the CCs re-added, sorry for any duplicate emails.

On Mar 01, 2011, at 11:52, Kyle Moffett wrote:
> Package: linux-2.6
> Version: 2.6.32-30
> Severity: important
>
> I'm getting a repeatable BUG from ext4, which seems to be caused by
> Postfix processing its mail queue.  The specific filesystem block device
> that has the problem seems to be "dm-13", which on this boot is the
> logical volume containing the "/var/spool/postfix" chroot.
>
> This is a completely standard Debian installation running on an Amazon EC2
> instance (x86_64).  The filesystem is mounted in "data=journal" mode.
>
> This crash is *very* repeatable.  It occurs almost every reboot when
> there are more than 1 or 2 queued emails.  I will try re-mounting the
> filesystem in "data=ordered" mode momentarily.
>
> The relevant filesystems are:
>  /dev/mapper/system-root / ext4 rw,noatime,barrier=1,data=ordered 0 0
>  /dev/mapper/system-var /var ext4 rw,noatime,barrier=1,nodelalloc,data=journal 0 0
>  /dev/mapper/system-log /var/log ext4 rw,nosuid,nodev,noatime,barrier=1,data=ordered 0 0
>  /dev/xvda1 /boot ext3 rw,noatime,user_xattr,acl,data=journal 0 0
>  /dev/mapper/db-mail /var/mail ext4 rw,nosuid,nodev,noatime,barrier=1,data=ordered 0 0
>  /dev/mapper/db-postfix /var/spool/postfix ext4 rw,nosuid,nodev,noatime,barrier=1,nodelalloc,data=journal 0 0
>  /dev/mapper/db-smtp /var/lib/postfix ext4 rw,nosuid,nodev,noatime,barrier=1,nodelalloc,data=journal 0 0
>  /dev/mapper/db-smtpcfg /etc/postfix ext4 rw,nosuid,nodev,noatime,barrier=1,nodelalloc,data=journal 0 0
>
> In particular, I note that there was a previous report of a BUG at
> fs/jbd2/commit.c:533 which never seemed to get isolated:
>  http://www.kerneltrap.com/mailarchive/linux-ext4/2009/9/2/6373283
>
> I need to get this system operational again right now, but I'm going to
> take a consistent snapshot of it so I can debug it later.
>
> NOTE:  For followers on the linux-ext4 mailing list, this particular
> system is running the Debian "squeeze" kernel (based on 2.6.32), so it's
> theoretically possible this bug has been fixed upstream since then.
> I didn't have any luck finding such a fix on Google, though.
>
> -- Package-specific info:
> ** Version:
> Linux version 2.6.32-5-xen-amd64 (Debian 2.6.32-30) (ben@decadent.org.uk) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Wed Jan 12 05:46:49 UTC 2011
>
> ** Command line:
> root=/dev/mapper/system-root ro
>
> ** Tainted: D (128)
> * Kernel has oopsed before.
>
> ** Kernel log:
> [  118.525038]   alloc irq_desc for 526 on node -1
> [  118.525040]   alloc kstat_irqs on node -1
> [  118.700415] device-mapper: uevent: version 1.0.3
> [  118.700890] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> [  118.925563] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
> [  118.925580] EXT4-fs (dm-0): write access will be enabled during recovery
> [  118.968700] EXT4-fs (dm-0): orphan cleanup on readonly fs
> [  118.968716] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 790044
> [  118.968761] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 790012
> [  118.968768] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 790011
> [  118.968775] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 790010
> [  118.968782] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 790009
> [  118.968788] EXT4-fs (dm-0): 5 orphan inodes deleted
> [  118.968794] EXT4-fs (dm-0): recovery complete
> [  118.979150] EXT4-fs (dm-0): mounted filesystem with ordered data mode
> [  119.293543] udev[204]: starting version 164
> [  119.366778] input: PC Speaker as /devices/platform/pcspkr/input/input1
> [  119.436417] Error: Driver 'pcspkr' is already registered, aborting...
> [  124.153241] Adding 4194296k swap on /dev/xvdb1.  Priority:-1 extents:1 across:4194296k SS
> [  125.156599] loop: module loaded
> [  138.650657] EXT4-fs (dm-21): Ignoring delalloc option - requested data journaling mode
> [  138.650959] EXT4-fs (dm-21): mounted filesystem with journalled data mode
> [  138.660092] EXT4-fs (dm-22): mounted filesystem with ordered data mode
> [  138.674436] kjournald starting.  Commit interval 5 seconds
> [  138.675145] EXT3 FS on xvda1, internal journal
> [  138.675155] EXT3-fs: mounted filesystem with journal data mode.
> [  138.728462] EXT4-fs (xvdc): mounted filesystem without journal
> [  138.745406] EXT4-fs (dm-17): mounted filesystem with ordered data mode
> [  138.748531] EXT4-fs (dm-18): mounted filesystem with ordered data mode
> [  138.774667] EXT4-fs (dm-19): mounted filesystem with ordered data mode
> [  138.780834] EXT4-fs (dm-2): Ignoring delalloc option - requested data journaling mode
> [  138.781400] EXT4-fs (dm-2): mounted filesystem with journalled data mode
> [  138.784700] EXT4-fs (dm-1): Ignoring delalloc option - requested data journaling mode
> [  138.784773] EXT4-fs (dm-1): mounted filesystem with journalled data mode
> [  138.790320] EXT4-fs (dm-4): Ignoring delalloc option - requested data journaling mode
> [  138.790871] EXT4-fs (dm-4): mounted filesystem with journalled data mode
> [  138.794955] EXT4-fs (dm-3): Ignoring delalloc option - requested data journaling mode
> [  138.795064] EXT4-fs (dm-3): mounted filesystem with journalled data mode
> [  138.800441] EXT4-fs (dm-14): Ignoring delalloc option - requested data journaling mode
> [  138.801015] EXT4-fs (dm-14): mounted filesystem with journalled data mode
> [  138.804188] EXT4-fs (dm-13): Ignoring delalloc option - requested data journaling mode
> [  138.804263] EXT4-fs (dm-13): mounted filesystem with journalled data mode
> [  138.807812] EXT4-fs (dm-12): Ignoring delalloc option - requested data journaling mode
> [  138.807890] EXT4-fs (dm-12): mounted filesystem with journalled data mode
> [  138.814241] EXT4-fs (dm-16): mounted filesystem with ordered data mode
> [  138.817864] EXT4-fs (dm-15): mounted filesystem with ordered data mode
> [  138.821251] EXT4-fs (dm-9): mounted filesystem with ordered data mode
> [  138.824801] EXT4-fs (dm-7): Ignoring delalloc option - requested data journaling mode
> [  138.824877] EXT4-fs (dm-7): mounted filesystem with journalled data mode
> [  138.828423] EXT4-fs (dm-6): Ignoring delalloc option - requested data journaling mode
> [  138.828495] EXT4-fs (dm-6): mounted filesystem with journalled data mode
> [  138.832295] EXT4-fs (dm-5): Ignoring delalloc option - requested data journaling mode
> [  138.832868] EXT4-fs (dm-5): mounted filesystem with journalled data mode
> [  138.836422] EXT4-fs (dm-8): Ignoring delalloc option - requested data journaling mode
> [  138.836495] EXT4-fs (dm-8): mounted filesystem with journalled data mode
> [  138.840309] EXT4-fs (dm-11): mounted filesystem with ordered data mode
> [  138.844664] EXT4-fs (dm-10): Ignoring delalloc option - requested data journaling mode
> [  138.844735] EXT4-fs (dm-10): mounted filesystem with journalled data mode
> [  138.859715] EXT4-fs (dm-20): mounted filesystem with ordered data mode
> [  150.205516] eth0: no IPv6 routers present
> [  157.443694] ------------[ cut here ]------------
> [  157.443708] kernel BUG at /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/commit.c:534!
> [  157.443717] invalid opcode: 0000 [#1] SMP
> [  157.443722] last sysfs file: /sys/devices/virtual/vc/vcsa6/uevent
> [  157.443727] CPU 0
> [  157.443730] Modules linked in: ext3 jbd loop snd_pcm snd_timer snd soundcore evdev snd_page_alloc pcspkr ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> [  157.443759] Pid: 748, comm: jbd2/dm-13-8 Not tainted 2.6.32-5-xen-amd64 #1
> [  157.443764] RIP: e030:[<ffffffffa00213bc>]  [<ffffffffa00213bc>] jbd2_journal_commit_transaction+0x58b/0x115b [jbd2]
> [  157.443778] RSP: e02b:ffff8801dc2adcf0  EFLAGS: 00010202
> [  157.443782] RAX: 0000000000000009 RBX: ffff8801d7c26870 RCX: 00000000ffff74c8
> [  157.443788] RDX: 00000000ffff74c8 RSI: ffff8801d7c26800 RDI: ffff8801d87a9024
> [  157.443793] RBP: ffff8801d7c26850 R08: ffff8801d87a9058 R09: ffff88000b1df780
> [  157.443798] R10: ffff8801d7aa0048 R11: ffff8801dba1d880 R12: ffff8801d87a9000
> [  157.443803] R13: ffff8801dc2add88 R14: ffff8801d7c26800 R15: 0000000000000000
> [  157.443812] FS:  00007f3afa7d3700(0000) GS:ffff88000b1ca000(0000) knlGS:0000000000000000
> [  157.443818] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  157.443822] CR2: 00007f3afc878268 CR3: 00000001d7b05000 CR4: 0000000000002660
> [  157.443828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  157.443833] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000000
> [  157.443839] Process jbd2/dm-13-8 (pid: 748, threadinfo ffff8801dc2ac000, task ffff8801db02e2e0)
> [  157.443844] Stack:
> [  157.443847]  ffff8801db02e318 ffff8801dc2add70 ffff8801db02e2e0 ffff8801d7aa38c8
> [  157.443854] <0> 00000024a85fc12e ffff8801d87a9024 ffff8801d87a939c ffff88000b1df780
> [  157.443865] <0> ffff8801d72f3000 ffff8801db02e2e0 0000000800000000 00000441000116e0
> [  157.443877] Call Trace:
> [  157.443886]  [<ffffffff8130b79f>] ? thread_return+0x79/0xe0
> [  157.443893]  [<ffffffff8100e609>] ? __raw_callee_save_xen_irq_disable+0x11/0x1e
> [  157.443901]  [<ffffffff8130cb3a>] ? _spin_unlock_irqrestore+0xd/0xe
> [  157.443908]  [<ffffffff8105b748>] ? try_to_del_timer_sync+0x63/0x6c
> [  157.443917]  [<ffffffffa002788f>] ? kjournald2+0xbe/0x206 [jbd2]
> [  157.443923]  [<ffffffff81065d4a>] ? autoremove_wake_function+0x0/0x2e
> [  157.443930]  [<ffffffffa00277d1>] ? kjournald2+0x0/0x206 [jbd2]
> [  157.443936]  [<ffffffff81065a7d>] ? kthread+0x79/0x81
> [  157.443942]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
> [  157.443947]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
> [  157.443952]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
> [  157.443956] Code: 00 48 89 4c 24 38 45 31 ed c7 44 24 4c 00 00 00 00 c7 44 24 50 00 00 00 00 c7 44 24 58 ff ff ff ff 48 89 44 24 18 e9 f0 02 00 00 <0f> 0b eb fe 41 f6 04 24 02 74 40 48 8b 13 48 8d 42 02 f0 80 62
> [  157.444009] RIP  [<ffffffffa00213bc>] jbd2_journal_commit_transaction+0x58b/0x115b [jbd2]
> [  157.444017]  RSP <ffff8801dc2adcf0>
> [  157.444035] ---[ end trace 1277bd032d9ae98f ]---
>
> ** Model information
> Amazon EC2 instance
>
> ** Loaded modules:
> Module                  Size  Used by
> ext3                  106502  1
> jbd                    37085  1 ext3
> loop                   11799  0
> snd_pcm                60551  0
> snd_timer              15582  1 snd_pcm
> snd                    46446  2 snd_pcm,snd_timer
> soundcore               4598  1 snd
> evdev                   7352  0
> snd_page_alloc          6249  1 snd_pcm
> pcspkr                  1699  0
> ext4                  289033  24
> mbcache                 5050  2 ext3,ext4
> jbd2                   67015  1 ext4
> crc16                   1319  1 ext4
> dm_mod                 53754  69
> xen_netfront           16257  0
> xen_blkfront            9435  8
>
> ** Network interface configuration:
> ###
> ## WARNING:
> ##   DO NOT MESS WITH THIS FILE, AND ESPECIALLY DO NOT RUN IFDOWN OR IFUP!!!
> ##   THIS MACHINE IS AN AMAZON EC2 VM WITH NO CONSOLE ACCESS!!!
> ###
>
> auto lo
> iface lo inet loopback
>        dns-search border.exmeritus.com exmeritus.com
>
> auto eth0
> iface eth0 inet dhcp
>
>
> ** Network status:
> *** IP interfaces and addresses:
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
>    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>    inet 127.0.0.1/8 scope host lo
>    inet6 ::1/128 scope host
>       valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
>    link/ether 12:31:3b:0a:94:dc brd ff:ff:ff:ff:ff:ff
>    inet 10.204.151.42/23 brd 10.204.151.255 scope global eth0
>    inet6 fe80::1031:3bff:fe0a:94dc/64 scope link
>       valid_lft forever preferred_lft forever
>
> *** Device statistics:
> Inter-|   Receive                                                |  Transmit
> face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
>    lo:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
>  eth0:  185543    1684    0    0    0     0          0         0   239161    1212    0    0    0     0       0          0
>
> *** Protocol statistics:
> Ip:
>    1653 total packets received
>    1 with invalid addresses
>    0 forwarded
>    0 incoming packets discarded
>    1652 incoming packets delivered
>    1203 requests sent out
> Icmp:
>    9 ICMP messages received
>    0 input ICMP message failed.
>    ICMP input histogram:
>        echo requests: 9
>    9 ICMP messages sent
>    0 ICMP messages failed
>    ICMP output histogram:
>        echo replies: 9
> IcmpMsg:
>        InType8: 9
>        OutType0: 9
> Tcp:
>    26 active connections openings
>    6 passive connection openings
>    7 failed connection attempts
>    7 connection resets received
>    6 connections established
>    1477 segments received
>    1008 segments send out
>    20 segments retransmited
>    0 bad segments received.
>    12 resets sent
> Udp:
>    166 packets received
>    0 packets to unknown port received.
>    0 packet receive errors
>    166 packets sent
> UdpLite:
> TcpExt:
>    2 TCP sockets finished time wait in fast timer
>    22 delayed acks sent
>    4 packets directly queued to recvmsg prequeue.
>    563 packet headers predicted
>    84 acknowledgments not containing data payload received
>    740 predicted acknowledgments
>    6 congestion windows recovered without slow start after partial ack
>    13 other TCP timeouts
>    1 connections reset due to unexpected data
>    2 connections reset due to early user close
>    7 connections aborted due to timeout
> IpExt:
>    InOctets: 184459
>    OutOctets: 221425
>
> *** Device features:
> eth0: 0x50003
> lo: 0x13865
>
> ** PCI devices:
>
> ** USB devices:
> not available
>
>
> -- System Information:
> Debian Release: 6.0
>  APT prefers stable
>  APT policy: (990, 'stable'), (700, 'testing'), (600, 'unstable'), (500, 'squeeze-updates'), (500, 'experimental')
> Architecture: amd64 (x86_64)
>
> Kernel: Linux 2.6.32-5-xen-amd64 (SMP w/2 CPU cores)
> Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
> Shell: /bin/sh linked to /bin/dash
>
> Versions of packages linux-image-2.6.32-5-xen-amd64 depends on:
> ii  debconf [debconf-2.0]         1.5.36.1   Debian configuration management sy
> ii  initramfs-tools               0.98.8     tools for generating an initramfs
> ii  linux-base                    2.6.32-30  Linux image base package
> ii  module-init-tools             3.12-1     tools for managing Linux kernel mo
>
> Versions of packages linux-image-2.6.32-5-xen-amd64 recommends:
> pn  firmware-linux-free           <none>     (no description available)
>
> Versions of packages linux-image-2.6.32-5-xen-amd64 suggests:
> ii  grub-legacy [grub]            0.97-64    GRand Unified Bootloader (Legacy v
> pn  linux-doc-2.6.32              <none>     (no description available)
>
> Versions of packages linux-image-2.6.32-5-xen-amd64 is related to:
> pn  firmware-bnx2                 <none>     (no description available)
> pn  firmware-bnx2x                <none>     (no description available)
> pn  firmware-ipw2x00              <none>     (no description available)
> pn  firmware-ivtv                 <none>     (no description available)
> pn  firmware-iwlwifi              <none>     (no description available)
> pn  firmware-linux                <none>     (no description available)
> pn  firmware-linux-nonfree        <none>     (no description available)
> pn  firmware-qlogic               <none>     (no description available)
> pn  firmware-ralink               <none>     (no description available)
> pn  xen-hypervisor                <none>     (no description available)
>
> -- debconf information:
>  linux-image-2.6.32-5-xen-amd64/postinst/ignoring-do-bootloader-2.6.32-5-xen-amd64:
>  linux-image-2.6.32-5-xen-amd64/prerm/removing-running-kernel-2.6.32-5-xen-amd64: true
>  linux-image-2.6.32-5-xen-amd64/postinst/depmod-error-initrd-2.6.32-5-xen-amd64: false
>  linux-image-2.6.32-5-xen-amd64/postinst/missing-firmware-2.6.32-5-xen-amd64:
>
>
