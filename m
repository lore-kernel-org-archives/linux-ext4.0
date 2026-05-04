Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D828B3803F4
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777933656; cv=none; b=Ec3RUJWLp+pHLlL4U7fTtTVpZX6fqfB0KhC/d9IqYCqwgUHxljhGU6gvE/d9f3LM8VgLQLSCXxmK8OsofB/3V9KhguLvW4IgTdMlqxc7oPP2fsvrS50qgQNpc5Azmu2q0zxY6ycVeYDcUVNgHaitPnP8n+fs3E8rP7ws+AGQg8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777933656; c=relaxed/simple;
	bh=rn8xHiWnj0kmbapSBpbMj68NgvThaMmowZ2I4HgF0qA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=P9Ln8qfrvDTLPACCNHEn9ZIXvf1yPfs6t3MpNN2ZwK5usjDOxDLPklEfEbINDozbvU0gFG1NkBhvhVs5nVrV1+xAp3Zw7kps+YdORWPI+q7dJxO0cBBudYS7jCEzdt3HyJzxhzRzM6QigRNjoRowkl0DSMOgx2YY+HCb2Bj6B1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-42fb9d10232so10318860fac.2
        for <linux-ext4@vger.kernel.org>; Mon, 04 May 2026 15:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777933654; x=1778538454;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2BY4WlD/VCV67779sfW7Vcrlk3Afldj79IuYArLJLJo=;
        b=f836LTekgxD+7/ol7TW6QYscV8Nax25fua9fD5ltLjtRo60HpZ9lg/p7t6RbRNdQaV
         eTzESMZDt/L+MAripgDUSk8u8JvC4QdsP1rtH8ErfdhAhDJUR7mOwN7EFJ6bG/0FvfeJ
         +9eE08wTXmPNIDqSEpaTPeYkoeg0XIFDPuEuY31PN6NtKRAENcxAfpikwC18o4oConOs
         oE1AupETuyUcHLIY5jM/DiVklxxHKVDH4Tmp2oKzfzaLuWaKFQWwfjjOHAEupLPdmV6e
         qy5dsN59oIdr6wLoykzk6H6kUzEcKzL9CJsm3pxOBxUD5Y1hFGVCglVsvn8dfbmXJfHi
         6InQ==
X-Forwarded-Encrypted: i=1; AFNElJ+08/vLsOvs+ylSTg/ZcNCAOvuH0eLyDj8R/84NYQIyfS9Dac11S8oRqZTRkGFyyOKT9sCpQql8i4xL@vger.kernel.org
X-Gm-Message-State: AOJu0YzVvjlNwWKBzzQlA6Nbe16w+AuVxAws//8anG6d7Xi4eN7u2cLv
	ksIq+UPAL76mE1RM7YBlvpmdz43sRISs72Gb1cTtbfAx1kwwWU2Oz9mSmzi1PD6Foy1irLJx0K7
	y+eoS9fcBpj3yzOCJYBqXcQF9Jtt6TJj93TdsfeQjvURXcmYhsC3bAZOzThU=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e90b:0:b0:694:980a:2c33 with SMTP id
 006d021491bc7-696979ad5e6mr5088420eaf.5.1777933653847; Mon, 04 May 2026
 15:27:33 -0700 (PDT)
Date: Mon, 04 May 2026 15:27:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f91d55.170a0220.bb392.000b.GAE@google.com>
Subject: [syzbot] [ocfs2?] [ext4?] general protection fault in
 jbd2_journal_dirty_metadata (2)
From: syzbot <syzbot+98f651460e558a21baae@syzkaller.appspotmail.com>
To: jack@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    08d0d3466664 Merge tag 'net-7.1-rc2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=152f81ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4caf64b1ee83dac0
dashboard link: https://syzkaller.appspot.com/bug?extid=98f651460e558a21baae
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1415f2d2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132f81ce580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5abd4fcc5ba/disk-08d0d346.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/896c46fd9ce9/vmlinux-08d0d346.xz
kernel image: https://storage.googleapis.com/syzbot-assets/04a44a684bb3/bzImage-08d0d346.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b6c8c7ca94d0/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=14e8a082580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com

(syz.2.23,6028,0):__ocfs2_remove_xattr_range:786 ERROR: status = -30
(syz.2.23,6028,0):ocfs2_xattr_shrink_size:840 ERROR: status = -30
(syz.2.23,6028,0):__ocfs2_journal_access:724 ERROR: Error -30 getting 1 access to buffer!
(syz.2.23,6028,0):ocfs2_xa_prepare_entry:2182 ERROR: status = -30
(syz.2.23,6028,0):ocfs2_xa_set:2285 ERROR: status = -30
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 6028 Comm: syz.2.23 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:jbd2_journal_dirty_metadata+0x4a/0xd30 fs/jbd2/transaction.c:1520
Code: 00 fc ff df e8 07 27 29 ff 4c 89 fd 48 c1 ed 03 42 80 7c 35 00 00 74 08 4c 89 ff e8 f0 61 94 ff 49 8b 1f 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 d7 61 94 ff 48 89 1c 24 4c 8b 2b
RSP: 0018:ffffc90003766bc0 EFLAGS: 00010256
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888035c3dc40
RDX: 0000000000000000 RSI: ffff88805927b9f8 RDI: ffff888034ddbf20
RBP: 1ffff110069bb7e4 R08: ffffffff9030a1f7 R09: 1ffffffff206143e
R10: dffffc0000000000 R11: fffffbfff206143f R12: dffffc0000000000
R13: 1ffff920006ecd94 R14: dffffc0000000000 R15: ffff888034ddbf20
FS:  000055556c64d500(0000) GS:ffff888125290000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8ff9c72700 CR3: 000000007908f000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
 ocfs2_xa_journal_dirty fs/ocfs2/xattr.c:1483 [inline]
 ocfs2_xa_set+0x15e3/0x2ec0 fs/ocfs2/xattr.c:2294
 ocfs2_xattr_block_set+0x3e0/0x33c0 fs/ocfs2/xattr.c:3016
 __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
 ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:252
 vfs_setxattr+0x163/0x360 fs/xattr.c:339
 do_setxattr fs/xattr.c:654 [inline]
 filename_setxattr+0x296/0x630 fs/xattr.c:682
 path_setxattrat+0x3eb/0x440 fs/xattr.c:726
 __do_sys_setxattr fs/xattr.c:760 [inline]
 __se_sys_setxattr fs/xattr.c:756 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:756
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8ff9d9cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd9c92e118 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f8ffa015fa0 RCX: 00007f8ff9d9cdd9
RDX: 0000000000000000 RSI: 0000200000000140 RDI: 0000200000000080
RBP: 00007f8ff9e32d69 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8ffa015fac R14: 00007f8ffa015fa0 R15: 00007f8ffa015fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:jbd2_journal_dirty_metadata+0x4a/0xd30 fs/jbd2/transaction.c:1520
Code: 00 fc ff df e8 07 27 29 ff 4c 89 fd 48 c1 ed 03 42 80 7c 35 00 00 74 08 4c 89 ff e8 f0 61 94 ff 49 8b 1f 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 d7 61 94 ff 48 89 1c 24 4c 8b 2b
RSP: 0018:ffffc90003766bc0 EFLAGS: 00010256
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888035c3dc40
RDX: 0000000000000000 RSI: ffff88805927b9f8 RDI: ffff888034ddbf20
RBP: 1ffff110069bb7e4 R08: ffffffff9030a1f7 R09: 1ffffffff206143e
R10: dffffc0000000000 R11: fffffbfff206143f R12: dffffc0000000000
R13: 1ffff920006ecd94 R14: dffffc0000000000 R15: ffff888034ddbf20
FS:  000055556c64d500(0000) GS:ffff888125290000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557909eb6950 CR3: 000000007908f000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess), 4 bytes skipped:
   0:	e8 07 27 29 ff       	call   0xff29270c
   5:	4c 89 fd             	mov    %r15,%rbp
   8:	48 c1 ed 03          	shr    $0x3,%rbp
   c:	42 80 7c 35 00 00    	cmpb   $0x0,0x0(%rbp,%r14,1)
  12:	74 08                	je     0x1c
  14:	4c 89 ff             	mov    %r15,%rdi
  17:	e8 f0 61 94 ff       	call   0xff94620c
  1c:	49 8b 1f             	mov    (%r15),%rbx
  1f:	48 89 d8             	mov    %rbx,%rax
  22:	48 c1 e8 03          	shr    $0x3,%rax
* 26:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2b:	74 08                	je     0x35
  2d:	48 89 df             	mov    %rbx,%rdi
  30:	e8 d7 61 94 ff       	call   0xff94620c
  35:	48 89 1c 24          	mov    %rbx,(%rsp)
  39:	4c 8b 2b             	mov    (%rbx),%r13


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
