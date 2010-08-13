From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15391] EXT4_USE_FOR_EXT23 causes ext4 partition to be mounted
 as ext2
Date: Fri, 13 Aug 2010 03:57:40 GMT
Message-ID: <201008130357.o7D3veXS002906@demeter.kernel.org>
References: <bug-15391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50136 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0HMD5l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Aug 2010 23:57:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7D3vfTx002910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 13 Aug 2010 03:57:41 GMT
In-Reply-To: <bug-15391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15391


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2010-08-13 03:57:35 ---
It's actually getting mounted using the ext4 file system driver.  It's just
that is getting identified as ext2 in /proc/mounts.  Whether or not users see
this depends on their init scripts, and especially whether they have an initrd.
  It is only a cosmetic issue, so it's low priority, but I do agree we should
try to fix it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
