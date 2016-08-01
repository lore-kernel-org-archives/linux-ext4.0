From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: ext4 error when testing virtio-scsi & vhost-scsi
Date: Mon, 1 Aug 2016 10:40:33 +0800
Message-ID: <CAMj5BkjdxqcRR2o9JjX65XSFKA8Jdgy=AK9WgyqiAgjSutm5ig@mail.gmail.com>
References: <CAMj5BkiVGQ4dAUY+wi-+O4qRdVS6YPiUP2BpsiE5y0r+2AhLgw@mail.gmail.com>
	<CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
	<CAMj5BkgSXjD+_GB_VPgizowyyJ1uYxLiKd7ehQmEdVvnuY55cA@mail.gmail.com>
	<20160712164324.GC11020@thunk.org>
	<CAMj5BkgTycMbfQpUVAV17ahYT1sGm6w3YDtpz0E--vN=tF55xA@mail.gmail.com>
	<CAMj5BkicJhB1Bk6q_ZT_nMKSPWf1XEGchtnGnMPFy=O_0x91hA@mail.gmail.com>
	<CAMj5BkifLL=3C5f0VZKhpNmi81em8P5VNupr7d7_aD=uo2Hwow@mail.gmail.com>
	<20160727155608.GC1659@quack2.suse.cz>
	<CAMj5BkgqYq4feie3HVpp673JyFq+SEXRn2YiaO=v_v9RqW_pBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	target-devel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAMj5BkgqYq4feie3HVpp673JyFq+SEXRn2YiaO=v_v9RqW_pBw@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-ext4.vger.kernel.org

Hi, Jan

On Thu, Jul 28, 2016 at 9:29 AM, Zhangfei Gao <zhangfei.gao@gmail.com> wrote:
> Hi, Jan
>
> On Wed, Jul 27, 2016 at 11:56 PM, Jan Kara <jack@suse.cz> wrote:
>> Hi!
>>
>> On Wed 27-07-16 15:58:55, Zhangfei Gao wrote:
>>> Hi, Michael
>>>
>>> I have met ext4 error when using vhost_scsi on arm64 platform, and
>>> suspect it is vhost_scsi issue.
>>>
>>> Ext4 error when testing virtio_scsi & vhost_scsi
>>>
>>>
>>> No issue:
>>> 1. virtio_scsi, ext4
>>> 2. vhost_scsi & virtio_scsi, ext2
>>> 3.  Instead of vhost, also tried loopback and no problem.
>>> Using loopback, host can use the new block device, while vhost is used
>>> by guest (qemu).
>>> http://www.linux-iscsi.org/wiki/Tcm_loop
>>> Test directly in host, not find ext4 error.
>>>
>>>
>>>
>>> Have issue:
>>> 1. vhost_scsi & virtio_scsi, ext4
>>> a. iblock
>>> b, fileio, file located in /tmp (ram), no device based.
>>>
>>> 2, Have tried 4.7-r2 and 4.5-rc1 on D02 board, both have issue.
>>> Since I need kvm specific patch for D02, so it may not freely to switch
>>> to older version.
>>>
>>> 3. Also test with ext4, disabling journal
>>> mkfs.ext4 -O ^has_journal /dev/sda
>>>
>>>
>>> Do you have any suggestion?
>>
>> So can you mount the filesystem with errors=remount-ro to avoid clobbering
>> the fs after the problem happens? And then run e2fsck on the problematic
>> filesystem and send the output here?
>>
>
> Tested twice, log pasted.
> Both using fileio, located in host ramfs /tmp
> Before e2fsck, umount /dev/sda
>
> 1.
> root@(none)$ mount -o errors=remount-ro /dev/sda /mnt
> [   22.812053] EXT4-fs (sda): mounted filesystem with ordered data
> mode. Opts: errors=remount-ro
> $ rm /mnt/test
> [  108.388905] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [  108.406930] Aborting journal on device sda-8.
> [  108.414120] EXT4-fs (sda): Remounting filesystem read-only
> [  108.414847] EXT4-fs error (device sda) in ext4_dirty_inode:5487: IO failure
> [  108.423571] EXT4-fs error (device sda) in ext4_free_blocks:4904:
> Journal has aborted
> [  108.431919] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [  108.440269] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [  108.448568] EXT4-fs error (device sda) in
> ext4_ext_remove_space:3058: IO failure
> [  108.456917] EXT4-fs error (device sda) in ext4_ext_truncate:4657:
> Corrupt filesystem
> [  108.465267] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [  108.473567] EXT4-fs error (device sda) in ext4_truncate:4150: IO failure
> [  108.481917] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> root@(none)$ e2fsck /dev/sda
> e2fsck 1.42.9 (28-Dec-2013)
> /dev/sda is mounted.
> e2fsck: Cannot continue, aborting.
>
>
> root@(none)$ umount /mnt
> [  260.756250] EXT4-fs error (device sda): ext4_put_super:837:
> Couldn't clean up the journal
> root@(none)$ umount /mnt           e2fsck /dev/sda
> e2fsck 1.42.9 (28-Dec-2013)
> ext2fs_open2: Bad magic number in super-block
> e2fsck: Superblock invalid, trying backup blocks...
> Superblock needs_recovery flag is clear, but journal has data.
> Recovery flag not set in backup superblock, so running journal anyway.
> /dev/sda: recovering journal
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong for group #1 (32703, counted=8127).
> Fix<y>? yes
> Free blocks count wrong for group #2 (32768, counted=31744).
> Fix<y>? yes
> Free blocks count wrong (249509, counted=223909).
> Fix<y>? yes
> Free inodes count wrong for group #0 (8181, counted=8180).
> Fix<y>? yes
> Free inodes count wrong (65525, counted=65524).
> Fix<y>? yes
>
> /dev/sda: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/sda: 12/65536 files (8.3% non-contiguous), 38235/262144 blocks
> root@(none)$
>
> 2.
>
>  root@(none)$ rm /mnt/test
> [   71.021484] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [   71.044959] Aborting journal on device sda-8.
> [   71.052152] EXT4-fs (sda): Remounting filesystem read-only
> [   71.052833] EXT4-fs error (device sda) in ext4_dirty_inode:5487: IO failure
> [   71.061600] EXT4-fs error (device sda) in ext4_free_blocks:4904:
> Journal has aborted
> [   71.069948] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [   71.078296] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [   71.086597] EXT4-fs error (device sda) in
> ext4_ext_remove_space:3058: IO failure
> [   71.094946] EXT4-fs error (device sda) in ext4_ext_truncate:4657:
> Corrupt filesystem
> [   71.103296] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> [   71.111595] EXT4-fs error (device sda) in ext4_truncate:4150: IO failure
> [   71.119946] EXT4-fs error (device sda) in
> ext4_reserve_inode_write:5362: Corrupt filesystem
> root@(none)$ e2fsck /dev/sda
> e2fsck 1.42.9 (28-Dec-2013)
> /dev/sda is mounted.
> e2fsck: Cannot continue, aborting.
>
>
> root@(none)$ umou nt /mnt/
> [   92.103221] EXT4-fs error (device sda): ext4_put_super:837:
> Couldn't clean up the journal
> root@(none)$ umount /mnt/            e2fsck /dev/sda
> e2fsck 1.42.9 (28-Dec-2013)
> ext2fs_open2: Bad magic number in super-block
> e2fsck: Superblock invalid, trying backup blocks...
> Superblock needs_recovery flag is clear, but journal has data.
> Recovery flag not set in backup superblock, so running journal anyway.
> /dev/sda: recovering journal
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong for group #1 (32703, counted=8127).
> Fix<y>? yes
> Free blocks count wrong for group #2 (32768, counted=31744).
> Fix<y>? yes
> Free blocks count wrong (249509, counted=223909).
> Fix<y>? yes
> Free inodes count wrong for group #0 (8181, counted=8180).
> Fix<y>? yes
> Free inodes count wrong (65525, counted=65524).
> Fix<y>? yes
>
> /dev/sda: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/sda: 12/65536 files (8.3% non-contiguous), 38235/262144 blocks
> root@(none)$
>

One more test on another different arm64 machine (apm-mustang).

root@(none)$ dd if=/dev/zero of=/mnt/test bs=1M count=100; sync;
[  117.556265] EXT4-fs error (device sda) in
ext4_reserve_inode_write:5172: Corrupt filesystem
[  117.570231] Aborting journal on device sda-8.
[  117.582769] EXT4-fs (sda): Remounting filesystem read-only
[  117.583739] EXT4-fs error (device sda) in ext4_dirty_inode:5297: IO failure
[  117.596578] EXT4-fs error (device sda) in ext4_free_blocks:4897:
Journal has aborted
[  117.609122] EXT4-fs error (device sda) in
ext4_reserve_inode_write:5172: Corrupt filesystem
[  117.622970] EXT4-fs error (device sda) in
ext4_reserve_inode_write:5172: Corrupt filesystem
[  117.635486] EXT4-fs error (device sda) in
ext4_ext_remove_space:3044: IO failure
[  117.649351] EXT4-fs error (device sda) in ext4_ext_truncate:4661:
Corrupt filesystem
[  117.661875] EXT4-fs error (device sda) in
ext4_reserve_inode_write:5172: Corrupt filesystem
[  117.675717] EXT4-fs error (device sda) in ext4_orphan_del:2896:
Corrupt filesystem
[  117.688235] EXT4-fs error (device sda) in
ext4_reserve_inode_write:5172: Corrupt filesystem
dd: writing '/mnt/test': Read-only file system
1+0 records in
0+0 records out
root@(none)$ umount /mnt
[  126.637862] EXT4-fs error (device sda): ext4_put_super:838:
Couldn't clean up the journal
root@(none)$ e2fsck /dev/sda
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
e2fsck: Superblock invalid, trying backup blocks...
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
/dev/sda: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(86016--87039)
Fix<y>? yes
Free blocks count wrong for group #1 (32703, counted=7103).
Fix<y>? yes
Free blocks count wrong (249509, counted=223909).
Fix<y>? yes
Free inodes count wrong for group #0 (8181, counted=8180).
Fix<y>? yes
Free inodes count wrong (65525, counted=65524).
Fix<y>? yes

/dev/sda: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda: 12/65536 files (8.3% non-contiguous), 38235/262144 blocks



Do you know what's the possible reason of this error?


I got from your comments from other mail.
"
Hum, interesting. So 'Free blocks count wrong' and 'Free inodes count
wrong' messages are harmless - those entries and updated only
opportunistically and on mount and generally do not have to match on live
filesystem. The other three errors regarding inode and directory count are
a fallout from aborted inode deletion. Most importantly there is *no
problem* whatsoever with block bitmaps. So it was either some memory glitch
(bitflip in the counter or the bitmap) or there is some race and bb_free
can get out of sync with the bitmap and I don't see how that could happen
especially so early after mount... Strange.
"

there is such error:
Block bitmap differences:  -(86016--87039)

Thanks
