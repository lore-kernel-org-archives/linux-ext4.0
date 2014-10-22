From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Wed, 22 Oct 2014 16:00:51 +0000
Message-ID: <bug-86471-13602-lurJZXY6BS@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbaJVQAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Oct 2014 12:00:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CFFA520121
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2014 16:00:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B1D20201DD
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2014 16:00:51 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D86471

--- Comment #3 from Markus K=C3=B6nigshaus <m.koenigshaus@wut.de> ---
It looks like a problem in the writeback - mechanism, not ext4 related,=
 sorry:

cd /sys/kernel/debug/tracing/
echo function > current_tracer
echo writeback* > set_ftrace_filter

>> before mysqlshutdown

# tracer: function
#
# entries-in-buffer/entries-written: 3/3   #P:1
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              dd-3666  [000] ...1  1338.484467: writeback_in_progress
<-balance_dirty_pages_ratelimited
    kworker/u2:2-1001  [000] ...2  1338.557118: writeback_sb_inodes
<-__writeback_inodes_wb
    kworker/u2:2-1001  [000] ...2  1338.557160: writeback_sb_inodes
<-__writeback_inodes_wb

>> after mysqlshutdown:
# tracer: function
#
# entries-in-buffer/entries-written: 384/384   #P:1
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              dd-3733  [000] ...1  1403.061232: writeback_in_progress
<-balance_dirty_pages_ratelimited
    kworker/u2:2-1001  [000] ...2  1403.061277: writeback_sb_inodes
<-__writeback_inodes_wb
              dd-3733  [000] ...1  1403.071042: writeback_in_progress
<-balance_dirty_pages_ratelimited
              dd-3733  [000] ...1  1403.071328: writeback_in_progress
<-balance_dirty_pages_ratelimited
    kworker/u2:2-1001  [000] ...2  1403.071350: writeback_sb_inodes
<-__writeback_inodes_wb
              dd-3733  [000] ...1  1403.077546: writeback_in_progress
<-balance_dirty_pages_ratelimited

[ ... repeat 368 times ... ]

              dd-3733  [000] ...1  1404.327043: writeback_in_progress
<-balance_dirty_pages_ratelimited
              dd-3733  [000] ...1  1404.327306: writeback_in_progress
<-balance_dirty_pages_ratelimited
    kworker/u2:2-1001  [000] ...2  1404.327336: writeback_sb_inodes
<-__writeback_inodes_wb
              dd-3733  [000] ...1  1404.337125: writeback_in_progress
<-balance_dirty_pages_ratelimited

someone an idea, where to report this problem?

Regards, Markus

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
