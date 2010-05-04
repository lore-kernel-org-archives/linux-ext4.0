From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Tue, 4 May 2010 20:37:33 GMT
Message-ID: <201005042037.o44KbX0F009791@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41926 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608Ab0EDUhd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 16:37:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44KbXcr009792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 20:37:33 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #1 from Kees Cook <kees@outflux.net>  2010-05-04 20:37:32 ---
Sorry, I meant Fedora 13 (Beta).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
