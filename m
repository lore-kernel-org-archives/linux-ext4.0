From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Mon, 18 Jan 2010 21:50:40 GMT
Message-ID: <201001182150.o0ILoeoi027264@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44978 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0ARVul (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 16:50:41 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0ILoe2q027265
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 21:50:40 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #2 from Jan Kara <jack@suse.cz>  2010-01-18 21:50:38 ---
There are two issues here - the first is that sync takes long - this is at the
level of "don't do it when it hurts" kind of thing ;). So when you do heavy
writing and call sync, it simply takes long time to flush all the caches to
disk. If you think the time is inappropriately long, we can have a look at it
but for that we'd need much more details like amount and nature of data writen
(many small files vs a few large ones), time it takes sync to complete, speed
of disks for sequential IO...

The second issue is that nfsd blocks as well. Partly this might be because sync
blocks writers (so that it can get it's work done in a finite time), partly it
might be a limitation of ext4 because all metadata writes go through a journal
which has a limited size and thus we have to copy data from the journal to
final locations on disk once in a while and that usually leads to all writer
processes blocking waiting for the journal space to be freed (which can take a
longer time when 'sync' process is making disk busy with data writes).

Note in the log file:
This problem prevents production use of systems using this kernel.

evokes a question: Do you have a kernel which behaved better for you? Which
one?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
