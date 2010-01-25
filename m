From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Mon, 25 Jan 2010 08:27:31 GMT
Message-ID: <201001250827.o0P8RVQl017436@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41824 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0AYI1b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 03:27:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0P8RVcG017437
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 08:27:31 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #8 from Theodore Tso <tytso@mit.edu>  2010-01-25 08:27:26 ---
Hmm, can you run "iostat 1 | tee iostat.log &", and while that is running, wait
for a 15 seconds or so we can capture what things like in steady state, and
then type "sync", and note when the sync command was initiated in the
iostat.log file?   It would be useful seeing what this looks like on both your
ext3 production server and on the ext4 test server.  Do you know if there are
any other differences between the two systems, in terms of the workload seen by
your production server versus your test server?

Another thing that would be very useful to do is to enable ftrace, and then cd
to /sys/kernel/debug/tracing.  (This assumes that you have debugfs mounted on
/sys/kernel/debug.)   Then "echo 1 > events/jbd2/jbd2_run_stats/enable" and
then in a similar fashion, do "cat trace_pipe | tee /tmp/trace.output", wait
for four or five data samples from your file system of interest, and then issue
the sync command, and let's see what is happening.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
