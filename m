From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: 2.6.32.9 ext4 related hangups?
Date: Thu, 25 Feb 2010 19:37:11 +0100
Message-ID: <20100225183711.GE30897@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nikola.ciprich@linuxbox.cz
To: ext4 devel list <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:60082 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab0BYSgl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Feb 2010 13:36:41 -0500
Received: from linuxbox.linuxbox.cz (server.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTP id o1PIadCN026420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Feb 2010 19:36:39 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
after lots of NFS related troubles, 2.6.32 seems to finally to get to usable
state for me. since 2.6.32.9-rc1, it works much better, but we're still getting
occasional hangups, and following traces:

[109921.032043] INFO: task jbd2/dm-7-8:4338 blocked for more than 120 seconds.
[109921.032048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[109921.032052] jbd2/dm-7-8   D ffff880001e13940     0  4338      2 0x00000080
[109921.032059]  ffff880071ddbce0 0000000000000046 ffff880071ddbca8 ffffffff8106e9a5
[109921.032066]  ffff880000000000 ffff880071f1a7e0 ffff880071f1a720 ffff88007ac7a720
[109921.032073]  ffff880071f1aad8 ffff880071c0e230 0000000101a1aca0 ffffffff00000002
[109921.032080] Call Trace:
[109921.032091]  [<ffffffff8106e9a5>] ? prepare_to_wait+0x25/0x80
[109921.032104]  [<ffffffffa05f6c1a>] jbd2_journal_commit_transaction+0x1ea/0x1890 [jbd2]
[109921.032111]  [<ffffffff8105e036>] ? lock_timer_base+0x36/0x70
[109921.032134]  [<ffffffff8106e770>] ? autoremove_wake_function+0x0/0x40
[109921.032140]  [<ffffffff8105e0b4>] ? try_to_del_timer_sync+0x44/0x100
[109921.032150]  [<ffffffffa05fdbea>] kjournald2+0xba/0x240 [jbd2]
[109921.032154]  [<ffffffff8106e770>] ? autoremove_wake_function+0x0/0x40
[109921.032163]  [<ffffffffa05fdb30>] ? kjournald2+0x0/0x240 [jbd2]
[109921.032167]  [<ffffffff8106e62e>] kthread+0x8e/0xa0
[109921.032173]  [<ffffffff8100c35a>] child_rip+0xa/0x20
[109921.032178]  [<ffffffff8106e5a0>] ? kthread+0x0/0xa0
[109921.032182]  [<ffffffff8100c350>] ? child_rip+0x0/0x20
[109921.032186] no locks held by jbd2/dm-7-8/4338.
[260041.032035] INFO: task jbd2/dm-7-8:4338 blocked for more than 120 seconds.
[260041.032040] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[260041.032044] jbd2/dm-7-8   D ffff880028db0c00     0  4338      2 0x00000080
[260041.032051]  ffff880071ddbce0 0000000000000046 0000000000000000 ffffffff8106e9a5
[260041.032058]  ffff880000000000 ffff880071f1a7e0 ffff880071f1a720 ffff88007f8ace40
[260041.032065]  ffff880071f1aad8 ffff880071c0e230 0000000103de36f0 0000000000000002
[260041.032072] Call Trace:
[260041.032083]  [<ffffffff8106e9a5>] ? prepare_to_wait+0x25/0x80
[260041.032096]  [<ffffffffa05f6c1a>] jbd2_journal_commit_transaction+0x1ea/0x1890 [jbd2]
[260041.032103]  [<ffffffff8105e036>] ? lock_timer_base+0x36/0x70
[260041.032108]  [<ffffffff8106e770>] ? autoremove_wake_function+0x0/0x40
[260041.032114]  [<ffffffff8105e0b4>] ? try_to_del_timer_sync+0x44/0x100
[260041.032123]  [<ffffffffa05fdbea>] kjournald2+0xba/0x240 [jbd2]
[260041.032128]  [<ffffffff8106e770>] ? autoremove_wake_function+0x0/0x40
[260041.032136]  [<ffffffffa05fdb30>] ? kjournald2+0x0/0x240 [jbd2]
[260041.032141]  [<ffffffff8106e62e>] kthread+0x8e/0xa0
[260041.032147]  [<ffffffff8100c35a>] child_rip+0xa/0x20
[260041.032152]  [<ffffffff8106e5a0>] ? kthread+0x0/0xa0
[260041.032156]  [<ffffffff8100c350>] ? child_rip+0x0/0x20
[260041.032160] no locks held by jbd2/dm-7-8/4338.

Seems to me that it's either ext4, or jbd2 related.
Any opinions somebody?
thanks a lot in advance
br
nik


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
