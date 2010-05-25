From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] ext4: panic causes lost data in git
Date: Tue, 25 May 2010 18:02:54 GMT
Message-ID: <201005251802.o4PI2sVU029195@demeter.kernel.org>
References: <bug-13964-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39316 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0EYSCy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 14:02:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4PI2sRm029196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 25 May 2010 18:02:54 GMT
In-Reply-To: <bug-13964-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13964


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-05-25 18:02:53 ---
Jesse, are you still running with data=writeback (as comment nr. 1 seemed to
indicate, since you said you would -try- data=ordered...) - data=writeback is
just not safe at all for anybody, anywhere, any time, unless you plan to
recreate all data post-crash.

With default mount options (which includes data=ordered) do you still see this
problem on upstream kernels?

In the end, though, you have to realize that buffered data which is not synced
to disk -will- be lost on a crash.  This is true for all filesystems, though
the window of "opportunity" may differ....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
