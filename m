Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072083BB123
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 21:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509324; cv=none; b=gVkvPwVwn47HA9A2UIzXAbgSWEUq7VEINAZi6hXr+PxuZ/CKzTD5O8+p9Lxv8E8HEXie6LnNHwxL4HU2RsuSql+6YHPBQRW0CAZaBmJYwyN2CPL8QQyuwAsvS/gr+en0wuo6MCtX283WL6aS+BEYFoKjpeG5CK5r1f0zaRnwASk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509324; c=relaxed/simple;
	bh=SOwtcRRM5FOrUI77OMkSX3vr63Ma8EI7iVbBZ2b9OrI=;
	h=Message-ID:Date:Subject:To:Cc:Content-Type:MIME-Version:From; b=ncy28IusBmXahGkGU0BbRNlu5gYG9WrwvlIjpehpjaSX20PF1unrSgQy7vjaq5S5jWBANTAQ/RMthphvq0+T8TN67OJ6jgFyzQ1FdBCk9LEwKwmMRo5s3PWcG8MF3cpau3N22lQrKa4yoGeQT1f4lRV1E6ydjik8KOqfdF7/zNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o0KPPiE8; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0KPPiE8"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-9691a218debso25063241.0
        for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509322; x=1783114122; darn=vger.kernel.org;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xJYM1sF5Ggi6PGjRiR4T4a06Igua14lTbI33A7TeQ6s=;
        b=o0KPPiE8+Ma8xpjrVwGBJoNzYR/mZARJJiF/kUJduTVx+4DoakW9RzrylHzJz3YLUP
         u6gIMQRz8kb3sFKwYa85KclhaBOtIepn6AHi56W+H6xIN1UisVKEp3wwc23wYKRDHe1p
         vikQTmaUy49CrE3f59+GnCzEAH3zsVcVMS3QodKcXSp0+G+VyfQJydoGEKTltsxhN/y9
         +EokYCGc4zK+gzBhu25z3wr0cYzTKjIwvlMzBHqqpEU56Ci9aU7BZDiv/WPRw1ics39f
         v3rqdSZUd+mGOoi4KHSWW0FqF1JBRF/idD0EGXRe9+hPbru3Bi4ROcDToUoIkRcWMtdC
         nSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509322; x=1783114122;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xJYM1sF5Ggi6PGjRiR4T4a06Igua14lTbI33A7TeQ6s=;
        b=TezZIWGVUmW+ZqXS1WlmMkUunI8lB83izinZWn4DiTuAYlBJO+7o9sEn77uzWwAWnX
         z1e3Vv0mz/B/nVBgzsR9asM729fstBGVGvbRE6flPSSPLxjI0umCb702AXuFlj0Xe0wx
         Fuv5+ne7u4oaYI8tPDFGZ1k7tYW5PQDy8yKZkrcU/os6gabYSQJAEjXz8+ZE7PQx62aD
         FTKl19NDNZlOoqJ/SR69nJmdNfNTr4qzcn3TGZC7vedxfp9JZ18S1U+KvAgUmbNTLfrE
         GIi2LR/1LEBBiPAa5rNNyJW4MNL7mTsw4F8HPL7q3hx6+KshqZM9KrnffusuF9LZjXMJ
         Fw7Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqc7gKT2yLha6RyxPF+N/+Uaj9dz0Wy7FJJxCvvt2JM2vgr3kHPnu9bD4ufiBlpe7+QAVU6C3HY5LLp@vger.kernel.org
X-Gm-Message-State: AOJu0YzeCdtdxaYNmcSKAngPP09N42P8QGyFhAsSF/LF9FdXoeeW8Ylg
	hoeLNkS7MGDniSNv4FQkEzkQmTzbJcYCzRKho2+Tr+qZyCPKjusKBzIl
X-Gm-Gg: AfdE7cmfkRWp9xeguiBMrbDXdjuEwIzHT6H+jY0lhx7BAfjn7j0CDQj6CqAk8HABSki
	V0mvwF8nRdM4YFODt13E2ig4msxEhpgq681gwgGJa2/KZdqSKhlynY+zjNwFtgttUMpQ6ZNOj8G
	k9QSZ60kAZu1vflYduYFhVw5KnKfNKuVqeL031v8Gtxy0yNpmEPDS6l2ZDHqINl4/rOOS6+AcZn
	XMXqBScJPYw6MfbikjE8hcUsL+UkZ6rIPNzm+ACcviNafHaqBa3tHDL8TKhZCu2DvBD+XtEfFDN
	Y7UByxizSOfMCktTtoLxu18LXyI2rtltcze5yY3PUDfOYz+sRCIeg3moGNsP82g+Ez1MZzgyWVf
	RSGgVWQT7glavSi83IUJIsSsihaKPCMKxupQtpL+ADiYHt41KkEPGeM+ovF6TrtXaQgeQyDT1nv
	Yf9ial/P7VExdxcU0LtbPUgUqiwfh36sACY6IFtqmxQffFXEEIOFbTRVBl09oZ+WiDxclPjTjhq
	ANHJ9CSqFU0
X-Received: by 2002:a05:6102:5243:b0:62f:2f09:6039 with SMTP id ada2fe7eead31-734362ac3e3mr1191590137.6.1782509321863;
        Fri, 26 Jun 2026 14:28:41 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9691d41f195sm1373964241.9.2026.06.26.14.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:28:41 -0700 (PDT)
Message-ID: <6a3eef09.ade5411d.badf0.e59a@mx.google.com>
Date: Fri, 26 Jun 2026 14:28:41 -0700 (PDT)
Subject: possible deadlock in ext4_evict_inode
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: sanan.hasanou@gmail.com

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1pN21FuDB9QSbn_3jaZGO1S5v7x7Qe-yl>
Reproducer: <https://drive.google.com/open?id=1WQnqnRCTxYzJaxeqSi9G9fL8nP6ewP29>
Thank you!

Best regards,
Sanan Hasanov

======================================================
WARNING: possible circular locking dependency detected
7.0.0-rc1 #1 Not tainted
------------------------------------------------------
kswapd0/88 is trying to acquire lock:
ffff8880256a8600 (sb_internal){.+.+}-{0:0}, at: percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
ffff8880256a8600 (sb_internal){.+.+}-{0:0}, at: __sb_start_write include/linux/fs/super.h:19 [inline]
ffff8880256a8600 (sb_internal){.+.+}-{0:0}, at: sb_start_intwrite include/linux/fs/super.h:177 [inline]
ffff8880256a8600 (sb_internal){.+.+}-{0:0}, at: ext4_evict_inode+0x249/0xe10 fs/ext4/inode.c:216

but task is already holding lock:
ffffffff94e35f80 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6968 [inline]
ffffffff94e35f80 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x81d/0x23b0 mm/vmscan.c:7343

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4348 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4362
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4452 [inline]
       slab_alloc_node mm/slub.c:4807 [inline]
       __do_kmalloc_node mm/slub.c:5218 [inline]
       __kmalloc_noprof+0x9c/0x630 mm/slub.c:5231
       kmalloc_noprof include/linux/slab.h:966 [inline]
       find_tree_dqentry+0x5c/0x1080 fs/quota/quota_tree.c:663
       find_dqentry fs/quota/quota_tree.c:716 [inline]
       qtree_read_dquot+0x55b/0x7f0 fs/quota/quota_tree.c:736
       ocfs2_acquire_dquot+0x2b2/0xa90 fs/ocfs2/quota_global.c:838
       dqget+0x77c/0xe80 fs/quota/dquot.c:980
       dquot_set_dqblk+0x2b/0xfa0 fs/quota/dquot.c:2823
       quota_setquota+0x4b0/0x530 fs/quota/quota.c:310
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x27f/0x950 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #2 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       down_write+0x96/0x1e0 kernel/locking/rwsem.c:1590
       ocfs2_create_local_dquot+0x19d/0x1a30 fs/ocfs2/quota_local.c:1227
       ocfs2_acquire_dquot+0x787/0xa90 fs/ocfs2/quota_global.c:883
       dqget+0x77c/0xe80 fs/quota/dquot.c:980
       dquot_set_dqblk+0x2b/0xfa0 fs/quota/dquot.c:2823
       quota_setquota+0x4b0/0x530 fs/quota/quota.c:310
       __do_sys_quotactl fs/quota/quota.c:961 [inline]
       __se_sys_quotactl+0x27f/0x950 fs/quota/quota.c:917
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x11c/0x800 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x4b/0x53

-> #1 (&dquot->dq_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1ae/0x1ac0 kernel/locking/mutex.c:776
       dquot_release+0x66/0x5f0 fs/quota/dquot.c:534
       ext4_release_dquot+0x3ee/0x6c0 fs/ext4/ext4_jbd2.h:-1
       quota_release_workfn+0x344/0x5e0 fs/quota/dquot.c:843
       process_one_work kernel/workqueue.c:3275 [inline]
       process_scheduled_works+0xa55/0x15d0 kernel/workqueue.c:3358
       worker_thread+0xa28/0xf00 kernel/workqueue.c:3439
       kthread+0x338/0x400 kernel/kthread.c:467
       ret_from_fork+0x497/0xa10 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:245

-> #0 (sb_internal){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1591/0x2870 kernel/locking/lockdep.c:5237
       lock_acquire+0xe0/0x290 kernel/locking/lockdep.c:5868
       percpu_down_read_internal+0x48/0x1c0 include/linux/percpu-rwsem.h:53
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ext4_evict_inode+0x249/0xe10 fs/ext4/inode.c:216
       evict+0x55b/0xa00 fs/inode.c:846
       __dentry_kill+0x197/0x6b0 fs/dcache.c:670
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1147
       shrink_dentry_list+0x266/0x5a0 fs/dcache.c:1174
       prune_dcache_sb+0x10e/0x170 fs/dcache.c:1256
       super_cache_scan+0x365/0x4a0 fs/super.c:223
       do_shrink_slab+0x6ae/0x1080 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x2d9/0x720 mm/vmscan.c:4928
       shrink_many mm/vmscan.c:4989 [inline]
       lru_gen_shrink_node mm/vmscan.c:5067 [inline]
       shrink_node+0x3064/0x3930 mm/vmscan.c:6047
       kswapd_shrink_node mm/vmscan.c:6894 [inline]
       balance_pgdat mm/vmscan.c:7070 [inline]
       kswapd+0x12fe/0x23b0 mm/vmscan.c:7343
       kthread+0x338/0x400 kernel/kthread.c:467
       ret_from_fork+0x497/0xa10 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  sb_internal --> &ocfs2_quota_ip_alloc_sem_key --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(fs_reclaim);
  rlock(sb_internal);

 *** DEADLOCK ***

2 locks held by kswapd0/88:
 #0: ffffffff94e35f80 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6968 [inline]
 #0: ffffffff94e35f80 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x81d/0x23b0 mm/vmscan.c:7343
 #1: ffff8880256a80e0 (&type->s_umount_key#45){++++}-{4:4}, at: super_trylock_shared fs/super.c:565 [inline]
 #1: ffff8880256a80e0 (&type->s_umount_key#45){++++}-{4:4}, at: super_cache_scan+0x91/0x4a0 fs/super.c:198

stack backtrace:
CPU: 0 UID: 0 PID: 88 Comm: kswapd0 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2f8/0x340 kernel/locking/lockdep.c:2043
 check_noncircular+0x109/0x130 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1591/0x2870 kernel/locking/lockdep.c:5237
 lock_acquire+0xe0/0x290 kernel/locking/lockdep.c:5868
 percpu_down_read_internal+0x48/0x1c0 include/linux/percpu-rwsem.h:53
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_intwrite include/linux/fs/super.h:177 [inline]
 ext4_evict_inode+0x249/0xe10 fs/ext4/inode.c:216
 evict+0x55b/0xa00 fs/inode.c:846
 __dentry_kill+0x197/0x6b0 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1147
 shrink_dentry_list+0x266/0x5a0 fs/dcache.c:1174
 prune_dcache_sb+0x10e/0x170 fs/dcache.c:1256
 super_cache_scan+0x365/0x4a0 fs/super.c:223
 do_shrink_slab+0x6ae/0x1080 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x2d9/0x720 mm/vmscan.c:4928
 shrink_many mm/vmscan.c:4989 [inline]
 lru_gen_shrink_node mm/vmscan.c:5067 [inline]
 shrink_node+0x3064/0x3930 mm/vmscan.c:6047
 kswapd_shrink_node mm/vmscan.c:6894 [inline]
 balance_pgdat mm/vmscan.c:7070 [inline]
 kswapd+0x12fe/0x23b0 mm/vmscan.c:7343
 kthread+0x338/0x400 kernel/kthread.c:467
 ret_from_fork+0x497/0xa10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:245
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

SYZFAIL: failed to recv rpc
fd=3 want=4 recv=0 n=0 (errno 9: Bad file descriptor)

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
