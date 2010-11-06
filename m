From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22212] Crash in ext4_init_io_end
Date: Sat, 6 Nov 2010 21:43:34 GMT
Message-ID: <201011062143.oA6LhY1W023213@demeter2.kernel.org>
References: <bug-22212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:39581 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab0KFVnf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Nov 2010 17:43:35 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA6LhYR7023246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Nov 2010 21:43:34 GMT
In-Reply-To: <bug-22212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22212


Nick Bowler <nbowler@draconx.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nbowler@draconx.ca




--- Comment #1 from Nick Bowler <nbowler@draconx.ca>  2010-11-06 21:43:29 ---
Probably the same problem as
http://thread.gmane.org/gmane.comp.file-systems.ext4/21663

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
