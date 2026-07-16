Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2ED34F27F
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784188230; cv=none; b=OV9XwsaDTLOsBTsAixf9BcUYnSOHy6Z/x3Yec2QA3f8ydvvgaGgeLILc/3qUOsqxtzB4d/rK3UNLA6ouoNL0Ev8yutBWtVMJOQyf8PuLxme0JmasAg5Uz+6DJW9AyqI2OJrWqMN+2FA0NKkL1YYxh8uvyP/F4Z1ShOlH0lW1r4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784188230; c=relaxed/simple;
	bh=vDuRJp5BjNTLdA+wz/Ma7U64C66pGtDGfvXZm5iSjT4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EoTnSJwsiHk3q8/H+AFsTUaxS99VVGoaoy4NFLMXpGDfA5RR4hSfPR2lnCJv9dYB/4C85VM/1z/dbVoy/9MgIZJEjaQPiZ0xRgGCtmtnekX+RfupXJHV0OoBA0rkM1JiPjZ0C8hx4Iq8fFAdLXmbv7PSRpbGJUIAiksuwKzKHr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6a1240143d0so7787243eaf.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 00:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784188228; x=1784793028;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HFluiFjByJbHTrsxFOo+leQd0OWf5APLNwABxoG1YJ0=;
        b=CLqPV6FSBilwGAd6HMqRDVgTlumvBl8xvVHtER3oUztFGumCO5U55hx28Przz5GUIf
         LKyO2iuPnNLbtVjyV7xKeEIqvYgok9B7rwwi60W12V5x3H1crCfsnbTvX542pHzlh+y0
         Wk8hZc3cQRgWpnArxmqgD48p40HVZukYvkybnv9Z9p1nzZiMkCSCzHt2KK4PvuU9zJws
         8L0T4LspxouuUlEBFJWBu8ZkOsJPUqZoMvM4Zs864RdsZmq1v8gJcm5R3QemW//uF8U5
         zimcM1MVtVG1IEE3XwZS01JToQbfBejIdOpZDJ5m7Y2/0zwUjN0c5oKoQRwRqtnqFydo
         1rZQ==
X-Forwarded-Encrypted: i=1; AHgh+RrkiRgEIYzhaflgnQr4071ahD1RNLlTlj9Kwvn9HCqDnJE9/AuuxnqpSNoQjqYSz9pCKRLQUdK6f6eQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzwZKs3YLWjOw0Bbns9LYw8lD1LPIBOvF2M7ubiIh7eK+x+te7D
	0nLtACkafA40QGvPU0MenhvPTrEh8MMEhJCcuRioXcFmK7z0zQl35xzA8/Dg0NRSK++ilT5vPHi
	7WZbyBUY6fUcZA9lvUA7WolTjNdTDMgphT7JjcM7ux7TI0hLkivzh7k58Bhg=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d0c:b0:6a2:739a:cea6 with SMTP id
 006d021491bc7-6a3da04fc6dmr4038713eaf.54.1784188228350; Thu, 16 Jul 2026
 00:50:28 -0700 (PDT)
Date: Thu, 16 Jul 2026 00:50:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a588d44.c96faac9.59e0.0012.GAE@google.com>
Subject: [syzbot] [ext4?] kernel BUG in ext4_write_inline_data_end (3)
From: syzbot <syzbot+293a57918b36cfae3d48@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a13c140cc289 Linux 7.2-rc3
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11d48789580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ecdef466b08b9772
dashboard link: https://syzkaller.appspot.com/bug?extid=293a57918b36cfae3d48
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e444b9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b40dd0e99ac8/disk-a13c140c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ef230d7959b/vmlinux-a13c140c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a593476d5c20/Image-a13c140c.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/172c5a39071b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12e444b9580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+293a57918b36cfae3d48@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ext4/inline.c:815!
Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 20668 Comm: syz.0.3283 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/02/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : ext4_write_inline_data_end+0x8fc/0x9d8 fs/ext4/ext4.h:3790
lr : ext4_has_inline_data fs/ext4/ext4.h:3790 [inline]
lr : ext4_write_inline_data_end+0x8fc/0x9d8 fs/ext4/inline.c:815
sp : ffff800090e575c0
x29: ffff800090e57670 x28: dfff800000000000 x27: ffff7000121caebc
x26: 0000000000000000 x25: ffff0000e01554b0 x24: fffffdffc3c2a340
x23: ffff800090e575e0 x22: 0000000000000023 x21: 0000000600080000
x20: ffff0000e01556a0 x19: 0000000000000023 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 00000000200000c0
x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: ffff60001c02aa97 x9 : 0000000000000000
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff8000810066e8
x2 : 0000000000000000 x1 : ffff0000c4c28000 x0 : 0000000000000000
Call trace:
 ext4_has_inline_data fs/ext4/ext4.h:3790 [inline] (P)
 ext4_write_inline_data_end+0x8fc/0x9d8 fs/ext4/inline.c:815 (P)
 ext4_write_end+0x320/0x9e0 fs/ext4/inode.c:1455
 ext4_da_write_end+0x90/0xba0 fs/ext4/inode.c:3297
 generic_perform_write+0x504/0x7a4 mm/filemap.c:4379
 ext4_buffered_write_iter+0xd0/0x2ec fs/ext4/file.c:316
 ext4_file_write_iter+0x1dc/0x134c fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739
 __do_sys_write fs/read_write.c:750 [inline]
 __se_sys_write fs/read_write.c:747 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
Code: c8097f28 35ffffa9 17fffe38 97d939e6 (d4210000) 
---[ end trace 0000000000000000 ]---


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
