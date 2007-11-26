From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: 2.6.24-rc3-$SHA1: kernel BUG at fs/jbd/checkpoint.c:683!
Date: Mon, 26 Nov 2007 08:59:25 +0300
Message-ID: <20071126055925.GC1726@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GRPZ8SYKNexpdSJ7"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: akpm@osdl.org, sct@redhat.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:34736 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbXKZF7d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2007 00:59:33 -0500
Received: by nf-out-0910.google.com with SMTP id g13so592865nfb
        for <linux-ext4@vger.kernel.org>; Sun, 25 Nov 2007 21:59:31 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In a desperate attempt to screw up /proc one more time, I added some
proc fixes, wrote test module which creates and removes simple proc
file, then ran a) modprobe/rmmod loop, b) cat /proc/foo/bar loop,
c) LTP loop. So far so good -- survived overnight run.

While rebooting into new kernel, kernel died:

[56400.857832] kernel BUG at fs/jbd/checkpoint.c:683!
[56400.857911] invalid opcode: 0000 [1] PREEMPT SMP 
[56400.857996] CPU 0 
[56400.858059] Modules linked in: foo
[56400.858138] Pid: 392, comm: kjournald Not tainted 2.6.24-rc3-proc #11
[56400.858227] RIP: 0010:[<ffffffff802cbf10>]  [<ffffffff802cbf10>] __journal_drop_transaction+0x110/0x120
[56400.858380] RSP: 0000:ffff81017f30dd58  EFLAGS: 00010286
[56400.858462] RAX: ffff81012ab9f210 RBX: ffff81017f336cd8 RCX: ffff81017fcbbe48
[56400.858555] RDX: ffff81012ab9f210 RSI: ffff810110eeb318 RDI: ffff81017f336cd8
[56400.858648] RBP: ffff81017aa8a2a0 R08: 0000000000000000 R09: ffff81017aa8a4f8
[56400.858741] R10: 0000000000000001 R11: ffffffff8021b220 R12: ffff81017aa8a2a0
[56400.858834] R13: ffff81017aa8a2a0 R14: ffff81017f30ddbc R15: ffff81017f30ddbc
[56400.858927] FS:  0000000000000000(0000) GS:ffffffff804ea000(0000) knlGS:0000000000000000
[56400.859070] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[56400.859157] CR2: 0000000000437c50 CR3: 0000000104dae000 CR4: 00000000000006e0
[56400.859250] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[56400.859343] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[56400.859436] Process kjournald (pid: 392, threadinfo ffff81017f30c000, task ffff81017fcc8ec0)
[56400.859581] Stack:  ffffffff802cbf7a ffff81016f795c60 ffffffff802cc0a8 0000000000000000
[56400.859734]  ffff810110eeb318 ffff81012ab9f210 0000000000000001 ffff810117e4da50
[56400.859881]  ffff81017f30ddbc ffff81017f336e3c ffffffff802cca0b ffff810117e4da50
[56400.859979] Call Trace:
[56400.860093]  [<ffffffff802cbf7a>] __journal_remove_checkpoint+0x5a/0xb0
[56400.860183]  [<ffffffff802cc0a8>] journal_clean_one_cp_list+0xd8/0x170
[56400.860273]  [<ffffffff802cca0b>] __journal_clean_checkpoint_list+0x4b/0xa0
[56400.860370]  [<ffffffff802ca6ed>] journal_commit_transaction+0x21d/0x1110
[56400.860462]  [<ffffffff80230984>] lock_timer_base+0x34/0x70
[56400.860546]  [<ffffffff80230a13>] try_to_del_timer_sync+0x53/0x60
[56400.860633]  [<ffffffff802cee1f>] kjournald+0xdf/0x240
[56400.860715]  [<ffffffff8023c3d0>] autoremove_wake_function+0x0/0x30
[56400.860803]  [<ffffffff802ced40>] kjournald+0x0/0x240
[56400.860884]  [<ffffffff8023bffb>] kthread+0x4b/0x80
[56400.860967]  [<ffffffff8020ca38>] child_rip+0xa/0x12
[56400.861047]  [<ffffffff8023bfb0>] kthread+0x0/0x80
[56400.861126]  [<ffffffff8020ca2e>] child_rip+0x0/0x12
[56400.861205] 
[56400.861262] 
[56400.861263] Code: 0f 0b eb fe 66 66 66 90 66 66 66 90 66 66 66 90 53 48 8b 77 
[56400.861546] RIP  [<ffffffff802cbf10>] __journal_drop_transaction+0x110/0x120
[56400.861642]  RSP <ffff81017f30dd58>
[56400.862158] Kernel panic - not syncing: Fatal exception

Version:	2.6.24-rc3-2ffbb8377c7a0713baf6644e285adc27a5654582
		 + proc fixes (cumulative patch attached)
Box:		Core 2 Duo E6400, 4G RAM
mount info:	/dev/sda2 on / type ext3 (rw,noatime,nodiratime)
scheduler:	CFQ
.config:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc3-proc
# Sun Nov 25 14:29:24 2007
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
# CONFIG_QUICKLIST is not set
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_HT=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_FOO=m

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_VSMP is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--GRPZ8SYKNexpdSJ7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="proc-cumul.patch"

diff --git a/Makefile b/Makefile
index a65ffd2..c301231 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 24
-EXTRAVERSION = -rc3
+EXTRAVERSION = -rc3-proc
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index a9806bc..9251e9f 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -25,12 +25,6 @@
 
 #include "internal.h"
 
-static ssize_t proc_file_read(struct file *file, char __user *buf,
-			      size_t nbytes, loff_t *ppos);
-static ssize_t proc_file_write(struct file *file, const char __user *buffer,
-			       size_t count, loff_t *ppos);
-static loff_t proc_file_lseek(struct file *, loff_t, int);
-
 DEFINE_SPINLOCK(proc_subdir_lock);
 
 static int proc_match(int len, const char *name, struct proc_dir_entry *de)
@@ -40,12 +34,6 @@ static int proc_match(int len, const char *name, struct proc_dir_entry *de)
 	return !memcmp(name, de->name, len);
 }
 
-static const struct file_operations proc_file_operations = {
-	.llseek		= proc_file_lseek,
-	.read		= proc_file_read,
-	.write		= proc_file_write,
-};
-
 /* buffer size is one page but our output routines use some slack for overruns */
 #define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)
 
@@ -233,6 +221,12 @@ proc_file_lseek(struct file *file, loff_t offset, int orig)
 	return retval;
 }
 
+static const struct file_operations proc_file_operations = {
+	.llseek		= proc_file_lseek,
+	.read		= proc_file_read,
+	.write		= proc_file_write,
+};
+
 static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
@@ -403,12 +397,12 @@ struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nam
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
 				inode = proc_get_inode(dir->i_sb, ino, de);
-				spin_lock(&proc_subdir_lock);
-				break;
+				goto out_unlock;
 			}
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
+out_unlock:
 	unlock_kernel();
 
 	if (inode) {
@@ -524,6 +518,7 @@ static const struct inode_operations proc_dir_inode_operations = {
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
 	unsigned int i;
+	struct proc_dir_entry *tmp;
 	
 	i = get_inode_number();
 	if (i == 0)
@@ -531,22 +526,26 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 	dp->low_ino = i;
 
 	if (S_ISDIR(dp->mode)) {
-		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
-			dp->proc_iops = &proc_dir_inode_operations;
-		}
+		dp->proc_fops = &proc_dir_operations;
+		dp->proc_iops = &proc_dir_inode_operations;
 		dir->nlink++;
 	} else if (S_ISLNK(dp->mode)) {
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_link_inode_operations;
+		dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
-		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
-		if (dp->proc_iops == NULL)
-			dp->proc_iops = &proc_file_inode_operations;
+		dp->proc_fops = &proc_file_operations;
+		dp->proc_iops = &proc_file_inode_operations;
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (tmp = dir->subdir; tmp; tmp = tmp->next)
+		if (strcmp(tmp->name, dp->name) == 0) {
+			printk(KERN_WARNING "PDE '%s' already registered\n",
+				dp->name);
+			dump_stack();
+			break;
+		}
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;
@@ -555,41 +554,6 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 	return 0;
 }
 
-/*
- * Kill an inode that got unregistered..
- */
-static void proc_kill_inodes(struct proc_dir_entry *de)
-{
-	struct list_head *p;
-	struct super_block *sb;
-
-	/*
-	 * Actually it's a partial revoke().
-	 */
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &proc_fs_type.fs_supers, s_instances) {
-		file_list_lock();
-		list_for_each(p, &sb->s_files) {
-			struct file *filp = list_entry(p, struct file,
-							f_u.fu_list);
-			struct dentry *dentry = filp->f_path.dentry;
-			struct inode *inode;
-			const struct file_operations *fops;
-
-			if (dentry->d_op != &proc_dentry_operations)
-				continue;
-			inode = dentry->d_inode;
-			if (PDE(inode) != de)
-				continue;
-			fops = filp->f_op;
-			filp->f_op = NULL;
-			fops_put(fops);
-		}
-		file_list_unlock();
-	}
-	spin_unlock(&sb_lock);
-}
-
 static struct proc_dir_entry *proc_create(struct proc_dir_entry **parent,
 					  const char *name,
 					  mode_t mode,
@@ -620,6 +584,7 @@ static struct proc_dir_entry *proc_create(struct proc_dir_entry **parent,
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
+	atomic_set(&ent->count, 1);
 	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
 	ent->pde_unload_completion = NULL;
@@ -710,24 +675,23 @@ void free_proc_entry(struct proc_dir_entry *de)
 
 	release_inode_number(ino);
 
-	if (S_ISLNK(de->mode) && de->data)
+	if (S_ISLNK(de->mode))
 		kfree(de->data);
 	kfree(de);
 }
 
 /*
  * Remove a /proc entry and free it if it's not currently in use.
- * If it is in use, we set the 'deleted' flag.
  */
 void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 {
 	struct proc_dir_entry **p;
-	struct proc_dir_entry *de;
+	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
 	int len;
 
 	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
-		goto out;
+		return;
 	len = strlen(fn);
 
 	spin_lock(&proc_subdir_lock);
@@ -737,47 +701,38 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 		de = *p;
 		*p = de->next;
 		de->next = NULL;
+		break;
+	}
+	spin_unlock(&proc_subdir_lock);
+	if (!de)
+		return;
 
-		spin_lock(&de->pde_unload_lock);
-		/*
-		 * Stop accepting new callers into module. If you're
-		 * dynamically allocating ->proc_fops, save a pointer somewhere.
-		 */
-		de->proc_fops = NULL;
-		/* Wait until all existing callers into module are done. */
-		if (de->pde_users > 0) {
-			DECLARE_COMPLETION_ONSTACK(c);
+	spin_lock(&de->pde_unload_lock);
+	/*
+	 * Stop accepting new callers into module. If you're
+	 * dynamically allocating ->proc_fops, save a pointer somewhere.
+	 */
+	de->proc_fops = NULL;
+	/* Wait until all existing callers into module are done. */
+	if (de->pde_users > 0) {
+		DECLARE_COMPLETION_ONSTACK(c);
 
-			if (!de->pde_unload_completion)
-				de->pde_unload_completion = &c;
+		if (!de->pde_unload_completion)
+			de->pde_unload_completion = &c;
 
-			spin_unlock(&de->pde_unload_lock);
-			spin_unlock(&proc_subdir_lock);
+		spin_unlock(&de->pde_unload_lock);
 
-			wait_for_completion(de->pde_unload_completion);
+		wait_for_completion(de->pde_unload_completion);
 
-			spin_lock(&proc_subdir_lock);
-			goto continue_removing;
-		}
-		spin_unlock(&de->pde_unload_lock);
+		goto continue_removing;
+	}
+	spin_unlock(&de->pde_unload_lock);
 
 continue_removing:
-		if (S_ISDIR(de->mode))
-			parent->nlink--;
-		if (!S_ISREG(de->mode))
-			proc_kill_inodes(de);
-		de->nlink = 0;
-		WARN_ON(de->subdir);
-		if (!atomic_read(&de->count))
-			free_proc_entry(de);
-		else {
-			de->deleted = 1;
-			printk("remove_proc_entry: %s/%s busy, count=%d\n",
-				parent->name, de->name, atomic_read(&de->count));
-		}
-		break;
-	}
-	spin_unlock(&proc_subdir_lock);
-out:
-	return;
+	if (S_ISDIR(de->mode))
+		parent->nlink--;
+	de->nlink = 0;
+	WARN_ON(de->subdir);
+	if (atomic_dec_and_test(&de->count))
+		free_proc_entry(de);
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index abe6a3f..8e374e5 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -37,19 +37,9 @@ void de_put(struct proc_dir_entry *de)
 {
 	if (de) {	
 		lock_kernel();		
-		if (!atomic_read(&de->count)) {
-			printk("de_put: entry %s already free!\n", de->name);
-			unlock_kernel();
-			return;
-		}
-
-		if (atomic_dec_and_test(&de->count)) {
-			if (de->deleted) {
-				printk("de_put: deferred delete of %s\n",
-					de->name);
-				free_proc_entry(de);
-			}
-		}		
+		BUG_ON(atomic_read(&de->count) == 0);
+		if (atomic_dec_and_test(&de->count))
+			free_proc_entry(de);
 		unlock_kernel();
 	}
 }
@@ -476,4 +466,3 @@ out_no_root:
 	de_put(&proc_root);
 	return -ENOMEM;
 }
-MODULE_LICENSE("GPL");
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 1b2b6c6..1820eb2 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -78,5 +78,3 @@ static inline int proc_fd(struct inode *inode)
 {
 	return PROC_I(inode)->fd;
 }
-
-extern struct file_system_type proc_fs_type;
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 2284622..3429683 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -15,9 +15,6 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 
-static int tty_ldiscs_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data);
-
 /*
  * The /proc/tty directory inodes...
  */
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1f86bb8..81f99e6 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -98,7 +98,7 @@ static void proc_kill_sb(struct super_block *sb)
 	put_pid_ns(ns);
 }
 
-struct file_system_type proc_fs_type = {
+static struct file_system_type proc_fs_type = {
 	.name		= "proc",
 	.get_sb		= proc_get_sb,
 	.kill_sb	= proc_kill_sb,
@@ -207,6 +207,7 @@ struct proc_dir_entry proc_root = {
 	.name		= "/proc",
 	.mode		= S_IFDIR | S_IRUGO | S_IXUGO, 
 	.nlink		= 2, 
+	.count		= ATOMIC_INIT(1),
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 9aa7a06..0011446 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -420,12 +420,6 @@ static void *r_start(struct seq_file *m, loff_t * pos)
 		return NULL;
 
 	up_write(&s->s_umount);
-
-	if (de->deleted) {
-		deactivate_super(s);
-		return NULL;
-	}
-
 	return s;
 }
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 1273c6e..88d96db 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -75,7 +75,6 @@ struct proc_dir_entry {
 	read_proc_t *read_proc;
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
-	int deleted;		/* delete flag */
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;

--GRPZ8SYKNexpdSJ7--
