From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Sat, 27 Mar 2010 17:48:54 GMT
Message-ID: <201003271748.o2RHmssd028610@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53154 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0C0Rsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 13:48:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2RHmsm6028611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 27 Mar 2010 17:48:54 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549


Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla.kernel.bpeb@manchm
                   |                            |al.in-ulm.de




--- Comment #16 from Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>  2010-03-27 17:48:48 ---
The last days I ran into the same problems on several machines and was finally
able to reproduce the BUG in 2.6.32.10, 2.6.33, 2.6.34-rc1.  The trick is to
resize a file system that once was ext3.



Steps to reproduce:

# create a volume group vg_test. (lvm was mainly used for convenience)

# create a logical volume
lvcreate -n test -L 128m vg_test

DEV=/dev/vg_test/test
# create an ext3 filesystem
mke2fs -j $DEV

# convert to ext4
tune2fs -O extents,uninit_bg,dir_index,flex_bg,huge_file,dir_nlink,extra_isize
$DEV
e2fsck -yDf -C0 $DEV

# mount
mkdir /tmp/text
mount -o noatime $DEV /tmp/test

# resize LV
lvresize -L +4m $DEV

# online resize ext4
resize2fs -p $DEV



Observed behaviour:


kernel: BUG: unable to handle kernel NULL pointer dereference at 00000184
kernel: IP: [<c10c9f66>] ext4_group_add+0xf8f/0x104d
kernel: *pde = 00000000
kernel: Oops: 0002 [#1]
kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:01.1/host0/target0:0:1/0:0:1:0/block/sdb/sdb1/dev
kernel:
kernel: Pid: 1302, comm: resize2fs Not tainted 2.6.34-rc2 #7 /VirtualBox
kernel: EIP: 0060:[<c10c9f66>] EFLAGS: 00010202 CPU: 0
kernel: EIP is at ext4_group_add+0xf8f/0x104d
kernel: EAX: 00000180 EBX: cfba8200 ECX: 00007dfe EDX: 00000180
kernel: ESI: ce03def0 EDI: 00000000 EBP: 00100001 ESP: ce03de40
kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0069
kernel: Process resize2fs (pid: 1302, ti=ce03c000 task=cf8e4280
task.ti=ce03c000)
kernel: Stack:
kernel:  00100202 00000000 ffffffff cfba8400 cf4ca3ec 00000000 ce03def0
cfba8200
kernel: <0> 00000000 00100202 00000000 00000002 00000000 cfba8200 cdc4b400
00100001
kernel: <0> 00000000 00000000 00000020 00000080 cfba8304 00000000 cfba8304
00000020
kernel: Call Trace:
kernel:  [<c10c0c96>] ? ext4_ioctl+0x57a/0x674
kernel:  [<c114e1c9>] ? do_output_char+0x84/0x191
kernel:  [<c10c071c>] ? ext4_ioctl+0x0/0x674
kernel:  [<c10753e6>] ? vfs_ioctl+0x12/0x42
kernel:  [<c10758dc>] ? do_vfs_ioctl+0x438/0x47c
kernel:  [<c106c83d>] ? vfs_write+0xf7/0x131
kernel:  [<c107594d>] ? sys_ioctl+0x2d/0x44
kernel:  [<c1237f75>] ? syscall_call+0x7/0xb
kernel: Code: 00 59 8b 40 38 f6 40 61 02 74 38 8b 5c 24 34 8b 74 24 18 8b 8b b0
01 00 00 8b 06 8b 93 b4 01 00 00 d3 e8 8b 4e 24 6b c0 0c 01 c2 <01> 4a 04 8b 4c
24 0c 03 83 b
kernel: EIP: [<c10c9f66>] ext4_group_add+0xf8f/0x104d SS:ESP 0069:ce03de40
kernel: CR2: 0000000000000184
kernel: ---[ end trace a1e9f008f870cb3b ]---

The code is (let's see whether bugzilla preserves the formatting):

        if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
                ext4_group_t flex_group;
                flex_group = ext4_flex_group(sbi, input->group);
                atomic_add(input->free_blocks_count,
                           &sbi->s_flex_groups[flex_group].free_blocks);
c10c9f46:       8b 5c 24 34             mov    0x34(%esp),%ebx
c10c9f4a:       8b 74 24 18             mov    0x18(%esp),%esi
c10c9f4e:       8b 8b b0 01 00 00       mov    0x1b0(%ebx),%ecx
c10c9f54:       8b 06                   mov    (%esi),%eax
c10c9f56:       8b 93 b4 01 00 00       mov    0x1b4(%ebx),%edx
c10c9f5c:       d3 e8                   shr    %cl,%eax
 *
 * Atomically adds @i to @v.
 */
static inline void atomic_add(int i, atomic_t *v)
{
        asm volatile(LOCK_PREFIX "addl %1,%0"
c10c9f5e:       8b 4e 24                mov    0x24(%esi),%ecx
c10c9f61:       6b c0 0c                imul   $0xc,%eax,%eax
c10c9f64:       01 c2                   add    %eax,%edx
c10c9f66:       01 4a 04                add    %ecx,0x4(%edx)
c10c9f69:       8b 4c 24 0c             mov    0xc(%esp),%ecx
                atomic_add(EXT4_INODES_PER_GROUP(sb),
                           &sbi->s_flex_groups[flex_group].free_inodes);
c10c9f6d:       03 83 b4 01 00 00       add    0x1b4(%ebx),%eax
c10c9f73:       8b 91 5c 01 00 00       mov    0x15c(%ecx),%edx
c10c9f79:       8b 52 0c                mov    0xc(%edx),%edx
c10c9f7c:       01 10                   add    %edx,(%eax)
        }


e2fsprogs is from Debian lenny (1.41.3-1).

Let me know if you're interested in the kernel .config.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
