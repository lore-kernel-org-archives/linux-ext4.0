From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 12 Mar 2011 06:03:25 GMT
Message-ID: <201103120603.p2C63PFc008980@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:57143 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1CLGD0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Mar 2011 01:03:26 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2C63PTt008981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 12 Mar 2011 06:03:25 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #40 from rocko <rockorequin@hotmail.com>  2011-03-12 06:03:21 ---
I tried kernel 2.6.36, and it also crashed the first time. I must just not have
noticed it before (or maybe the compiler *is* important). The log was along the
lines of:

Pid: 0, comm: swapper Not tainted 2.6.36-git
...
Call Trace:
? sched_clock_local
tick_nohz_stop_sched_tick
cpu_idle
rest_init
start_kernel
x86_64_start_reservations
x86_64_start_kernel

RIP get_next_timer_interrupt

Kernel panic: not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G   D  2.6.36-git

Call trace:
panic
do_exit
? kmsg_dump
oops_end
no_context
__bad_area_nosemaphore
bad_area_nosemaphore
do_page_fault
page_fault
? get_next_timer_interrupt
? get_next_timer_interrupt
? sched_clock_local
tick_nohz_stop_sched_tick
cpu_idle
rest_init
...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
