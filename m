From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 20 Apr 2010 02:49:41 GMT
Message-ID: <201004200249.o3K2nfS9008248@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33301 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0DTCtl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 22:49:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3K2nfjB008251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 20 Apr 2010 02:49:41 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830


Dave Chinner <david@fromorbit.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david@fromorbit.com




--- Comment #34 from Dave Chinner <david@fromorbit.com>  2010-04-20 02:49:34 ---
See:

http://marc.info/?l=linux-fsdevel&m=127166071530948&w=2

Sync is acting as designed right now. I agree it's not ideal, but it's now
defaulting to slow-but-safe behaviour rather than the previous behaviour of
potentially not syncing everything that was dirty at the time of the sync call.

Cheers,

Dave.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
