From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Fwd: can't get e4defrag to work
Date: Tue, 03 Feb 2009 17:02:52 +0900
Message-ID: <4987FA2C.7090700@rs.jp.nec.com>
References: <7a45233b0901210704w5038d8b8g5c657e3a4746f34d@mail.gmail.com>	 <49797056.7030607@rs.jp.nec.com>	 <87f94c370901230751m107afe09w6df76e258c57eae3@mail.gmail.com>	 <497D6843.50905@rs.jp.nec.com>	 <37d33d830901260409y2cb01512u19646c477fa0e365@mail.gmail.com>	 <7a45233b0901300507y164dd475w4d96a5a47fed58d7@mail.gmail.com> <7a45233b0901301307t5f045ddflc9fdbeb48bbcad0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Derkjan de Haan <haanjdj@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49437 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZBCIDP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 03:03:15 -0500
In-Reply-To: <7a45233b0901301307t5f045ddflc9fdbeb48bbcad0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Derkjan,

Derkjan de Haan wrote:
> I would like to report the following issues:
> 
> - the patch doesn't apply cleanly to 2.6.29-rc3:
> 
> Applying patch patches/1
> patching file fs/ext4/Makefile
> patching file fs/ext4/defrag.c
> patching file fs/ext4/ext4.h
> Hunk #1 succeeded at 303 (offset 10 lines).
> Hunk #2 succeeded at 312 with fuzz 2 (offset -2 lines).
> Hunk #3 succeeded at 1033 (offset 9 lines).
> patching file fs/ext4/ext4_extents.h
> patching file fs/ext4/extents.c
> patching file fs/ext4/ioctl.c
> Hunk #2 succeeded at 215 (offset -11 lines).
> 
> Applying patch patches/2
> patching file fs/ext4/defrag.c
> 
> Now at patch patches/2

Defrag pathces applied cleanly to the ext4 patch queue
(7554f240866634a3b5394aced79e1768b4b1f3bf) without any hunks.

[root@bsd086 KERN]# patch -d linux-2.6.29-rc3 -p1 < 1.patch
patching file fs/ext4/Makefile
patching file fs/ext4/defrag.c
patching file fs/ext4/ext4.h
patching file fs/ext4/ext4_extents.h
patching file fs/ext4/extents.c
patching file fs/ext4/ioctl.c

Maybe your ext4 patch queue was not the latest version.

> 
> - I just found out e4defrag needs to be compiled with the -lm flag due
> to the powf function being used.

Yes.  I should have mentioned it in advance.

> - When compiling ext4 as a module, the kernel build fails on this error:
> 
> ERROR: "fget_light" [fs/ext4/ext4.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 

Thank you for reporting.
I will use fget() and fput() in the next version instead.

Regards,
Akira Fujita
