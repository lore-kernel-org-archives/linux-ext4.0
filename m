From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 15:57:27 GMT
Message-ID: <201006021557.o52FvQZg028758@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53508 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0FBP51 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 11:57:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52FvR3l028759
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 15:57:27 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081


lkolbe@techfak.uni-bielefeld.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #26590|0                           |1
        is obsolete|                            |




--- Comment #7 from lkolbe@techfak.uni-bielefeld.de  2010-06-02 15:57:20 ---
Created an attachment (id=26618)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26618)
oops after writing 1TB 

This was rather sooner than expected, after writing about 1TB of data to two
ext4 filesystems with approx. 150MB/sec.

Hopefully this trace means something?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
