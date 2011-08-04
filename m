From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40512] EXT4_IOC_MIGRATE is dangerous on directories
Date: Thu, 4 Aug 2011 06:31:43 GMT
Message-ID: <201108040631.p746VhOf015044@demeter2.kernel.org>
References: <bug-40512-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48188 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HDGbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Aug 2011 02:31:44 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p746Vhu4015045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 06:31:44 GMT
In-Reply-To: <bug-40512-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40512


Tao Ma <tm@tao.ma> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tm@tao.ma




--- Comment #1 from Tao Ma <tm@tao.ma>  2011-08-04 06:31:42 ---
Tested with 3.0, and it works here. git log shows that a possible fix should be
74e4e6db3 which is included in 3.0.

One thing you could confirm is to run:
debugfs 'stat dir' /dev/sdx
to see whether the EXTENTS flags is set or not. If it isn't set, it should be
the root cause.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
