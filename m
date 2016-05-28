From: Bruce Dubbs <bruce.dubbs@gmail.com>
Subject: e2fsprogs-1.43 make check failures
Date: Sat, 28 May 2016 16:36:50 -0500
Message-ID: <574A0F72.6020609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35074 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcE1Vgz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 May 2016 17:36:55 -0400
Received: by mail-wm0-f41.google.com with SMTP id a136so36026112wme.0
        for <linux-ext4@vger.kernel.org>; Sat, 28 May 2016 14:36:54 -0700 (PDT)
Received: from [192.168.0.76] (cpe-70-123-244-133.satx.res.rr.com. [70.123.244.133])
        by smtp.gmail.com with ESMTPSA id c4sm26139696wjm.24.2016.05.28.14.36.51
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 May 2016 14:36:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When building e2fsprogs we normally ask users to run 'make check'.  For 
e2fsprogs-1.42.13 we had '153 tests succeeded, 0 tests failed', but for 
version 1.43, we have '62 tests succeeded, 265 tests failed'.

Many of the failures look like:

$ cat f_lpffile.failed
--- ../../tests/f_lpffile/expect.1 2009-08-13 01:39:58.000000000 +0000
+++ f_lpffile.1.log 2016-05-28 19:40:20.364025801 +0000
@@ -1,3 +1,4 @@
+e2fsck 1.43 (17-May-2016)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
--- ../../tests/f_lpffile/expect.2 2009-08-13 01:39:58.000000000 +0000
+++ f_lpffile.2.log 2016-05-28 19:40:20.367025703 +0000
@@ -1,3 +1,4 @@
+e2fsck 1.43 (17-May-2016)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity

In fact running:

[ /sources/e2fsprogs-1.43/build/tests ]$ grep ^+ *.failed|grep -v 
1.43|grep -v @@|grep -v +++

gives no output. My conclusion is that all the tests actually pass, but 
the expected results need to be updated in the release tarball.

   -- Bruce Dubbs
      linuxfromscratch.org
