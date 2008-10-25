From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: v2.6.28-rc1: Regression in ext3/jbd
Date: Sat, 25 Oct 2008 13:22:45 +0200
Message-ID: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Jan Kara" <jack@ucw.cz>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	"Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>,
	"Pekka Enberg" <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org
To: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>,
	"Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:42141 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYJYLWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2008 07:22:47 -0400
Received: by wa-out-1112.google.com with SMTP id v27so666577wah.21
        for <linux-ext4@vger.kernel.org>; Sat, 25 Oct 2008 04:22:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Sorry in advance for the huge Cc, most of it is from the commit.]

Hi,

This commit:

commit 2d7c820e56ce83b23daee9eb5343730fb309418e
Author: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date:   Wed Oct 22 14:15:01 2008 -0700

    ext3: add checks for errors from jbd

introduces a regression which was discovered by kmemcheck:

WARNING: kmemcheck: Caught 32-bit read from freed memory (f4f1b804)
00b0f1f4fbffffff404439ef008830f20200000097970000ad4eaddeffffffff
 i i i i f f f f f f f f f f f f f f f f f f f f f f f f f f f f
         ^

Pid: 9550, comm: umount Not tainted (2.6.28-rc1 #58) 945P-A
EIP: 0060:[<c05bdf38>] EFLAGS: 00010246 CPU: 0
EIP is at __journal_abort_soft+0x18/0xa0
EAX: f4f1b800 EBX: f4f1b800 ECX: c0462799 EDX: fffffffb
ESI: fffffffb EDI: f4f1a800 EBP: f145dea8 ESP: c25699c8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: f6c1d704 CR3: 31448000 CR4: 00000650
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c05bdfc8>] journal_abort+0x8/0x10
 [<c0589eb5>] ext3_abort+0xb5/0xc0
 [<c058a300>] ext3_put_super+0x160/0x230
 [<c04ec02a>] generic_shutdown_super+0x5a/0xe0

In particular, this hunk is guilty:

-       journal_destroy(sbi->s_journal);
+       if (journal_destroy(sbi->s_journal) < 0)
+               ext3_abort(sb, __func__, "Couldn't clean up the journal");

because journal_destroy() will free the journal regardless of whether
it returned < 0 or not. And then ext3_abort() makes some calls that
dereference the (freed) journal. These are the line numbers for the
backtrace:

addr2line -e vmlinux -i c05bdf38 c05bdfc8 c0589eb5 c058a300 c04ec02a
fs/jbd/journal.c:1502
fs/jbd/journal.c:1560
fs/ext3/super.c:284
fs/ext3/super.c:397
fs/super.c:307

(as of e013e13bf605b9e6b702adffbe2853cfc60e7806 in Linus's tree).

I hope this helps.


Vegard
