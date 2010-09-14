From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Tue, 14 Sep 2010 05:48:11 GMT
Message-ID: <201009140548.o8E5mBVc000760@demeter1.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44387 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0INFsM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Sep 2010 01:48:12 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8E5mB74000761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 14 Sep 2010 05:48:11 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #1 from Christian Casteyde <casteyde.christian@free.fr>  2010-09-14 05:48:04 ---
Update :
still present in 2.6.36-rc4.
However, the call stack is a little different now. As the computer crashes very
soon, I've taken a photo, see attachment.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
