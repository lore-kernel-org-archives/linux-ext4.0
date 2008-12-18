From: "Chris Worley" <worleys@gmail.com>
Subject: Bad page state in process 'kjournald2'
Date: Thu, 18 Dec 2008 09:24:39 -0700
Message-ID: <f3177b9e0812180824w7382e25dk534d827f68b6ca58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34976 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYLRQYl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 11:24:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Testing "discards" atop ext4 on a 2.6.28-rc8 kernel:

Dec 17 18:03:51  kernel: Bad page state in process 'kjournald2'
Dec 17 18:03:51  kernel: page:ffffe200004695a0
flags:0x0100000000000080 mapping:0000000000000000 mapcount:0 count:0
Dec 17 18:03:51  kernel: Trying to fix it up, but a reboot is needed
Dec 17 18:03:51  kernel: Backtrace:
Dec 17 18:03:51  kernel: Pid: 19919, comm: kjournald2 Tainted: P
 W  2.6.28-rc8 #2
Dec 17 18:03:51  kernel: Call Trace:
Dec 17 18:03:51  kernel:  [<ffffffff80274349>] bad_page+0x6f/0x9d
Dec 17 18:03:51  kernel:  [<ffffffff80274f19>] free_hot_cold_page+0xc8/0x1a0
Dec 17 18:03:51  kernel:  [<ffffffff80275046>] free_hot_page+0xb/0xd
Dec 17 18:03:51  kernel:  [<ffffffff8027532e>] __free_pages+0x18/0x21
Dec 17 18:03:51  kernel:  [<ffffffff80275369>] free_pages+0x32/0x37
Dec 17 18:03:51  kernel:  [<ffffffffa065577d>]
jbd2_journal_commit_transaction+0xb63/0xf06 [jbd2]
Dec 17 18:03:51  kernel:  [<ffffffff804ae925>] ? thread_return+0x3d/0xa2

Was iteratively running:

iozone -s 1g -i 0 -+u -I -t 100 -x -r 1024

... the error occurred during the initial write phase (writing 100
files of 1GB each), where the files were all at ~215MB.

Chris
