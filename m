From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Mon, 07 Jul 2014 12:29:38 +0000
Message-ID: <bug-78651-13602-GiLIjgUfLh@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57267 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaGGM3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 08:29:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 547A9202EC
	for <linux-ext4@vger.kernel.org>; Mon,  7 Jul 2014 12:29:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DA9E42027D
	for <linux-ext4@vger.kernel.org>; Mon,  7 Jul 2014 12:29:38 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #8 from Theodore Tso <tytso@mit.edu> ---
*Very* interesting.  If increasing the journal helped significantly, I'd really
like to get the traces from enabling jbd2_checkpoint and jbd2_run_stats, with
both with the original and new journal size.  (Note, you'll need to use
"trace-cmd report" to get the actual traces, and then delete the trace.dat file
between runs.   The traces will be quite voluminous, but they should compress
well.)

To explain what you'll see:

     jbd2/sda3-8-331   [000] ...2 35527.318772: jbd2_run_stats: dev 8,3 tid
14512411 wait 0 request_delay 0 running 5290 locked 0 flushing 0 logging 0
handle_count 33 blocks 7 blocks_logged 8

This means that we spent a bit over five seconds letting the transaction run,
and in that transaction contained 33 handles ("micro transactions") which
covered 7 blocks, and it used 8 blocks of space in the journal.

     jbd2/sda3-8-331   [000] ...2 35534.133232: jbd2_run_stats: dev 8,3 tid
14512413 wait 0 request_delay 0 running 440 locked 0 flushing 0 logging 10
handle_count 27 blocks 8 blocks_logged 9

This is an example of a transaction that only ran for less than half a second
(440 jiffies); since it ran for less than the default five seconds, we can
surmise that there was an explicit fsync() that triggered the transaction.  If
the number of blocks logged was very high, it's possible it was triggered by
running out of room in the journal, but in that case, you'd see a lot of
jbd2_checkpoint tracepoint data as well.

So now that we know that the journal size is making a difference, this will
allow us to figure out *why* the journal size is making a difference.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
