Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BF1136672
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791568463; cv=none; b=ltTugTKeFcm5i1lsM7LolMSXhFlOlPsYHW3zfiYMmQCpE53w9WvYcOMjmHimUjWpBKgNrJTLyJiSuSsnv63UsSPTMFyjRhGNyo3iwnUrchLog+mTEI6YJ+XQJEe+Gwsp1mDh3c29PUAu2OjGcCrthuQB5SZzk1dSIuqyOXPb/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791568463; c=relaxed/simple;
	bh=8RnH9GuPagBX6F9GffrrKe3MQ2cVs+r9jdOGWXAEbOg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=n8O0cVnTXmsKFcQSYaM1YqNFEzD7JQcg6qEeqXCt5wkS0/76eWtureARNJ/8sXXEKPJcv9PP+WGpwTNRl8SXyaPoJYAy1Vs8zZgilZ6SFeAi3hPrBwjD9TB+SYpRzRezBESNipWcONnb3EekPb/8z0zhWKy+vEafYgEWgZB/aDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a45b3f0bdfso82995b6e.1
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 10:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791568461; x=1792173261;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zPD9BdrlBaG5YPzJzYY3HFzR6feRrXbYDBkB6lUduvY=;
        b=YKSiS6cCPpULyHqnPgreKS6SAG7S3DQhwmA0YjOhW0dJUbL9pyhGEvyNNvxl44L5D9
         hSnTkk1gwCWxiIUgs+2Y1NqfTECGckAzQgq3S2CNLz3+nJJ3n5YWWLl1AH25lGJcMEOC
         neSnpzGVDuPbsv+aJXnHQiFTWHDvMURBNLulM+4Q39zPKZaXO7qRU4zdATtXN9qmHgyq
         yU8D6KwgDS2ztBkFUU+KVUsfFF8ib0oja4hVd4o7bhdvKzbn4N6ALAryzYCRhPeqOsKo
         yLZ4YFjqitmwHo3j54WzzER16BuhzodauAlpzCZhAIsKnZtzQXx3t6ZFiqd49m4zz/K1
         09kw==
X-Forwarded-Encrypted: i=1; AKwUvBzmyP4Ul5AFhoLNP3Xiu6NQ6p2dvNTu+CExMcyadYzqTWKPhfHpuw3jlC8Cc3I+BjcDkc+HvtfJ0CbC@vger.kernel.org
X-Gm-Message-State: AFuF++k4AyTaXd+rxKvXUIIEDVNTHWnm0Nn4T41eA12qVQnDCfbqnU1d
	Lha/eOmCqbQc0dhovC1V7R+qTVXFYxqCcNPUftFuZxabySdRNx/zo0iAMHbDVV7HORPjKrWcL33
	amX6EQuv8Mac3HYdX5d7DaMGNJaHLkLpayc/lCOolC6SkeZjZPZlkLMOXTfE=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1304:b0:4f4:9314:af39 with SMTP id
 5614622812f47-50c54170c5dmr2039521b6e.28.1791568460765; Fri, 09 Oct 2026
 10:54:20 -0700 (PDT)
Date: Fri, 09 Oct 2026 10:54:20 -0700
In-Reply-To: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com>
Subject: [syzbot ci] Re: ext4: use iomap for regular file's buffered I/O path
From: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, chengzhihao1@huawei.com, djwong@kernel.org, 
	hch@infradead.org, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	tytso@mit.edu, wangkefeng.wang@huawei.com, yangerkun@huawei.com, 
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com, yizhang089@gmail.com, 
	yukuai@fnnas.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v7] ext4: use iomap for regular file's buffered I/O path
https://lore.kernel.org/all/20261009103033.2920530-1-yi.zhang@huaweicloud.com
* [PATCH v7 01/31] ext4: simplify size updating in ext4_setattr()
* [PATCH v7 02/31] ext4: factor out ext4_truncate_[up|down]()
* [PATCH v7 03/31] ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
* [PATCH v7 04/31] ext4: recheck extent status tree before block allocation
* [PATCH v7 05/31] ext4: fix orig_mlen initialization in ext4_map_blocks()
* [PATCH v7 06/31] ext4: allow ext4_map_blocks() to start its own transaction handle
* [PATCH v7 07/31] ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents
* [PATCH v7 08/31] ext4: skip block allocation for holes in the data submission path
* [PATCH v7 09/31] ext4: add iomap address space operations for buffered I/O
* [PATCH v7 10/31] ext4: implement buffered read path using iomap
* [PATCH v7 11/31] ext4: pass out extent seq counter when mapping da blocks
* [PATCH v7 12/31] ext4: do not use data=ordered mode for inodes using buffered iomap path
* [PATCH v7 13/31] ext4: implement buffered write path using iomap
* [PATCH v7 14/31] ext4: rework handle credit accounting for unwritten extent conversion
* [PATCH v7 15/31] ext4: implement writeback path using iomap
* [PATCH v7 16/31] ext4: implement mmap path using iomap
* [PATCH v7 17/31] ext4: implement partial block zero range path using iomap
* [PATCH v7 18/31] ext4: drain writeback before removing extents on the iomap path
* [PATCH v7 19/31] ext4: add block mapping tracepoints for iomap buffered I/O path
* [PATCH v7 20/31] ext4: disable online defrag when inode using iomap buffered I/O path
* [PATCH v7 21/31] ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
* [PATCH v7 22/31] ext4: submit and wait for pending disksize-grow I/O on writeback
* [PATCH v7 23/31] ext4: advance i_disksize to i_size upon disksize-grow I/O completion
* [PATCH v7 24/31] ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
* [PATCH v7 25/31] ext4: submit and wait for disksize-grow I/O in fallocate paths
* [PATCH v7 26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate or error
* [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
* [PATCH v7 28/31] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
* [PATCH v7 29/31] ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
* [PATCH v7 30/31] ext4: partially enable iomap for the buffered I/O path of regular files
* [PATCH v7 31/31] ext4: introduce a mount option for iomap buffered I/O path

and found the following issue:
WARNING in ext4_do_writepages

Full report is available here:
https://ci.syzbot.org/series/3711c951-acf4-4ebe-a920-9cc89b6be2ff

***

WARNING in ext4_do_writepages

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      3d399224425573875b6f6f1181bd8cf9a28cc7d1
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/c3c01f8c-846d-4c7a-955a-fd7427af6b0d/config

------------[ cut here ]------------
!err
WARNING: fs/ext4/inode.c:2512 at ext4_do_writepages+0x33b3/0x44a0, CPU#0: kworker/u9:3/147
Modules linked in:
CPU: 0 UID: 0 PID: 147 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: writeback wb_workfn (flush-7:1)
RIP: 0010:ext4_do_writepages+0x33b3/0x44a0
Code: 0f 0b 90 e9 b6 d9 ff ff e8 6a e2 36 ff 90 0f 0b 90 e9 e6 dc ff ff e8 5c e2 36 ff 90 0f 0b 90 e9 94 df ff ff e8 4e e2 36 ff 90 <0f> 0b 90 bb ea ff ff ff e9 ae f8 ff ff e8 3b e2 36 ff 48 8d 3d 64
RSP: 0018:ffffc90003106ce0 EFLAGS: 00010293
RAX: ffffffff8290e912 RBX: 0000000000000000 RCX: ffff8881053f9e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900031070f0 R08: ffff888025da4a37 R09: 1ffff11004bb4946
R10: dffffc0000000000 R11: ffffed1004bb4947 R12: ffffc900031071a0
R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff11004bb495d
FS:  0000000000000000(0000) GS:ffff88818d6c9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555565a5a28 CR3: 0000000031f66000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ext4_writepages+0x241/0x3b0
 do_writepages+0x338/0x560
 __writeback_single_inode+0x136/0x1220
 writeback_sb_inodes+0x9de/0x1b00
 wb_writeback+0x41c/0xad0
 wb_workfn+0x431/0x10f0
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
