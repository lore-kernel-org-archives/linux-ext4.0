From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104311] New: Out of bounds read in test suite of e2fsprogs
Date: Wed, 09 Sep 2015 15:23:41 +0000
Message-ID: <bug-104311-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36619 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbbIIPXp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2015 11:23:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AF1AD20A13
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2015 15:23:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3D15A20A05
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2015 15:23:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104311

            Bug ID: 104311
           Summary: Out of bounds read in test suite of e2fsprogs
           Product: File System
           Version: 2.5
    Kernel Version: 4.2.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
          Assignee: fs_ext2@kernel-bugs.osdl.org
          Reporter: hanno@hboeck.de
        Regression: No

Created attachment 187181
  --> https://bugzilla.kernel.org/attachment.cgi?id=187181&action=edit
fix tst_badblocks test memory access

When compiling e2fsprogs with address sanitizer enabled and run "make check" it
will show an out of bounds heap read error.

The reason is in the file tst_badblocks.c. The test arrays are supposed
to be zero-terminated (there's a loop iterating over them that will
cause the oob), however test2 doesn't have a zero at the end. Patch attached.

To reproduce:
./configure CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address"
make
make check

Error message:
==26295==ERROR: AddressSanitizer: global-buffer-overflow on address
0x00000063b3f0 at pc 0x0000004026c0 bp 0x7fff3876edd0 sp 0x7fff3876edc0
READ of size 4 at 0x00000063b3f0 thread T0
    #0 0x4026bf in create_test_list
(/mnt/ram/e2fsprogs-1.42.13/lib/ext2fs/tst_badblocks+0x4026bf)
    #1 0x40383d in main
(/mnt/ram/e2fsprogs-1.42.13/lib/ext2fs/tst_badblocks+0x40383d)
    #2 0x7fc4a97ad7af in __libc_start_main (/lib64/libc.so.6+0x207af)
    #3 0x4023f8 in _start
(/mnt/ram/e2fsprogs-1.42.13/lib/ext2fs/tst_badblocks+0x4023f8)

0x00000063b3f0 is located 0 bytes to the right of global variable 'test2'
defined in 'tst_badblocks.c:33:7' (0x63b3c0) of size 48
0x00000063b3f0 is located 48 bytes to the left of global variable 'test3'
defined in 'tst_badblocks.c:34:7' (0x63b420) of size 52
SUMMARY: AddressSanitizer: global-buffer-overflow ??:0 create_test_list
Shadow bytes around the buggy address:
  0x0000800bf620: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800bf630: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800bf640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800bf650: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0000800bf660: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0000800bf670: 00 04 f9 f9 f9 f9 f9 f9 00 00 00 00 00 00[f9]f9
  0x0000800bf680: f9 f9 f9 f9 00 00 00 00 00 00 04 f9 f9 f9 f9 f9
  0x0000800bf690: 00 00 00 00 00 f9 f9 f9 f9 f9 f9 f9 00 00 00 00
  0x0000800bf6a0: 00 00 00 00 00 00 00 00 00 04 f9 f9 f9 f9 f9 f9
  0x0000800bf6b0: 00 00 00 00 04 f9 f9 f9 f9 f9 f9 f9 00 00 00 00
  0x0000800bf6c0: 00 00 00 00 00 04 f9 f9 f9 f9 f9 f9 00 00 00 00
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Heap right redzone:      fb
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack partial redzone:   f4
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
==26295==ABORTING

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
