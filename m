From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 6 Apr 2010 16:50:33 GMT
Message-ID: <201004061650.o36GoXXS019915@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40435 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab0DFQue (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Apr 2010 12:50:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o36GoXYA019916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 6 Apr 2010 16:50:33 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #25882|Patch to stop background    |Patch to stop background
        description|writeback when other IO is  |writeback when other work
                   |in progress                 |is queued for the thread




--- Comment #26 from Jan Kara <jack@suse.cz>  2010-04-06 16:47:54 ---
Created an attachment (id=25882)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25882)
Patch to stop background writeback when other IO is in progress

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
