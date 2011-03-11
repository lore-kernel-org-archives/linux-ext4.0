From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Fri, 11 Mar 2011 08:13:07 GMT
Message-ID: <201103110813.p2B8D70I016703@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:49343 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1CKINI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Mar 2011 03:13:08 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2B8D70X016715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Mar 2011 08:13:07 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402


Lukas Czerner <lczerner@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #49642|0                           |1
        is obsolete|                            |




--- Comment #18 from Lukas Czerner <lczerner@redhat.com>  2011-03-11 08:13:05 ---
Created an attachment (id=50622)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=50622)
Simplification to avoid bad ordering

This is new version of the bug fix, which has been tested by Eric Whitney and
posted (https://patchwork.kernel.org/patch/627671/).

Quoting Eric:
"No panics, another full pass through the ffsb workloads on the three ext4
variants without trouble, and the system logs are clean as well."

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
