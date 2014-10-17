From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Fri, 17 Oct 2014 16:29:29 +0000
Message-ID: <bug-86471-13602-AW4uRZDgkk@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36297 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbaJQQ3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2014 12:29:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A47C7200ED
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2014 16:29:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AB9C42021B
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2014 16:29:29 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D86471

--- Comment #2 from Markus K=C3=B6nigshaus <m.koenigshaus@wut.de> ---
Hi Theodore,

even after a very long wait, the performance remain so low. The perform=
ance is
also low when you copy files. I have used dd, so I create only reproduc=
ible
write access.
I have now tested the ext3 FS, same result.

After some debugging I found out, there is a delay in start_this_handle=
 (look
at the timing), with echo 5 > /sys/kernel/debug/jbd/jbd-debug I get:

>> before mysqlshutdown:
=2E..
[   40.400755] fs/jbd/transaction.c: (journal_stop, 1380): h_ref 2 -> 1
[   40.400755]=20
[   40.400765] fs/jbd/transaction.c: (journal_stop, 1384): Handle df03e=
000
going down
[   40.400765]=20
[   40.400789] fs/jbd/transaction.c: (journal_start, 290): from journal=
_start
[   40.400789]=20
[   40.400801] fs/jbd/transaction.c: (start_this_handle, 110): New hand=
le
df03e000 going live.
[   40.400801]=20
[   40.400813] fs/jbd/transaction.c: (start_this_handle, 229): Handle d=
f03e000
given 14 credits (total 21, free 14286)
=2E..

>> after mysqlshutdown:
=2E..
[   61.383886] fs/jbd/transaction.c: (journal_stop, 1380): h_ref 2 -> 1
[   61.383886]=20
[   61.383896] fs/jbd/transaction.c: (journal_stop, 1384): Handle df03e=
000
going down
[   61.383896]=20
[   61.393528] fs/jbd/transaction.c: (start_this_handle, 110): New hand=
le
df03e000 going live.
[   61.393528]=20
[   61.393541] fs/jbd/transaction.c: (start_this_handle, 229): Handle d=
f03e000
given 14 credits (total 21, free 14271)
=2E..

I try to isolate the problem in more detail next week, I would welcome =
tips and
help for my try.

Regards, Markus

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
