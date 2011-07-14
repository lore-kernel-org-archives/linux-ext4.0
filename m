From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Thu, 14 Jul 2011 17:17:44 GMT
Message-ID: <201107141717.p6EHHigN022088@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50539 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab1GNRRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jul 2011 13:17:45 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6EHHir0022090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2011 17:17:44 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #11 from Eric Sandeen <sandeen@redhat.com>  2011-07-14 17:17:39 ---
It would be worth filing bugs, or at least asking about, those applications.

If syslog-ng is syncing every few seconds without writing any data, that sounds
like a bug.

I collected some of these for fedora, for a while:

"Tracker bug for over-eager apps that won't let disks spin down"
https://bugzilla.redhat.com/show_bug.cgi?id=454582

but I probably need to go hunting again.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
