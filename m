From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Wed, 09 Jul 2014 03:27:45 +0000
Message-ID: <bug-78651-13602-FykloBi6G5@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaGID1r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 23:27:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 637F6202E5
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jul 2014 03:27:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5BE75202AE
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jul 2014 03:27:45 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #15 from Joseph D. Wagner <joe@josephdwagner.info> ---
Assuming these don't change across reboots:
253, 1 -> /dev/dm-1 -> system-os
253, 3 -> /dev/dm-3 -> backup (destination)
253, 5 -> /dev/dm-5 -> data-home (source)

I used the same options for formatting.  Here are the exact commands:

$ mke2fs -E lazy_itable_init=0,lazy_journal_init=0 -J size=1024 -L backup -m 1
-t ext4 -v /dev/mapper/backup

$ mke2fs -E lazy_itable_init=0,lazy_journal_init=0 -J size=256 -L backup -m 1
-t ext4 -v /dev/mapper/backup

Here is the exact command for the ftrace and dump:

$ trace-cmd record -o /root/ftrace/trace.dat \
  -e jbd2:jbd2_checkpoint \
  -e jbd2:jbd2_run_stats \
dump -${DUMPLEVEL} -a -b 64 -u -A "${TARGET_TOC}" -f "${TARGET_IMG}" -Q
"${TARGET_QFA}" "${SNAPSHOT_PATH}"

Often (but not always), I would set the system to shutdown immediately after
backup.  However, it was mounted automatically by /etc/fstab on each boot, and
it was left mounted in the background.

Prior to submitting these bug report, I had been running without reformatting
for a number of months.  I just finally got sick of it when I submitted my
report.

What do you think should be the next step?  Reformat with those options, and
rerun with a trace?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
