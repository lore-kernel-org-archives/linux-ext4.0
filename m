From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 2 May 2012 12:10:51 GMT
Message-ID: <201205021210.q42CAp3S026655@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:51302 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2EBMKv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 08:10:51 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q42CApK4026656
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2012 12:10:51 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Hugues Tranli <huguelectro@hotmail.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |huguelectro@hotmail.fr




--- Comment #2 from Hugues Tranli <huguelectro@hotmail.fr>  2012-05-02 12:10:49 ---
Same issue on my computer using ext4 with Archlinux. I can hear my HDD writing
every 3 seconds.
Checked with iotop, it's jbd2 related. I don't remember having this in 3.2.
Running 3.3.3 kernel was just painful. Switched to 3.3.4, it's a bit better but
I can still hear my HDD very often. Especially when I use Chromium in spite of
the cache is on tmpfs.
Even I verify HDD S.M.A.R.T. sometimes, I hope this will be fixed soon.

Here mount output: http://pastebin.archlinux.fr/441560

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
