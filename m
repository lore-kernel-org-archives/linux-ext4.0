From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Mon, 13 Feb 2012 20:29:14 GMT
Message-ID: <201202132029.q1DKTEah027348@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:55149 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab2BMU3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 15:29:14 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DKTE9h027349
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 20:29:14 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #7 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-13 20:29:13 ---
If I run the multi-threaded 'du' *without* flushing caches between, I don't
seem to trigger the problem (after ~250 iterations, whereas ~20 trigger it
otherwise)

The command I use that triggers the bug (/packages is about 17G of ordinary
software installs):

n=1; while [ $n -lt 128 ]; do sync; echo 3 > /proc/sys/vm/drop_caches; ./edu
/packages $n; n=$[$n+1]; done

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
