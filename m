From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Thu, 6 May 2010 07:09:06 GMT
Message-ID: <201005060709.o46796l1023178@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47626 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0EFHJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 May 2010 03:09:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o467979M023182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 6 May 2010 07:09:07 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #18 from Jens Axboe <axboe@kernel.dk>  2010-05-06 07:08:55 ---
Created an attachment (id=26255)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26255)
Explicitly pass in whether sb is pinned or not

Revision two of this patch. I got rid of WB_SYNC_NONE_PIN, since we should not
further muddy the sync type and whether or not the sb is pinned. Instead lets
add a specific flag for this.

Untested, but it compiles.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
