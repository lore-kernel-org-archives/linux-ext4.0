From: Jeff Moyer <jmoyer@redhat.com>
Subject: xfstests test 049 hangs, warning in ext4_discard_preallocations
Date: Mon, 21 Jan 2013 10:02:41 -0500
Message-ID: <x49r4lezii6.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shaggy <dave.kleikamp@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3AUPCn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 10:02:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In running xfstests on 3.8.0-rc4 with Shaggy's O_DIRECT loop patch set,
test 049 never completes (it's been hung for most of the weekend), and I
get this repeatedly in dmesg:

[234733.925026] ------------[ cut here ]------------
[234733.929725] WARNING: at fs/ext4/mballoc.c:3803 ext4_discard_preallocations+0x371/0x400()
[234733.937883] Hardware name: PowerEdge R715
[234733.941971] Modules linked in: xfs libcrc32c fuse sunrpc binfmt_misc dcdbas kvm_amd kvm microcode serio_raw pcspkr ses enclosure ixgbe dca ptp pps_core mdio k10temp amd64_edac_mod edac_core edac_mce_amd sp5100_tco i2c_piix4 i2c_core sg acpi_power_meter bnx2 sr_mod cdrom sd_mod crc_t10dif usb_storage megaraid_sas mpt2sas scsi_transport_sas raid_class dm_mirror dm_region_hash dm_log dm_mod
[234733.976754] Pid: 55604, comm: fsstress Tainted: G        W    3.8.0-rc4+ #30
[234733.983870] Call Trace:
[234733.986405]  [<ffffffff8106504f>] warn_slowpath_common+0x7f/0xc0
[234733.992485]  [<ffffffff810650aa>] warn_slowpath_null+0x1a/0x20
[234733.998395]  [<ffffffff8125dca1>] ext4_discard_preallocations+0x371/0x400
[234734.005257]  [<ffffffff811df135>] ? fsnotify+0x1d5/0x2f0
[234734.010650]  [<ffffffff81221187>] ext4_release_file+0xa7/0xe0
[234734.016474]  [<ffffffff811a16db>] __fput+0xbb/0x260
[234734.021433]  [<ffffffff811a18ee>] ____fput+0xe/0x10
[234734.026395]  [<ffffffff81085a6f>] task_work_run+0x8f/0xf0
[234734.031875]  [<ffffffff81014af5>] do_notify_resume+0xb5/0xc0
[234734.037612]  [<ffffffff81616592>] int_signal+0x12/0x17
[234734.042828] ---[ end trace 496b2af844fac579 ]---
[234735.045084] EXT4-fs (loop3): uh-oh! used pa while discarding

Note that I was running the tests on a loop device:

# losetup -a
/dev/loop0: [fd00]:3032796 (/root/phro/xfstests-dev/testdev.img)
/dev/loop1: [fd00]:3032797 (/root/phro/xfstests-dev/scratchdev.img)
/dev/loop2: [0701]:12 (/mnt/scratch/test.xfs)
/dev/loop3: [0702]:131 (/mnt/scratch/test/test.ext2)

TEST_DEV is loop0, SCRATCH_DEV is loop1.  I'll try to reproduce on a
regular device.  Has anyone seen anything like this?

Cheers,
Jeff
