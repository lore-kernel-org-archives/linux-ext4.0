From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 20 May 2010 11:11:47 GMT
Message-ID: <201005201111.o4KBBlLC032543@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53777 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0ETLLs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2010 07:11:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4KBBlC9032544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 20 May 2010 11:11:47 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #25883|0                           |1
        is obsolete|                            |




--- Comment #40 from Jan Kara <jack@suse.cz>  2010-05-20 11:11:41 ---
Created an attachment (id=26456)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26456)
Patch to stop background writeback when other work is queued for the thread

Ah, there's a bug in the condition in the original patch and thus it stops
background writeback when there it *no* other work queued instead when there
*is*. Could you please test this fixed version?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
