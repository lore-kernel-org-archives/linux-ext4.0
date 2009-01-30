From: Derkjan de Haan <haanjdj@gmail.com>
Subject: Fwd: can't get e4defrag to work
Date: Fri, 30 Jan 2009 22:07:53 +0100
Message-ID: <7a45233b0901301307t5f045ddflc9fdbeb48bbcad0@mail.gmail.com>
References: <7a45233b0901210704w5038d8b8g5c657e3a4746f34d@mail.gmail.com>
	 <49797056.7030607@rs.jp.nec.com>
	 <87f94c370901230751m107afe09w6df76e258c57eae3@mail.gmail.com>
	 <497D6843.50905@rs.jp.nec.com>
	 <37d33d830901260409y2cb01512u19646c477fa0e365@mail.gmail.com>
	 <7a45233b0901300507y164dd475w4d96a5a47fed58d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:64258 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZA3VH4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2009 16:07:56 -0500
Received: by fxm13 with SMTP id 13so441450fxm.13
        for <linux-ext4@vger.kernel.org>; Fri, 30 Jan 2009 13:07:53 -0800 (PST)
In-Reply-To: <7a45233b0901300507y164dd475w4d96a5a47fed58d7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I would like to report the following issues:

- the patch doesn't apply cleanly to 2.6.29-rc3:

Applying patch patches/1
patching file fs/ext4/Makefile
patching file fs/ext4/defrag.c
patching file fs/ext4/ext4.h
Hunk #1 succeeded at 303 (offset 10 lines).
Hunk #2 succeeded at 312 with fuzz 2 (offset -2 lines).
Hunk #3 succeeded at 1033 (offset 9 lines).
patching file fs/ext4/ext4_extents.h
patching file fs/ext4/extents.c
patching file fs/ext4/ioctl.c
Hunk #2 succeeded at 215 (offset -11 lines).

Applying patch patches/2
patching file fs/ext4/defrag.c

Now at patch patches/2

- I just found out e4defrag needs to be compiled with the -lm flag due
to the powf function being used.

- When compiling ext4 as a module, the kernel build fails on this error:

ERROR: "fget_light" [fs/ext4/ext4.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

After that, I compiled a kernel with ext4 built in, and that one built
OK. I now have a working e4defrag; thanks for your work on this!


regards,

Derkjan
