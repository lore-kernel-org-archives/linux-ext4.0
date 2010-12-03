From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 24282] linux/ext2_fs.h uses defines from linux/fs.h
Date: Fri, 3 Dec 2010 15:13:10 GMT
Message-ID: <201012031513.oB3FDA5i014899@demeter2.kernel.org>
References: <bug-24282-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:37082 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0LCPNL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Dec 2010 10:13:11 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oB3FDAwe014900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Dec 2010 15:13:10 GMT
In-Reply-To: <bug-24282-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=24282


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-12-03 15:13:08 ---
Please attach your config and the compile error that you get, thanks.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
