Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7A3932DB
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338705; cv=none; b=H7axEqVIszJkkOl+CMv5nBqnKKBQce4gGb6van5G2nPHmLWCKw0bpnajiqwxAKScUQafzJX1c0LVdfLFB/Sal199WS+l2s2hfkUejMJWkBJ+hFgZb1akvlu78hyWWGa/wIA9XhPXcPwrqO8PnZGhU9/JD7SlxNM6KfQMjusFBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338705; c=relaxed/simple;
	bh=QJ6PirdsrccNogK7BhUWp8PmrWBdQZhAR5fW/YLaIlk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iZdnnB/1Yku0Mi5tbD1L9rlJQMvShEV1qUgTlOxuzUALeFmpjOnfdGj61WCT0DTa8+TcNG14vhMtEOHaBqH3HrTIGAElIgLpIv4PPDjwU0pQdN1Llu6NMN2yN1j3ePjgcFb+UEnoPMORaQH083frBmpJfj0oYEv9ZgQxmDXwph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67ba8269efaso9251979eaf.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 11:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773338703; x=1773943503;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4nfAWwh7aAzWTYDWseO92ruE5hd32XoC52n75ECcy5A=;
        b=f9CdwlYkpwqavW/V8zSp/jyJCsxFV+/6wXQ9RxVA0qSauZrlJah8J8UD4uitbWOgsg
         Pc/hdfzjHkQ9Yhsm+OxbBC3A96zEVfnqmXljMIIUlOlddkGIFJU6JLvg77NfI1f8Kcfc
         Nk/okdbOTyMpD9gT2/u3DYunNAS/A6+S5C8qy0OKWeb2zEPAhRA5x02DRWoJit+Blu+z
         cJz07e0Ej1apaPUenJXtKZDfCLp8CTrtxS12IRR3ciMdQSWpiQsEE1nBzWjqXjjJp1CA
         owhfnbx2337pgXyi7JVttDUWeY1lXsX0PEl2t85kbS7ElCyLTYLxXf9ec3DrXwdPEAJT
         02yw==
X-Forwarded-Encrypted: i=1; AJvYcCXzRqZ8ZjkC4ydwN9S7YEgsuQ8wnUJM9Pnt8aTb188oc2uv+sVPd4K+69VrryEE+c1BUiJuwsy/uhfm@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6pdXmlDS2s8gDry0u9GpqDIZLWWr54TmmuDcyvymKs0IU4GTh
	3MoKlpuerOhuIdWEgCenVH2gg6tmDDskXtN07efaos4YuDH3Cyltk7AM5eSQuJtP9S20deczOG2
	hH8L9cQ8xk8Xd5ZFNOzw8zGfyPBjB07rIcc/YK7FrQUKKVYMcaxgR7904rCk=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:98f:b0:67a:405:7ffc with SMTP id
 006d021491bc7-67bda983ab1mr202033eaf.5.1773338702886; Thu, 12 Mar 2026
 11:05:02 -0700 (PDT)
Date: Thu, 12 Mar 2026 11:05:02 -0700
In-Reply-To: <abL7zFZvQv9yddtu@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b3004e.050a0220.102acc.0000.GAE@google.com>
Subject: Re: [syzbot] [ext4?] kernel BUG in ext4_es_cache_extent (4)
From: syzbot <syzbot+ccf1421545dbe5caa20c@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in ext4_es_cache_extent

EXT4-fs warning (device loop0): ext4_mb_new_blocks:6274: inode #15: comm syz.0.55: ext4_mb_new_blocks: Allocation requested for: lblk:0 len:1
EXT4-fs warning (device loop0): ext4_mb_regular_allocator:3120: inode #15: comm syz.0.55: ext4_mb_regular_allocator: Best len 1, origin len 1, ac_status 2, ac_flags 0xa0, cr 5 ret 0
------------[ cut here ]------------
kernel BUG at fs/ext4/extents_status.c:1057!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 6693 Comm: syz.0.55 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/27/2026
RIP: 0010:ext4_es_cache_extent+0x8eb/0xa10 fs/ext4/extents_status.c:1057
Code: e1 07 80 c1 03 38 c1 0f 8c 51 fe ff ff 48 8b 7c 24 18 e8 f8 54 af ff e9 42 fe ff ff e8 ee 19 47 ff 90 0f 0b e8 e6 19 47 ff 90 <0f> 0b 65 8b 1d 70 7b 6e 10 bf 07 00 00 00 89 de e8 10 1e 47 ff 83
RSP: 0018:ffffc900041aec20 EFLAGS: 00010293
RAX: ffffffff827d24ba RBX: 0000000000000060 RCX: ffff88802d9f3d00
RDX: 0000000000000000 RSI: 0000000000000064 RDI: 0000000000000060
RBP: ffffc900041aed80 R08: ffff88807eaeca47 R09: 1ffff1100fd5d948
R10: dffffc0000000000 R11: ffffed100fd5d949 R12: 0000000000000008
R13: dffffc0000000000 R14: 000000000000000f R15: 0000000000000064
FS:  00007fca40bd36c0(0000) GS:ffff888125866000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000011000 CR3: 000000007715a000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ext4_cache_extents+0x143/0x2f0 fs/ext4/extents.c:540
 __read_extent_tree_block+0x3b8/0x580 fs/ext4/extents.c:587
 ext4_find_extent+0x5bb/0xa20 fs/ext4/extents.c:942
 ext4_ext_map_blocks+0x27a/0x5730 fs/ext4/extents.c:4285
 ext4_map_query_blocks+0x13b/0xa00 fs/ext4/inode.c:553
 ext4_map_blocks+0x444/0x11d0 fs/ext4/inode.c:771
 _ext4_get_block+0x1e3/0x470 fs/ext4/inode.c:909
 ext4_get_block_unwritten+0x2e/0x100 fs/ext4/inode.c:942
 ext4_block_write_begin+0xb14/0x1950 fs/ext4/inode.c:1196
 ext4_write_begin+0xb40/0x1870 fs/ext4/ext4_jbd2.h:-1
 ext4_da_write_begin+0x355/0xd30 fs/ext4/inode.c:3123
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4314
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:299
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:686
 ksys_pwrite64 fs/read_write.c:793 [inline]
 __do_sys_pwrite64 fs/read_write.c:801 [inline]
 __se_sys_pwrite64 fs/read_write.c:798 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:798
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca3fd9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fca40bd3028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007fca40016090 RCX: 00007fca3fd9c799
RDX: 00000000200000c1 RSI: 00002000000000c0 RDI: 0000000000000006
RBP: 00007fca3fe32bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000009000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca40016128 R14: 00007fca40016090 R15: 00007ffe8193e178
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ext4_es_cache_extent+0x8eb/0xa10 fs/ext4/extents_status.c:1057
Code: e1 07 80 c1 03 38 c1 0f 8c 51 fe ff ff 48 8b 7c 24 18 e8 f8 54 af ff e9 42 fe ff ff e8 ee 19 47 ff 90 0f 0b e8 e6 19 47 ff 90 <0f> 0b 65 8b 1d 70 7b 6e 10 bf 07 00 00 00 89 de e8 10 1e 47 ff 83
RSP: 0018:ffffc900041aec20 EFLAGS: 00010293
RAX: ffffffff827d24ba RBX: 0000000000000060 RCX: ffff88802d9f3d00
RDX: 0000000000000000 RSI: 0000000000000064 RDI: 0000000000000060
RBP: ffffc900041aed80 R08: ffff88807eaeca47 R09: 1ffff1100fd5d948
R10: dffffc0000000000 R11: ffffed100fd5d949 R12: 0000000000000008
R13: dffffc0000000000 R14: 000000000000000f R15: 0000000000000064
FS:  00007fca40bd36c0(0000) GS:ffff888125866000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000011000 CR3: 000000007715a000 CR4: 0000000000350ef0


Tested on:

commit:         4f5e8e6f et4: allow zeroout when doing written to unwr..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
console output: https://syzkaller.appspot.com/x/log.txt?x=1236cd52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a535ad5429f72a2
dashboard link: https://syzkaller.appspot.com/bug?extid=ccf1421545dbe5caa20c
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1696cd52580000

