From: Jeff Merkey <linux.mdb@gmail.com>
Subject: [BUG REPORT] NULL pointer dereference in jdb2_journal_grab_journal_head
 (RDI)
Date: Sat, 23 Jan 2016 09:42:52 -0700
Message-ID: <CAO6TR8Vhxjp-nX-wPXeBLOPmsHcb7_3y2uxk7x_V19o8hTZG0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If I leave the system in the debugger console overnight with all the
processors suspended for about 8 hours, then type go, the following
bug shows up during file I/O.  This particular bug showed up while
using git to update some branches.

I have only seen this bug once and I attempted to reproduce it to get
a trace dump but have not been able to trigger it again.  The NULL
pointer is RDI set to NULL while trying to obtain a lock.

(2)> .z grab_journal
ffffffffa00bb740 t jbd2_journal_grab_journal_head [jbd2]
(2)> u ffffffffa00bb740
jbd2|jbd2_journal_grab_journal_head:
0xffffffffa00bb740 0F1F440000      nop    DWORD PTR [rax+rax]=0x0
0xffffffffa00bb745 55              push   rbp
0xffffffffa00bb746 4889E5          mov    rbp,rsp
<<<<<<<<<<<<   Crashes here with RDI set to NULL
0xffffffffa00bb749 F00FBA2F18      lock bts DWORD PTR [rdi]=0x0,0x18
<<<<<<<<<<<<
0xffffffffa00bb74e 7219            jb
jbd2_journal_grab_journal_head+0x29 (0xffffffffa00bb769) (down)
0xffffffffa00bb750 488B07          mov    rax,QWORD PTR [rdi]=0x0
0xffffffffa00bb753 A900000200      test   eax,0x20000
0xffffffffa00bb758 741D            je
jbd2_journal_grab_journal_head+0x37 (0xffffffffa00bb777) (down)
0xffffffffa00bb75a 488B4740        mov    rax,QWORD PTR [rdi+64]=0x0
0xffffffffa00bb75e 83400801        add    DWORD PTR [rax+8]=0x0,0x1
0xffffffffa00bb762 F0806703FE      lock and BYTE PTR [rdi+3]=0x00,0xfe
0xffffffffa00bb767 5D              pop    rbp
0xffffffffa00bb768 C3              ret
0xffffffffa00bb769 F390            pause
0xffffffffa00bb76b 488B07          mov    rax,QWORD PTR [rdi]=0x0
0xffffffffa00bb76e A900000001      test   eax,0x1000000
0xffffffffa00bb773 75F4            jne
jbd2_journal_grab_journal_head+0x29 (0xffffffffa00bb769) (up)
0xffffffffa00bb775 EBD2            jmp
jbd2_journal_grab_journal_head+0x9 (0xffffffffa00bb749) (up)
0xffffffffa00bb777 31C0            xor    eax,eax

The backtrace showed this function being called from the swapper
thread when the crash occurred.   It's damn hard to reproduce.  If I
see it again, I'll get you a better trace.

Jeff
