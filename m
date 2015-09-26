From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Sat, 26 Sep 2015 11:06:08 +0300
Message-ID: <1443254768.16309.46.camel@gmail.com>
References: <1434495193-31182-3-git-send-email-tj@kernel.org>
	 <20150722035620.GD2944@thunk.org> <1443012552.19983.209.camel@gmail.com>
	 <20150923180934.GE26647@mtj.duckdns.org>
	 <20150923185137.GJ26647@mtj.duckdns.org>
	 <20150923210729.GA23180@mtj.duckdns.org>
	 <1443082186.19983.234.camel@gmail.com>
	 <20150924204529.GF25415@mtj.duckdns.org>
	 <1443163749.19983.254.camel@gmail.com>
	 <1443178222.10230.10.camel@gmail.com>
	 <20150925154925.GH4449@mtj.duckdns.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150925154925.GH4449@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2015-09-25 at 11:49 -0400, Tejun Heo wrote:
> Hello, Artem.

I've applied this patch on top of

ced255c Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux

I've added 'ignore_loglevel' to the kernel boot parameters. I have the
serial console configured and I collect the serial output.

I've reproduced the issue on a machine with host name 'ivbep0'. The
serial log is at the end of this e-mail.

To recap, the test I did is.

1. The machine runs the ced255c kernel + your patch.
2. We are re-installing the same kernel there by doing this:
2.1 Remove the modules: /usr/lib/modules/v4.3-rc2+
2.2 Copy the modules to /usr/lib/modules/v4.3-rc2+
3. We run 'sync'
4. We run 'reboot'

Expected outcome: the machine reboots into the same kernel, modules can
be loaded and they are not corrupted.

Real outcome: the kernel boots up, but modules cannot be loaded,
because they are corrupted, for example:

[root@ivbep0 ~]# modprobe xfs
modprobe: ERROR: magic check fail: 0 instead of b007f457
[root@ivbep0 ~]# hexdump /usr/lib/modules/4.3.0-rc2+/kernel/fs/xfs/xfs.ko  
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
17adc90 0000 0000 0000 0000 0000 0000 0000      
17adc9e
[root@ivbep0 ~]# file /usr/lib/modules/4.3.0-rc2+/kernel/fs/xfs/xfs.ko         
/usr/lib/modules/4.3.0-rc2+/kernel/fs/xfs/xfs.ko: data

To make it easier for you, I've edited the log and added a couple of
comments there describing the stage we are at.

HTH,
Artem.


#
# Artem: The below is printed when we run 'sync'
#
[   94.900810] XXX SYNCING 8:1
[   95.075622] XXX sync_inodes_sb(8:1): dirty inode 13107315 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.087258] XXX sync_inodes_sb(8:1): dirty inode 13107314 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.098881] XXX sync_inodes_sb(8:1): dirty inode 13107313 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.110487] XXX sync_inodes_sb(8:1): dirty inode 13107312 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.122085] XXX sync_inodes_sb(8:1): dirty inode 13107311 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.133677] XXX sync_inodes_sb(8:1): dirty inode 13107310 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.145259] XXX sync_inodes_sb(8:1): dirty inode 13107309 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.156854] XXX sync_inodes_sb(8:1): dirty inode 13107308 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.168447] XXX sync_inodes_sb(8:1): dirty inode 13107307 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.180034] XXX sync_inodes_sb(8:1): dirty inode 13107306 skipped, wb=15 comp_gen=0->0 which=1->1 i_state=0x7
[   95.191703] XXX all_wbs      = 1
[   95.195596] XXX iterated_wbs = 1
[   95.199488] XXX written_wbs  = 1
[   95.203382] XXX sync_wbs     = 
[   95.568881] echo (1452): drop_caches: 3
[   95.982140] XXX SYNCING 8:1
[   95.999746] XXX all_wbs      = 1
[   96.003668] XXX iterated_wbs = 1
[   96.007569] XXX written_wbs  = 1
[   96.011472] XXX sync_wbs     = 
[   96.394702] XXX SYNCING 8:1
[   96.404041] ixgbe 0000:81:00.0: removed PHC on enp129s0f0
[   96.803148] systemd[1]: Received SIGRTMIN+20 from PID 1499 (plymouthd).
[[32m  OK  [0m] Stopped Network Manager.
[   96.816673] XXX all_wbs      = 1
[   96.820401] XXX iterated_wbs = 1
[   96.824099] XXX written_wbs  = 1
[   96.827790] XXX sync_wbs     = 
#
# Artem: The below is printed when we run 'restart'
#
[[32m  OK  [0m] Started Show Plymouth Power Off Screen.
[[32m  OK  [0m] Stopped User Manager for UID 0.
         Stopping Permit User Sessions...
[[32m  OK  [0m] Removed slice user-0.slice.
[[32m  OK  [0m] Stopped Permit User Sessions.
[[32m  OK  [0m] Stopped target Remote File Systems.
[[32m  OK  [0m] Stopped target Basic System.
[[32m  OK  [0m] Stopped target Paths.
[[32m  OK  [0m] Stopped target Sockets.
[[32m  OK  [0m] Closed D-Bus [   97.249846] audit_printk_skb: 18 callbacks suppressed
System Message B[   97.256420] audit: type=1305 audit(1443252516.709:330): audit_pid=0 old=1012 auid=4294967295 ses=4294967295 res=1
us Socket.
[[[   97.269838] audit: type=1131 audit(1443252516.729:331): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=auditd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
32m  OK  [0m] S[   97.291815] audit: type=1131 audit(1443252516.751:332): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
topped target System Initializat[   97.315950] audit: type=1131 audit(1443252516.776:333): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=fedora-import-state comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
ion.
[[32m  OK  [0m] Stopped target Encrypte[   97.343202] audit: type=1131 audit(1443252516.803:334): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-random-seed comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
d Volumes.
[[[   97.365840] audit: type=1131 audit(1443252516.825:335): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=fedora-readonly comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
32m  OK  [0m] Stopped target Swap.
         Stopping Load/Save Random Seed...
         Stopping Security Auditing Service...
[[32m  OK  [0m] Stopped Apply Kernel Variables.
        [   97.405563] audit: type=1131 audit(1443252516.865:336): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-remount-fs comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
 Stopping Apply Kernel Variables[   97.429778] audit: type=1131 audit(1443252516.889:337): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
...
[[32m  OK  [0m] Stopped Setup Virtual Console.
         Stopping Setup Virtual Console...
[[32m  OK  [0m] Stopped target Slices.
[[32m  OK  [0m] Removed slice User and Session Slice.
[[32m  OK  [0m] Stopped Security Auditing Service.
[[32m  OK  [0m] Stopped Create Volatile Files and Directories.
         Stopping Create Volatile Files and Directories...
[[32m  OK  [0m] Stopped Import network configuration from initramfs.
         Stopping Import network configuration from initramfs...
[[32m  OK  [0m] Stopped target Local File Systems.
         Unmounting Temporary Directory...
[   97.514487] systemd-shutdown[1]: Sending SIGTERM to remaining processes...

         Unmounting /run/user/0...
         Unmounting Configuration File System...
[[32m  OK  [0m] Stopped Load/Save Random Seed.
[[32m  OK  [0m] Stopped Configure read-only root support.
         Stopping Configure read-only root support...
[[32m  OK  [0m] Unmounted /run/user/0.
[[32m  OK  [0m] Unmounted Tempor[   97.556195] systemd-journald[952]: Received SIGTERM from PID 1 (systemd-shutdow).
ary Directory.
[[32m  OK  [0m] Unmounted Configuration File System.
[[32m  OK  [0m] Reached target Unmount All Filesystems.
[[32m  OK  [0m] Stopped target Local File Systems (Pre).
[[32m  OK  [0m] Stopped Remount Root and Kernel File Systems.
         Stopping Remount Root and Kernel File Systems...
[[32m  OK  [0m] Stopped Create Static Device Nodes in /dev.
         Stopping Create Static Device Nodes in /dev...
[[32m  OK  [0m] Reached target Shutdown.
[   97.867762] systemd-shutdown[1]: Sending SIGKILL to remaining processes...
[   97.896993] systemd-shutdown[1]: Unmounting file systems.
[   97.903912] XXX SYNCING 8:1
[   97.909272] XXX wb_writeback: inode 0 marker2=1 on b_dirty
[   97.915762] XXX all_wbs      = 1,17
[   97.919950] XXX iterated_wbs = 1,17
[   97.924131] XXX written_wbs  = 1
[   97.928021] XXX sync_wbs     = 
[   98.069893] EXT4-fs (sda1): re-mounted. Opts: (null)
[   98.076437] EXT4-fs (sda1): re-mounted. Opts: (null)
[   98.082281] systemd-shutdown[1]: All filesystems unmounted.
[   98.088794] systemd-shutdown[1]: Deactivating swaps.
[   98.094660] systemd-shutdown[1]: All swaps deactivated.
[   98.100780] systemd-shutdown[1]: Detaching loop devices.
[   98.135582] systemd-shutdown[1]: All loop devices detached.
[   98.142090] systemd-shutdown[1]: Detaching DM devices.
[   98.148154] systemd-shutdown[1]: All DM devices detached.
[   98.178359] systemd-shutdown[1]: Powering off.
[   98.183644] kvm: exiting hardware virtualization
[   98.773702] pcieport 0000:00:1c.0: System wakeup enabled by ACPI
[   98.909853] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   98.915989] sd 0:0:0:0: [sda] Stopping disk
[   99.350194] ACPI: Preparing to enter system sleep state S5
[   99.358139] reboot: Power down
[   99.362200] acpi_power_off called

#
# Artem: the machine restarted, and now booting the same kernel.
# I do not see your messages there, but included for reference.
#
[    0.000000] microcode: CPU0 microcode updated early to revision 0x428, date = 2014-05-29
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.3.0-rc2+ (abityuts@powerlab) (gcc version 5.1.1 20150618 (Red Hat 5.1.1-4) (GCC) ) #1 SMP Sat Sep 26 10:11:32 EEST 2015
[    0.000000] Command line: initrd=/suts/ivbep0/custom-kernel/initramfs.img root=/dev/sda1 ro console=tty0 console=ttyS0,115200 LANG=en_US.UTF-8 nomodeset ignore_loglevel BOOT_IMAGE=/suts/ivbep0/custom-kernel/kernel 
[    0.000000] x86/fpu: xstate_offset[2]: 0240, xstate_sizes[2]: 0100
[    0.000000] x86/fpu: Supporting XSAVE feature 0x01: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x02: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x04: 'AVX registers'
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 0x340 bytes, using 'standard' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ba762fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ba763000-0x00000000bac7ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bac80000-0x00000000bb019fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb01a000-0x00000000bd956fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd957000-0x00000000bdb5bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdb5c000-0x00000000bdde6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdde7000-0x00000000bde2bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bde2c000-0x00000000bdefffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf00000-0x00000000bdf00fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf01000-0x00000000bdf1efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf1f000-0x00000000bdffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.00.29.D696.1311111329 11/11/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-through
[    0.000000]   CC000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask 3FFF80000000 write-back
[    0.000000]   1 base 000080000000 mask 3FFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask 3FFF00000000 write-back
[    0.000000]   3 base 000200000000 mask 3FFE00000000 write-back
[    0.000000]   4 base 000400000000 mask 3FFC00000000 write-back
[    0.000000]   5 base 000800000000 mask 3FF800000000 write-back
[    0.000000]   6 base 001000000000 mask 3FFFC0000000 write-back
[    0.000000]   7 base 0000FFC00000 mask 3FFFFFC00000 write-protect
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: last_pfn = 0xba763 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcb30-0x000fcb3f] mapped at [ffff8800000fcb30]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02004000, 0x02004fff] PGTABLE
[    0.000000] BRK [0x02005000, 0x02005fff] PGTABLE
[    0.000000] BRK [0x02006000, 0x02006fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x103fe00000-0x103fffffff]
[    0.000000]  [mem 0x103fe00000-0x103fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1020000000-0x103fdfffff]
[    0.000000]  [mem 0x1020000000-0x103fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xba762fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xba5fffff] page 2M
[    0.000000]  [mem 0xba600000-0xba762fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x101fffffff]
[    0.000000]  [mem 0x100000000-0x101fffffff] page 1G
[    0.000000] RAMDISK: [mem 0x7d204000-0x7fffefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000BDF1CD98 00008C (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: FACP 0x00000000BDF1CA98 0000F4 (v04 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20150818/tbfadt-704)
[    0.000000] ACPI: DSDT 0x00000000BDF01018 019B5A (v02 INTEL  ROMLEY   00000029 INTL 20100331)
[    0.000000] ACPI: FACS 0x00000000BDF1CF40 000040
[    0.000000] ACPI: FACS 0x00000000BDF1CF40 000040
[    0.000000] ACPI: APIC 0x00000000BDF1B018 000BAA (v03 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 0x00000000BDF1EF18 000041 (v05 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 0x00000000BDF1EE98 00003C (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SRAT 0x00000000BDF1BC18 0003A8 (v03 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SLIT 0x00000000BDF1ED98 000030 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: MSCT 0x00000000BDF1ED18 00004E (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: HPET 0x00000000BDF1EE18 000038 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 0x00000000BDF1EC98 00002B (v02 INTEL  PtidDevc 00001000 INTL 20100331)
[    0.000000] ACPI: BOOT 0x00000000BDF1EC18 000028 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 0x00000000BDE2C018 0D3050 (v02 INTEL  CpuPm    00004000 INTL 20100331)
[    0.000000] ACPI: DMAR 0x00000000BDF1C918 000120 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: BDAT 0x00000000BDF1EB98 000030 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x83fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x840000000-0x103fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x83fffffff] -> [mem 0x00000000-0x83fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x83ffec000-0x83fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x103ffe9000-0x103fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0020ffffff] PMD -> [ffff88081fe00000-ffff88083fdfffff] on node 0
[    0.000000]  [ffffea0021000000-ffffea0040ffffff] PMD -> [ffff88101f600000-ffff88103f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000103fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009afff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000ba762fff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000083fffffff]
[    0.000000]   node   1: [mem 0x0000000840000000-0x000000103fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000083fffffff]
[    0.000000] On node 0 totalpages: 8365821
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11870 pages used for memmap
[    0.000000]   DMA32 zone: 759651 pages, LIFO batch:31
[    0.000000]   Normal zone: 118784 pages used for memmap
[    0.000000]   Normal zone: 7602176 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x0000000840000000-0x000000103fffffff]
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
[    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 240 CPUs, 192 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xba763000-0xbac7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbac80000-0xbb019fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb01a000-0xbd956fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd957000-0xbdb5bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdb5c000-0xbdde6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdde7000-0xbde2bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbde2c000-0xbdefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf00000-0xbdf00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf01000-0xbdf1efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf1f000-0xbdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:240 nr_node_ids:2
[    0.000000] PERCPU: Embedded 32 pages/cpu @ffff88081ee00000 s93784 r8192 d29096 u131072
[    0.000000] pcpu-alloc: s93784 r8192 d29096 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 024 025 026 027 
[    0.000000] pcpu-alloc: [0] 028 029 030 031 032 033 034 035 048 050 052 054 056 058 060 062 
[    0.000000] pcpu-alloc: [0] 064 066 068 070 072 074 076 078 080 082 084 086 088 090 092 094 
[    0.000000] pcpu-alloc: [0] 096 098 100 102 104 106 108 110 112 114 116 118 120 122 124 126 
[    0.000000] pcpu-alloc: [0] 128 130 132 134 136 138 140 142 144 146 148 150 152 154 156 158 
[    0.000000] pcpu-alloc: [0] 160 162 164 166 168 170 172 174 176 178 180 182 184 186 188 190 
[    0.000000] pcpu-alloc: [0] 192 194 196 198 200 202 204 206 208 210 212 214 216 218 220 222 
[    0.000000] pcpu-alloc: [0] 224 226 228 230 232 234 236 238 --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 012 013 014 015 016 017 018 019 020 021 022 023 036 037 038 039 
[    0.000000] pcpu-alloc: [1] 040 041 042 043 044 045 046 047 049 051 053 055 057 059 061 063 
[    0.000000] pcpu-alloc: [1] 065 067 069 071 073 075 077 079 081 083 085 087 089 091 093 095 
[    0.000000] pcpu-alloc: [1] 097 099 101 103 105 107 109 111 113 115 117 119 121 123 125 127 
[    0.000000] pcpu-alloc: [1] 129 131 133 135 137 139 141 143 145 147 149 151 153 155 157 159 
[    0.000000] pcpu-alloc: [1] 161 163 165 167 169 171 173 175 177 179 181 183 185 187 189 191 
[    0.000000] pcpu-alloc: [1] 193 195 197 199 201 203 205 207 209 211 213 215 217 219 221 223 
[    0.000000] pcpu-alloc: [1] 225 227 229 231 233 235 237 239 --- --- --- --- --- --- --- --- 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16492618
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=/suts/ivbep0/custom-kernel/initramfs.img root=/dev/sda1 ro console=tty0 console=ttyS0,115200 LANG=en_US.UTF-8 nomodeset ignore_loglevel BOOT_IMAGE=/suts/ivbep0/custom-kernel/kernel 
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 978944 bytes
[    0.000000] log_buf_len min size: 262144 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 244568(93%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 65806184K/67017716K available (6874K kernel code, 1170K rwdata, 3080K rodata, 1408K init, 1492K bss, 1211532K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=240, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=240.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=240
[    0.000000] NR_IRQS:33024 nr_irqs:3160 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-239.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2693.671 MHz processor
[    0.000119] Calibrating delay loop (skipped), value calculated using timer frequency.. 5387.34 BogoMIPS (lpj=2693671)
[    0.012547] pid_max: default: 245760 minimum: 1920
[    0.018246] ACPI: Core revision 20150818
[    0.079790] ACPI: 3 ACPI AML tables successfully acquired and loaded
[    0.087782] Security Framework initialized
[    0.092636] SELinux:  Initializing.
[    0.096817] SELinux:  Starting in permissive mode
[    0.106345] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.131064] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.146666] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.154895] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.164798] Initializing cgroup subsys io
[    0.169562] Initializing cgroup subsys memory
[    0.174774] Initializing cgroup subsys devices
[    0.180018] Initializing cgroup subsys freezer
[    0.185261] Initializing cgroup subsys net_cls
[    0.190509] Initializing cgroup subsys perf_event
[    0.196068] Initializing cgroup subsys net_prio
[    0.201408] Initializing cgroup subsys hugetlb
[    0.206804] CPU: Physical Processor ID: 0
[    0.211560] CPU: Processor Core ID: 0
[    0.216730] mce: CPU supports 29 MCE banks
[    0.221625] CPU0: Thermal monitoring enabled (TM1)
[    0.227288] process: using mwait in idle threads
[    0.232727] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.239140] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0, 1GB 4
[    0.246718] Freeing SMP alternatives memory: 28K (ffffffff81e86000 - ffffffff81e8d000)
[    0.283410] ftrace: allocating 25890 entries in 102 pages
[    0.301868] DMAR: Host address width 46
[    0.306436] DMAR: DRHD base: 0x000000fbffe000 flags: 0x0
[    0.312655] DMAR: dmar0: reg_base_addr fbffe000 ver 1:0 cap d2078c106f0466 ecap f020de
[    0.321987] DMAR: DRHD base: 0x000000ebffc000 flags: 0x1
[    0.332800] DMAR: dmar1: reg_base_addr ebffc000 ver 1:0 cap d2078c106f0466 ecap f020de
[    0.342131] DMAR: RMRR base: 0x000000bddbd000 end: 0x000000bddd3fff
[    0.349414] DMAR: ATSR flags: 0x0
[    0.353396] DMAR-IR: IOAPIC id 2 under DRHD base  0xfbffe000 IOMMU 0
[    0.360777] DMAR-IR: IOAPIC id 0 under DRHD base  0xebffc000 IOMMU 1
[    0.368157] DMAR-IR: IOAPIC id 1 under DRHD base  0xebffc000 IOMMU 1
[    0.375536] DMAR-IR: HPET id 0 under DRHD base 0xebffc000
[    0.381850] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.392925] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.399230] x2apic enabled
[    0.402533] Switched APIC routing to cluster x2apic.
[    0.409103] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.426087] TSC deadline timer enabled
[    0.430588] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (family: 0x6, model: 0x3e, stepping: 0x4)
[    0.442570] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.454929] ... version:                3
[    0.459681] ... bit width:              48
[    0.464528] ... generic registers:      4
[    0.469280] ... value mask:             0000ffffffffffff
[    0.475490] ... max period:             0000ffffffffffff
[    0.481701] ... fixed-purpose events:   3
[    0.486451] ... event mask:             000000070000000f
[    0.496806] x86: Booting SMP configuration:
[    0.501753] .... node  #0, CPUs:          #1
[    0.511846] microcode: CPU1 microcode updated early to revision 0x428, date = 2014-05-29
[    0.535097] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.544673]    #2
[    0.553192] microcode: CPU2 microcode updated early to revision 0x428, date = 2014-05-29
[    0.565639]    #3
[    0.569204] microcode: CPU3 microcode updated early to revision 0x428, date = 2014-05-29
[    0.581657]    #4
[    0.585249] microcode: CPU4 microcode updated early to revision 0x428, date = 2014-05-29
[    0.597723]    #5
[    0.601278] microcode: CPU5 microcode updated early to revision 0x428, date = 2014-05-29
[    0.613738]    #6
[    0.617496] microcode: CPU6 microcode updated early to revision 0x428, date = 2014-05-29
[    0.629956]    #7
[    0.633481] microcode: CPU7 microcode updated early to revision 0x428, date = 2014-05-29
[    0.645933]    #8
[    0.649459] microcode: CPU8 microcode updated early to revision 0x428, date = 2014-05-29
[    0.661903]    #9
[    0.665403] microcode: CPU9 microcode updated early to revision 0x428, date = 2014-05-29
[    0.677832]   #10
[    0.681513] microcode: CPU10 microcode updated early to revision 0x428, date = 2014-05-29
[    0.694041]   #11
[    0.697523] microcode: CPU11 microcode updated early to revision 0x428, date = 2014-05-29
[    0.710071] 
[    0.712007] .... node  #1, CPUs:    #12
[    0.719436] microcode: CPU12 microcode updated early to revision 0x428, date = 2014-05-29
[    0.809024]   #13
[    0.814348] microcode: CPU13 microcode updated early to revision 0x428, date = 2014-05-29
[    0.827688]   #14
[    0.833232] microcode: CPU14 microcode updated early to revision 0x428, date = 2014-05-29
[    0.846607]   #15
[    0.851928] microcode: CPU15 microcode updated early to revision 0x428, date = 2014-05-29
[    0.865311]   #16
[    0.870717] microcode: CPU16 microcode updated early to revision 0x428, date = 2014-05-29
[    0.884138]   #17
[    0.889440] microcode: CPU17 microcode updated early to revision 0x428, date = 2014-05-29
[    0.902845]   #18
[    0.908370] microcode: CPU18 microcode updated early to revision 0x428, date = 2014-05-29
[    0.921762]   #19
[    0.927000] microcode: CPU19 microcode updated early to revision 0x428, date = 2014-05-29
[    0.940384]   #20
[    0.945628] microcode: CPU20 microcode updated early to revision 0x428, date = 2014-05-29
[    0.958977]   #21
[    0.964161] microcode: CPU21 microcode updated early to revision 0x428, date = 2014-05-29
[    0.977486]   #22
[    0.982828] microcode: CPU22 microcode updated early to revision 0x428, date = 2014-05-29
[    0.996129]   #23
[    1.001273] microcode: CPU23 microcode updated early to revision 0x428, date = 2014-05-29
[    1.014574] 
[    1.016509] .... node  #0, CPUs:    #24  #25  #26  #27  #28  #29  #30  #31  #32  #33  #34  #35
[    1.079793] .... node  #1, CPUs:    #36  #37  #38  #39  #40  #41  #42  #43  #44  #45  #46  #47
[    1.166965] x86: Booted up 2 nodes, 48 CPUs
[    1.172393] smpboot: Total of 48 processors activated (258734.54 BogoMIPS)
[    1.307005] devtmpfs: initialized
[    1.311059] memory block size : 1024MB
[    1.318055] PM: Registering ACPI NVS region [mem 0xbac80000-0xbb019fff] (3776512 bytes)
[    1.327531] PM: Registering ACPI NVS region [mem 0xbd957000-0xbdb5bfff] (2117632 bytes)
[    1.336979] PM: Registering ACPI NVS region [mem 0xbdde7000-0xbde2bfff] (282624 bytes)
[    1.346309] PM: Registering ACPI NVS region [mem 0xbdf00000-0xbdf00fff] (4096 bytes)
[    1.355439] PM: Registering ACPI NVS region [mem 0xbdf1f000-0xbdffffff] (921600 bytes)
[    1.365126] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    1.377380] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    1.385440] pinctrl core: initialized pinctrl subsystem
[    1.391703] RTC time:  7:30:42, date: 09/26/15
[    1.398311] NET: Registered protocol family 16
[    1.409803] cpuidle: using governor menu
[    1.414505] Simple Boot Flag at 0x4f set to 0x80
[    1.420209] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.429150] ACPI: bus type PCI registered
[    1.433904] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.441841] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.452727] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.460607] PCI: Using configuration type 1 for base access
[    1.468247] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    1.486296] ACPI: Added _OSI(Module Device)
[    1.491250] ACPI: Added _OSI(Processor Device)
[    1.496491] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.502022] ACPI: Added _OSI(Processor Aggregator Device)
[    1.523402] ACPI: Executed 1 blocks of module-level executable AML code
[    1.643237] ACPI: Interpreter enabled
[    1.647611] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150818/hwxface-580)
[    1.658557] ACPI: (supports S0 S1 S3 S4 S5)
[    1.663502] ACPI: Using IOAPIC for interrupt routing
[    1.669348] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.704544] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    1.711734] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.721660] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    1.731086] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    1.741005] PCI host bridge to bus 0000:00
[    1.745861] pci_bus 0000:00: root bus resource [bus 00-7e]
[    1.752267] pci_bus 0000:00: root bus resource [io  0x0000-0xbfff window]
[    1.760129] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    1.768971] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[    1.777809] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[    1.786649] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[    1.795490] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    1.804331] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    1.813170] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    1.822011] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    1.830853] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    1.839699] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    1.848531] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    1.857371] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
[    1.866211] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
[    1.875053] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
[    1.883893] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xebffffff window]
[    1.892734] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x38007fffffff window]
[    1.902361] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
[    1.909407] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.916578] pci 0000:00:01.0: [8086:0e02] type 01 class 0x060400
[    1.923630] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.930768] pci 0000:00:01.0: System wakeup disabled by ACPI
[    1.937403] pci 0000:00:01.1: [8086:0e03] type 01 class 0x060400
[    1.944456] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    1.951596] pci 0000:00:01.1: System wakeup disabled by ACPI
[    1.958231] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
[    1.965272] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.972400] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.979033] pci 0000:00:02.2: [8086:0e06] type 01 class 0x060400
[    1.986083] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    1.993221] pci 0000:00:02.2: System wakeup disabled by ACPI
[    1.999848] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
[    2.006902] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.014040] pci 0000:00:03.0: System wakeup disabled by ACPI
[    2.020664] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
[    2.027715] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    2.034855] pci 0000:00:03.2: System wakeup disabled by ACPI
[    2.041490] pci 0000:00:04.0: [8086:0e20] type 00 class 0x088000
[    2.048499] pci 0000:00:04.0: reg 0x10: [mem 0xebf90000-0xebf93fff 64bit]
[    2.056473] pci 0000:00:04.1: [8086:0e21] type 00 class 0x088000
[    2.063482] pci 0000:00:04.1: reg 0x10: [mem 0xebf80000-0xebf83fff 64bit]
[    2.071455] pci 0000:00:04.2: [8086:0e22] type 00 class 0x088000
[    2.078466] pci 0000:00:04.2: reg 0x10: [mem 0xebf70000-0xebf73fff 64bit]
[    2.086437] pci 0000:00:04.3: [8086:0e23] type 00 class 0x088000
[    2.093447] pci 0000:00:04.3: reg 0x10: [mem 0xebf60000-0xebf63fff 64bit]
[    2.101420] pci 0000:00:04.4: [8086:0e24] type 00 class 0x088000
[    2.108421] pci 0000:00:04.4: reg 0x10: [mem 0xebf50000-0xebf53fff 64bit]
[    2.116391] pci 0000:00:04.5: [8086:0e25] type 00 class 0x088000
[    2.123401] pci 0000:00:04.5: reg 0x10: [mem 0xebf40000-0xebf43fff 64bit]
[    2.131375] pci 0000:00:04.6: [8086:0e26] type 00 class 0x088000
[    2.138388] pci 0000:00:04.6: reg 0x10: [mem 0xebf30000-0xebf33fff 64bit]
[    2.146357] pci 0000:00:04.7: [8086:0e27] type 00 class 0x088000
[    2.153367] pci 0000:00:04.7: reg 0x10: [mem 0xebf20000-0xebf23fff 64bit]
[    2.161339] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
[    2.168435] pci 0000:00:05.1: [8086:0e29] type 00 class 0x088000
[    2.175550] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
[    2.182649] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
[    2.189653] pci 0000:00:05.4: reg 0x10: [mem 0xd0d60000-0xd0d60fff]
[    2.197044] pci 0000:00:05.6: [8086:0e39] type 00 class 0x110100
[    2.204143] pci 0000:00:06.0: [8086:0e10] type 00 class 0x088000
[    2.211240] pci 0000:00:06.1: [8086:0e11] type 00 class 0x088000
[    2.218336] pci 0000:00:06.2: [8086:0e12] type 00 class 0x088000
[    2.225435] pci 0000:00:06.3: [8086:0e13] type 00 class 0x088000
[    2.232531] pci 0000:00:06.4: [8086:0e14] type 00 class 0x088000
[    2.239634] pci 0000:00:06.5: [8086:0e15] type 00 class 0x088000
[    2.246732] pci 0000:00:06.6: [8086:0e16] type 00 class 0x088000
[    2.253832] pci 0000:00:06.7: [8086:0e17] type 00 class 0x088000
[    2.260929] pci 0000:00:07.0: [8086:0e18] type 00 class 0x088000
[    2.268030] pci 0000:00:07.1: [8086:0e19] type 00 class 0x088000
[    2.275129] pci 0000:00:07.2: [8086:0e1a] type 00 class 0x088000
[    2.282228] pci 0000:00:07.3: [8086:0e1b] type 00 class 0x088000
[    2.293975] pci 0000:00:07.4: [8086:0e1c] type 00 class 0x088000
[    2.301096] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    2.308115] pci 0000:00:1a.0: reg 0x10: [mem 0xd0d20000-0xd0d203ff]
[    2.315462] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    2.322610] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.329243] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
[    2.336304] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.343440] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    2.350083] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
[    2.357138] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    2.364272] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    2.370907] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    2.377925] pci 0000:00:1d.0: reg 0x10: [mem 0xd0d10000-0xd0d103ff]
[    2.385270] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    2.392413] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.399044] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    2.406115] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    2.412749] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    2.419906] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
[    2.426917] pci 0000:00:1f.2: reg 0x10: [io  0x4070-0x4077]
[    2.433426] pci 0000:00:1f.2: reg 0x14: [io  0x4060-0x4063]
[    2.439936] pci 0000:00:1f.2: reg 0x18: [io  0x4050-0x4057]
[    2.446445] pci 0000:00:1f.2: reg 0x1c: [io  0x4040-0x4043]
[    2.452956] pci 0000:00:1f.2: reg 0x20: [io  0x4020-0x403f]
[    2.459464] pci 0000:00:1f.2: reg 0x24: [mem 0xd0d00000-0xd0d007ff]
[    2.466769] pci 0000:00:1f.2: PME# supported from D3hot
[    2.472954] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    2.479952] pci 0000:00:1f.3: reg 0x10: [mem 0xebf10000-0xebf100ff 64bit]
[    2.487823] pci 0000:00:1f.3: reg 0x20: [io  0x4000-0x401f]
[    2.494412] pci 0000:00:1f.6: [8086:1d24] type 00 class 0x118000
[    2.501428] pci 0000:00:1f.6: reg 0x10: [mem 0xebf00000-0xebf00fff 64bit]
[    2.509464] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    2.515581] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    2.522672] pci 0000:00:01.0:   bridge window [mem 0xd0b00000-0xd0cfffff]
[    2.530539] pci 0000:00:01.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    2.539706] pci 0000:01:00.0: [8086:1d74] type 01 class 0x060400
[    2.546738] pci 0000:01:00.0: reg 0x10: [mem 0xd0c00000-0xd0c03fff]
[    2.554082] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.563276] pci 0000:01:00.0: PCI bridge to [bus 02-03]
[    2.569415] pci 0000:01:00.0:   bridge window [io  0x3000-0x3fff]
[    2.576522] pci 0000:01:00.0:   bridge window [mem 0xd0b00000-0xd0bfffff]
[    2.584410] pci 0000:01:00.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    2.593571] pci 0000:02:08.0: [8086:1d3f] type 01 class 0x060400
[    2.600655] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    2.607879] pci 0000:02:08.0: PCI bridge to [bus 03]
[    2.613714] pci 0000:02:08.0:   bridge window [io  0x3000-0x3fff]
[    2.620813] pci 0000:02:08.0:   bridge window [mem 0xd0b00000-0xd0bfffff]
[    2.628700] pci 0000:02:08.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    2.637853] pci 0000:03:00.0: [8086:1d68] type 00 class 0x010700
[    2.644890] pci 0000:03:00.0: reg 0x10: [mem 0xeb800000-0xeb807fff 64bit pref]
[    2.653470] pci 0000:03:00.0: reg 0x18: [mem 0xeb000000-0xeb7fffff 64bit pref]
[    2.662037] pci 0000:03:00.0: reg 0x20: [io  0x3100-0x31ff]
[    2.668568] pci 0000:03:00.0: reg 0x24: [io  0x3000-0x30ff]
[    2.675159] pci 0000:03:00.0: reg 0x164: [mem 0xeb810000-0xeb817fff 64bit pref]
[    2.683806] pci 0000:03:00.0: VF(n) BAR0 space: [mem 0xeb810000-0xeb907fff 64bit pref] (contains BAR0 for 31 VFs)
[    2.695942] pci 0000:03:00.3: [8086:1d70] type 00 class 0x0c0500
[    2.702979] pci 0000:03:00.3: reg 0x10: [mem 0xd0b10000-0xd0b10fff]
[    2.710313] pci 0000:03:00.3: reg 0x20: [io  0x3220-0x323f]
[    2.716878] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    2.724049] pci 0000:03:00.4: [8086:1d71] type 00 class 0x0c0500
[    2.731085] pci 0000:03:00.4: reg 0x10: [mem 0xd0b00000-0xd0b00fff]
[    2.738416] pci 0000:03:00.4: reg 0x20: [io  0x3200-0x321f]
[    2.744972] pci 0000:03:00.4: PME# supported from D0 D3hot D3cold
[    2.752246] acpiphp: Slot [2] registered
[    2.756922] pci 0000:00:01.1: PCI bridge to [bus 04]
[    2.762827] acpiphp: Slot [2-2] registered
[    2.767693] pci 0000:00:02.0: PCI bridge to [bus 05]
[    2.773593] acpiphp: Slot [2-3] registered
[    2.778460] pci 0000:00:02.2: PCI bridge to [bus 06]
[    2.784363] acpiphp: Slot [2-4] registered
[    2.789230] pci 0000:00:03.0: PCI bridge to [bus 07]
[    2.795131] acpiphp: Slot [2-5] registered
[    2.800001] pci 0000:00:03.2: PCI bridge to [bus 08]
[    2.805881] pci 0000:00:1c.0: PCI bridge to [bus 09-0a]
[    2.811998] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    2.819087] pci 0000:00:1c.0:   bridge window [mem 0xd0900000-0xd0afffff]
[    2.826974] pci 0000:09:00.0: [8086:1521] type 00 class 0x020000
[    2.833996] pci 0000:09:00.0: reg 0x10: [mem 0xd0960000-0xd097ffff]
[    2.841300] pci 0000:09:00.0: reg 0x18: [io  0x2060-0x207f]
[    2.847814] pci 0000:09:00.0: reg 0x1c: [mem 0xd09b0000-0xd09b3fff]
[    2.855201] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    2.862331] pci 0000:09:00.0: reg 0x184: [mem 0xd0aa0000-0xd0aa3fff]
[    2.869712] pci 0000:09:00.0: VF(n) BAR0 space: [mem 0xd0aa0000-0xd0abffff] (contains BAR0 for 8 VFs)
[    2.880529] pci 0000:09:00.0: reg 0x190: [mem 0xd0a80000-0xd0a83fff]
[    2.887906] pci 0000:09:00.0: VF(n) BAR3 space: [mem 0xd0a80000-0xd0a9ffff] (contains BAR3 for 8 VFs)
[    2.898767] pci 0000:09:00.0: System wakeup disabled by ACPI
[    2.905413] pci 0000:09:00.1: [8086:1521] type 00 class 0x020000
[    2.912445] pci 0000:09:00.1: reg 0x10: [mem 0xd0940000-0xd095ffff]
[    2.919748] pci 0000:09:00.1: reg 0x18: [io  0x2040-0x205f]
[    2.926261] pci 0000:09:00.1: reg 0x1c: [mem 0xd09a0000-0xd09a3fff]
[    2.933642] pci 0000:09:00.1: PME# supported from D0 D3hot D3cold
[    2.940772] pci 0000:09:00.1: reg 0x184: [mem 0xd0a60000-0xd0a63fff]
[    2.948154] pci 0000:09:00.1: VF(n) BAR0 space: [mem 0xd0a60000-0xd0a7ffff] (contains BAR0 for 8 VFs)
[    2.958976] pci 0000:09:00.1: reg 0x190: [mem 0xd0a40000-0xd0a43fff]
[    2.966354] pci 0000:09:00.1: VF(n) BAR3 space: [mem 0xd0a40000-0xd0a5ffff] (contains BAR3 for 8 VFs)
[    2.977258] pci 0000:09:00.2: [8086:1521] type 00 class 0x020000
[    2.984279] pci 0000:09:00.2: reg 0x10: [mem 0xd0920000-0xd093ffff]
[    2.991581] pci 0000:09:00.2: reg 0x18: [io  0x2020-0x203f]
[    2.998097] pci 0000:09:00.2: reg 0x1c: [mem 0xd0990000-0xd0993fff]
[    3.005477] pci 0000:09:00.2: PME# supported from D0 D3hot D3cold
[    3.012606] pci 0000:09:00.2: reg 0x184: [mem 0xd0a20000-0xd0a23fff]
[    3.019976] pci 0000:09:00.2: VF(n) BAR0 space: [mem 0xd0a20000-0xd0a3ffff] (contains BAR0 for 8 VFs)
[    3.030796] pci 0000:09:00.2: reg 0x190: [mem 0xd0a00000-0xd0a03fff]
[    3.038175] pci 0000:09:00.2: VF(n) BAR3 space: [mem 0xd0a00000-0xd0a1ffff] (contains BAR3 for 8 VFs)
[    3.049082] pci 0000:09:00.3: [8086:1521] type 00 class 0x020000
[    3.056112] pci 0000:09:00.3: reg 0x10: [mem 0xd0900000-0xd091ffff]
[    3.063416] pci 0000:09:00.3: reg 0x18: [io  0x2000-0x201f]
[    3.069931] pci 0000:09:00.3: reg 0x1c: [mem 0xd0980000-0xd0983fff]
[    3.077312] pci 0000:09:00.3: PME# supported from D0 D3hot D3cold
[    3.084441] pci 0000:09:00.3: reg 0x184: [mem 0xd09e0000-0xd09e3fff]
[    3.091818] pci 0000:09:00.3: VF(n) BAR0 space: [mem 0xd09e0000-0xd09fffff] (contains BAR0 for 8 VFs)
[    3.102636] pci 0000:09:00.3: reg 0x190: [mem 0xd09c0000-0xd09c3fff]
[    3.110012] pci 0000:09:00.3: VF(n) BAR3 space: [mem 0xd09c0000-0xd09dffff] (contains BAR3 for 8 VFs)
[    3.122886] pci 0000:00:1c.7: PCI bridge to [bus 0b]
[    3.128713] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
[    3.136581] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
[    3.145734] pci 0000:0b:00.0: [102b:0522] type 00 class 0x030000
[    3.152775] pci 0000:0b:00.0: reg 0x10: [mem 0xea000000-0xeaffffff pref]
[    3.160547] pci 0000:0b:00.0: reg 0x14: [mem 0xd0810000-0xd0813fff]
[    3.167833] pci 0000:0b:00.0: reg 0x18: [mem 0xd0000000-0xd07fffff]
[    3.175173] pci 0000:0b:00.0: reg 0x30: [mem 0xd0800000-0xd080ffff pref]
[    3.183010] pci 0000:0b:00.0: System wakeup disabled by ACPI
[    3.191683] pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
[    3.199556] pci 0000:00:1e.0:   bridge window [io  0x0000-0xbfff window] (subtractive decode)
[    3.209567] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    3.220355] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff window] (subtractive decode)
[    3.231139] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff window] (subtractive decode)
[    3.241922] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000cbfff window] (subtractive decode)
[    3.252706] pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff window] (subtractive decode)
[    3.263489] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff window] (subtractive decode)
[    3.274272] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff window] (subtractive decode)
[    3.285058] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff window] (subtractive decode)
[    3.295846] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff window] (subtractive decode)
[    3.306636] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff window] (subtractive decode)
[    3.317420] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff window] (subtractive decode)
[    3.328209] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff window] (subtractive decode)
[    3.338997] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff window] (subtractive decode)
[    3.349780] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff window] (subtractive decode)
[    3.360564] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xebffffff window] (subtractive decode)
[    3.371351] pci 0000:00:1e.0:   bridge window [mem 0x380000000000-0x38007fffffff window] (subtractive decode)
[    3.382997] pci_bus 0000:00: on NUMA node 0
[    3.388532] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    3.397392] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 10 11 12 14 15)
[    3.406249] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    3.415107] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    3.423965] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.439098] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.449576] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.460041] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    3.468976] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    3.476165] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.485936] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    3.495360] acpi PNP0A08:01: FADT indicates ASPM is unsupported, using BIOS configuration
[    3.505154] PCI host bridge to bus 0000:80
[    3.510005] pci_bus 0000:80: root bus resource [bus 80-fe]
[    3.516411] pci_bus 0000:80: root bus resource [io  0xc000-0xffff window]
[    3.524273] pci_bus 0000:80: root bus resource [mem 0xec000000-0xfbffffff window]
[    3.533116] pci_bus 0000:80: root bus resource [mem 0x380080000000-0x3800ffffffff window]
[    3.542738] pci 0000:80:02.0: [8086:0e04] type 01 class 0x060400
[    3.549799] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    3.556918] pci 0000:80:02.0: System wakeup disabled by ACPI
[    3.563558] pci 0000:80:04.0: [8086:0e20] type 00 class 0x088000
[    3.570571] pci 0000:80:04.0: reg 0x10: [mem 0xfbf70000-0xfbf73fff 64bit]
[    3.578533] pci 0000:80:04.1: [8086:0e21] type 00 class 0x088000
[    3.585548] pci 0000:80:04.1: reg 0x10: [mem 0xfbf60000-0xfbf63fff 64bit]
[    3.593507] pci 0000:80:04.2: [8086:0e22] type 00 class 0x088000
[    3.600519] pci 0000:80:04.2: reg 0x10: [mem 0xfbf50000-0xfbf53fff 64bit]
[    3.608481] pci 0000:80:04.3: [8086:0e23] type 00 class 0x088000
[    3.615493] pci 0000:80:04.3: reg 0x10: [mem 0xfbf40000-0xfbf43fff 64bit]
[    3.623451] pci 0000:80:04.4: [8086:0e24] type 00 class 0x088000
[    3.630460] pci 0000:80:04.4: reg 0x10: [mem 0xfbf30000-0xfbf33fff 64bit]
[    3.638420] pci 0000:80:04.5: [8086:0e25] type 00 class 0x088000
[    3.645431] pci 0000:80:04.5: reg 0x10: [mem 0xfbf20000-0xfbf23fff 64bit]
[    3.653389] pci 0000:80:04.6: [8086:0e26] type 00 class 0x088000
[    3.660398] pci 0000:80:04.6: reg 0x10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    3.668360] pci 0000:80:04.7: [8086:0e27] type 00 class 0x088000
[    3.675372] pci 0000:80:04.7: reg 0x10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    3.683329] pci 0000:80:05.0: [8086:0e28] type 00 class 0x088000
[    3.690416] pci 0000:80:05.1: [8086:0e29] type 00 class 0x088000
[    3.697517] pci 0000:80:05.2: [8086:0e2a] type 00 class 0x088000
[    3.704597] pci 0000:80:05.4: [8086:0e2c] type 00 class 0x080020
[    3.711602] pci 0000:80:05.4: reg 0x10: [mem 0xec500000-0xec500fff]
[    3.718983] pci 0000:80:05.6: [8086:0e39] type 00 class 0x110100
[    3.726070] pci 0000:80:06.0: [8086:0e10] type 00 class 0x088000
[    3.733155] pci 0000:80:06.1: [8086:0e11] type 00 class 0x088000
[    3.740245] pci 0000:80:06.2: [8086:0e12] type 00 class 0x088000
[    3.747331] pci 0000:80:06.3: [8086:0e13] type 00 class 0x088000
[    3.754418] pci 0000:80:06.4: [8086:0e14] type 00 class 0x088000
[    3.761506] pci 0000:80:06.5: [8086:0e15] type 00 class 0x088000
[    3.768595] pci 0000:80:06.6: [8086:0e16] type 00 class 0x088000
[    3.775680] pci 0000:80:06.7: [8086:0e17] type 00 class 0x088000
[    3.782769] pci 0000:80:07.0: [8086:0e18] type 00 class 0x088000
[    3.789854] pci 0000:80:07.1: [8086:0e19] type 00 class 0x088000
[    3.796945] pci 0000:80:07.2: [8086:0e1a] type 00 class 0x088000
[    3.804031] pci 0000:80:07.3: [8086:0e1b] type 00 class 0x088000
[    3.811117] pci 0000:80:07.4: [8086:0e1c] type 00 class 0x088000
[    3.818261] pci 0000:80:02.0: PCI bridge to [bus 81-82]
[    3.824369] pci 0000:80:02.0:   bridge window [io  0xc000-0xcfff]
[    3.831458] pci 0000:80:02.0:   bridge window [mem 0xec000000-0xec4fffff]
[    3.839324] pci 0000:80:02.0:   bridge window [mem 0xfbb00000-0xfbefffff 64bit pref]
[    3.848465] pci 0000:81:00.0: [8086:151c] type 00 class 0x020000
[    3.855474] pci 0000:81:00.0: reg 0x10: [mem 0xec200000-0xec3fffff 64bit]
[    3.863342] pci 0000:81:00.0: reg 0x18: [io  0xc020-0xc03f]
[    3.869856] pci 0000:81:00.0: reg 0x20: [mem 0xec410000-0xec413fff 64bit]
[    3.877750] pci 0000:81:00.0: PME# supported from D0 D3hot D3cold
[    3.884862] pci 0000:81:00.0: reg 0x184: [mem 0xfbe00000-0xfbe03fff 64bit pref]
[    3.893500] pci 0000:81:00.0: VF(n) BAR0 space: [mem 0xfbe00000-0xfbefffff 64bit pref] (contains BAR0 for 64 VFs)
[    3.905460] pci 0000:81:00.0: reg 0x190: [mem 0xfbd00000-0xfbd03fff 64bit pref]
[    3.914106] pci 0000:81:00.0: VF(n) BAR3 space: [mem 0xfbd00000-0xfbdfffff 64bit pref] (contains BAR3 for 64 VFs)
[    3.926201] pci 0000:81:00.1: [8086:151c] type 00 class 0x020000
[    3.933208] pci 0000:81:00.1: reg 0x10: [mem 0xec000000-0xec1fffff 64bit]
[    3.941079] pci 0000:81:00.1: reg 0x18: [io  0xc000-0xc01f]
[    3.947593] pci 0000:81:00.1: reg 0x20: [mem 0xec400000-0xec403fff 64bit]
[    3.955486] pci 0000:81:00.1: PME# supported from D0 D3hot D3cold
[    3.962595] pci 0000:81:00.1: reg 0x184: [mem 0xfbc00000-0xfbc03fff 64bit pref]
[    3.971243] pci 0000:81:00.1: VF(n) BAR0 space: [mem 0xfbc00000-0xfbcfffff 64bit pref] (contains BAR0 for 64 VFs)
[    3.983205] pci 0000:81:00.1: reg 0x190: [mem 0xfbb00000-0xfbb03fff 64bit pref]
[    3.991852] pci 0000:81:00.1: VF(n) BAR3 space: [mem 0xfbb00000-0xfbbfffff 64bit pref] (contains BAR3 for 64 VFs)
[    4.005856] pci_bus 0000:80: on NUMA node 1
[    4.016249] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 7f])
[    4.023136] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.032757] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.040477] PCI host bridge to bus 0000:7f
[    4.045328] pci_bus 0000:7f: root bus resource [bus 7f]
[    4.051448] pci 0000:7f:08.0: [8086:0e80] type 00 class 0x088000
[    4.058489] pci 0000:7f:08.2: [8086:0e32] type 00 class 0x110100
[    4.065525] pci 0000:7f:08.3: [8086:0e83] type 00 class 0x088000
[    4.072568] pci 0000:7f:08.4: [8086:0e84] type 00 class 0x088000
[    4.079614] pci 0000:7f:08.5: [8086:0e85] type 00 class 0x088000
[    4.086654] pci 0000:7f:08.6: [8086:0e86] type 00 class 0x088000
[    4.093694] pci 0000:7f:08.7: [8086:0e87] type 00 class 0x088000
[    4.100740] pci 0000:7f:09.0: [8086:0e90] type 00 class 0x088000
[    4.107773] pci 0000:7f:09.2: [8086:0e33] type 00 class 0x110100
[    4.114808] pci 0000:7f:09.3: [8086:0e93] type 00 class 0x088000
[    4.121844] pci 0000:7f:09.4: [8086:0e94] type 00 class 0x088000
[    4.128896] pci 0000:7f:09.5: [8086:0e95] type 00 class 0x088000
[    4.135934] pci 0000:7f:09.6: [8086:0e96] type 00 class 0x088000
[    4.142974] pci 0000:7f:0a.0: [8086:0ec0] type 00 class 0x088000
[    4.150002] pci 0000:7f:0a.1: [8086:0ec1] type 00 class 0x088000
[    4.157035] pci 0000:7f:0a.2: [8086:0ec2] type 00 class 0x088000
[    4.164063] pci 0000:7f:0a.3: [8086:0ec3] type 00 class 0x088000
[    4.171095] pci 0000:7f:0a.4: [8086:0ec4] type 00 class 0x088000
[    4.178115] pci 0000:7f:0a.5: [8086:0ec5] type 00 class 0x088000
[    4.185148] pci 0000:7f:0a.6: [8086:0ec6] type 00 class 0x088000
[    4.192177] pci 0000:7f:0a.7: [8086:0ec7] type 00 class 0x088000
[    4.199208] pci 0000:7f:0b.0: [8086:0e1e] type 00 class 0x088000
[    4.206234] pci 0000:7f:0b.2: [8086:0e7d] type 00 class 0x088000
[    4.213263] pci 0000:7f:0b.3: [8086:0e1f] type 00 class 0x088000
[    4.220290] pci 0000:7f:0c.0: [8086:0ee0] type 00 class 0x088000
[    4.227321] pci 0000:7f:0c.1: [8086:0ee2] type 00 class 0x088000
[    4.234350] pci 0000:7f:0c.2: [8086:0ee4] type 00 class 0x088000
[    4.241380] pci 0000:7f:0c.3: [8086:0ee6] type 00 class 0x088000
[    4.248406] pci 0000:7f:0c.4: [8086:0ee8] type 00 class 0x088000
[    4.255434] pci 0000:7f:0c.5: [8086:0eea] type 00 class 0x088000
[    4.262461] pci 0000:7f:0d.0: [8086:0ee1] type 00 class 0x088000
[    4.269489] pci 0000:7f:0d.1: [8086:0ee3] type 00 class 0x088000
[    4.276517] pci 0000:7f:0d.2: [8086:0ee5] type 00 class 0x088000
[    4.283548] pci 0000:7f:0d.3: [8086:0ee7] type 00 class 0x088000
[    4.290575] pci 0000:7f:0d.4: [8086:0ee9] type 00 class 0x088000
[    4.297605] pci 0000:7f:0d.5: [8086:0eeb] type 00 class 0x088000
[    4.304639] pci 0000:7f:0e.0: [8086:0ea0] type 00 class 0x088000
[    4.311673] pci 0000:7f:0e.1: [8086:0e30] type 00 class 0x110100
[    4.318703] pci 0000:7f:0e.2: [8086:0e70] type 00 class 0x088000
[    4.325743] pci 0000:7f:0f.0: [8086:0ea8] type 00 class 0x088000
[    4.332782] pci 0000:7f:0f.1: [8086:0e71] type 00 class 0x088000
[    4.339826] pci 0000:7f:0f.2: [8086:0eaa] type 00 class 0x088000
[    4.346863] pci 0000:7f:0f.3: [8086:0eab] type 00 class 0x088000
[    4.353907] pci 0000:7f:0f.4: [8086:0eac] type 00 class 0x088000
[    4.360944] pci 0000:7f:0f.5: [8086:0ead] type 00 class 0x088000
[    4.367991] pci 0000:7f:10.0: [8086:0eb0] type 00 class 0x088000
[    4.375029] pci 0000:7f:10.1: [8086:0eb1] type 00 class 0x088000
[    4.382068] pci 0000:7f:10.2: [8086:0eb2] type 00 class 0x088000
[    4.389107] pci 0000:7f:10.3: [8086:0eb3] type 00 class 0x088000
[    4.396148] pci 0000:7f:10.4: [8086:0eb4] type 00 class 0x088000
[    4.403190] pci 0000:7f:10.5: [8086:0eb5] type 00 class 0x088000
[    4.410236] pci 0000:7f:10.6: [8086:0eb6] type 00 class 0x088000
[    4.417275] pci 0000:7f:10.7: [8086:0eb7] type 00 class 0x088000
[    4.424317] pci 0000:7f:11.0: [8086:0eb8] type 00 class 0x088000
[    4.431359] pci 0000:7f:11.4: [8086:0ebc] type 00 class 0x088000
[    4.438400] pci 0000:7f:11.5: [8086:0ebd] type 00 class 0x088000
[    4.445430] pci 0000:7f:11.6: [8086:0ebe] type 00 class 0x088000
[    4.452468] pci 0000:7f:11.7: [8086:0ebf] type 00 class 0x088000
[    4.459506] pci 0000:7f:13.0: [8086:0e1d] type 00 class 0x088000
[    4.466538] pci 0000:7f:13.1: [8086:0e34] type 00 class 0x110100
[    4.473569] pci 0000:7f:13.4: [8086:0e81] type 00 class 0x088000
[    4.480604] pci 0000:7f:13.5: [8086:0e36] type 00 class 0x110100
[    4.487636] pci 0000:7f:13.6: [8086:0e37] type 00 class 0x110100
[    4.494663] pci 0000:7f:16.0: [8086:0ec8] type 00 class 0x088000
[    4.501693] pci 0000:7f:16.1: [8086:0ec9] type 00 class 0x088000
[    4.508723] pci 0000:7f:16.2: [8086:0eca] type 00 class 0x088000
[    4.515765] pci 0000:7f:1c.0: [8086:0e60] type 00 class 0x088000
[    4.522799] pci 0000:7f:1c.1: [8086:0e38] type 00 class 0x110100
[    4.529833] pci 0000:7f:1c.2: [8086:0e78] type 00 class 0x088000
[    4.536875] pci 0000:7f:1d.0: [8086:0e68] type 00 class 0x088000
[    4.543913] pci 0000:7f:1d.1: [8086:0e79] type 00 class 0x088000
[    4.550955] pci 0000:7f:1d.2: [8086:0e6a] type 00 class 0x088000
[    4.557995] pci 0000:7f:1d.3: [8086:0e6b] type 00 class 0x088000
[    4.565036] pci 0000:7f:1d.4: [8086:0e6c] type 00 class 0x088000
[    4.572065] pci 0000:7f:1d.5: [8086:0e6d] type 00 class 0x088000
[    4.579113] pci 0000:7f:1e.0: [8086:0ef0] type 00 class 0x088000
[    4.586154] pci 0000:7f:1e.1: [8086:0ef1] type 00 class 0x088000
[    4.593184] pci 0000:7f:1e.2: [8086:0ef2] type 00 class 0x088000
[    4.600226] pci 0000:7f:1e.3: [8086:0ef3] type 00 class 0x088000
[    4.607268] pci 0000:7f:1e.4: [8086:0ef4] type 00 class 0x088000
[    4.614308] pci 0000:7f:1e.5: [8086:0ef5] type 00 class 0x088000
[    4.621351] pci 0000:7f:1e.6: [8086:0ef6] type 00 class 0x088000
[    4.628392] pci 0000:7f:1e.7: [8086:0ef7] type 00 class 0x088000
[    4.635436] pci 0000:7f:1f.0: [8086:0e98] type 00 class 0x088000
[    4.642475] pci 0000:7f:1f.1: [8086:0e99] type 00 class 0x088000
[    4.654144] pci 0000:7f:1f.2: [8086:0e9a] type 00 class 0x088000
[    4.661182] pci 0000:7f:1f.3: [8086:0e9b] type 00 class 0x088000
[    4.668288] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus ff])
[    4.675181] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.684801] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.692520] PCI host bridge to bus 0000:ff
[    4.697365] pci_bus 0000:ff: root bus resource [bus ff]
[    4.703485] pci 0000:ff:08.0: [8086:0e80] type 00 class 0x088000
[    4.710525] pci 0000:ff:08.2: [8086:0e32] type 00 class 0x110100
[    4.717561] pci 0000:ff:08.3: [8086:0e83] type 00 class 0x088000
[    4.724612] pci 0000:ff:08.4: [8086:0e84] type 00 class 0x088000
[    4.731665] pci 0000:ff:08.5: [8086:0e85] type 00 class 0x088000
[    4.738713] pci 0000:ff:08.6: [8086:0e86] type 00 class 0x088000
[    4.745759] pci 0000:ff:08.7: [8086:0e87] type 00 class 0x088000
[    4.752810] pci 0000:ff:09.0: [8086:0e90] type 00 class 0x088000
[    4.759844] pci 0000:ff:09.2: [8086:0e33] type 00 class 0x110100
[    4.766883] pci 0000:ff:09.3: [8086:0e93] type 00 class 0x088000
[    4.773919] pci 0000:ff:09.4: [8086:0e94] type 00 class 0x088000
[    4.780972] pci 0000:ff:09.5: [8086:0e95] type 00 class 0x088000
[    4.788020] pci 0000:ff:09.6: [8086:0e96] type 00 class 0x088000
[    4.795064] pci 0000:ff:0a.0: [8086:0ec0] type 00 class 0x088000
[    4.802096] pci 0000:ff:0a.1: [8086:0ec1] type 00 class 0x088000
[    4.809129] pci 0000:ff:0a.2: [8086:0ec2] type 00 class 0x088000
[    4.816164] pci 0000:ff:0a.3: [8086:0ec3] type 00 class 0x088000
[    4.823201] pci 0000:ff:0a.4: [8086:0ec4] type 00 class 0x088000
[    4.830236] pci 0000:ff:0a.5: [8086:0ec5] type 00 class 0x088000
[    4.837271] pci 0000:ff:0a.6: [8086:0ec6] type 00 class 0x088000
[    4.844305] pci 0000:ff:0a.7: [8086:0ec7] type 00 class 0x088000
[    4.851340] pci 0000:ff:0b.0: [8086:0e1e] type 00 class 0x088000
[    4.858372] pci 0000:ff:0b.2: [8086:0e7d] type 00 class 0x088000
[    4.865397] pci 0000:ff:0b.3: [8086:0e1f] type 00 class 0x088000
[    4.872430] pci 0000:ff:0c.0: [8086:0ee0] type 00 class 0x088000
[    4.879466] pci 0000:ff:0c.1: [8086:0ee2] type 00 class 0x088000
[    4.886500] pci 0000:ff:0c.2: [8086:0ee4] type 00 class 0x088000
[    4.893539] pci 0000:ff:0c.3: [8086:0ee6] type 00 class 0x088000
[    4.900575] pci 0000:ff:0c.4: [8086:0ee8] type 00 class 0x088000
[    4.907611] pci 0000:ff:0c.5: [8086:0eea] type 00 class 0x088000
[    4.914646] pci 0000:ff:0d.0: [8086:0ee1] type 00 class 0x088000
[    4.921680] pci 0000:ff:0d.1: [8086:0ee3] type 00 class 0x088000
[    4.928714] pci 0000:ff:0d.2: [8086:0ee5] type 00 class 0x088000
[    4.935752] pci 0000:ff:0d.3: [8086:0ee7] type 00 class 0x088000
[    4.942788] pci 0000:ff:0d.4: [8086:0ee9] type 00 class 0x088000
[    4.949825] pci 0000:ff:0d.5: [8086:0eeb] type 00 class 0x088000
[    4.956861] pci 0000:ff:0e.0: [8086:0ea0] type 00 class 0x088000
[    4.963904] pci 0000:ff:0e.1: [8086:0e30] type 00 class 0x110100
[    4.970943] pci 0000:ff:0e.2: [8086:0e70] type 00 class 0x088000
[    4.977995] pci 0000:ff:0f.0: [8086:0ea8] type 00 class 0x088000
[    4.985045] pci 0000:ff:0f.1: [8086:0e71] type 00 class 0x088000
[    4.992097] pci 0000:ff:0f.2: [8086:0eaa] type 00 class 0x088000
[    4.999143] pci 0000:ff:0f.3: [8086:0eab] type 00 class 0x088000
[    5.006193] pci 0000:ff:0f.4: [8086:0eac] type 00 class 0x088000
[    5.013241] pci 0000:ff:0f.5: [8086:0ead] type 00 class 0x088000
[    5.020295] pci 0000:ff:10.0: [8086:0eb0] type 00 class 0x088000
[    5.027344] pci 0000:ff:10.1: [8086:0eb1] type 00 class 0x088000
[    5.034386] pci 0000:ff:10.2: [8086:0eb2] type 00 class 0x088000
[    5.041433] pci 0000:ff:10.3: [8086:0eb3] type 00 class 0x088000
[    5.048484] pci 0000:ff:10.4: [8086:0eb4] type 00 class 0x088000
[    5.055531] pci 0000:ff:10.5: [8086:0eb5] type 00 class 0x088000
[    5.062581] pci 0000:ff:10.6: [8086:0eb6] type 00 class 0x088000
[    5.069632] pci 0000:ff:10.7: [8086:0eb7] type 00 class 0x088000
[    5.076682] pci 0000:ff:11.0: [8086:0eb8] type 00 class 0x088000
[    5.083737] pci 0000:ff:11.4: [8086:0ebc] type 00 class 0x088000
[    5.090787] pci 0000:ff:11.5: [8086:0ebd] type 00 class 0x088000
[    5.097834] pci 0000:ff:11.6: [8086:0ebe] type 00 class 0x088000
[    5.104883] pci 0000:ff:11.7: [8086:0ebf] type 00 class 0x088000
[    5.111929] pci 0000:ff:13.0: [8086:0e1d] type 00 class 0x088000
[    5.118964] pci 0000:ff:13.1: [8086:0e34] type 00 class 0x110100
[    5.126006] pci 0000:ff:13.4: [8086:0e81] type 00 class 0x088000
[    5.133046] pci 0000:ff:13.5: [8086:0e36] type 00 class 0x110100
[    5.140084] pci 0000:ff:13.6: [8086:0e37] type 00 class 0x110100
[    5.147128] pci 0000:ff:16.0: [8086:0ec8] type 00 class 0x088000
[    5.154167] pci 0000:ff:16.1: [8086:0ec9] type 00 class 0x088000
[    5.161206] pci 0000:ff:16.2: [8086:0eca] type 00 class 0x088000
[    5.168254] pci 0000:ff:1c.0: [8086:0e60] type 00 class 0x088000
[    5.175300] pci 0000:ff:1c.1: [8086:0e38] type 00 class 0x110100
[    5.182348] pci 0000:ff:1c.2: [8086:0e78] type 00 class 0x088000
[    5.189406] pci 0000:ff:1d.0: [8086:0e68] type 00 class 0x088000
[    5.196450] pci 0000:ff:1d.1: [8086:0e79] type 00 class 0x088000
[    5.203507] pci 0000:ff:1d.2: [8086:0e6a] type 00 class 0x088000
[    5.210559] pci 0000:ff:1d.3: [8086:0e6b] type 00 class 0x088000
[    5.217618] pci 0000:ff:1d.4: [8086:0e6c] type 00 class 0x088000
[    5.224667] pci 0000:ff:1d.5: [8086:0e6d] type 00 class 0x088000
[    5.231717] pci 0000:ff:1e.0: [8086:0ef0] type 00 class 0x088000
[    5.238774] pci 0000:ff:1e.1: [8086:0ef1] type 00 class 0x088000
[    5.245829] pci 0000:ff:1e.2: [8086:0ef2] type 00 class 0x088000
[    5.252883] pci 0000:ff:1e.3: [8086:0ef3] type 00 class 0x088000
[    5.259938] pci 0000:ff:1e.4: [8086:0ef4] type 00 class 0x088000
[    5.266994] pci 0000:ff:1e.5: [8086:0ef5] type 00 class 0x088000
[    5.274049] pci 0000:ff:1e.6: [8086:0ef6] type 00 class 0x088000
[    5.281101] pci 0000:ff:1e.7: [8086:0ef7] type 00 class 0x088000
[    5.288155] pci 0000:ff:1f.0: [8086:0e98] type 00 class 0x088000
[    5.295209] pci 0000:ff:1f.1: [8086:0e99] type 00 class 0x088000
[    5.302262] pci 0000:ff:1f.2: [8086:0e9a] type 00 class 0x088000
[    5.309317] pci 0000:ff:1f.3: [8086:0e9b] type 00 class 0x088000
[    5.316519] ACPI: Enabled 5 GPEs in block 00 to 3F
[    5.322591] vgaarb: setting as boot device: PCI:0000:0b:00.0
[    5.329223] vgaarb: device added: PCI:0000:0b:00.0,decodes=io+mem,owns=io+mem,locks=none
[    5.338909] vgaarb: loaded
[    5.342227] vgaarb: bridge control possible 0000:0b:00.0
[    5.348828] SCSI subsystem initialized
[    5.353343] libata version 3.00 loaded.
[    5.357978] ACPI: bus type USB registered
[    5.362786] usbcore: registered new interface driver usbfs
[    5.369232] usbcore: registered new interface driver hub
[    5.375970] usbcore: registered new device driver usb
[    5.382860] PCI: Using ACPI for IRQ routing
[    5.394564] PCI: pci_cache_line_size set to 64 bytes
[    5.401096] e820: reserve RAM buffer [mem 0x0009bc00-0x0009ffff]
[    5.408111] e820: reserve RAM buffer [mem 0xba763000-0xbbffffff]
[    5.415708] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    5.423716] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    5.432890] clocksource: Switched to clocksource hpet
[    5.457827] pnp: PnP ACPI init
[    5.461988] system 00:00: [io  0x0680-0x069f] has been reserved
[    5.468915] system 00:00: [io  0xffff] has been reserved
[    5.475152] system 00:00: [io  0xffff] has been reserved
[    5.481392] system 00:00: [io  0xffff] has been reserved
[    5.487631] system 00:00: [io  0x0400-0x0453] could not be reserved
[    5.494931] system 00:00: [io  0x0458-0x047f] has been reserved
[    5.501849] system 00:00: [io  0x0500-0x057f] has been reserved
[    5.508766] system 00:00: [io  0x164e-0x164f] has been reserved
[    5.515688] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.523640] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.531443] system 00:02: [io  0x0454-0x0457] has been reserved
[    5.538374] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    5.547640] pnp 00:03: [dma 0 disabled]
[    5.552327] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.560181] pnp 00:04: [dma 0 disabled]
[    5.564853] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.573236] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    5.580946] system 00:05: [mem 0xebfff000-0xebffffff] has been reserved
[    5.588644] system 00:05: [mem 0xc0000000-0xcfffffff] has been reserved
[    5.596341] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    5.604035] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    5.611731] system 00:05: [mem 0xff000000-0xffffffff] could not be reserved
[    5.619815] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    5.627899] system 00:05: [mem 0xfec00000-0xfecfffff] could not be reserved
[    5.635985] system 00:05: [mem 0xd0d70000-0xd0d70fff] has been reserved
[    5.643679] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.651820] system 00:06: [mem 0xebffc000-0xebffdfff] could not be reserved
[    5.659912] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.668275] system 00:07: [mem 0xfbffe000-0xfbffffff] could not be reserved
[    5.676369] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.684444] system 00:08: [mem 0x00000000-0x0009cfff] could not be reserved
[    5.692537] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    5.700973] pnp: PnP ACPI: found 9 devices
[    5.713729] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    5.724319] pci 0000:02:08.0: PCI bridge to [bus 03]
[    5.730191] pci 0000:02:08.0:   bridge window [io  0x3000-0x3fff]
[    5.737332] pci 0000:02:08.0:   bridge window [mem 0xd0b00000-0xd0bfffff]
[    5.745245] pci 0000:02:08.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    5.754438] pci 0000:01:00.0: PCI bridge to [bus 02-03]
[    5.760598] pci 0000:01:00.0:   bridge window [io  0x3000-0x3fff]
[    5.767732] pci 0000:01:00.0:   bridge window [mem 0xd0b00000-0xd0bfffff]
[    5.775668] pci 0000:01:00.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    5.784862] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    5.791004] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    5.798118] pci 0000:00:01.0:   bridge window [mem 0xd0b00000-0xd0cfffff]
[    5.806011] pci 0000:00:01.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    5.815184] pci 0000:00:01.1: PCI bridge to [bus 04]
[    5.821042] pci 0000:00:02.0: PCI bridge to [bus 05]
[    5.826900] pci 0000:00:02.2: PCI bridge to [bus 06]
[    5.832757] pci 0000:00:03.0: PCI bridge to [bus 07]
[    5.838623] pci 0000:00:03.2: PCI bridge to [bus 08]
[    5.844482] pci 0000:00:1c.0: PCI bridge to [bus 09-0a]
[    5.850623] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    5.857736] pci 0000:00:1c.0:   bridge window [mem 0xd0900000-0xd0afffff]
[    5.865633] pci 0000:00:1c.7: PCI bridge to [bus 0b]
[    5.871485] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
[    5.879377] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
[    5.888557] pci 0000:00:1e.0: PCI bridge to [bus 0c]
[    5.894419] pci_bus 0000:00: resource 4 [io  0x0000-0xbfff window]
[    5.906537] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff window]
[    5.914522] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff window]
[    5.922509] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff window]
[    5.930496] pci_bus 0000:00: resource 8 [mem 0x000c8000-0x000cbfff window]
[    5.938482] pci_bus 0000:00: resource 9 [mem 0x000cc000-0x000cffff window]
[    5.946468] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff window]
[    5.954549] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff window]
[    5.962631] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff window]
[    5.970715] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff window]
[    5.978800] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff window]
[    5.986887] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff window]
[    5.994970] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff window]
[    6.003051] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff window]
[    6.011133] pci_bus 0000:00: resource 18 [mem 0x000f0000-0x000fffff window]
[    6.019215] pci_bus 0000:00: resource 19 [mem 0xd0000000-0xebffffff window]
[    6.027298] pci_bus 0000:00: resource 20 [mem 0x380000000000-0x38007fffffff window]
[    6.036371] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    6.042896] pci_bus 0000:01: resource 1 [mem 0xd0b00000-0xd0cfffff]
[    6.050201] pci_bus 0000:01: resource 2 [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.058789] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    6.065308] pci_bus 0000:02: resource 1 [mem 0xd0b00000-0xd0bfffff]
[    6.072614] pci_bus 0000:02: resource 2 [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.081198] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    6.087727] pci_bus 0000:03: resource 1 [mem 0xd0b00000-0xd0bfffff]
[    6.095032] pci_bus 0000:03: resource 2 [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.103621] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
[    6.110149] pci_bus 0000:09: resource 1 [mem 0xd0900000-0xd0afffff]
[    6.117453] pci_bus 0000:0b: resource 1 [mem 0xd0000000-0xd08fffff]
[    6.124758] pci_bus 0000:0b: resource 2 [mem 0xea000000-0xeaffffff 64bit pref]
[    6.133346] pci_bus 0000:0c: resource 4 [io  0x0000-0xbfff window]
[    6.140547] pci_bus 0000:0c: resource 5 [mem 0x000a0000-0x000bffff window]
[    6.148534] pci_bus 0000:0c: resource 6 [mem 0x000c0000-0x000c3fff window]
[    6.156520] pci_bus 0000:0c: resource 7 [mem 0x000c4000-0x000c7fff window]
[    6.164506] pci_bus 0000:0c: resource 8 [mem 0x000c8000-0x000cbfff window]
[    6.172494] pci_bus 0000:0c: resource 9 [mem 0x000cc000-0x000cffff window]
[    6.180478] pci_bus 0000:0c: resource 10 [mem 0x000d0000-0x000d3fff window]
[    6.188565] pci_bus 0000:0c: resource 11 [mem 0x000d4000-0x000d7fff window]
[    6.196651] pci_bus 0000:0c: resource 12 [mem 0x000d8000-0x000dbfff window]
[    6.204734] pci_bus 0000:0c: resource 13 [mem 0x000dc000-0x000dffff window]
[    6.212817] pci_bus 0000:0c: resource 14 [mem 0x000e0000-0x000e3fff window]
[    6.220899] pci_bus 0000:0c: resource 15 [mem 0x000e4000-0x000e7fff window]
[    6.228983] pci_bus 0000:0c: resource 16 [mem 0x000e8000-0x000ebfff window]
[    6.237067] pci_bus 0000:0c: resource 17 [mem 0x000ec000-0x000effff window]
[    6.245151] pci_bus 0000:0c: resource 18 [mem 0x000f0000-0x000fffff window]
[    6.253235] pci_bus 0000:0c: resource 19 [mem 0xd0000000-0xebffffff window]
[    6.261317] pci_bus 0000:0c: resource 20 [mem 0x380000000000-0x38007fffffff window]
[    6.270405] pci 0000:80:02.0: PCI bridge to [bus 81-82]
[    6.276547] pci 0000:80:02.0:   bridge window [io  0xc000-0xcfff]
[    6.283652] pci 0000:80:02.0:   bridge window [mem 0xec000000-0xec4fffff]
[    6.291543] pci 0000:80:02.0:   bridge window [mem 0xfbb00000-0xfbefffff 64bit pref]
[    6.300719] pci_bus 0000:80: resource 4 [io  0xc000-0xffff window]
[    6.307927] pci_bus 0000:80: resource 5 [mem 0xec000000-0xfbffffff window]
[    6.315916] pci_bus 0000:80: resource 6 [mem 0x380080000000-0x3800ffffffff window]
[    6.324897] pci_bus 0000:81: resource 0 [io  0xc000-0xcfff]
[    6.331426] pci_bus 0000:81: resource 1 [mem 0xec000000-0xec4fffff]
[    6.338734] pci_bus 0000:81: resource 2 [mem 0xfbb00000-0xfbefffff 64bit pref]
[    6.347853] NET: Registered protocol family 2
[    6.355143] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    6.365630] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    6.373720] TCP: Hash tables configured (established 524288 bind 65536)
[    6.381683] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    6.389441] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    6.399054] NET: Registered protocol family 1
[    6.446427] pci 0000:0b:00.0: Video device with shadowed ROM
[    6.453540] PCI: CLS 64 bytes, default 64
[    6.458479] Unpacking initramfs...
[    7.987210] Freeing initrd memory: 47084K (ffff88007d204000 - ffff88007ffff000)
[    7.996224] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.003734] software IO TLB [mem 0xb6763000-0xba763000] (64MB) mapped at [ffff8800b6763000-ffff8800ba762fff]
[    8.015915] RAPL PMU detected, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    8.026065] hw unit of domain pp0-core 2^-16 Joules
[    8.031815] hw unit of domain package 2^-16 Joules
[    8.037468] hw unit of domain dram 2^-16 Joules
[    8.057083] microcode: CPU0 sig=0x306e4, pf=0x1, revision=0x428
[    8.063985] microcode: CPU1 sig=0x306e4, pf=0x1, revision=0x428
[    8.070904] microcode: CPU2 sig=0x306e4, pf=0x1, revision=0x428
[    8.077822] microcode: CPU3 sig=0x306e4, pf=0x1, revision=0x428
[    8.084731] microcode: CPU4 sig=0x306e4, pf=0x1, revision=0x428
[    8.091648] microcode: CPU5 sig=0x306e4, pf=0x1, revision=0x428
[    8.098563] microcode: CPU6 sig=0x306e4, pf=0x1, revision=0x428
[    8.105478] microcode: CPU7 sig=0x306e4, pf=0x1, revision=0x428
[    8.112392] microcode: CPU8 sig=0x306e4, pf=0x1, revision=0x428
[    8.119309] microcode: CPU9 sig=0x306e4, pf=0x1, revision=0x428
[    8.126223] microcode: CPU10 sig=0x306e4, pf=0x1, revision=0x428
[    8.133234] microcode: CPU11 sig=0x306e4, pf=0x1, revision=0x428
[    8.140247] microcode: CPU12 sig=0x306e4, pf=0x1, revision=0x428
[    8.147261] microcode: CPU13 sig=0x306e4, pf=0x1, revision=0x428
[    8.154288] microcode: CPU14 sig=0x306e4, pf=0x1, revision=0x428
[    8.161313] microcode: CPU15 sig=0x306e4, pf=0x1, revision=0x428
[    8.168339] microcode: CPU16 sig=0x306e4, pf=0x1, revision=0x428
[    8.175366] microcode: CPU17 sig=0x306e4, pf=0x1, revision=0x428
[    8.182393] microcode: CPU18 sig=0x306e4, pf=0x1, revision=0x428
[    8.189419] microcode: CPU19 sig=0x306e4, pf=0x1, revision=0x428
[    8.196446] microcode: CPU20 sig=0x306e4, pf=0x1, revision=0x428
[    8.203469] microcode: CPU21 sig=0x306e4, pf=0x1, revision=0x428
[    8.210495] microcode: CPU22 sig=0x306e4, pf=0x1, revision=0x428
[    8.217520] microcode: CPU23 sig=0x306e4, pf=0x1, revision=0x428
[    8.224543] microcode: CPU24 sig=0x306e4, pf=0x1, revision=0x428
[    8.231553] microcode: CPU25 sig=0x306e4, pf=0x1, revision=0x428
[    8.238573] microcode: CPU26 sig=0x306e4, pf=0x1, revision=0x428
[    8.245587] microcode: CPU27 sig=0x306e4, pf=0x1, revision=0x428
[    8.252600] microcode: CPU28 sig=0x306e4, pf=0x1, revision=0x428
[    8.259613] microcode: CPU29 sig=0x306e4, pf=0x1, revision=0x428
[    8.266625] microcode: CPU30 sig=0x306e4, pf=0x1, revision=0x428
[    8.273638] microcode: CPU31 sig=0x306e4, pf=0x1, revision=0x428
[    8.280649] microcode: CPU32 sig=0x306e4, pf=0x1, revision=0x428
[    8.287660] microcode: CPU33 sig=0x306e4, pf=0x1, revision=0x428
[    8.294670] microcode: CPU34 sig=0x306e4, pf=0x1, revision=0x428
[    8.301680] microcode: CPU35 sig=0x306e4, pf=0x1, revision=0x428
[    8.308694] microcode: CPU36 sig=0x306e4, pf=0x1, revision=0x428
[    8.315723] microcode: CPU37 sig=0x306e4, pf=0x1, revision=0x428
[    8.322744] microcode: CPU38 sig=0x306e4, pf=0x1, revision=0x428
[    8.329769] microcode: CPU39 sig=0x306e4, pf=0x1, revision=0x428
[    8.336794] microcode: CPU40 sig=0x306e4, pf=0x1, revision=0x428
[    8.343819] microcode: CPU41 sig=0x306e4, pf=0x1, revision=0x428
[    8.350840] microcode: CPU42 sig=0x306e4, pf=0x1, revision=0x428
[    8.357860] microcode: CPU43 sig=0x306e4, pf=0x1, revision=0x428
[    8.364883] microcode: CPU44 sig=0x306e4, pf=0x1, revision=0x428
[    8.371906] microcode: CPU45 sig=0x306e4, pf=0x1, revision=0x428
[    8.378930] microcode: CPU46 sig=0x306e4, pf=0x1, revision=0x428
[    8.385955] microcode: CPU47 sig=0x306e4, pf=0x1, revision=0x428
[    8.393121] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    8.414248] futex hash table entries: 65536 (order: 10, 4194304 bytes)
[    8.423146] audit: initializing netlink subsys (disabled)
[    8.429534] audit: type=2000 audit(1443252643.536:1): initialized
[    8.438175] Initialise system trusted keyring
[    8.443742] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.454028] zbud: loaded
[    8.457820] VFS: Disk quotas dquot_6.6.0
[    8.462906] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    8.472768] Key type big_key registered
[    8.477366] SELinux:  Registering netfilter hooks
[    8.492454] NET: Registered protocol family 38
[    8.497745] Key type asymmetric registered
[    8.502629] Asymmetric key parser 'x509' registered
[    8.508500] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    8.517709] io scheduler noop registered
[    8.522405] io scheduler deadline registered
[    8.527623] io scheduler cfq registered (default)
[    8.539030] aer 0000:00:01.0:pcie02: service driver aer loaded
[    8.545943] aer 0000:00:01.1:pcie02: service driver aer loaded
[    8.552818] aer 0000:00:02.0:pcie02: service driver aer loaded
[    8.559693] aer 0000:00:02.2:pcie02: service driver aer loaded
[    8.566568] aer 0000:00:03.0:pcie02: service driver aer loaded
[    8.573437] aer 0000:00:03.2:pcie02: service driver aer loaded
[    8.580311] aer 0000:80:02.0:pcie02: service driver aer loaded
[    8.587165] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    8.595252] pcieport 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    8.603338] pcieport 0000:02:08.0: Signaling PME through PCIe PME interrupt
[    8.611424] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    8.619022] pci 0000:03:00.3: Signaling PME through PCIe PME interrupt
[    8.626621] pci 0000:03:00.4: Signaling PME through PCIe PME interrupt
[    8.634222] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    8.642026] pcieport 0000:00:01.1: Signaling PME through PCIe PME interrupt
[    8.650115] pcie_pme 0000:00:01.1:pcie01: service driver pcie_pme loaded
[    8.657922] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    8.666007] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    8.673813] pcieport 0000:00:02.2: Signaling PME through PCIe PME interrupt
[    8.681902] pcie_pme 0000:00:02.2:pcie01: service driver pcie_pme loaded
[    8.689705] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    8.697796] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    8.705607] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[    8.713695] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[    8.721525] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    8.729612] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    8.742100] pci 0000:09:00.1: Signaling PME through PCIe PME interrupt
[    8.749696] pci 0000:09:00.2: Signaling PME through PCIe PME interrupt
[    8.757297] pci 0000:09:00.3: Signaling PME through PCIe PME interrupt
[    8.764897] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    8.772728] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    8.780816] pci 0000:0b:00.0: Signaling PME through PCIe PME interrupt
[    8.788418] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    8.796224] pcieport 0000:80:02.0: Signaling PME through PCIe PME interrupt
[    8.804312] pci 0000:81:00.0: Signaling PME through PCIe PME interrupt
[    8.811909] pci 0000:81:00.1: Signaling PME through PCIe PME interrupt
[    8.819513] pcie_pme 0000:80:02.0:pcie01: service driver pcie_pme loaded
[    8.827309] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.833853] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    8.841628] intel_idle: MWAIT substates: 0x1120
[    8.846992] intel_idle: v0.4 model 0x3E
[    8.851575] intel_idle: lapic_timer_reliable_states 0xffffffff
[    8.859953] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    8.868719] ACPI: Power Button [PWRF]
[    8.920571] GHES: HEST is not enabled!
[    8.925100] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    8.953104] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    8.982522] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    8.991817] Non-volatile memory driver v1.3
[    8.996838] Linux agpgart interface v0.103
[    9.005943] ahci 0000:00:1f.2: version 3.0
[    9.011056] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
[    9.015209] tsc: Refined TSC clocksource calibration: 2693.509 MHz
[    9.015213] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x26d34aa491a, max_idle_ns: 440795256568 ns
[    9.039432] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    9.050766] scsi host0: ahci
[    9.054494] scsi host1: ahci
[    9.058233] scsi host2: ahci
[    9.061954] scsi host3: ahci
[    9.065691] scsi host4: ahci
[    9.069421] scsi host5: ahci
[    9.072944] ata1: SATA max UDMA/133 abar m2048@0xd0d00000 port 0xd0d00100 irq 34
[    9.081690] ata2: SATA max UDMA/133 abar m2048@0xd0d00000 port 0xd0d00180 irq 34
[    9.090435] ata3: DUMMY
[    9.093438] ata4: DUMMY
[    9.096442] ata5: DUMMY
[    9.099446] ata6: DUMMY
[    9.102977] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.110596] ehci-pci: EHCI PCI platform driver
[    9.116250] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    9.122480] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    9.131231] ehci-pci 0000:00:1a.0: debug port 2
[    9.140473] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    9.148354] ehci-pci 0000:00:1a.0: irq 16, io mem 0xd0d20000
[    9.160106] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    9.166851] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.174717] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.183269] usb usb1: Product: EHCI Host Controller
[    9.188995] usb usb1: Manufacturer: Linux 4.3.0-rc2+ ehci_hcd
[    9.195692] usb usb1: SerialNumber: 0000:00:1a.0
[    9.201306] hub 1-0:1.0: USB hub found
[    9.205780] hub 1-0:1.0: 2 ports detected
[    9.210810] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    9.217034] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    9.225792] ehci-pci 0000:00:1d.0: debug port 2
[    9.235032] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    9.242911] ehci-pci 0000:00:1d.0: irq 23, io mem 0xd0d10000
[    9.255060] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    9.261794] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    9.269660] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.278211] usb usb2: Product: EHCI Host Controller
[    9.283935] usb usb2: Manufacturer: Linux 4.3.0-rc2+ ehci_hcd
[    9.290632] usb usb2: SerialNumber: 0000:00:1d.0
[    9.296260] hub 2-0:1.0: USB hub found
[    9.300722] hub 2-0:1.0: 2 ports detected
[    9.305695] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.312934] ohci-pci: OHCI PCI platform driver
[    9.318257] uhci_hcd: USB Universal Host Controller Interface driver
[    9.325787] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    9.407036] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    9.414314] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.421738] ata1.00: ATA-8: WDC WD1002FAEX-00Y9A0, 05.01D05, max UDMA/133
[    9.429644] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    9.438269] ata2.00: ATAPI: ATAPI   iHAS124   W, HL04, max UDMA/100
[    9.446802] ata1.00: configured for UDMA/133
[    9.451915] ata2.00: configured for UDMA/100
[    9.453575] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
[    9.454333] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.454416] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    9.454633] sd 0:0:0:0: [sda] Write Protect is off
[    9.454635] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.454819] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.466775]  sda: sda1
[    9.467574] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.511984] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    9.522103] scsi 1:0:0:0: CD-ROM            ATAPI    iHAS124   W      HL04 PQ: 0 ANSI: 5
[    9.606947] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    9.630366] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    9.638145] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.646668] hub 1-1:1.0: USB hub found
[    9.651269] hub 1-1:1.0: 6 ports detected
[    9.729328] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    9.737106] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.745621] hub 2-1:1.0: USB hub found
[    9.750224] hub 2-1:1.0: 8 ports detected
[    9.849861] i8042: Can't read CTR while initializing i8042
[    9.856334] i8042: probe of i8042 failed with error -5
[    9.862514] mousedev: PS/2 mouse device common for all mice
[    9.865094] sr 1:0:0:0: [sr0] scsi3-mmc drive: 188x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[    9.865096] cdrom: Uniform CD-ROM driver Revision: 3.20
[    9.865344] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    9.865490] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    9.897589] rtc_cmos 00:01: RTC can wake from S4
[    9.903299] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    9.910462] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    9.919699] device-mapper: uevent: version 1.0.3
[    9.925350] device-mapper: ioctl: 4.33.0-ioctl (2015-8-18) initialised: dm-devel@redhat.com
[    9.935420] Intel P-state driver initializing.
[    9.944493] hidraw: raw HID events driver (C) Jiri Kosina
[    9.951014] usbcore: registered new interface driver usbhid
[    9.957549] usbhid: USB HID core driver
[    9.962632] drop_monitor: Initializing network drop monitor service
[    9.970505] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.976755] Initializing XFRM netlink socket
[    9.981840] NET: Registered protocol family 17
[    9.989513] AVX version of gcm_enc/dec engaged.
[    9.994887] AES CTR mode by8 optimization enabled
[   10.026622] clocksource: Switched to clocksource tsc
[   10.029714] usb 2-1.4: new full-speed USB device number 3 using ehci-pci
[   10.039069] registered taskstats version 1
[   10.039079] Loading compiled-in X.509 certificates
[   10.039955] Loaded X.509 cert 'Build time autogenerated kernel key: cd28390833b39dce97e6aa142acc02320d77becd'
[   10.040027] zswap: loaded using pool lzo/zbud
[   10.041933]   Magic number: 15:191:522
[   10.042084] acpi device:116: hash matches
[   10.045074] rtc_cmos 00:01: setting system clock to 2015-09-26 07:30:51 UTC (1443252651)
[   10.045148] PM: Hibernation image not present or could not be loaded.
[   10.094473] Freeing unused kernel memory: 1408K (ffffffff81d26000 - ffffffff81e86000)
[   10.103740] Write protecting the kernel read-only data: 12288k
[   10.111305] Freeing unused kernel memory: 1308K (ffff8800016b9000 - ffff880001800000)
[   10.121025] Freeing unused kernel memory: 1016K (ffff880001b02000 - ffff880001c00000)
[   10.131421] usb 2-1.4: New USB device found, idVendor=046b, idProduct=ff10
[   10.139390] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   10.148045] usb 2-1.4: Product: Virtual Keyboard and Mouse
[   10.149367] random: systemd urandom read with 17 bits of entropy available
[   10.162425] usb 2-1.4: Manufacturer: American Megatrends Inc.
[   10.162426] usb 2-1.4: SerialNumber: serial
[   10.163721] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:046B:FF10.0001/input/input1
[   10.192154] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[   10.213635] systemd[1]: Detected architecture x86-64.
[   10.214689] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
[   10.215524] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:046B:FF10.0002/input/input2
[   10.215636] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
[   10.275787] systemd[1]: Running in initial RAM disk.

Welcome to [0[   10.281666] systemd[1]: No hostname configured.
;34mFedora 22 (T[   10.288576] systemd[1]: Set hostname to <localhost>.
wenty Two) dracu[   10.288589] usb 2-1.8: new full-speed USB device number 4 using ehci-pci
t-041-14.fc22 (I[   10.304729] systemd[1]: Initializing machine ID from random generator.
nitramfs)[0m!

[[32m  OK  [0m[   10.343927] systemd[1]: Created slice -.slice.
] Created slice [   10.350751] systemd[1]: Starting -.slice.
-.slice.
[   10.356813] systemd[1]: Listening on Journal Socket.
[[32m  OK  [0m[   10.363292] systemd[1]: Starting Journal Socket.
] Listening on J[   10.370016] systemd[1]: Listening on udev Kernel Socket.
ournal Socket.
[   10.377478] systemd[1]: Starting udev Kernel Socket.
[[32m  OK  [0m[   10.378685] usb 2-1.8: New USB device found, idVendor=9999, idProduct=0120
] Listening on u[   10.378686] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
dev Kernel Socke[   10.378687] usb 2-1.8: Product: CAT5 Adapter
t.
[   10.378688] usb 2-1.8: Manufacturer: Generic
[   10.378689] usb 2-1.8: SerialNumber: 000013f221ef
[   10.381118] input: Generic CAT5 Adapter as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8:1.0/0003:9999:0120.0003/input/input3
[   10.431622] hid-generic 0003:9999:0120.0003: input,hidraw2: USB HID v1.00 Keyboard [Generic CAT5 Adapter] on usb-0000:00:1d.0-1.8/input0
[   10.433693] input: Generic CAT5 Adapter as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8:1.1/0003:9999:0120.0004/input/input4
[   10.433808] hid-generic 0003:9999:0120.0004: input,hidraw3: USB HID v1.00 Mouse [Generic CAT5 Adapter] on usb-0000:00:1d.0-1.8/input1
[[32m  OK  [0m[   10.476369] systemd[1]: Reached target Swap.
] Reached target[   10.482992] systemd[1]: Starting Swap.
 Swap.
[   10.488807] systemd[1]: Listening on Journal Audit Socket.
[[32m  OK  [0m[   10.495646] systemd[1]: Starting Journal Audit Socket.
] Listening on J[   10.503020] systemd[1]: Created slice System Slice.
ournal Audit Soc[   10.509921] systemd[1]: Starting System Slice.
ket.
[[32m  OK[   10.516884] systemd[1]: Starting Create list of required static device nodes for the current kernel...
  [0m] Created [   10.528636] systemd[1]: Started Device-Mapper Multipath Device Controller.
slice System Sli[   10.537638] systemd[1]: Reached target Slices.
ce.
         St[   10.544144] systemd[1]: Starting Slices.
arting Create li[   10.550188] systemd[1]: Started Load Kernel Modules.
st of required s[   10.557257] systemd[1]: Listening on Journal Socket (/dev/log).
t... nodes for t[   10.565397] systemd[1]: Starting Journal Socket (/dev/log).
he current kerne[   10.573570] systemd[1]: Starting Journal Service...
l...
[[32m  OK[   10.580244] systemd[1]: Reached target Timers.
  [0m] Reached [   10.586751] systemd[1]: Starting Timers.
target Slices.
[   10.592714] systemd[1]: Reached target Local File Systems.
[[32m  OK  [0m[   10.600398] systemd[1]: Starting Local File Systems.
] Listening on J[   10.607546] systemd[1]: Started dracut ask for additional cmdline parameters.
ournal Socket (/[   10.617547] systemd[1]: Starting dracut cmdline hook...
dev/log).
     [   10.624508] systemd[1]: Listening on udev Control Socket.
    Starting Jou[   10.632055] systemd[1]: Starting udev Control Socket.
rnal Service...
[   10.639272] systemd[1]: Reached target Sockets.

[[32m  OK  [0[   10.645884] systemd[1]: Starting Sockets.
m] Reached targe[   10.652336] systemd[1]: Starting Setup Virtual Console...
t Timers.
[[32[   10.660030] systemd[1]: Starting Apply Kernel Variables...
m  OK  [0m] Rea[   10.667255] systemd[1]: Reached target Encrypted Volumes.
ched target Loca[   10.674832] systemd[1]: Starting Encrypted Volumes.
l File Systems.
[   10.682164] systemd[1]: Started Journal Service.

         Starti[   10.688676] audit: type=1130 audit(1443252652.145:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
ng dracut cmdlin[   10.713544] audit: type=1130 audit(1443252652.170:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
e hook...
[[32[   10.737867] audit: type=1130 audit(1443252652.194:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
m  OK  [0m] Lis[   10.762713] audit: type=1130 audit(1443252652.219:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
tening on udev Control Socket.
[[32m  OK  [0m] Reached target Sockets.
         Starting Setup Virtual Conso[   10.795752] audit: type=1130 audit(1443252652.252:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
le...
         [   10.821978] audit: type=1130 audit(1443252652.278:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
Starting Apply Kernel Variables...
[[32m  OK  [0m] Reached target Encrypted Volumes.
[[32m  OK  [0m] Started Journal Service.
[[32m  OK  [0m] Started Create list of required sta...ce nodes for the current kernel.
[[32m  OK  [0m] Started Setup Virtual Console.
[[32m  OK  [0m] Started Apply Kernel Variables.
         Starting Create Static Device Nodes in /dev...
[[32m  OK  [0m] Started Create Static Device Nodes in /dev.
[[32m  OK  [0m] Started dracut cmdline hook.
         Starting dracut pre-udev hook...
[   10.981844] RPC: Registered named UNIX socket transport module.
[   10.988759] RPC: Registered udp transport module.
[   10.994309] RPC: Registered tcp transport module.
[   10.999854] RPC: Registered tcp NFSv4.1 backchannel transport module.
[[32m  OK  [0m[   11.124116] audit: type=1130 audit(1443252652.580:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-udev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[[32m  OK  [0m[   11.159487] audit: type=1130 audit(1443252652.616:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
] Started udev Kernel Device Manager.
         Starting dracut pre-trigger hook...
[[32m  OK  [0m[   11.319703] audit: type=1130 audit(1443252652.776:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=console res=success'
] Started dracut pre-trigger hook.
         Starting udev Coldplug all Devices...
         Mounting Configuration File System...
[[32m  OK  [0m] Mounted Configuration File System.
[[32m  OK  [0m] Started udev Coldplug all Devices.
         Starting Show Plymouth Boot Screen...
[[32m  OK  [0m] Reached target System Initialization.
         Starting dracut initqueue hook...
[[32m  OK  [0m] Started dracut initqueue hook.
[[32m  OK  [0m] Reached target Remote File Systems (Pre).
[[32m  OK  [0m] Reached target Remote File Systems.
         Starting dracut pre-mount hook...
[[32m  OK  [0m] Started dracut pre-mount hook.
%G[[32m  OK  [0m] Found device WDC_WD1002FAEX-00Y9A0 root.
         Starting File System Check on /dev/sda1...
[[32m  OK  [0m] Started Show Plymouth Boot Screen.
[[32m  OK  [0m] Reached target Paths.
[[32m  OK  [0m] Reached target Basic System.
[[32m  OK  [0m] Started File System Check on /dev/sda1.
         Mounting /sysroot...
[   11.641197] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[[32m  OK  [0m] Mounted /sysroot.
[[32m  OK  [0m] Reached target Initrd Root File System.
         Starting Reload Configuration from the Real Root...
[[32m  OK  [0m] Started Reload Configuration from the Real Root.
[[32m  OK  [0m] Reached target Initrd File Systems.
[[32m  OK  [0m] Reached target Initrd Default Target.
         Starting dracut pre-pivot and cleanup hook...
[[32m  OK  [0m] Started dracut pre-pivot and cleanup hook.
         Starting Cleaning Up and Shutting Down Daemons...
[[32m  OK  [0m] Stopped target Timers.
         Starting Plymouth switch root service...
[[32m  OK  [0m] Sto[   11.972329] random: nonblocking pool is initialized
pped Cleaning Up and Shutting Down Daemons.
[[32m  OK  [0m] Stopped dracut pre-pivot and cleanup hook.
         Stopping dracut pre-pivot and cleanup hook...
[[32m  OK  [0m] Stopped target Remote File Systems.
[[32m  OK  [0m] Stopped target Remote File Systems (Pre).
[[32m  OK  [0m] Stopped dracut pre-mount hook.
         Stopping dracut pre-mount hook...
[[32m  OK  [0m] Stopped dracut initqueue hook.
         Stopping dracut initqueue hook...
[[32m  OK  [0m] Stopped target Initrd Default Target.
[[32m  OK  [0m] Stopped target Basic System.
[[32m  OK  [0m] Stopped target Paths.
[[32m  OK  [0m] Stopped target Slices.
[[32m  OK  [0m] St[   12.047219] systemd-journald[525]: Received SIGTERM from PID 1 (systemd).
opped target Sockets.
[[32m  OK  [0m] Stopped target System Initialization.
[[32m  OK  [0m] Stopped target Swap.
[[32m  OK  [0m] Stopped target Encrypted Volumes.
[[32m  OK  [0m] Stopped udev Coldplug all Devices.
         Stopping udev Coldplug all Devices...
[[32m  OK  [0m] Stopped dracut pre-trigger hook.
         Stopping dracut pre-trigger hook...
         Stopping udev Kernel Device Manager...
[[32m  OK  [0m] Stopped target Local File Systems.
[[32m  OK  [0m] Stopped Apply Kernel Variables.
         Stopping Apply Kernel Variables...
[[32m  OK  [0m] Stopped udev Kernel Device Manager.
[[32m  OK  [0m] Stopped dracut pre-udev hook.
         Stopping dracut pre-udev hook...
[[32m  OK  [0m] Stopped dracut cmdline hook.
         Stopping dracut cmdline hook...
[[32m  OK  [0m] Stopped Create Static Device Nodes in /dev.
         Stopping Create Static Device Nodes in /dev...
[[32m  OK  [0m] Stopped Create list of required sta...ce nodes for the current kernel.
         Stopping Create list of required st... nodes for the current kernel...
[[32m  OK  [0m] Closed udev Control Socket.
[[32m  OK  [0m] Closed udev Kernel Socket.
         Starting Cleanup udevd DB...
[[32m  OK  [0m] Started Plymouth switch root service.
[[32m  OK  [0m] Started Cleanup udevd DB.
[[32m  OK  [0m] Reached target Switch Root.
         Starting Switch Root...
[   12.478765] SELinux:  Disabled at runtime.
[   12.483689] SELinux:  Unregistering netfilter hooks

Welcome to [0;34mFedora 22 (Twenty Two)[0m!

[[32m  OK  [0m] Stopped Switch Root.
[[32m  OK  [0m] Stopped target Switch Root.
[[32m  OK  [0m] Created slice system-serial\x2dgetty.slice.
[[32m  OK  [0m] Listening on Delayed Shutdown Socket.
[[32m  OK  [0m] Created slice User and Session Slice.
         Mounting Debug File System...
         Starting Create list of required st... nodes for the current kernel...
[[32m  OK  [0m] Reached target Encrypted Volumes.
         Mounting Temporary Directory...
[[32m  OK  [0m] Stopped target Initrd File Systems.
         Mounting Huge Pages File System...
[[32m  OK  [0m] Reached target Swap.
[[32m  OK  [0m] Reached target Paths.
[[32m  OK  [0m] Listening on udev Control Socket.
         Mounting POSIX Message Queue File System...
[[32m  OK  [0m] Listening on /dev/initctl Compatibility Named Pipe.
[[32m  OK  [0m] Reached target Slices.
[[32m  OK  [0m] Created slice system-getty.slice.
         Starting Apply Kernel Variables...
[[32m  OK  [0m] Stopped Flush Journal to Persistent Storage.
         Starting Remount Root and Kernel File Systems...
[[32m  OK  [0m] Stopped Journal Service.
         Starting Journal Service...
[[32m  OK  [0m] Stopped target Initrd Root File System.
[[32m  OK  [0m] Listening on udev Kernel Socket.
[[32m  OK  [0m] Set up automount Arbitrary Executab...ats File System Automount Point.
[[32m  OK  [0m] Reached target Remote File Systems.
[[1;31mFAILED[0m] Failed to start Create list of requ...ce nodes for the current kernel.
See "systemctl status kmod-static-nodes.service" for details.
[[32m  OK  [0m] Started Apply Kernel Variables.
[[32m  OK  [0m] Started Journal Service.
[[32m  OK  [0m] Mounted Huge Pages File System.
[[32m  OK  [0m] Mounted POSIX Message Queue File System.
[[32m  OK  [0m] Mounted Debug[   13.155218] EXT4-fs (sda1): re-mounted. Opts: (null)
 File System.
[[32m  OK  [0m] Mounted Temporary Directory.
[[32m  OK  [0m] Started Remount Root and Kernel File Systems.
         Starting udev Coldplug all Devices...
         Starting Flush Journal to Persistent Storage...
         Starting Create Static Device Nodes in /dev...
         Starting Configure read-only root support...
[   13.205098] systemd-journald[964]: Received request to flush runtime journal from PID 1
[[32m  OK  [0m] Started udev Coldplug all Devices.
[[32m  OK  [0m[   13.548777] audit_printk_skb: 144 callbacks suppressed
] Started Create[   13.548779] audit: type=1130 audit(1443252655.006:59): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
 Static Device Nodes in /dev.
         Starting udev Kernel Device Manager...
[[32m  OK  [0m] Reached target Local File Systems (Pre).
[[32m  OK  [0m[   13.734632] audit: type=1130 audit(1443252655.192:60): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=fedora-readonly comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
] Started Configure read-only root support.
         Starting Load/Save Random Seed...
[[32m  OK  [0m] Reached target Local File Systems.
         Starting Import network configuration from initramfs...
         Starting Tell Plymouth To Write Out Runtime Data...
         Starting Restore /run/initramfs on shutdown...
[[32m  OK  [0m] Started Load/Save Random Seed.
[   13.853118] audit: type=1130 audit(1443252655.311:61): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-random-seed comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[[32m  OK  [0m] Started Restore /run/initramfs on shutdown.
[   13.885078] audit: type=1130 audit(1443252655.343:62): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=dracut-shutdown comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[[32m  OK  [0m] Started Tell Plymouth To Write Out Runtime Data.
[   13.949065] audit: type=1130 audit(1443252655.407:63): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   13.971203] audit: type=1131 audit(1443252655.429:64): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[[32m  OK  [0m] Started Import network configuration from initramfs.
[   14.003008] audit: type=1130 audit(1443252655.461:65): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=fedora-import-state comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[[32m  OK  [0m] Started udev Kernel Device Manager.
[   14.687731] audit: type=1130 audit(1443252656.146:66): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[[32m  OK  [0m] Found device /dev/ttyS0.
%G[[32m  OK  [0m] Started Flush Journal to Persistent Storage.
[   16.421912] audit: type=1130 audit(1443252657.881:67): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-journal-flush comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
         Starting Create Volatile Files and Directories...
[[32m  OK  [0m[   16.514203] audit: type=1130 audit(1443252657.973:68): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-tmpfiles-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
] Started Create Volatile Files and Directories.
         Starting Security Auditing Service...
[[32m  OK  [0m] Started Security Auditing Service.
         Starting Update UTMP about System Boot/Shutdown...
[[32m  OK  [0m] Started Update UTMP about System Boot/Shutdown.
[[32m  OK  [0m] Reached target System Initialization.
[[32m  OK  [0m] Listening on D-Bus System Message Bus Socket.
[[32m  OK  [0m] Reached target Sockets.
[[32m  OK  [0m] Reached target Basic System.
         Starting Network Manager...
         Starting Login Service...
         Starting Machine Check Exception Logging Daemon...
[[32m  OK  [0m] Started D-Bus System Message Bus.
         Starting D-Bus System Message Bus...
         Starting Permit User Sessions...
[[32m  OK  [0m] Reached target Timers.
[[32m  OK  [0m] Started Machine Check Exception Logging Daemon.
[[32m  OK  [0m] Started Login Service.
[[32m  OK  [0m] Started Permit User Sessions.
         Starting Terminate Plymouth Boot Screen...
[[32m  OK  [0m] Started Command Scheduler.
         Starting Command Scheduler...
         Starting Wait for Plymouth Boot Screen to Quit...

Fedora release 22 (Twenty Two)
Kernel 4.3.0-rc2+ on an x86_64 (ttyS0)

#
# Artem:
# The machine is booted up, but it is not available over network, because the
# network module cannot be loaded, due to corruptions. Well, many modules can't
# be loaded, may be even all of them are corrupted.
#
ivbep0 login: root
Password: 
Last login: Sat Sep 26 02:31:50 from 192.168.100.1
[root@ivbep0 ~]# modprobe xfs
modprobe: ERROR: magic check fail: 0 instead of b007f457
[root@ivbep0 ~]# hexdump /usr/lib/modules/4.3.0-rc2+/kernel/fs/xfs/xfs.ko 
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
17adc90 0000 0000 0000 0000 0000 0000 0000     
17adc9e
[root@ivbep0 ~]# hexdump /usr/lib/modules/4.3.0-rc2+/kernel/fs/xfs/xfs.ko
/usr/lib/modules/4.3.0-rc2+/kernel/fs/xfs/xfs.ko: data
[root@ivbep0 ~]# 
