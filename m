From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 18:21:24 GMT
Message-ID: <200908101821.n7AILOcs014007@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54053 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZHJSVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 14:21:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7AILOMk014008
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 18:21:24 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #19 from Roland Kletzing <devzero@web.de>  2009-08-10 18:21:23 ---
maybe running 

"strace md5sum bigfile 2>&1 | tail -n 25"
"strace dd if=bigfile of=/dev/null 2>&1 |tail -n 25"

gives some additional information where it gets stuck.
sorry if this information already hides in the stacktrace - i`m not familar
with reading those. 


also contents from 
/proc/sched_debug

and checking 
/proc/$PID_OF_STUCK_TASK/stat for increasing values (utime/stime/eip)

would perhaps give additional information.

to see if this is scheduling/smp issue, you could either boot with 'maxcpus=1'
into single cpu mode or start your tasks with cpu affinity "taskset -c 0
cmdname" or "taskset -c 1 cmdname". does that make any difference ?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
