From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Mon, 11 Jul 2011 03:15:51 GMT
Message-ID: <201107110315.p6B3Fpl2024329@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:33143 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1GKDPw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jul 2011 23:15:52 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6B3FpMG024330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jul 2011 03:15:51 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072


Lars Stokholm <lars.stokholm@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lars.stokholm@gmail.com




--- Comment #2 from Lars Stokholm <lars.stokholm@gmail.com>  2011-07-10 20:08:51 ---
I just wanted to say that I agree

--- Comment #3 from Lars Stokholm <lars.stokholm@gmail.com>  2011-07-10 20:13:38 ---
Oops. Sorry, I'm very new to this bug list, I committed before I should have.

I just wanted to say that I agree with you Theodore. Going into single user
mode helps. In fact just killing off my daemons (syslog-ng, cron and so on)
along with X was enough. I didn't have to go to single user mode.

--- Comment #4 from Theodore Tso <tytso@mit.edu>  2011-07-11 03:15:46 ---
Created an attachment (id=65212)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=65212)
Journal tracepoint patch

The following patch should help people figure out which process is responsible
for starting an jbd2 transaction handle.   After applying the patch, enable it
via:

echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_journal_start/enable
echo 1 > /sys/kernel/debug/tracing/events/jbd2/jbd2_run_stats/enable
cat /sys/kernel/debug/tracing/trace_pipe

... and wait.

(All of this assumes you have ftrace enabled, of course).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
