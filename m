From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36172] "kernel BUG at fs/ext4/super.c" triggered after
 tune2fs/remount
Date: Sun, 29 May 2011 21:50:52 GMT
Message-ID: <201105292150.p4TLoqRa032656@demeter1.kernel.org>
References: <bug-36172-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:38938 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1E2Vuw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 May 2011 17:50:52 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4TLoq7w032657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 29 May 2011 21:50:52 GMT
In-Reply-To: <bug-36172-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36172





--- Comment #1 from Manish Katiyar <mkatiyar@gmail.com>  2011-05-29 21:50:48 ---
Created an attachment (id=60002)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=60002)
Possible fix attached.

This patch fixes it for me.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
