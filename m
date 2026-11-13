Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558584;
	b=CLBqzlq+Siy+CLr+nGrc2q0VwFKUz0bEiGxrEMQvPbbknfi2T43o12Wh9UUQlE4mLjIL
	 6bs3sc+jV2L1avbTEot5O9hWcDrTTepg/ovgfLAzaQCRrm7vG297IMm1/0PfwqUynnIbg
	 IP6AJK5kbDNrEnPGo00uoOxQ6UPbAOQoeY7XxMNpAUUFWjIossxkCV2wm5X1dL+c7ST8Y
	 ymm9KiH1pMP6u0pEPwWWb3PVWafU32H64OsTlt3ODttFL7ji9fUoblb/MQaXRKIEBNGM+
	 92ZnMuFv7YtzqEMBh++kQso3mKBA8UOW+t7L4085cnYHPMVXq/7PjUpBnRs3ppEQedA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558584;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=M1RalLg9Lt0k9t7OD+9IlcWm5GqT3IN6fsoV+q1/AHo=;
	b=quf35SHTnH/JjBdPIfOo8fCDKvgKLtmHI1E31qBi2lbOLXb2b6h7mGnH8q9TkxBGPwbv
	 gpW3lyP7WpD5c1cxU8/kPSbN42nQM7ZCKEfzaAqARDC85UxOuJ+pj7ljWwbnPZSCdX4oZ
	 PQ8k8jKLITw4+ZhPwWdAEs2ecMgF9wuYqksRFegyKufjHBzqfmEh8GitsJM3fz3XxTQoF
	 vb7F5iso4oHDIBY8xrRNstwJ0emJh58EZdejkz0VmRRKMW1n6me/qrV29A/nA2hvQqnJs
	 GcN5DbU8YRdGfYugQP3FQ2TindNuvmLiVwOFhsqizBgUT4bLQXm7vRVCosDlsY+sfkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76A060A3830
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 08:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D76A060A3830
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4e778acdbc6so923350b6e.3
        for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 00:29:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794558583; x=1795163383;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M1RalLg9Lt0k9t7OD+9IlcWm5GqT3IN6fsoV+q1/AHo=;
        b=gejMqHL97n5yX9fjTF7N6lGGiFEHtZ5Zr7DU8YmGfaJzEqdt6/jT6yHfEnjvNnCZUe
         4BwBj595WYZtRaNzrmKfbOwlFyPNivB9RO1O9BUtlX1e/AJtBX/u6kgE+8Iy1f40RB2T
         M8z+/j59mEf6DnGcAKQfmxBLCyZTxSlQkRIMjKfLoy0gqLfrSVWVcG24ha9ULRt+xUZX
         ajgDghqQYXlxEIaLj6KN819Hg2+0LwnnQxPXRRtqLzsfL26s8exxdVA/qt4IDRwXutpv
         XQTNlWoiFA3icsU+9R0sisRnPvhn4yUNFXwi+d12JIGQMH5DFnsJwWphPlYpNhHnJ8Mw
         2Gdw==
X-Forwarded-Encrypted: i=1; AL+hErGjMovO6siYZa9mUD5CMDPIiGfw09bLmhttCV3/8slv8QcVPEWlW2hS/gKTccOsOy+F3fRPR/8FuuPr@vger.kernel.org
X-Gm-Message-State: APuU4Z+ob4SBDfYCC2FPrXYBBI9yXVtzW6JypX8dfx4NlXlc3cOjRjet
	4TlhXzSZI3pTVBskI89InB+uXZCQJ9BB5aGudNZAyhDZ8j+hyRuAx7C/8xJ6Gx/ufIiz3/Bdei0
	UkEjopSaB+tLAiZhuj1unJ9G9wAbcsJhZAHy5G9mE84opanKwv22c11qSsUM=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:238a:b0:568:2816:c1c4 with SMTP id
 5614622812f47-56e647deedemr1396228b6e.35.1794558582939; Fri, 13 Nov 2026
 00:29:42 -0800 (PST)
Date: Fri, 13 Nov 2026 00:29:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af6ca76.ff6dfe28.557e.0025.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in start_this_handle
From: syzbot <syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com>
To: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7e1392a42ea2 Merge tag 'net-7.4-rc3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163a62c3580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cc6a7ee2d24d208
dashboard link: https://syzkaller.appspot.com/bug?extid=25d45c0bd716f2b794a7
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b79aad580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a501ad580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-7e1392a4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/77888612dedb/vmlinux-7e1392a4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99bd86cd6b67/bzImage-7e1392a4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/196af8ecb072/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=11e37fe1580000)

AI-generated root cause summary:
When setting a large extended attribute on an ext4 filesystem formatted with a
1KB block size, the ea_inode feature, and a minimum-sized JBD2 journal (1024
blocks), __ext4_xattr_set_credits() calculates a worst-case credit requirement
of up to 341 blocks (accounting for creating a new ea_inode, dereferencing an
old ea_inode, and metadata updates). However, for a 1024-block journal,
jbd2_max_user_trans_buffers() limits transaction payload credits to 334 blocks.
Because ext4 does not validate at mount time that the journal is large enough to
support the ea_inode feature nor limits requested credits in ext4_xattr_set(),
jbd2__journal_start() requests more credits than the journal allows, triggering
a WARN_ON(1) in start_this_handle() and returning -ENOSPC.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=25d45c0bd716f2b794a7

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com

ext4 filesystem being mounted at /0/file0 supports timestamps until 2038-01-19 (0x7fffffff)
JBD2: syz.0.17 wants too many credits credits:341 rsv_credits:0 max:334
------------[ cut here ]------------
1
WARNING: fs/jbd2/transaction.c:334 at start_this_handle+0x1e3f/0x21f0 fs/jbd2/transaction.c:334, CPU#0: syz.0.17/5590
Modules linked in:
CPU: 0 UID: 0 PID: 5590 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:start_this_handle+0x1e3f/0x21f0 fs/jbd2/transaction.c:334
Code: 8b 35 ed a2 2f 12 48 81 c6 20 09 00 00 48 c7 c7 c0 8c 48 8c 48 8b 94 24 90 00 00 00 48 8b 4c 24 38 41 89 d8 e8 62 c5 74 fe 90 <0f> 0b 90 b8 e4 ff ff ff e9 35 fe ff ff e8 8f 34 16 ff eb 05 e8 88
RSP: 0018:ffffc90001dc7500 EFLAGS: 00010246
RAX: 0000000000000047 RBX: 000000000000014e RCX: 0d7a67c029606f00
RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
RBP: ffffc90001dc77e0 R08: ffffc90001dc7287 R09: 1ffff920003b8e50
R10: dffffc0000000000 R11: fffff520003b8e51 R12: 0000000000000000
R13: 0000000000000c40 R14: dffffc0000000000 R15: 0000000000000155
FS:  000055557077c500(0000) GS:ffff88808a9f6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000013000 CR3: 0000000041ad4000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 jbd2__journal_start+0x2c0/0x5d0 fs/jbd2/transaction.c:502
 __ext4_journal_start_sb+0x205/0x780 fs/ext4/ext4_jbd2.c:126
 __ext4_journal_start fs/ext4/ext4_jbd2.h:238 [inline]
 ext4_xattr_set+0x221/0x340 fs/ext4/xattr.c:2557
 __vfs_setxattr+0x442/0x480 fs/xattr.c:223
 __vfs_setxattr_noperm+0x12a/0x660 fs/xattr.c:257
 vfs_setxattr+0x151/0x370 fs/xattr.c:344
 do_setxattr fs/xattr.c:662 [inline]
 filename_setxattr+0x296/0x630 fs/xattr.c:690
 path_setxattrat+0x408/0x450 fs/xattr.c:734
 __do_sys_setxattr fs/xattr.c:768 [inline]
 __se_sys_setxattr fs/xattr.c:764 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:764
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f918c1a94d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff574286f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f918c425fa0 RCX: 00007f918c1a94d9
RDX: 0000200000003d00 RSI: 0000200000003cc0 RDI: 0000200000003c80
RBP: 00007f918c23804e R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000ff10 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f918c425fac R14: 00007f918c425fa0 R15: 00007f918c425fa0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
