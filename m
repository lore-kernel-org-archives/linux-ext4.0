From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Fri, 26 Nov 2010 20:45:00 GMT
Message-ID: <201011262045.oAQKj0Lb022940@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:54289 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0KZUpB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Nov 2010 15:45:01 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAQKj0ea022941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Nov 2010 20:45:00 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #9 from Eric Sandeen <sandeen@redhat.com>  2010-11-26 20:44:57 ---
Stale data on disk being picked up as mount options after

8b67f04ab9de5d8f3a71aef72bf02c995a506db5 ext4: Add mount options in superblock

perhaps?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
