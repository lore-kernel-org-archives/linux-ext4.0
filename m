From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Wed, 8 Sep 2010 07:44:24 GMT
Message-ID: <201009080744.o887iOgP026033@demeter1.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49880 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab0IHHoZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 03:44:25 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o887iOc0026034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 8 Sep 2010 07:44:24 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #27 from Florian Mickler <florian@mickler.org>  2010-09-08 07:44:20 ---
The patches here seem not to be mainline yet. 
I can see some discussion about the patch set of Jan Kara on lkml[1].
But I can't see Tejun's patch either in linus tree nor on lkml. 

Are these still necessary? 

[1]
References: http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/00884.html

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
