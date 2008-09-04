From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: oops during unmount - ext3? (2.6.27-rc5)
Date: Thu, 4 Sep 2008 21:14:03 +0200
Message-ID: <20080904191356.GA7799@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:48753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbYIDTOp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2008 15:14:45 -0400
Received: by ug-out-1314.google.com with SMTP id c2so52206ugf.37
        for <linux-ext4@vger.kernel.org>; Thu, 04 Sep 2008 12:14:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi
2 days ago 2.6.27-rc5 oopsed on halt with this call trace:

dispose_list
invalidate_inodes
generic_shutdown_super
kill_block_super
? deactivate_super
mntput_no_expire
sys_umount
system_call_fastpath

Code: f8 ff 48 89 df e8 bd 19 01 00 48 83 bb 90 02 00 00 00 74 04 0f 0b eb fe 48 8b 83 b8 03 00 00 a8 20 75 04 0f 0b eb fe a8 40 74 04 <0f> 0b eb fe 48 c7 c7 7a a0 57 80 be 56 00 00 00 e8 56 31 f8 ff

RIP clear_inode

Output of decodecode:
/tmp/tmp.To8z8HQ0uE.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   f8                      clc
   1:   ff 48 89                decl   -0x77(%rax)
   4:   df e8                   fucomip %st(0),%st
   6:   bd 19 01 00 48          mov    $0x48000119,%ebp
   b:   83 bb 90 02 00 00 00    cmpl   $0x0,0x290(%rbx)
  12:   74 04                   je     0x18
  14:   0f 0b                   ud2a
  16:   eb fe                   jmp    0x16
  18:   48 8b 83 b8 03 00 00    mov    0x3b8(%rbx),%rax
  1f:   a8 20                   test   $0x20,%al
  21:   75 04                   jne    0x27
  23:   0f 0b                   ud2a
  25:   eb fe                   jmp    0x25
  27:   a8 40                   test   $0x40,%al
  29:   74 04                   je     0x2f

/tmp/tmp.To8z8HQ0uE.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   0f 0b                   ud2a
   2:   eb fe                   jmp    0x2
   4:   48 c7 c7 7a a0 57 80    mov    $0xffffffff8057a07a,%rdi
   b:   be 56 00 00 00          mov    $0x56,%esi
  10:   e8 56 31 f8 ff          callq  0xfffffffffff8316b

You can see partial screenshot and .config at http://www.kadu.net/~joi/kernel/2008.09.04/

It might be related to http://lkml.org/lkml/2008/9/3/405 - I'm not sure.
2 bugs related to VFS and/or ext3 in 2 days (I'm running .27 since rc1)

Marcin
