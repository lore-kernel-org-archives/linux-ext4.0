From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: ext4 error when testing virtio-scsi & vhost-scsi
Date: Wed, 13 Jul 2016 15:25:09 +0800
Message-ID: <CAMj5BkiCDiZNyOHQbio9OaormPjEeM_a6E8Vz20_stPiKEEs1g@mail.gmail.com>
References: <CAMj5BkiVGQ4dAUY+wi-+O4qRdVS6YPiUP2BpsiE5y0r+2AhLgw@mail.gmail.com>
	<CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
	<CAMj5BkgSXjD+_GB_VPgizowyyJ1uYxLiKd7ehQmEdVvnuY55cA@mail.gmail.com>
	<20160712164324.GC11020@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, target-devel@vger.kernel.org,
	qemu-devel@nongnu.org, kvm@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20160712164324.GC11020@thunk.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Id: linux-ext4.vger.kernel.org

Dear Ted

On Wed, Jul 13, 2016 at 12:43 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jul 12, 2016 at 03:14:38PM +0800, Zhangfei Gao wrote:
>> Some update:
>>
>> If test with ext2, no problem in iblock.
>> If test with ext4, ext4_mb_generate_buddy reported error in the
>> removing files after reboot.
>>
>>
>> root@(none)$ rm test
>> [   21.006549] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 18
>> , block bitmap and bg descriptor inconsistent: 26464 vs 25600 free clusters
>> [   21.008249] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). Th
>> ere's a risk of filesystem corruption in case of system crash.
>>
>> Any special notes of using ext4 in qemu?
>
> Ext4 has more runtime consistency checking than ext2.  So just because
> ext4 complains doesn't mean that there isn't a problem with the file
> system; it just means that ext4 is more likely to notice before you
> lose user data.
>
> So if you test with ext2, try running e2fsck afterwards, to make sure
> the file system is consistent.
>
> Given that I'm reguarly testing ext4 using kvm, and I haven't seen
> anything like this in a very long time, I suspect the problemb is with
> your SCSI code, and not with ext4.
>

Instead of using sas disk, I am trying with u-disk as backstore, via iblock.

# targetcli
/backstores/iblock> create name=block_backend dev=/dev/sdb
/backstores/iblock> cd /vhost
/vhost> create wwn=naa.60014053c5cc00ac
/vhost> ls
o- vhost ............................................................ [1 Target]
  o- naa.60014053c5cc00ac .............................................. [1 TPG]
    o- tpg1 ............................................. [naa.6001405830beacfa]
      o- luns ......................................................... [0 LUNs]
/vhost> cd naa.60014053c5cc00ac/tpg1/luns
/vhost/naa.60...0ac/tpg1/luns> create /backstores/iblock/block_backend

/work/qemu.git/aarch64-softmmu/qemu-system-aarch64 \
    -enable-kvm -nographic -kernel Image \
    -device vhost-scsi-pci,wwpn=naa.60014053c5cc00ac \
    -m 512 -M virt -cpu host \
    -append "earlyprintk console=ttyAMA0 mem=512M"



in qemu:

Just test with dd, got following error.

 #sync; date; dd if=/dev/zero of=test bs=1M count=100; sync;
Thu Jan  1 00:00:45 UTC 1970
[   45.150514] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.153319] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.156054] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.160806] EXT4-fs error (device sda) in ext4_ext_truncate:4661: Corrupt fil
esystem
[   45.165431] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.169177] EXT4-fs error (device sda) in ext4_orphan_del:2896: Corrupt files
ystem
[   45.172676] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.176427] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.180800] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem
[   45.183571] EXT4-fs error (device sda) in ext4_reserve_inode_write:5172: Corr
upt filesystem

[   50.122300] jbd2_journal_bmap: journal block not found at offset 26 on sda-8
[   50.123181] Aborting journal on device sda-8.
[   50.138046] EXT4-fs error (device sda): ext4_journal_check_start:56: Detected
 aborted journal
[   50.139117] EXT4-fs (sda): Remounting filesystem read-only
dd: writing 'test': Read-only file system
6+0 records in
4+1 records out
Thu Jan  1 00:00:50 UTC 1970


Also get error like this after reboot, not always happen.
root@(none)$ rm test
root@(none)$ ls
lost+found
; date;one)$ sync; date; dd if=/dev/zero of=test bs=1M count=100; sync
Thu Jan  1 00:00:29 UTC 1970
[   29.909074] EXT4-fs error (device sda): ext4_init_inode_bitmap:79: comm dd: C
hecksum bad for group 3
[   29.910205] BUG: scheduling while atomic: dd/1091/0x00000002
[   29.910928] Modules linked in:
[   29.911340] CPU: 0 PID: 1091 Comm: dd Not tainted 4.5.0-rc1+ #70
[   29.912066] Hardware name: linux,dummy-virt (DT)
[   29.912639] Call trace:
[   29.912957] [<ffffffc000089830>] dump_backtrace+0x0/0x180
[   29.913623] [<ffffffc0000899c4>] show_stack+0x14/0x20
[   29.914249] [<ffffffc00033fc88>] dump_stack+0x90/0xc8
[   29.914893] [<ffffffc0000d68d4>] __schedule_bug+0x44/0x58
[   29.915573] [<ffffffc0006cc46c>] __schedule+0x4f4/0x5a0
[   29.916200] [<ffffffc0006cc554>] schedule+0x3c/0xa8
[   29.916786] [<ffffffc0006cf07c>] schedule_timeout+0x15c/0x1b0
[   29.917471] [<ffffffc0006cbf08>] io_schedule_timeout+0xa0/0x110
[   29.918177] [<ffffffc0006cceb8>] bit_wait_io+0x18/0x68
[   29.918827] [<ffffffc0006ccd5c>] __wait_on_bit_lock+0x7c/0xf0
[   29.919552] [<ffffffc0006cce30>] out_of_line_wait_on_bit_lock+0x60/0x68
[   29.920352] [<ffffffc0001eb110>] __lock_buffer+0x38/0x48
[   29.920991] [<ffffffc0001efb4c>] __sync_dirty_buffer+0xf4/0xf8
[   29.921692] [<ffffffc00024c6d4>] ext4_commit_super+0x18c/0x268
[   29.922389] [<ffffffc00024ca38>] __ext4_error+0x60/0xd0
[   29.923055] [<ffffffc000236b6c>] ext4_read_inode_bitmap+0x3a4/0x7b0
[   29.923826] [<ffffffc000237d5c>] __ext4_new_inode+0x344/0x1468
[   29.924532] [<ffffffc000248084>] ext4_create+0xac/0x1c0
[   29.925163] [<ffffffc0001c9ab4>] vfs_create+0xf4/0x158
[   29.925780] [<ffffffc0001ca498>] path_openat+0x980/0xf00
[   29.926419] [<ffffffc0001cbe0c>] do_filp_open+0x64/0xe0
[   29.927086] [<ffffffc0001bafc8>] do_sys_open+0x148/0x218
[   29.927746] [<ffffffc0001bb0d0>] SyS_openat+0x10/0x18
[   29.928359] [<ffffffc000085d30>] el0_svc_naked+0x24/0x28


Again, ext2 test no problem.


qemu is master branch:
qemu.git$ git log --oneline
860a3b3 Update version for v2.6.0-rc5 release
53db932 Merge remote-tracking branch
'remotes/kraxel/tags/pull-vga-20160509-1' into staging
975eb6a Update version for v2.6.0-rc4 release
1beb99f Revert "acpi: mark PMTIMER as unlocked"

kernel is 4.5-rc1, cherry-pick latest vhost and target patches.

Thanks
