From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Mon, 17 May 2010 10:52:58 GMT
Message-ID: <201005171052.o4HAqwis020806@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41194 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0EQKw7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 May 2010 06:52:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4HAqwh8020807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 17 May 2010 10:52:58 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #24 from Jens Axboe <axboe@kernel.dk>  2010-05-17 10:52:54 ---
I'll add both patches to for-2.6.35 and mark them with a stable tag.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
