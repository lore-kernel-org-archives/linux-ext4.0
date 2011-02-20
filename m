From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 20 Feb 2011 00:16:35 GMT
Message-ID: <201102200016.p1K0GZxP031017@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56494 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1BTAQg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 19:16:36 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1K0GaMH031019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Feb 2011 00:16:36 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #31 from rocko <rockorequin@hotmail.com>  2011-02-20 00:16:33 ---
Thanks, that helped a lot! Incidentally, if I don't sleep between unbind and
bind operations in the script, the kernel becomes unresponsive (ie to
everything including ssh sessions, ctrl-c/d/z and trying to switch to another
tty) and just keeps scrolling the bind/unbind messages up the screen, even long
after I remove the USB device, so presumably bind/unbind would have to fail at
this point.

Anyway, I managed to reproduce the freeze quite quickly with just a single USB
key. The stack trace is slightly longer this time:

<this scrolled off the top of the screen>
wake_up_process
wakeup_timer_fn
run_timer_softirq
? wakeup_timer_fn
__do_softirq
call_softirq
irq_exit
do_IRQ
ret_from_intr
? arch_local_irq_enable
? sched_clock_idle_wakeup_event
acpi_idle_enter_bm
cpuidle_idle_call
cpu_idle
rest_init
start_kernel
x86_64_start_reservvations
x86_64_start_kernel
...
RIP task_rq_lock
--- end trace ---
Kernel panic - not syncing: fatal exception in interrupt
Pid: 0, comm: swapper
Call trace:
IRQ ? panic
? kmsg_dump
? oops_end
? no_context
? __bad_area_nosemaphore
? bad_area_nosemaphore
? enqueue_task
? resched_task
? try_to_wake_up
? native_sched_clock
? native_sched_clock [yes, twice]
? page_fault
? task_rq_lock
? try_to_wake_up
? wake_up_process
? wake_up_process [twice]
? wakeup_timer
? run_timer_softirq
? wakeup_timer_fn
? __do_softirq
? call_softirq
? irq_exit
? do_IRQ
? ret_from_intr
? arch_local_irq_enable
? sched_clock_idle_wakeup_event
? acpi_idle_enter_bm
? cpuidle_idle_call
? cpu_idle
? rest_init
? x86_64_start_reservvations
? x86_64_start_kernel

But does that help any?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
