From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory permissions for
 ext2/ext3/ext4 file systems
Date: Thu, 29 Apr 2010 10:16:21 GMT
Message-ID: <201004291016.o3TAGL1M006173@demeter.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab0D3RbW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 13:31:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3TAGLm3006176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 Apr 2010 10:16:21 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875





--- Comment #4 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-04-29 10:16:06 ---
It doesn't work:

# dd if=/dev/zero of=ext2.img bs=100M count=1
...
# mke2fs ext2.img -> y
...
# mount -o loop,noacl ext2.img loop
# mount | grep noacl
/dev/loop0 on /tmp/loop type ext2 (rw,noacl)

$ cd /tmp/loop
$ touch test
touch: cannot touch `test': Permission denied

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
