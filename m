Received: from mail-oi2-f3.google.com (mail-oi2-f3.google.com [74.125.231.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D20B49E12F
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 19:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790104601; cv=none; b=jtpcQ7mhERsGiTpZ5JAH9mVE07WTgeCHHkSS6sd1PBTI9dEC5MXnFIuJ513etOafdhVL88A2QWfuK3ifpspnNyUQMcXt6nbd74rOezaf6vxRVfRi8Pek3N/79JGXMVqqfUd1CS48qSbTm+Fe/44Q+0zWM7dzAJbAjvNs5AT74WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790104601; c=relaxed/simple;
	bh=b+Ywp/ZpyrIEnfefheNfEPIdjdCipyAZgtHf9lV3LmY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=edrbZAUi9Ub8zXIK9HECLwq/QnFVwQ179nU3Gcjol/X8y8Y5bZArMSBCfuLVNBbwNbAFAMWw2cUQtqmaW8Rpxyg3aH1ITE/+O79RlZm6e9Yu0B8PSSF1o6jeCEDkJlqShgeAdcIvzTYFSe36bQD+tLw/rywzLE4MwIt9v4YXGLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f3.google.com with SMTP id 5614622812f47-4b38a6e8c79so87044b6e.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 12:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790104599; x=1790709399;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/gMM6g+OJzqMhgZJMjF9K5DY01VFcArJtblxa3kjwiQ=;
        b=F474s28v+Et+0C8SqUP15ZGhqL/kR+P8roZm8wq1p9ZId2/DLhMafh/dRhBvPcXqIl
         FmXRu+PUklZr55WesOuD8TD0Wyi4pnuzrBsu3/cu6N/kHQTA8q0q9AO4kn4Y8gzsLWYf
         Kl1Zc7jw9C8fctgkO+Zdyzqh3UdU4GTBitoAAzwtU8/VZ8eSkztFYUXbA+sz1J6z7A5R
         aKFC7IowBX7iiRcnhSAi5dbdofLmVTWVcD2O+AuNI84CHOc0uS2igz8/1Jw6NwIolrSI
         R/9njaVjxk7ypbX9lFXx+8WXfDeAuntKBjvE1OaL33X7gHyjUkLqCv6t+vO5gDY9kiXM
         NeEg==
X-Forwarded-Encrypted: i=1; AKwUvBx+ZoAF6y3cZp53pAAC+UWOU3D0FwXTz2YhhBsdW8OXPXmlyhXFPPjaF2GpY0VEvPv54xW/lGZuRL5I@vger.kernel.org
X-Gm-Message-State: AFuF++kkDXtUTTLXNLsXM+ax7iu3RurzBbprYod7yFbZcyEWmlNkS6m3
	jSfk4eaBTDSP858HL8iTDUWFDkDEzNRK3eRskyrOCqvmlNQuhIAKF57qHlpb0BWclxGktoYRXwu
	hEHnnZLIshmqOvbeT+CEyMNTXP32MzQRYCPVHXTKMyZu84F/8ZmDhi7Rvlzw=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d0b:b0:6c2:4f65:3e87 with SMTP id
 006d021491bc7-6d2d043c4a7mr301765eaf.34.1790104598940; Tue, 22 Sep 2026
 12:16:38 -0700 (PDT)
Date: Tue, 22 Sep 2026 12:16:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab2d416.45639fcc.16cae0.0000.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in ext4_write_inode (4)
From: syzbot <syzbot+77d4c409352d8b3a015e@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5dd1818b15d9 Merge tag 'for-next-keys-v7.3-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=150017f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3bddd52b22c2498
dashboard link: https://syzkaller.appspot.com/bug?extid=77d4c409352d8b3a015e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5dd1818b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa126b13cb66/vmlinux-5dd1818b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e10c187acaf6/bzImage-5dd1818b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77d4c409352d8b3a015e@syzkaller.appspotmail.com

------------[ cut here ]------------
current->flags & PF_MEMALLOC
WARNING: fs/ext4/inode.c:5879 at ext4_write_inode+0x2af/0x350 fs/ext4/inode.c:5879, CPU#0: kswapd0/77
Modules linked in:
CPU: 0 UID: 0 PID: 77 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ext4_write_inode+0x2af/0x350 fs/ext4/inode.c:5879
Code: 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 e3 9d 34 ff e8 fe 78 9f fe bd fb ff ff ff eb d9 e8 d2 9d 34 ff 90 <0f> 0b 90 eb ce e8 c7 9d 34 ff bd fb ff ff ff eb c2 e8 bb 9d 34 ff
RSP: 0018:ffffc90000af6ef0 EFLAGS: 00010293
RAX: ffffffff829345be RBX: dffffc0000000000 RCX: ffff88801d340000
RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff907a667f R09: 1ffffffff20f4ccf
R10: dffffc0000000000 R11: ffffffff82934310 R12: ffff88801d34002c
R13: ffff8880520aaf90 R14: 0000000000000800 R15: ffff88801d340000
FS:  0000000000000000(0000) GS:ffff88808c2c3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa506dff000 CR3: 000000000eb48000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 write_inode fs/fs-writeback.c:1608 [inline]
 __writeback_single_inode+0x69d/0x1220 fs/fs-writeback.c:1851
 writeback_single_inode+0x544/0xf70 fs/fs-writeback.c:1926
 write_inode_now+0x1c2/0x290 fs/fs-writeback.c:3080
 iput_final fs/inode.c:2005 [inline]
 iput+0x98b/0xf00 fs/inode.c:2064
 dentry_kill+0x1b9/0x880 fs/dcache.c:826
 shrink_kill fs/dcache.c:1275 [inline]
 shrink_dentry_list+0x209/0x310 fs/dcache.c:1292
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1374
 super_cache_scan+0x35f/0x4a0 fs/super.c:225
 do_shrink_slab+0x6d0/0x10e0 mm/shrinker.c:445
 shrink_slab_memcg mm/shrinker.c:562 [inline]
 shrink_slab+0x838/0x1220 mm/shrinker.c:640
 shrink_one+0x2a2/0x730 mm/vmscan.c:5119
 shrink_many mm/vmscan.c:5180 [inline]
 lru_gen_shrink_node mm/vmscan.c:5258 [inline]
 shrink_node+0x35d0/0x3e30 mm/vmscan.c:6247
 kswapd_shrink_node mm/vmscan.c:7101 [inline]
 balance_pgdat mm/vmscan.c:7279 [inline]
 kswapd+0x185e/0x32c0 mm/vmscan.c:7555
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
