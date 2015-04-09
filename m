From: Sasha Levin <sasha.levin@oracle.com>
Subject: ext4: WARNING: CPU: 10 PID: 23340 at fs/block_dev.c
Date: Thu, 09 Apr 2015 10:14:49 -0400
Message-ID: <55268959.6040507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I was running xfstests on the latest -next kernel directed at an ext4 mount,
and saw the following on the generic/019 test:

[40638.238369] run fstests generic/019 at 2015-04-09 08:20:00
[40639.320440] kobject: 'sdd' (ffff8837cd5082b0): kobject_release, parent           (null) (delayed 300)
[40642.328483] kobject: 'sdd' (ffff8837cd5082b0): kobject_cleanup, parent           (null)
[40642.328494] kobject: 'sdd' (ffff8837cd5082b0): calling ktype release
[40642.328520] kobject: 'sdd': free name
[40643.643347] kobject: 'sdd' (ffff88007ade08a8): kobject_uevent_env
[40643.643364] kobject: 'sdd' (ffff88007ade08a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:03.2/0000:50:00.0/host0/target0:2:3/0:2:3:0/block/sdd'
[40643.920368] kobject: 'sdd' (ffff881ff26ee2b0): kobject_add_internal: parent: 'ext4', set: 'ext4'
[40643.920556] EXT4-fs (sdd): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[40673.974468] Aborting journal on device sdd-8.
[40673.974631] Buffer I/O error on dev sdd, logical block 36208640, lost sync page write
[40673.974726] JBD2: Error -5 detected when updating journal superblock for sdd-8.
[40673.975282] Buffer I/O error on dev sdd, logical block 0, lost sync page write
[40673.975373] EXT4-fs error (device sdd): ext4_journal_check_start:56: Detected aborted journal
[40673.975479] EXT4-fs (sdd): Remounting filesystem read-only
[40673.975544] EXT4-fs (sdd): previous I/O error to superblock detected
[40676.771510] kobject: 'sdd' (ffff881ff26ee2b0): kobject_release, parent           (null) (delayed 200)
[40678.771514] kobject: 'sdd' (ffff881ff26ee2b0): kobject_cleanup, parent           (null)
[40678.771524] kobject: 'sdd' (ffff881ff26ee2b0): calling ktype release
[40678.771543] kobject: 'sdd': free name
[40678.771719] ------------[ cut here ]------------
[40678.771736] WARNING: CPU: 10 PID: 23340 at fs/block_dev.c:56 __blkdev_put+0x230/0x680()
[40678.771738] Modules linked in: intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ast ttm drm_kms_helper crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel drm aes_x86_64 lrw glue_helper ablk_helper cryptd joydev i2c_algo_bit syscopyarea sysfillrect sysimgblt ipmi_si sb_edac edac_core ipmi_msghandler ioatdma shpchp lpc_ich mac_hid btrfs xor mlx4_en vxlan raid6_pq hid_generic usbhid hid ixgbe mlx4_core dca megaraid_sas ahci ptp libahci pps_core mdio
[40678.771823] CPU: 10 PID: 23340 Comm: umount Not tainted 4.0.0-rc7-next-20150408+ #6
[40678.771827] Hardware name: Oracle Corporation OVCA X3-2             /ASSY,MOTHERBOARD,1U   , BIOS 17021300 06/19/2012
[40678.771831]  ffffffff82b1baa0 ffff8837ca757cf8 ffffffff82947148 0000000000000000
[40678.771837]  0000000000000000 ffff8837ca757d48 ffffffff8115a04a ffff881fdb310740
[40678.771843]  ffffffff816b1960 ffff881fdb310740 ffff881fdb310580 ffff881fdb310740
[40678.771850] Call Trace:
[40678.771860] dump_stack (lib/dump_stack.c:52)
[40678.771869] warn_slowpath_common (kernel/panic.c:447)
[40678.771874] ? __blkdev_put (fs/block_dev.c:56 fs/block_dev.c:1491)
[40678.771879] warn_slowpath_null (kernel/panic.c:481)
[40678.771884] __blkdev_put (fs/block_dev.c:56 fs/block_dev.c:1491)
[40678.771889] blkdev_put (fs/block_dev.c:1561)
[40678.771909] kill_block_super (fs/super.c:1037 (discriminator 8))
[40678.771914] deactivate_locked_super (fs/super.c:294)
[40678.771918] deactivate_super (fs/super.c:320)
[40678.771926] cleanup_mnt (fs/namespace.c:1035)
[40678.771931] __cleanup_mnt (fs/namespace.c:1043)
[40678.771941] task_work_run (kernel/task_work.c:125 (discriminator 1))
[40678.771950] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2575 kernel/locking/lockdep.c:2622)
[40678.771959] do_notify_resume (include/linux/tracehook.h:190 arch/x86/kernel/signal.c:753)
[40678.771966] int_signal (arch/x86/kernel/entry_64.S:396)
[40678.771970] ---[ end trace 8a666a17111b188a ]---

I've verified that the disk is okay, and tried with a different disk. It also reproduces
every time the test is run.


Thanks,
Sasha
