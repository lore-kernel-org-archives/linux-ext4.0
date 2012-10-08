From: Peter Moody <pmoody@google.com>
Subject: Oops with ext(3|4) and audit and Xen
Date: Mon, 8 Oct 2012 11:19:53 -0700
Message-ID: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d646a6614c6404cb9046ce
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46391 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab2JHSUZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 14:20:25 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so4312719wib.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 11:20:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e6d646a6614c6404cb9046ce
Content-Type: text/plain; charset=ISO-8859-1

Hey folks,

I'm trying to track down a BUG() that seems to strike a particular
system configuration (unfortunately, an increasingly common
configuration), but does so with 100% reliability.

The system in question is a Xen instance (6 vcpus, 32G memory) running
3.2 on essentially stock ubuntu (10.04) system.

if I run the attached program with the crash dir set to any ext3 or
ext4 file system with any audit rules installed, I get an oops on the
second time through the while loop:

kernel BUG at fs/buffer.c:1267!
invalid opcode: 0000 [#1] SMP
CPU 1
Pid: 4146, comm: a.out Not tainted 3.2.5-will-break-2-ganetixenu #4
RIP: e030:[<ffffffff81696a6c>]  [<ffffffff81696a6c>] check_irqs_on.part
.10+0x17/0x19
RSP: e02b:ffff8807c7339bf8  EFLAGS: 00010096
RAX: 000000000000001e RBX: ffff8807970840b0 RCX: 00000000000000e7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: ffff8807c7339bf8 R08: 0000000000000000 R09: 0000000000000018
R10: 0000000000006a5d R11: 0000000000000001 R12: 0000000000000400
R13: ffff8807dee05040 R14: ffff8807c7339dc0 R15: 0000000000000124
FS:  00007fe7cde057c0(0000) GS:ffff8807fff44000(0063) knlGS:00000000000
00000
CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f76dc4b0 CR3: 00000007a769a000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 4146, threadinfo ffff8807c7338000, task ffff8807ab3
496b0)
Stack:
 ffff8807c7339c68 ffffffff81161dc9 ffff8807c7339c90 ffff8807b6b909f0
 ffff8807ab23901a ffff8807c7339d60 ffff880700000000 ffff8807c7339d30
 ffff8807c7339d60 ffff8807c7339e78 ffff8807970840b0 0000000000000400
Call Trace:
 [<ffffffff81161dc9>] __find_get_block+0x1f9/0x200
 [<ffffffff81164c8f>] __getblk+0x1f/0x280
 [<ffffffff811f35bb>] __ext4_get_inode_loc+0x10b/0x410
 [<ffffffff81124935>] ? kmem_cache_alloc+0xa5/0x150
 [<ffffffff811f9857>] ? ext4_evict_inode+0x177/0x450
 [<ffffffff811f4cc7>] ext4_get_inode_loc+0x17/0x20
 [<ffffffff811f75a8>] ext4_reserve_inode_write+0x28/0xa0
 [<ffffffff811f9815>] ? ext4_evict_inode+0x135/0x450
 [<ffffffff811f7673>] ext4_mark_inode_dirty+0x53/0x200
 [<ffffffff811f9857>] ext4_evict_inode+0x177/0x450
 [<ffffffff8114bfb1>] evict+0xa1/0x1a0
 [<ffffffff8114cc61>] iput+0x101/0x210
 [<ffffffff81148040>] d_kill+0xf0/0x130
 [<ffffffff81148bd2>] dput+0xd2/0x1b0
 [<ffffffff8113eb85>] path_put+0x15/0x30
 [<ffffffff81693e39>] audit_free_names+0x96/0xb5
 [<ffffffff810ac629>] audit_syscall_exit+0x139/0x1e0
 [<ffffffff816a076a>] sysexit_audit+0x21/0x5f
Code: 5c 48 89 df e8 b6 20 ab ff 5b 41 5c 5d c3 55 48 89 e5 0f 0b 55 be
 08 00 00 00 48 c7 c7 c4 fe a0 81 31 c0 48 89 e5 e8 91 cb ff ff <0f>
0b 55 48 89 e5 0f
 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55
RIP  [<ffffffff81696a6c>] check_irqs_on.part.10+0x17/0x19
 RSP <ffff8807c7339bf8>

line 1267 of fs/buffer.c is

static inline void check_irqs_on(void)
{
#ifdef irqs_disabled
	BUG_ON(irqs_disabled());
#endif
}

If I run the same code on the same system with the same audit rule(s)
on an ext2 filesystem, I get no such oops.

So it seems like something either in the ext3/ext4 or Xen codepath is
disabling interrupts. I'm getting an updated test Xen instance to test
on, but I while I'm waiting on that, I wanted to see if anyone one
here might have an idea of the ext3/4 codepath. whether something
there is doing the interrupt disabling or if there might be some other
race condition going on. I haven't had a chance to test with the large
"ext4 updates for v3.7" tytso recently posted, but I'll be doing that
later today in case something there fixes this.

So, does any one have any thoughts and/or pointers which might help me
get to the bottom of this?

Cheers,
peter

-- 
Peter Moody      Google    1.650.253.7306
Security Engineer  pgp:0xC3410038

--0016e6d646a6614c6404cb9046ce
Content-Type: text/x-csrc; charset=US-ASCII; name="crasher.c"
Content-Disposition: attachment; filename="crasher.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h81wh77p0

LyoKICogc3RlcHM6CiAqICAxKSBjb21waWxlIHdpdGggZ2NjIC1tMzIKICogIDIpIHN0YXJ0IGF1
ZGl0ZCwgaW5zdGFsbCBhbnkgcnVsZS4KICogICAgIC9ldGMvaW5pdC5kL2F1ZGl0ZCBzdGFydCA7
IGF1ZGl0Y3RsIC1EIDsgYXVkaXRjdGwgLWEgZXhpdCxhbHdheXMgLUYgYXJjaD1iNjQgLVMgY2ht
b2QKICogIDMpIHJ1biduIHdhaXQgKHRoaXMgb25seSBsb29wcyB0d2ljZSBmb3IgbWUgYmVmb3Jl
IGR5aW5nKQogKiAgICAgLi9hLm91dAogKiAgNCkgYmFzayBpbiBpbnN0YW50YW5lb3VzIGtlcm5l
bCBidWdzLgogWyAgNTcxLjI4Mjc3N10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tCiBbICA1NzEuMjgyNzg2XSBrZXJuZWwgQlVHIGF0IGZzL2J1ZmZlci5jOjEyNjMhCiBbICA1
NzEuMjgyNzkwXSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFNNUAogWyAgNTcxLjI4Mjc5NV0g
bGFzdCBzeXNmcyBmaWxlOiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9zY2hlZF9tY19wb3dlcl9z
YXZpbmdzCiBbICA1NzEuMjgyNzk4XSBDUFUgMAogWyAgNTcxLjI4MjgwMl0gUGlkOiA3NDU3LCBj
b21tOiBhLm91dCBOb3QgdGFpbnRlZCAyLjYuMzguOC1nZzg2OC1nYW5ldGl4ZW51ICMxCiBbICA1
NzEuMjgyODA4XSBSSVA6IGUwMzA6WzxmZmZmZmZmZjgxMTUzODUzPl0gIFs8ZmZmZmZmZmY4MTE1
Mzg1Mz5dIF9fZmluZF9nZXRfYmxvY2srMHgxZjMvMHgyMDAKIFsgIDU3MS4yODI4MTldIFJTUDog
ZTAyYjpmZmZmODgwNzliN2RkYzc4ICBFRkxBR1M6IDAwMDEwMDQ2CiBbICA1NzEuMjgyODIyXSBS
QVg6IGZmZmY4ODA3YmMyOTAwMDAgUkJYOiBmZmZmODgwNmQ5YmI5YTk4IFJDWDogMDAwMDAwMDAw
MjNkYzE3YwogWyAgNTcxLjI4MjgyNl0gUkRYOiAwMDAwMDAwMDAwMDAxMDAwIFJTSTogMDAwMDAw
MDAwMjNkYzE3YyBSREk6IGZmZmY4ODA3ZmVjMjlhMDAKIFsgIDU3MS4yODI4MzBdIFJCUDogZmZm
Zjg4MDc5YjdkZGNkOCBSMDg6IDAwMDAwMDAwMDAwMDAwMDEgUjA5OiBmZmZmODgwNmQ5YmI5OWMw
CiBbICA1NzEuMjgyODM0XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAw
MDAwIFIxMjogZmZmZjg4MDZkOWJiOTljNAogWyAgNTcxLjI4MjgzOV0gUjEzOiBmZmZmODgwNmQ5
YmI5OWYwIFIxNDogZmZmZjg4MDdmZWZmOTA2MCBSMTU6IDAwMDAwMDAwMDIzZGMxN2MKIFsgIDU3
MS4yODI4NDVdIEZTOiAgMDAwMDdmOGY2YTc2YTdjMCgwMDAwKSBHUzpmZmZmODgwN2ZmZjI2MDAw
KDAwNjMpIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKIFsgIDU3MS4yODI4NDldIENTOiAgZTAzMyBE
UzogMDAyYiBFUzogMDAyYiBDUjA6IDAwMDAwMDAwODAwNTAwM2IKIFsgIDU3MS4yODI4NTNdIENS
MjogMDAwMDAwMDBmNzZjNjk3MCBDUjM6IDAwMDAwMDA3YTI1MGIwMDAgQ1I0OiAwMDAwMDAwMDAw
MDAyNjYwCiBbICA1NzEuMjgyODU3XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAw
MDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMAogWyAgNTcxLjI4Mjg2MV0gRFIzOiAwMDAw
MDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDAK
IFsgIDU3MS4yODI4NjZdIFByb2Nlc3MgYS5vdXQgKHBpZDogNzQ1NywgdGhyZWFkaW5mbyBmZmZm
ODgwNzliN2RjMDAwLCB0YXNrIGZmZmY4ODA3Nzg2ODQzZTApCiBbICA1NzEuMjgyODcwXSBTdGFj
azoKIFsgIDU3MS4yODI4NzJdICBmZmZmODgwNzliN2RkYzk4IGZmZmZmZmZmODE2NTRjZDEgZmZm
Zjg4MDc5YjdkZGNhOCBmZmZmODgwNmQ5YmJhNDQwCiBbICA1NzEuMjgyODc5XSAgZmZmZjg4MDc5
YjdkZGQwOCBmZmZmZmZmZjgxMWM5Mjk0IGZmZmY4ODA3ZmZmZmZmYzMgMDAwMDAwMDAwMDAwMDAx
NAogWyAgNTcxLjI4Mjg4N10gIGZmZmY4ODA2ZDliYjlhOTggZmZmZjg4MDZkOWJiOTljNCBmZmZm
ODgwNmQ5YmI5OWYwIGZmZmY4ODA3ZmVmZjkwNjAKIFsgIDU3MS4yODI4OTVdIENhbGwgVHJhY2U6
CiBbICA1NzEuMjgyOTAxXSAgWzxmZmZmZmZmZjgxNjU0Y2QxPl0gPyBkb3duX3JlYWQrMHgxMS8w
eDMwCiBbICA1NzEuMjgyOTA3XSAgWzxmZmZmZmZmZjgxMWM5Mjk0Pl0gPyBleHQzX3hhdHRyX2dl
dCsweGY0LzB4MmIwCiBbICA1NzEuMjgyOTEzXSAgWzxmZmZmZmZmZjgxMWJhZjg4Pl0gZXh0M19j
bGVhcl9ibG9ja3MrMHgxMjgvMHgxOTAKIFsgIDU3MS4yODI5MThdICBbPGZmZmZmZmZmODExYmIx
MDQ+XSBleHQzX2ZyZWVfZGF0YSsweDExNC8weDE2MAogWyAgNTcxLjI4MjkyM10gIFs8ZmZmZmZm
ZmY4MTFiYmMwYT5dIGV4dDNfdHJ1bmNhdGUrMHg4N2EvMHg5NTAKIFsgIDU3MS4yODI5MjhdICBb
PGZmZmZmZmZmODEyMTMzZjU+XSA/IGpvdXJuYWxfc3RhcnQrMHhiNS8weDEwMAogWyAgNTcxLjI4
MjkzM10gIFs8ZmZmZmZmZmY4MTFiYzg0MD5dIGV4dDNfZXZpY3RfaW5vZGUrMHgxODAvMHgxYTAK
IFsgIDU3MS4yODI5MzhdICBbPGZmZmZmZmZmODExNDA2NWY+XSBldmljdCsweDFmLzB4YjAKIFsg
IDU3MS4yODI5NDVdICBbPGZmZmZmZmZmODEwMDZkNTI+XSA/IGNoZWNrX2V2ZW50cysweDEyLzB4
MjAKIFsgIDU3MS4yODI5NDldICBbPGZmZmZmZmZmODExNDBjMTQ+XSBpcHV0KzB4MWE0LzB4Mjkw
CiBbICA1NzEuMjgyOTU1XSAgWzxmZmZmZmZmZjgxMTNlZDA1Pl0gZHB1dCsweDI2NS8weDMxMAog
WyAgNTcxLjI4Mjk1OV0gIFs8ZmZmZmZmZmY4MTEzMjQzNT5dIHBhdGhfcHV0KzB4MTUvMHgzMAog
WyAgNTcxLjI4Mjk2NV0gIFs8ZmZmZmZmZmY4MTBhNWQzMT5dIGF1ZGl0X3N5c2NhbGxfZXhpdCsw
eDE3MS8weDI2MAogWyAgNTcxLjI4Mjk3MV0gIFs8ZmZmZmZmZmY4MTAzZWQ5YT5dIHN5c2V4aXRf
YXVkaXQrMHgyMS8weDVmCiBbICA1NzEuMjgyOTc0XSBDb2RlOiA4MiAwMCAwNSAwMSAwMCA4NSBj
MCA3NSBkZSA2NSA0OCA4OSAxYyAyNSAwMCAwNSAwMSAwMCBlOSA4NyBmZSBmZiBmZiA0OCA4OSBk
ZiBlOCBlOSBmYyBmZiBmZiA0YyA4OSBmNyBlOSAwMiBmZiBmZiBmZiAwZiAwYiBlYiBmZSA8MGY+
IDBiIGViIGZlIDBmIDBiIGViIGZlIDBmIDFmIDQ0IDAwIDAwIDU1IDQ4IDg5IGU1IDQxIDU3IDQ5
IDg5CiBbICA1NzEuMjgzMDI3XSBSSVAgIFs8ZmZmZmZmZmY4MTE1Mzg1Mz5dIF9fZmluZF9nZXRf
YmxvY2srMHgxZjMvMHgyMDAKIFsgIDU3MS4yODMwMzNdICBSU1AgPGZmZmY4ODA3OWI3ZGRjNzg+
CiBbICA1NzEuMjgzMDM2XSAtLS1bIGVuZCB0cmFjZSA1OTc1ZmZlMjA4MDhlY2QyIF0tLS0KICoK
ICovCgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxz
eXMvdHlwZXMuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKI2RlZmluZSBLSUxMRElSICIvdG1wL2tp
bGxfZGlyL2EiCgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpIHsKICBGSUxFICpmOwog
IGNoYXIgZnVsbHBhdGhbNTEyXSwgKmtkaXIgPSBLSUxMRElSOwogIGludCBpID0gMDsKCiAgaWYg
KGFyZ2MgPiAxKSB7CiAgICBrZGlyID0gYXJndlsxXTsKICB9CiAgZnByaW50ZihzdGRlcnIsICJj
cmFzaGluZyBpbiAlc1xuIiwga2Rpcik7CgogIHdoaWxlICgxKSB7CiAgICBmcHJpbnRmKHN0ZGVy
ciwgIiVkICIsIGkrKyk7CiAgICBta2RpcihrZGlyLCAwNzc3KTsKICAgIGNoZGlyKGtkaXIpOwog
ICAgc3ByaW50ZihmdWxscGF0aCwgIiVzL2ZpbGUiLCBrZGlyKTsKICAgIGYgPSBmb3BlbihmdWxs
cGF0aCwgIncrIik7CiAgICBmcHJpbnRmKGYsICJub3RoaW5nIHRvIHNlZSBoZXJlIik7CiAgICBm
Y2xvc2UoZik7CiAgICB1bmxpbmsoZnVsbHBhdGgpOwogICAgcm1kaXIoa2Rpcik7CiAgICBpZiAo
aSA+IDEwMCkKICAgICAgYnJlYWs7CiAgfQogIHJldHVybiAwOwp9Cg==
--0016e6d646a6614c6404cb9046ce--
