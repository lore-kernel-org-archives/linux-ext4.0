Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE943C0630
	for <linux-ext4@vger.kernel.org>; Sat,  5 Sep 2026 10:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788604235; cv=none; b=F1FFOXITh0+wmBIEJg4n6EVlwDF9DZH/j5QPnukmoc6ADG32hj+q5XW8THj2fimnhj1TXtDYqHFyAVu6G0rb6e4jnGNfI0DTmODdwPrzgj5G/WH95cmjcuFN7FYaOYGX5WGol38V3BAgGp53Rx/6SyuSRGfues4vWQueBlgtWE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788604235; c=relaxed/simple;
	bh=KnT7J76VOs0JF4MkaqyU7PKqA4YcPl9vPwF1cPE55wM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bqd36QT/x1ESBL5oXs+EIA6vs9ho0O5k9BkEE0R+JV/A642Hmi0iBmtkE45KNSLmPpcXTanxK4yFKkLpcuQs6U1sLW42vM1qhnQhGlZlxTLNXgpWZ7EvI+eUPSJuYARV9hE1hxF8DeG2pf0JjHdHhjBOZcC5yqciEbm+n+SH9Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f6.google.com with SMTP id 006d021491bc7-6aafac56856so596399eaf.1
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2026 03:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788604232; x=1789209032;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2ikTUDMvgbs6Pvx2tv73p+QKcEhBgflCF3gftTATyaI=;
        b=ZAE/AI8BcJF5OPj1wqMIka5GpjUDyV8YgvREa36MZ9qzrGrTXJpHPEraXhO5xBXUZ0
         QG2sinyo/ZtHbg2Q9nhbaXu0ol3Fnfud784Wg0acGcbN/xCMjx/tKtdeGYH1FjgoyLMv
         Erx2DhAk2Md2Jv8tgos+AhC7SCRlTS6cgKb/SSVxX+f/IolmE4vHcZJNoEr2y83KZnLd
         NZfdtO9RdaZZ4y1em2os2O1AXYVC5k4H3SXEdcMSRODqRamae0fPtSee78wDY+lTm8Tr
         rto/XndQJDcAiIBR6uC2tiQNO1tIs5kBqBj5YmW9rwFS4yHJQdHTzhMO8VPT31qRt8x4
         v1Yw==
X-Forwarded-Encrypted: i=1; AKwUvBxIhqumSBtC5tR51+todZKm0oTjMbud09fe+xWXLhnVgIetx5A2qSD0lLmyyTYKkgHxjf6in/qn891g@vger.kernel.org
X-Gm-Message-State: AFuF++mMtiKceqM+Qh4FsgpuxBrncFt9KKBzUvMgTRwdkrGlL+GAhIRp
	2QFV/I0h6oibJVH6ia3MJpSAUDUn5yvp/cVIKJA7UlkYgnXquy1fE4ye/3qs5miMHRBqWo7/bl5
	JJYb6Jf0VuEni2EvPjzTLIXoqOuVNMXc4CZ7ExxwuMGDl1/2QMDOuIIT7bzk=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2019:b0:6b1:7251:41d5 with SMTP id
 006d021491bc7-6b6fabe1b66mr11573347eaf.3.1788604231940; Sat, 05 Sep 2026
 03:30:31 -0700 (PDT)
Date: Sat, 05 Sep 2026 03:30:31 -0700
In-Reply-To: <6a6a9895.7eebbf3c.214d51.000d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9bef47.37659fcc.e790.0002.GAE@google.com>
Subject: Re: [syzbot] [ext4?] possible deadlock in process_measurement (6)
From: syzbot <syzbot+c0bfa7a9a227036e8454@syzkaller.appspotmail.com>
To: dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	gregkh@linuxfoundation.org, jmorris@namei.org, linux-ext4@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, roberto.sassu@huawei.com, serge@hallyn.com, 
	syzkaller-bugs@googlegroups.com, zohar@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    654ae5d73c05 Merge tag 'drm-fixes-2026-09-05' of https://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14c568f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=c0bfa7a9a227036e8454
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c568f9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cc6b49580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/49c1a99f815b/disk-654ae5d7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6fcecf1b8c8d/vmlinux-654ae5d7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa54b23691ca/bzImage-654ae5d7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7be96c47c44b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12041125580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c0bfa7a9a227036e8454@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor428/5602 is trying to acquire lock:
ffff88803f38b458 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}, at: process_measurement+0x7e0/0x1c20 security/integrity/ima/ima_main.c:319

but task is already holding lock:
ffff888038eee198 (&common->filesem){++++}-{4:4}, at: fsg_store_file+0x163/0x400 drivers/usb/gadget/function/storage_common.c:452

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&common->filesem){++++}-{4:4}:
       down_read+0x97/0x200 kernel/locking/rwsem.c:1574
       fsg_show_file+0x2d/0x140 drivers/usb/gadget/function/storage_common.c:339
       fill_read_buffer fs/configfs/file.c:68 [inline]
       configfs_read_iter+0x2ba/0x620 fs/configfs/file.c:88
       __kernel_read+0x4d3/0x970 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api.c:300
       process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4839 [inline]
       path_openat+0x148a/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&p->frag_sem){.+.+}-{4:4}:
       down_read+0x97/0x200 kernel/locking/rwsem.c:1574
       fill_read_buffer fs/configfs/file.c:66 [inline]
       configfs_read_iter+0x1cf/0x620 fs/configfs/file.c:88
       __kernel_read+0x4d3/0x970 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api.c:300
       process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4839 [inline]
       path_openat+0x148a/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&buffer->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       configfs_read_iter+0x73/0x620 fs/configfs/file.c:86
       __kernel_read+0x4d3/0x970 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api.c:300
       process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4839 [inline]
       path_openat+0x148a/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x15ff/0x2e40 kernel/locking/lockdep.c:5254
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
       __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       process_measurement+0x7e0/0x1c20 security/integrity/ima/ima_main.c:319
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4839 [inline]
       path_openat+0x148a/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       file_open_name fs/open.c:1375 [inline]
       filp_open+0x16d/0x1d0 fs/open.c:1392
       fsg_lun_open+0x6c/0xe00 drivers/usb/gadget/function/storage_common.c:194
       fsg_store_file+0x19e/0x400 drivers/usb/gadget/function/storage_common.c:455
       flush_write_buffer fs/configfs/file.c:207 [inline]
       configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x61e/0xbb0 fs/read_write.c:687
       ksys_write+0x156/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ima_iint_mutex_key[depth] --> &p->frag_sem --> &common->filesem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&common->filesem);
                               lock(&p->frag_sem);
                               lock(&common->filesem);
  lock(&ima_iint_mutex_key[depth]);

 *** DEADLOCK ***

locks held by syz-executor428/5602: 4, last CPU#0:
 #0: ffff88801d734510 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #0: ffff88801d734510 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff888028b16678 (&buffer->mutex){+.+.}-{4:4}, at: configfs_write_iter+0x81/0x430 fs/configfs/file.c:226
 #2: ffff888025f30b68 (&p->frag_sem){.+.+}-{4:4}, at: flush_write_buffer fs/configfs/file.c:205 [inline]
 #2: ffff888025f30b68 (&p->frag_sem){.+.+}-{4:4}, at: configfs_write_iter+0x23b/0x430 fs/configfs/file.c:229
 #3: ffff888038eee198 (&common->filesem){++++}-{4:4}, at: fsg_store_file+0x163/0x400 drivers/usb/gadget/function/storage_common.c:452

stack backtrace:
CPU: 0 UID: 0 PID: 5602 Comm: syz-executor428 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x15ff/0x2e40 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
 mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
 process_measurement+0x7e0/0x1c20 security/integrity/ima/ima_main.c:319
 ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
 security_file_post_open+0xb3/0x260 security/security.c:2755
 do_open fs/namei.c:4839 [inline]
 path_openat+0x148a/0x1d60 fs/namei.c:5000
 do_file_open+0x23e/0x4a0 fs/namei.c:5029
 file_open_name fs/open.c:1375 [inline]
 filp_open+0x16d/0x1d0 fs/open.c:1392
 fsg_lun_open+0x6c/0xe00 drivers/usb/gadget/function/storage_common.c:194
 fsg_store_file+0x19e/0x400 drivers/usb/gadget/function/storage_common.c:455
 flush_write_buffer fs/configfs/file.c:207 [inline]
 configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f29897e19a9
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe566936c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00002000000002c0 RCX: 00007f29897e19a9
RDX: 0000000000000005 RSI: 00002000000003c0 RDI: 0000000000000005
RBP: 0000200000000200 R08: 00005555573c7560 R09: 00005555573c7560
R10: 00005555573c7560 R11: 0000000000000246 R12: 6769666e6f632f2e
R13: 0000000000000002 R14: 431bde82d7b634db R15: 00007f298984104b
 </TASK>
mass_storage.0/lun.0: file too small: file0


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
