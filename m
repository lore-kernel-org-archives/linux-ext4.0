From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Fri, 9 Jul 2010 02:23:43 GMT
Message-ID: <201007090223.o692NhbI011515@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60284 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab0GICXp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jul 2010 22:23:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o692Nidn011516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Jul 2010 02:23:44 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312


Larry Finger <Larry.Finger@lwfinger.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |Larry.Finger@lwfinger.net




--- Comment #1 from Larry Finger <Larry.Finger@lwfinger.net>  2010-07-09 02:23:40 ---
This is a duplicate of Bug #16122.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
