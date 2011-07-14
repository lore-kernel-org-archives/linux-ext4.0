From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Thu, 14 Jul 2011 17:02:50 GMT
Message-ID: <201107141702.p6EH2o34019830@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50989 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1GNRCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jul 2011 13:02:53 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6EH2pag019831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2011 17:02:51 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072


mkkot <marcin2006@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #10 from mkkot <marcin2006@gmail.com>  2011-07-14 17:02:39 ---
After 5 and half hour of compilation ;) I have some results:

- command sysctl vm.block_dump=1 (so I can see writes and reads with dmesg |
grep -e READ -e WRITE) makes syslog-ng to write every few seconds which
triggers jbd2 as well. So I fell in my own trap. Killing syslog helps there.

- console-kit-daemon also triggers jbd2. I'm not sure why but it writes over
and over again in text-mode. Killing it helps until you log in within another
console, then it starts again. It quiets in X mode, though. Strange.

- Killing console-kit-daemon in text-mode enables possibility to spin-down the
disk for a minute or two. Then some pdflush or cron job starts.

So it seems there is nothing wrong with ext4. Anyway, thanks for the patch, it
was very helpful to determine what is wrong and solve people's problems.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
