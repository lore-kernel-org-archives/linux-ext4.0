From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26752] NPD when using sb->s_fs_info during clean-up after a
 failed mount
Date: Tue, 29 Mar 2011 00:11:20 GMT
Message-ID: <201103290011.p2T0BKT6009469@demeter2.kernel.org>
References: <bug-26752-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:32981 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1C2ALV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 20:11:21 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2T0BKMI009470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 00:11:20 GMT
In-Reply-To: <bug-26752-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=26752


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #3 from Florian Mickler <florian@mickler.org>  2011-03-29 00:11:17 ---
A patch referencing this bug report has been merged in v2.6.38-8876-g036a982:

commit 32a9bb57d7c1fd04ae0f72b8f671501f000a0e9f
Author: Manish Katiyar <mkatiyar@gmail.com>
Date:   Sun Feb 27 20:42:06 2011 -0500

    ext4: fix missing iput of root inode for some mount error paths

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
