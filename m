From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34302] Errors from kjournald
Date: Tue, 3 May 2011 16:27:27 GMT
Message-ID: <201105031627.p43GRRQo017978@demeter1.kernel.org>
References: <bug-34302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39306 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1ECQ11 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 12:27:27 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p43GRRYa017979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 16:27:27 GMT
In-Reply-To: <bug-34302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=34302





--- Comment #2 from Tom Moore <tmoore@spatial.ca>  2011-05-03 16:27:25 ---
Yes, it appears that there is additional in the syslog that is not in the
messages file (sorry about that).

May  3 01:02:25 fawkes kernel: [307200.700498] INFO: task kjournald:6416
blocked for more than 120 seconds.
May  3 01:02:25 fawkes kernel: [307200.700506] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.

The machine was doing a full backup of about 1Tb of data at the time using
backuppc, so that might be the reason that the journal could not keep up.  It
is possible that something else in the crontab also kicked off at around that
time.  I am a bit confused by the messages however.  The backup source is 2
SATA 3 (6Gbs) disks in a Raid-1 config; the backup target is 1 SATA2 (3gbs)
disk.  The final message of concern was 

May  3 01:40:09 fawkes kernel: [309464.781078] ata8.00: exception Emask 0x0
SAct 0x2 SErr 0x0 action 0x6 frozen
May  3 01:40:09 fawkes kernel: [309464.781091] ata8.00: failed command: READ
FPDMA QUEUED
May  3 01:40:09 fawkes kernel: [309464.781107] ata8.00: cmd
60/08:08:47:0a:ab/00:00:45:00:00/40 tag 1 ncq 4096 in
May  3 01:40:09 fawkes kernel: [309464.781111]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May  3 01:40:09 fawkes kernel: [309464.781118] ata8.00: status: { DRDY }
May  3 01:40:09 fawkes kernel: [309464.781131] ata8: hard resetting link
May  3 01:40:10 fawkes kernel: [309465.112103] ata8: SATA link up 6.0 Gbps
(SStatus 133 SControl 300)
May  3 01:40:10 fawkes kernel: [309465.119531] ata8.00: configured for UDMA/133
May  3 01:40:10 fawkes kernel: [309465.119543] ata8.00: device reported invalid
CHS sector 0
May  3 01:40:10 fawkes kernel: [309465.119559] ata8: EH complete

I am not 100% sure which disk ata8 corresponds to.  I tried looking through the
boot log to figure out the device assignments, but it was a bit confusing, It
appears that ata8.00 is one of the source raid disks.  If so, I wonder why it
got reset?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
