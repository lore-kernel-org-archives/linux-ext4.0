From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16380] Loop devices act strangely in 2.6.35
Date: Tue, 22 Mar 2011 22:02:58 GMT
Message-ID: <201103222202.p2MM2wp6016186@demeter1.kernel.org>
References: <bug-16380-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36266 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab1CVWDD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 18:03:03 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2MM2wkv016187
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 22:02:58 GMT
In-Reply-To: <bug-16380-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16380


Artem S. Tashkinov <t.artem@mailcity.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Block Layer                 |ext2
         AssignedTo|axboe@kernel.dk             |fs_ext2@kernel-bugs.osdl.or
                   |                            |g
            Product|IO/Storage                  |File System




--- Comment #8 from Artem S. Tashkinov <t.artem@mailcity.com>  2011-03-22 22:02:54 ---
This is an ext2 fs bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
