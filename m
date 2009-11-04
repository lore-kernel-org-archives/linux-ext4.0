From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14287] ext4: fixpoint divide exception at ext4_fill_super
Date: Wed, 4 Nov 2009 14:05:15 GMT
Message-ID: <200911041405.nA4E5F59019628@demeter.kernel.org>
References: <bug-14287-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55441 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZKDOFK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 09:05:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA4E5FFk019629
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 14:05:15 GMT
In-Reply-To: <bug-14287-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14287


R.N.Sastry <rnsastry@linux.vnet.ibm.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #23647|0                           |1
        is obsolete|                            |




--- Comment #6 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-11-04 14:05:14 ---
Created an attachment (id=23648)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23648)
Patch which solves this fixpoint division exception

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
