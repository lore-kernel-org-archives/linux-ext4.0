From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: bdev_inode_switch_bdi WARN_ON_ONCE on write_inode_now
Date: Mon, 15 Sep 2014 23:24:02 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C8207F@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

After the warning described in
	"mark_buffer_dirty WARN_ON_ONCE on buffer_uptodate"

shutting down the system triggered a different WARN_ON_ONCE,
reporting that write_inode_now failed.

[22138.654946] EXT4-fs (sdu): previous I/O error to superblock detected
[22138.657435] Buffer I/O error on dev sdu, logical block 0, lost sync page write
[22138.660216] EXT4-fs error (device sdu): ext4_put_super:792: Couldn't clean up the journal
[22138.686148] ------------[ cut here ]------------
[22138.688406] WARNING: CPU: 0 PID: 15793 at fs/block_dev.c:67 bdev_inode_switch_bdi+0x81/0x90()
[22138.691568] Modules linked in: ftdi_sio usbserial nfsd nfs_acl exportfs autofs4 rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd sunrpc cpufreq_ondemand pcc_cpufreq dm_mirror dm_region_hash dm_log uinput ipv6 iTCO_wdt iTCO_vendor_support microcode serio_raw pcspkr sb_edac edac_core hpilo hpwdt lpc_ich mfd_core ioatdma dca dm_mod wmi sg tg3 ptp pps_core ext4(E) jbd2(E) mbcache(E) sd_mod(E) crc_t10dif(E) crct10dif_common(E) pata_acpi(E) ata_generic(E) ata_piix(E) hpsa(E) mpt3sas(E) scsi_transport_sas(E) raid_class(E)
[22138.715231] CPU: 0 PID: 15793 Comm: umount Tainted: G        W   EL 3.17.0-rc4+ #3
[22138.718904] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 09/08/2013
[22138.721423]  0000000000000043 ffff8803ea14fda8 ffffffff815a8b3f 0000000000000043
[22138.725253]  0000000000000000 ffff8803ea14fde8 ffffffff8105267c ffffffff8181ca12
[22138.728817]  ffff88042e0f75b8 ffff88042e0f7530 ffffffff81a8d9a0 ffff88042c80d000
[22138.732579] Call Trace:
[22138.733623]  [<ffffffff815a8b3f>] dump_stack+0x49/0x62
[22138.735595]  [<ffffffff8105267c>] warn_slowpath_common+0x8c/0xc0
[22138.737952]  [<ffffffff810526ca>] warn_slowpath_null+0x1a/0x20
[22138.740080]  [<ffffffff811cfcd1>] bdev_inode_switch_bdi+0x81/0x90
[22138.742708]  [<ffffffff811d0fbf>] __blkdev_put+0x7f/0x1c0
[22138.744745]  [<ffffffff815aa519>] ? mutex_unlock+0x9/0x20
[22138.747487]  [<ffffffff811d1156>] blkdev_put+0x56/0x140
[22138.749512]  [<ffffffff8119d4fd>] kill_block_super+0x4d/0x80
[22138.751942]  [<ffffffff8119d804>] deactivate_locked_super+0x54/0x70
[22138.754315]  [<ffffffff8119e05a>] deactivate_super+0x4a/0x70
[22138.756435]  [<ffffffff811b9184>] mntput_no_expire+0x94/0xf0
[22138.759070]  [<ffffffff811bb474>] SyS_umount+0xc4/0x100
[22138.761175]  [<ffffffff815ad152>] system_call_fastpath+0x16/0x1b
[22138.763392] ---[ end trace 72065e1b51c7c1cc ]---

That starts in
SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
...
        retval = do_umount(mnt, flags);
dput_and_out:
        /* we mustn't call path_put() as that would clear mnt_expiry_mark */
        dput(path.dentry);
        mntput_no_expire(mnt);
out:
        return retval;

and hits the warning in that mntput_no_expire call:
static void bdev_inode_switch_bdi(struct inode *inode,
                        struct backing_dev_info *dst)
...
	                WARN_ON_ONCE(write_inode_now(inode, true));

The mntput_no_expire call chain doesn't pass return values 
back, so umount doesn't report if anything extra went wrong
in the write_inode_now call; it just returns the result
from do_umount.  The first problem to the first device
triggers the WARN_ON_ONCE message, but then it's silent
for other afflicted devices.

Every afflicted device does get one of these:
[22141.816183] EXT4-fs error (device sda): ext4_put_super:792: Couldn't clean up the journal

and shutdown was not blocked by these problems.

---
Rob Elliott    HP Server Storage


