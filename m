From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31542] ext4 : "No space left on the device" persists even when
 I deleted more than 40GB of data
Date: Sun, 20 Mar 2011 23:46:19 GMT
Message-ID: <201103202346.p2KNkJG5019548@demeter2.kernel.org>
References: <bug-31542-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:59029 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1CTXqU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 19:46:20 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2KNkKLq019617
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 23:46:20 GMT
In-Reply-To: <bug-31542-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=31542


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2011-03-20 23:46:18 ---
That's right, you've run into the reserved-for-root space, which as you noted
above, can be changed...

So CLOSED/NOTABUG I think?

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
