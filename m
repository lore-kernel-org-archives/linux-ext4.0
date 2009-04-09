From: Karl Pickett <karl.pickett@gmail.com>
Subject: Proposal for safe/unsafe atomic rename()
Date: Thu, 9 Apr 2009 13:09:31 -0400
Message-ID: <f9be06770904091009v4a8074edv94c26525406de432@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:31944 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZDIRJc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 13:09:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is only regarding open(TMP_FILE),close(),rename() - not about
directly overwriting an existing file which to me is clearly not safe
and a different issue.

I think the safe atomic rename semantics by default are important.
Most files on my disk I regard as critical after a crash.  Only a few,
in tmp, can be sacrificed safety.   Now if these semantics are too
onerous for certain apps, I have a proposal to disable it.

fcntl(fd, F_SET_ATOMIC_RENAME) (int)
Only allowed to set to 0.  Once set to 0, can not be restored to 1,
which doesn't make much sense and seems easier to implement. (I could
easily be wrong).

fcntl(fd, F_GET_ATOMIC_RENAME) (int)
Ext3/4 could return 1 here for all newly opened files.  If you set to
0 (above), then this call would return 0 as well.

I have a daemon that, when prompted by a UI, writes a report out to
/tmp/report.tmp and renames it to /tmp/report.  Then the UI opens
/tmp/report and displays it to the user.  Clearly after a crash I
don't care if /tmp/report is 0 length because it's always regenerated
by the gui poking the daemon first.  It would also be very easy for
me, if I thought it would help performance, to put a one line
fcntl(SET_ATOMIC_RENAME, 0) to get that extra bit of speed during any
checkpointing.

I think the fcntl is easiest when dealing with multiple layers of
software, and not always being able to intercept the low level open()
call.
Also, if the performance difference is so onerous 1 fcntl isn't going
to be a problem.

There may be a better word than "Atomic".  Maybe "Safe",  "Robust",
"NoEatMyData", ...

-- 
Karl Pickett
