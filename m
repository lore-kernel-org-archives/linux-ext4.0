From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36172] New: "kernel BUG at fs/ext4/super.c" triggered after
 tune2fs/remount
Date: Sun, 29 May 2011 19:23:49 GMT
Message-ID: <bug-36172-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:33484 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab1E2TXu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 May 2011 15:23:50 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4TJNn5N026122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 29 May 2011 19:23:49 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36172

           Summary: "kernel BUG at fs/ext4/super.c" triggered after
                    tune2fs/remount
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: bugzilla.kernel.bpeb@manchmal.in-ulm.de
        Regression: No


So I wanted to create an ext4 without a journal, but I noticed after mkfs.ext4
and mount, so I decided to do this online. Now tune2fs says the file system has
to be mounted r/o, no problem. The result was not what I expected.

How to repeat:

truncate --size 128M fsfile
mkfs.ext4 -F fsfile
mkdir mnt
losetup /dev/loop0 fsfile
mount /dev/loop0 mnt
mount -o remount,ro /dev/loop0
tune2fs -O ^has_journal /dev/loop0
mount -o remount,rw /dev/loop0

Observed behaviour:

"Segmentation fault" from mount, and

 ------------[ cut here ]------------
 kernel BUG at fs/ext4/super.c:4094!
 invalid opcode: 0000 [#1] 
 last sysfs file: /sys/devices/virtual/block/loop0/removable
 Modules linked in: evdev

 Pid: 2068, comm: mount Tainted: G        W   2.6.39 #1 innotek GmbH VirtualBox
 EIP: 0060:[<c10d5b34>] EFLAGS: 00010246 CPU: 0
 EIP is at ext4_clear_journal_err+0x19/0x91
 EAX: cfa5a200 EBX: cecab800 ECX: 00000000 EDX: cdd6f400
 ESI: cdd6f400 EDI: cdd6f400 EBP: 00000010 ESP: cfa25ea0
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0069
 Process mount (pid: 2068, ti=cfa24000 task=cfa8f990 task.ti=cfa24000)
 Stack:
  c10d577d 0000000f 0000cca5 cdd6f400 cfa5a200 cecab800 cdd6f400 c10d9358
  cdd6f9e0 00000000 00000000 60010001 00000000 00003a98 00000000 000001f4
  00000000 00000000 00000000 8c02c810 cf6cb414 00271d65 00000003 cf83b005
 Call Trace:
  [<c10d577d>] ? ext4_group_desc_csum+0x47/0x6e
  [<c10d9358>] ? ext4_remount+0x2cc/0x485
  [<c10d908c>] ? __ext4_abort+0xb0/0xb0
  [<c1071909>] ? do_remount_sb+0x9d/0xdb
  [<c10829bd>] ? do_mount+0x1c1/0x5e5
  [<c105f011>] ? memdup_user+0x29/0x3f
  [<c1082e47>] ? sys_mount+0x66/0x97
  [<c1363995>] ? syscall_call+0x7/0xb
 Code: ba 01 00 00 00 e8 c6 fe ff ff 89 d8 5b e9 97 bb f9 ff 57 56 89 d6 53 89
c3 83 ec 10 8b 80 68 01 00 00 8b 50 38 f6 42 5c 04 75 04 <0f> 0b eb fe 8b b8 ec
00 00 0
 EIP: [<c10d5b34>] ext4_clear_journal_err+0x19/0x91 SS:ESP 0069:cfa25ea0
 ---[ end trace 93cca63c7a7f6c4d ]---
 ------------[ cut here ]------------
 WARNING: at kernel/exit.c:910 do_exit+0x28/0x55d()
 Hardware name: VirtualBox
 Modules linked in: evdev
 Pid: 2068, comm: mount Tainted: G      D W   2.6.39 #1
 Call Trace:
  [<c101d141>] ? warn_slowpath_common+0x6a/0x7b
  [<c101f64a>] ? do_exit+0x28/0x55d
  [<c101d15f>] ? warn_slowpath_null+0xd/0x10
  [<c101f64a>] ? do_exit+0x28/0x55d
  [<c1003ddc>] ? oops_end+0x7f/0x83
  [<c1002a9f>] ? do_coprocessor_segment_overrun+0x4b/0x4b
  [<c1002b06>] ? do_invalid_op+0x67/0x70
  [<c10d5b34>] ? ext4_clear_journal_err+0x19/0x91
  [<c10768fa>] ? __follow_mount_rcu+0x5c/0x8e
  [<c1076f12>] ? do_lookup+0xa6/0x1f6
  [<c10768fa>] ? __follow_mount_rcu+0x5c/0x8e
  [<c1363bd4>] ? error_code+0x58/0x60
  [<c1002a9f>] ? do_coprocessor_segment_overrun+0x4b/0x4b
  [<c10d5b34>] ? ext4_clear_journal_err+0x19/0x91
  [<c10d577d>] ? ext4_group_desc_csum+0x47/0x6e
  [<c10d9358>] ? ext4_remount+0x2cc/0x485
  [<c10d908c>] ? __ext4_abort+0xb0/0xb0
  [<c1071909>] ? do_remount_sb+0x9d/0xdb
  [<c10829bd>] ? do_mount+0x1c1/0x5e5
  [<c105f011>] ? memdup_user+0x29/0x3f
  [<c1082e47>] ? sys_mount+0x66/0x97
  [<c1363995>] ? syscall_call+0x7/0xb
 ---[ end trace 93cca63c7a7f6c4e ]---


This is:

static void ext4_clear_journal_err(struct super_block *sb,
                                   struct ext4_super_block *es)
{
c10d5b1b:       57                      push   %edi
c10d5b1c:       56                      push   %esi
c10d5b1d:       89 d6                   mov    %edx,%esi
c10d5b1f:       53                      push   %ebx
c10d5b20:       89 c3                   mov    %eax,%ebx
c10d5b22:       83 ec 10                sub    $0x10,%esp
        unsigned int s_li_wait_mult;
};

static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
{
        return sb->s_fs_info;
c10d5b25:       8b 80 68 01 00 00       mov    0x168(%eax),%eax
        journal_t *journal;
        int j_errno;
        const char *errstr;

        BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
c10d5b2b:       8b 50 38                mov    0x38(%eax),%edx
c10d5b2e:       f6 42 5c 04             testb  $0x4,0x5c(%edx)
c10d5b32:       75 04                   jne    c10d5b38
<ext4_clear_journal_err+0x1d>
c10d5b34:       0f 0b                   ud2a   
c10d5b36:       eb fe                   jmp    c10d5b36
<ext4_clear_journal_err+0x1b>

        journal = EXT4_SB(sb)->s_journal;
c10d5b38:       8b b8 ec 00 00 00       mov    0xec(%eax),%edi
        /*
         * Now check for any error status which may have been recorded in the
         * journal by a prior ext4_error() or ext4_abort()
         */


Versions affected:
All versions tested, that is
* 2.6.39 on i386
* 2.6.38.7 on i386
* 2.6.32.41 on i386 and armel

e2fsprogs version is tune2fs 1.41.12 (17-May-2010)
mount from util-linux-ng 2.17.2 (with libblkid and selinux support)

Severity left to "normal" this is a rather unusual operation and a workaround
exists by umounting the device.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
