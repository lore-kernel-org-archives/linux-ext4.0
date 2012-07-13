From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Fri, 13 Jul 2012 14:06:40 +0000 (UTC)
Message-ID: <20120713140640.313E311FAD0@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50720 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab2GMOGo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jul 2012 10:06:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8AAF2201D1
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 14:06:43 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 37C25201D2
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 14:06:40 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731


Mirek Rusin <mirek@me.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mirek@me.com




--- Comment #1 from Mirek Rusin <mirek@me.com>  2012-07-13 14:06:39 ---
Some additional information:

- this hang situation happens very rarely, I'd say maybe every 10TBytes of data
written (at 1Gbit/sec).
- there are maximum of 32 threads doing io.
- each io operation is at most 0.5MB of data (written or read) per syscall with
an exception of fallocate, which can be rarely large, ie. 60GB.
- this situation happens on both empty volumes (where fallocate can find
continuous blocks to do any requested fallocate) and, what seems more often,
when disk is close to being full.
- the volume is LSI RAID6 with 500MB cache and 24x 2TB hard drives
- i'm able to do several hundred of ios per second normally, the hang seems to
be caused by the kernel itself and not hardware
- during the hang i can access and write to the volume from other
processes/threads.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
