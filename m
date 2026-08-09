Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A03911D5
	for <linux-ext4@vger.kernel.org>; Sun,  9 Aug 2026 19:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786302770; cv=none; b=SJFBz17xujC9AnGrbDYUbZT+knifGso6L/+qFt/RTum7y+RtzbRdwoqMxrfG68HFdiE/zE0S7mAbZ/P8c5GGUoHKy8tOrOHUzXptbo7SWAi2wLBU1PoQuGoD9U1AeM7gnKNw3cSPQf78yyzohlXAILGYaEaSbNqHYmlXSrOCm9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786302770; c=relaxed/simple;
	bh=fPvinxA54imzdT3QU+qBV6bpd1Gy3ctxiCJZDtS+/yM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=V5js2xBUuj/HThRS+xG79vbtAZPAE/yMFpflTV/J5nprx2z9DkHeZo9spiVOAOLSe8GPaRPJjwyO0UhWUS6rU6sNANFGSi/Pavg+a77uIhoS0/MvlWjdjae1rmfQZqOnmbeZArCvRuB/W0gPJ9bZ1rUZFUf1JtF7jlV6jMKVzts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7eb6a8c61deso1025616a34.3
        for <linux-ext4@vger.kernel.org>; Sun, 09 Aug 2026 12:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786302764; x=1786907564;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PkZkDYRMiXb223Ypl5INSPCUQWRoz7cIQd6t9TboElo=;
        b=FRgl4laB7xjMt/u8hERmjIJwh4z6Lnflsiqv4L7TJ3kGQz2jAbbiP+OVFzs6GzvaPf
         hQWvyyZ9sSQb0V9EgXgNNcOYMv1WFKGMhZFvNsib2NHOIGRkiN6HD30nnucN2a4EaY62
         yU9TUnutbUt+Nm/PL0qSmJIZVwpL7GPaAwwI3CPqIn08m3nvz1T/TeFLBxbpc1mzwkBz
         mIVd1PAN9BwPrK2wr7Y6HaYOQqtWMT0i7tPR/vA1DB9wgpi5DycAaiuNmOUY2tscfxqb
         bKYS4engj2ohdVQe+SRwSE8zw8NkCr3hLeCl6WQlEyXQMb5+rH9/oeAVvJZquAfTTbIj
         lS0w==
X-Forwarded-Encrypted: i=1; AHgh+RpTChYoWxpOftzYhAlB3ELNQnHVs/FP+8FOARyXburt6peEQZfH2iuG5UeISVW6y+DI/6QxbXZPashq@vger.kernel.org
X-Gm-Message-State: AOJu0YzSODrEWSN8PjwHVU92TOzxMTGofEORVh0sj4n55YUX2s2NhbIi
	atiIC/v5/cGzK0DZHLknvQLugLSpi0ijBaWldpDEcb4nIm+9QcNVjKCCKJbW5oss+r09EppC4km
	xnDTq+bKBAVyY93JWU+jJKF/z+0ocg/sOqjL37LqsQFgZ72KEADX11Lbtm+s=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:308b:b0:6ae:4131:98c6 with SMTP id
 006d021491bc7-6b041ee0bb8mr6842764eaf.2.1786302764212; Sun, 09 Aug 2026
 12:12:44 -0700 (PDT)
Date: Sun, 09 Aug 2026 12:12:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a78d12c.01d0871a.3a0d52.008f.GAE@google.com>
Subject: [syzbot] [bcache?] [ext4?] KASAN: use-after-free Read in register_bcache
From: syzbot <syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com>
To: colyli@fnnas.com, colyli@fygo.io, kent.overstreet@linux.dev, 
	linux-bcache@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ba5cc80fd326 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17767fb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccf4bea59f67007
dashboard link: https://syzkaller.appspot.com/bug?extid=cb5b32abe226710cdd8a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f67fb9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cd8149580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/959ad5f4e730/disk-ba5cc80f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0787d25f251e/vmlinux-ba5cc80f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2e85c36fabac/Image-ba5cc80f.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/130fa1cc1a68/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=111f8079580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb5b32abe226710cdd8a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in crc64_be_generic lib/crc/crc64-main.c:47 [inline]
BUG: KASAN: use-after-free in crc64_be+0xb8/0xe8 lib/crc/crc64-main.c:68
Read of size 1 at addr ffff0000dd543000 by task syz.0.33/4986

CPU: 1 UID: 0 PID: 4986 Comm: syz.0.33 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/02/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xb0/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0x8c/0xc4 mm/kasan/report.c:595
 __asan_report_load1_noabort+0x20/0x2c mm/kasan/report_generic.c:378
 crc64_be_generic lib/crc/crc64-main.c:47 [inline]
 crc64_be+0xb8/0xe8 lib/crc/crc64-main.c:68
 bch_crc64 drivers/md/bcache/util.h:529 [inline]
 read_super drivers/md/bcache/super.c:208 [inline]
 register_bcache+0x9a4/0x13d8 drivers/md/bcache/super.c:2601
 kobj_attr_store+0x6c/0x90 lib/kobject.c:840
 sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739
 __do_sys_write fs/read_write.c:750 [inline]
 __se_sys_write fs/read_write.c:747 [inline]
 __arm64_sys_write+0x84/0x98 fs/read_write.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:738
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:757
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000dd543af0 pfn:0x11d543
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 05ffc00000000000 fffffdffc3754688 fffffdffc3755348 0000000000000000
raw: ffff0000dd543af0 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000dd542f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff0000dd542f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff0000dd543000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff0000dd543080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff0000dd543100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
bcache: register_bcache() error : Bad checksum


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
