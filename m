From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Wed, 7 Apr 2010 09:33:08 GMT
Message-ID: <201004070933.o379X8eT010714@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35943 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0DGJdJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 05:33:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o379X8B4010715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 09:33:08 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #31 from Jan Kara <jack@suse.cz>  2010-04-07 09:33:00 ---
(In reply to comment #29)
> I'm not familiar enough with all the new writeback code; does this mean that a
> sync will return as soon as any new IO is queued post-sync?  That seems odd if
> so - but maybe I misunderstand.
  No. The patch means that writeback thread stops doing pdflush-style writeback
when it sees new work queued - work does not mean IO. It means that someone
asks writeback thread to do some kind of writeout... Now I'm still not sure my
patch is the right approach to the problem but I just wanted to checkout
whether it
at least solves the problem of this particular workload.

  If you still see the problem (only less often) even with ext3, then we
probably have also some other work that is livelockable and thus we never get
to work submitted by sync(1). I guess I'll have to find a machine with enough
disks and memory to try this out...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
