Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA248CD5E
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403908; cv=none; b=qaYQa0sqSd99Sq54ET0tlOa2s+LpEQchKwjxtq0mq4UchyNAMxEFb25MyQH1XanHrrRUS5jM9eZnr/53gLRpO2LHAFd01kCr3SVgtHovdvuR86rEtWm6TNfk/0TWSII1XZzvdXVGrtnBw7AynabsXwd052h2HcIWm3p8rAuN1fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403908; c=relaxed/simple;
	bh=23d7+x2zm6cvtYou9WH/kKCprswvTWnpYnPNRkmpps0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n+wYW3BaZXiMVqFoAlzuTMwnJYH0c3mnA/2zVHLehb2iE1XVoGDAiT3XHZdwg/Gfjms1bhzjU+dsnXR4bQJ4bZVsC6eFsiHhWPMt0gllvgewUAcy7G/MDpzTLTqqTBHRwWSVeLhWBl+2016AGA3gcrGxkWxQqr9QdsklfWCaKys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f6.google.com with SMTP id 006d021491bc7-6b1b8f5a1d5so664790eaf.1
        for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 09:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789403905; x=1790008705;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YU7qZKeyKs8K9w4inWh1hQOv9aWTGkQRcwK+vaqSvlo=;
        b=UuD1A2b1qB2LmsSCr41+gRr03i9ArF0ae+qh6JEDDgCgKXAiDJiqk5mgDl0/D3Odc/
         NkISiFOG6kJe47A+bAJNKoSDMHqwbCYiRilMJZ/HCC5KCRrj6EWuFBEq/KzQD8AZDUVh
         XZHO9kkEyrNkY+37yTFn6eKJ7rreTHfOSLd5SqVrOaHItsMV7Atl04OC8A8z25XvpKCU
         TW4Cxq0nRf8J1dCE9jAGcrx7oAmYq71nhFdg7aYyWFas3XDSQAfyaqigmmLzN4npqvGo
         q1shgYLs+XLC2mh7eZcLkm1+DOj8buAj3Wn1lDZbrJ4aYJt5rTDCb/lblPKz2msxTJl3
         tH4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxthV+awU9PpUJGlV8+Xq6a/kvuWXxVxovJDWfOPnyyra4/POyk33+sT/Aa9TKorIuf+seOkC90T48B@vger.kernel.org
X-Gm-Message-State: AFuF++niVKyo9bOzB4D//ycXNnyAdYJLnIu7B36AOooTHvduQNqO8S8L
	C/onlRBdKm/1ncVsblO7Wc89hIW+zd60SZ4ap7itulcnhBYNgiLnNypQasuH9OV0WZO/E07lJNY
	7qVA2dhM1eueC891tIWj9taC9vLlUlK1IgZTVw5imYeNseTyC5xoVHicuE4w=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c05:b0:6bd:f333:7b83 with SMTP id
 006d021491bc7-6c53f97770emr1996125eaf.16.1789403905366; Mon, 14 Sep 2026
 09:38:25 -0700 (PDT)
Date: Mon, 14 Sep 2026 09:38:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa82301.a211d2ce.1a5198.0297.GAE@google.com>
Subject: [syzbot] [ext4?] KASAN: use-after-free Read in ext4_read_inline_data (2)
From: syzbot <syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2f0c1cf72f46 Merge tag 's390-7.3-3' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14fcc115580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=085a394c92518a04fd09
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=151135f9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fcc115580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2ceccb470aef/disk-2f0c1cf7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/66118825dd52/vmlinux-2f0c1cf7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ab86c4814e1b/bzImage-2f0c1cf7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2b7927e0529e/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1188e925580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com

=========
==================================================================
BUG: KASAN: use-after-free in ext4_read_inline_data+0x1c9/0x2b0 fs/ext4/inline.c:213
Read of size 68 at addr ffff8880723bf51a by task syz-executor313/5649

CPU: 1 UID: 0 PID: 5649 Comm: syz-executor313 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 ext4_read_inline_data+0x1c9/0x2b0 fs/ext4/inline.c:213
 ext4_read_inline_dir+0x320/0xc20 fs/ext4/inline.c:1422
 ext4_readdir+0x46c/0x4250 fs/ext4/dir.c:164
 iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
 __do_sys_getdents64 fs/readdir.c:399 [inline]
 __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f74cc073df3
Code: 48 0f 45 c2 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 c7 c2 d0 ff ff ff f7 d8
RSP: 002b:00007fff22d6b888 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 0000555562e4b9d0 RCX: 00007f74cc073df3
RDX: 0000000000008000 RSI: 0000555562e4ba00 RDI: 0000000000000005
RBP: 0000555562e4ba00 R08: 00007f74cc0e35a0 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000293 R12: 0000555562e4b9d4
R13: ffffffffffffffd0 R14: 0000000000000016 R15: 431bde82d7b634db
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x723bf
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0001c86008 ffffea0001c8ef88 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x500cc2(GFP_HIGHUSER|__GFP_ACCOUNT), pid 5495, tgid 5495 (sshd-session), ts 69474537754
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_pages_mpol+0x21e/0x390 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof+0xb1/0x2b0 mm/mempolicy.c:2577
 anon_pipe_prefill_and_lock fs/pipe.c:158 [inline]
 anon_pipe_write+0x21b/0x1a30 fs/pipe.c:534
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5499 tgid 5499 ts 69475806887 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __folio_put+0x4b3/0x590 mm/folio.c:105
 folio_put include/linux/mm.h:2160 [inline]
 put_page include/linux/mm.h:2229 [inline]
 anon_pipe_trim_and_unlock+0x3e2/0x520 fs/pipe.c:191
 anon_pipe_read+0xf1c/0x10c0 fs/pipe.c:472
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880723bf400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880723bf480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880723bf500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                            ^
 ffff8880723bf580: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880723bf600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
