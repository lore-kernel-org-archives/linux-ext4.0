From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Mon, 4 Oct 2010 18:48:33 GMT
Message-ID: <201010041848.o94ImXst005147@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:36827 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab0JDSsd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 14:48:33 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o94ImXVs005148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 4 Oct 2010 18:48:33 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #15 from Christian Casteyde <casteyde.christian@free.fr>  2010-10-04 18:48:29 ---
I've explored some of the ideas you mentionned.

First, I disabled kmemcheck, and indeed I've got no warning at all. So this is
really a kmemcheck + something else (buggy driver or perf counters as
mentionned by Vegard in his previous mail).

I could check the reverse: kmemcheck but without perf counters, however I
cannot unselect the perf option on my config (it is forced by something else
I've not found). kmemcheck used to work (I don't know if perf counters were
available in previous kernels however).

Second, I have most of my drivers built in, however I use sound cards as
modules in order to control the load order.

I've booted after erasing the /lib/module driver, but with kmemcheck enabled,
and it was far better. I got only one kmemecheck error:

ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ERROR: kmemcheck: Fatal error

Pid: 1914, comm: gtk-update-icon Not tainted 2.6.36-rc6 #13 K8 Combo-Z/K8
Combo-Z
RIP: 0010:[<ffffffff81010b90>]  [<ffffffff81010b90>]
x86_perf_event_update+0x0/0x80
RSP: 0018:ffff880002607d50  EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: ffff88000260b5c0 RSI: 0000000000000400 RDI: ffff88003f808800
RBP: ffff880002607df8 R08: 0000000000000000 R09: 0000000000000004
R10: 0000000000000001 R11: 0000000000000038 R12: ffff88000260b7c8
R13: 0000000000000000 R14: ffff88000260b7c0 R15: ffff88003f808800
FS:  00007fdb70d5e700(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88003f836420 CR3: 000000003da52000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8102bc34>] kmemcheck_error_save_bug+0xb4/0xe0
 [<ffffffff8102c658>] kmemcheck_access+0xe8/0x4a0
 [<ffffffff8102ca82>] kmemcheck_fault+0x72/0x80
 [<ffffffff81026f89>] do_page_fault+0x359/0x440
 [<ffffffff8159711f>] page_fault+0x1f/0x30
 [<ffffffff81011528>] perf_event_nmi_handler+0x78/0x140
 [<ffffffff810665d0>] notifier_call_chain+0x50/0xa0
 [<ffffffff81066b81>] __atomic_notifier_call_chain+0x71/0xd0
 [<ffffffff81066bf1>] atomic_notifier_call_chain+0x11/0x20
 [<ffffffff81066c2e>] notify_die+0x2e/0x30
 [<ffffffff81004343>] do_nmi+0x193/0x2b0
 [<ffffffff8159740a>] nmi+0x1a/0x2c
 [<ffffffff8102c5c7>] kmemcheck_access+0x57/0x4a0
 [<ffffffff8102ca82>] kmemcheck_fault+0x72/0x80
 [<ffffffff81026f89>] do_page_fault+0x359/0x440
 [<ffffffff8159711f>] page_fault+0x1f/0x30
 [<ffffffff810dab55>] do_lookup+0x55/0x170
 [<ffffffff810dcb10>] link_path_walk+0x130/0xbd0
 [<ffffffff810dd720>] path_walk+0x60/0xe0
 [<ffffffff810dd7f3>] do_path_lookup+0x53/0x60
 [<ffffffff810de433>] user_path_at+0x53/0xa0
 [<ffffffff810d4c17>] vfs_fstatat+0x37/0x70
 [<ffffffff810d4c86>] vfs_stat+0x16/0x20
 [<ffffffff810d4e5f>] sys_newstat+0x1f/0x50
 [<ffffffff810023ab>] system_call_fastpath+0x16/0x1b
 [<ffffffffffffffff>] 0xffffffffffffffff

The good news is all other errors are gone. Here is the lsmod output without
kmemcheck, just to tell the modules that could cause more grief:
Module                  Size  Used by
snd_intel8x0           29098  1 
snd_cmipci             31770  4 
snd_opl3_lib            9332  1 snd_cmipci
snd_hwdep               6314  1 snd_opl3_lib
snd_mpu401_uart         6360  1 snd_cmipci
snd_rawmidi            20342  1 snd_mpu401_uart
snd_ac97_codec        117688  1 snd_intel8x0
ac97_bus                1290  1 snd_ac97_codec

The .config file is already attached to this bug report (please note I've also
some other unused drivers configured, for hardware I do not use for now).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
