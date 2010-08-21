From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] Oops with 2.6.36-rc1
Date: Sat, 21 Aug 2010 16:28:17 GMT
Message-ID: <201008211628.o7LGSHOE009814@demeter1.kernel.org>
References: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46230 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0HUQ2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Aug 2010 12:28:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7LGSHeM009815
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 21 Aug 2010 16:28:17 GMT
In-Reply-To: <bug-16711-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-08-21 16:28:12 ---
Not an ext4 or even filesystem bug; looks like it was going down an apparmor
path (aa_alloc_task_context) when it oopsed.  Unfortunately I don't know how to
move a bug off the filesystem component.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
