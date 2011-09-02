From: Andreas Dilger <adilger@whamcloud.com>
Subject: e2fsck sigcatcher breaks valgrind
Date: Fri, 2 Sep 2011 11:38:09 -0600
Message-ID: <A1043F1C-DAAD-4FAB-B8F4-82AB00E21DEF@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44592 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1IBRiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 13:38:13 -0400
Received: by gxk21 with SMTP id 21so2325050gxk.19
        for <linux-ext4@vger.kernel.org>; Fri, 02 Sep 2011 10:38:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was reading Eric's recent commit message in "next" about how he used
e2fsprogs "./test_script --valgrind" to find the uninitialized memory and
thought I would try it myself.  To my dismay it was failing on my system with:

==2806==    at 0x3566A0F5BE: __libc_sigaction (in /lib64/libpthread-2.12.2.so)
==2806==    by 0x4321A3: sigcatcher_setup (sigcatcher.c:224)
==2806==    by 0x40F4DE: main (unix.c:1027)
==2806==  Address 0x7fefffe18 is on thread 1's stack
==2806==
==2806== Syscall param rt_sigaction(act->sa_mask) points to uninitialised byte(s)

After a bunch of testing as to why this system was not working correctly,
it turns out that the problem is in the later commit 9b3018a82e843d.
Reverting that commit fixes the problem and allows --valgrind tests to pass.



I also noticed (for Lukas), "./test_script --valgrind i_e2image" fails with:

i_e2image: Create/convert raw and qcow2 disk images: ./i_e2image/script: line 2: test: too many arguments

That is due to:

   if test -x $E2IMAGE; then

expanding to:

   if test -x valgrind -q --sim-hints=lax-ioctls ../misc/e2image; then

It probably needs some parameter manipulation to check only the last parameter.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



