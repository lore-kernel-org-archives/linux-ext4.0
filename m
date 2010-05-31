From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory permissions for
 ACL'ed file systems
Date: Mon, 31 May 2010 07:50:50 GMT
Message-ID: <201005310750.o4V7ooME028407@demeter.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41579 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0EaHuv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 May 2010 03:50:51 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4V7ooUo028408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 31 May 2010 07:50:50 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875


Artem S. Tashkinov <t.artem@mailcity.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fs_vfs@kernel-bugs.osdl.org
          Component|ext2                        |VFS
            Summary|Add an option to disable    |Add an option to disable
                   |file/directory permissions  |file/directory permissions
                   |for ext2/ext3/ext4 file     |for ACL'ed file systems
                   |systems                     |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
