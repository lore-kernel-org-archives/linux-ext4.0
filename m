From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19362] WARNING: at fs/fs-writeback.c:87
 __mark_inode_dirty+0x1f2/0x230()
Date: Thu, 30 Sep 2010 13:10:49 GMT
Message-ID: <201009301310.o8UDAnTc018978@demeter1.kernel.org>
References: <bug-19362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37645 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab0I3NKu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Sep 2010 09:10:50 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8UDAoBG018979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 30 Sep 2010 13:10:50 GMT
In-Reply-To: <bug-19362-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19362





--- Comment #1 from Thomas Renninger <trenn@suse.de>  2010-09-30 13:10:45 ---
Created an attachment (id=32032)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=32032)
Warnings in dmesg after was up for about 3 hours

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
