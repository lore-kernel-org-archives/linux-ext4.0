From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Wed, 24 Aug 2011 21:50:48 GMT
Message-ID: <201108242150.p7OLomN1017350@demeter1.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:55040 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1HXVus (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Aug 2011 17:50:48 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7OLomVT017351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 21:50:48 GMT
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182


Peter Hanecak <hany+kernel.org@hany.sk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hany+kernel.org@hany.sk




--- Comment #10 from Peter Hanecak <hany+kernel.org@hany.sk>  2011-08-24 21:50:19 ---
I'm seeing similar errors during boot:

[   91.652208] EXT4-fs error (device dm-0): ext4_ext_check_inode: inode
#1839235: (comm Xorg) bad header/extent: invalid magic - magic 0, entries 0,
max 0(0), depth 0(0)
[   91.940546] EXT4-fs error (device dm-0): ext4_ext_check_inode: inode
#1839235: (comm Xorg) bad header/extent: invalid magic - magic 0, entries 0,
max 0(0), depth 0(0)
[   91.954354] EXT4-fs error (device dm-0): ext4_ext_check_inode: inode
#1839235: (comm Xorg) bad header/extent: invalid magic - magic 0, entries 0,
max 0(0), depth 0(0)
[   93.449371] EXT4-fs error (device dm-0): ext4_ext_check_inode: inode
#1839235: (comm Xorg) bad header/extent: invalid magic - magic 0, entries 0,
max 0(0), depth 0(0)

Some additional information:

# uname -r
2.6.35.14-95.fc14.x86_64

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
