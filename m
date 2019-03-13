Return-Path: <SRS0=5sbL=RQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B738CC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 06:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 859582070D
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 06:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfCMGvF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Mar 2019 02:51:05 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60058 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727049AbfCMGvF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Mar 2019 02:51:05 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4947B29944
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2019 06:51:04 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 3D91329A8D; Wed, 13 Mar 2019 06:51:04 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202897] New: BUG: unable to handle kernel paging request at
 __memmove
Date:   Wed, 13 Mar 2019 06:51:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jungyeon@gatech.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-202897-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202897

            Bug ID: 202897
           Summary: BUG: unable to handle kernel paging request at
                    __memmove
           Product: File System
           Version: 2.5
    Kernel Version: 5.0-rc8
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jungyeon@gatech.edu
        Regression: No

Created attachment 281787
  --> https://bugzilla.kernel.org/attachment.cgi?id=281787&action=edit
The (compressed) crafted image which causes crash

- Overview
After mounting crafted image, I got this page fault while running attached
program.

- Produces
mkdir test
mount -t ext4 tmp.img test
gcc min_01.c
cp a.out test
cd test
./a.out

- Kernel messages
[   74.327744] BUG: unable to handle kernel paging request at ffff95f12b296000
[   74.329597] #PF error: [PROT] [WRITE]
[   74.330547] PGD 23601067 P4D 23601067 PUD 2366b2063 PMD 23541d063 PTE
800000022b296061
[   74.332538] Oops: 0003 [#1] SMP PTI
[   74.333429] CPU: 0 PID: 1158 Comm: a.out Not tainted 5.0.0-rc8+ #9
[   74.335059] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.10.2-1ubuntu1 04/01/2014
[   74.337313] RIP: 0010:__memmove+0x81/0x1a0
[   74.338359] Code: 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4 48 83 c2 20 e9
a2 00 00 00 66 90 48 89 d1 4c 8b 5c 16 f8 4c 8d 54 17 f8 48 c1 e9 03 <f3> 48 a5
4d 89 1a e9 0c 01 00 00 0f 1f 40 00 48 89 d1 4c 8b 1e 49
[   74.343035] RSP: 0018:ffffb09a011ef938 EFLAGS: 00010207
[   74.344361] RAX: ffff95f12666a000 RBX: ffffb09a011efb40 RCX:
1fffffffff67a7fc
[   74.346163] RDX: ffffffffffffffe4 RSI: ffff95f12b296000 RDI:
ffff95f12b296000
[   74.347980] RBP: ffffb09a011efa38 R08: 0000000000000001 R09:
ffff95f1324acf00
[   74.349763] R10: ffff95f126669fdc R11: 0000000000000000 R12:
ffffb09a011efab8
[   74.351560] R13: ffff95f12666a000 R14: 00000000000003e4 R15:
0000000000000000
[   74.353343] FS:  00007fa3b7981700(0000) GS:ffff95f137a00000(0000)
knlGS:0000000000000000
[   74.355374] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.356815] CR2: ffff95f12b296000 CR3: 000000022b2bc006 CR4:
00000000000206f0
[   74.358622] Call Trace:
[   74.359263]  ? ext4_xattr_set_entry+0xa55/0x1090
[   74.360447]  ? jbd2_journal_cancel_revoke+0xbf/0xf0
[   74.361696]  ? kmem_cache_alloc+0xb0/0x170
[   74.362761]  ? jbd2_journal_get_write_access+0x5b/0x70
[   74.364062]  ext4_xattr_block_set+0x37a/0xf80
[   74.365173]  ? __getblk_gfp+0x2f/0x300
[   74.366129]  ? xattr_find_entry+0x8c/0x110
[   74.367183]  ext4_xattr_set_handle+0x544/0x5f0
[   74.368315]  __ext4_set_acl+0x1aa/0x290
[   74.369293]  ext4_set_acl+0xbf/0x1f0
[   74.370210]  ? posix_acl_from_xattr+0x180/0x180
[   74.371373]  set_posix_acl+0x79/0xb0
[   74.372282]  posix_acl_xattr_set+0x84/0x90
[   74.373321]  __vfs_removexattr+0x52/0x70
[   74.374310]  vfs_removexattr+0x84/0x100
[   74.375293]  removexattr+0x55/0x80
[   74.376157]  ? __check_object_size+0x17c/0x1b0
[   74.377272]  ? strncpy_from_user+0x50/0x1b0
[   74.378323]  ? _cond_resched+0x1a/0x50
[   74.379292]  ? __sb_start_write+0x3f/0x70
[   74.380310]  ? mnt_want_write+0x2c/0x50
[   74.381284]  path_removexattr+0x9a/0xb0
[   74.382252]  __x64_sys_removexattr+0x1b/0x20
[   74.383357]  do_syscall_64+0x5a/0x110
[   74.384293]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   74.385568] RIP: 0033:0x7fa3b749c4d9
[   74.386491] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 8f 29 2c 00 f7 d8 64 89 01 48
[   74.391133] RSP: 002b:00007ffffd7aeb08 EFLAGS: 00000202 ORIG_RAX:
00000000000000c5
[   74.393021] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fa3b749c4d9
[   74.394822] RDX: 0000000000000000 RSI: 00007ffffd7aeb30 RDI:
00007ffffd7aeb20
[   74.396608] RBP: 00007ffffd7aeb50 R08: 00007fa3b7775ab0 R09:
00007ffffd7aec38
[   74.398392] R10: 00000000004006a0 R11: 0000000000000202 R12:
00000000004004a0
[   74.400175] R13: 00007ffffd7aec30 R14: 0000000000000000 R15:
0000000000000000
[   74.401951] Modules linked in:
[   74.402744] CR2: ffff95f12b296000
[   74.403596] ---[ end trace e7fe34a5ca4f4421 ]---
[   74.404771] RIP: 0010:__memmove+0x81/0x1a0
[   74.405815] Code: 4c 89 4f 10 4c 89 47 18 48 8d 7f 20 73 d4 48 83 c2 20 e9
a2 00 00 00 66 90 48 89 d1 4c 8b 5c 16 f8 4c 8d 54 17 f8 48 c1 e9 03 <f3> 48 a5
4d 89 1a e9 0c 01 00 00 0f 1f 40 00 48 89 d1 4c 8b 1e 49
[   74.410512] RSP: 0018:ffffb09a011ef938 EFLAGS: 00010207
[   74.411833] RAX: ffff95f12666a000 RBX: ffffb09a011efb40 RCX:
1fffffffff67a7fc
[   74.413618] RDX: ffffffffffffffe4 RSI: ffff95f12b296000 RDI:
ffff95f12b296000
[   74.415419] RBP: ffffb09a011efa38 R08: 0000000000000001 R09:
ffff95f1324acf00
[   74.417211] R10: ffff95f126669fdc R11: 0000000000000000 R12:
ffffb09a011efab8
[   74.419022] R13: ffff95f12666a000 R14: 00000000000003e4 R15:
0000000000000000
[   74.420821] FS:  00007fa3b7981700(0000) GS:ffff95f137a00000(0000)
knlGS:0000000000000000
[   74.422857] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.424306] CR2: ffff95f12b296000 CR3: 000000022b2bc006 CR4:
00000000000206f0

- Primitive reason

When calling memmove at 1704, it give extreme value as count (3rd parameter).
This is because val is smaller than first_val in this case, so that the count
becomes negative number. (-28 became -xfff....ffe4 because of two's compliment)
As a result, memmove show errors while copying with huge count number.

1696     /* No failures allowed past this point. */
1697 
1698     if (!s->not_found && here->e_value_size && here->e_value_offs) {
1699         /* Remove the old value. */
1700         void *first_val = s->base + min_offs;
1701         size_t offs = le16_to_cpu(here->e_value_offs);
1702         void *val = s->base + offs;
1703 
1704         memmove(first_val + old_size, first_val, val - first_val);
1705         memset(first_val, 0, old_size);
1706         min_offs += old_size;
1707 
1708         /* Adjust all value offsets. */
1709         last = s->first;
1710         while (!IS_LAST_ENTRY(last)) {
1711             size_t o = le16_to_cpu(last->e_value_offs);
1712 
1713             if (!last->e_value_inum &&
1714                 last->e_value_size && o < offs)
1715                 last->e_value_offs = cpu_to_le16(o + old_size);
1716             last = EXT4_XATTR_NEXT(last);
1717         }
1718     }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
