From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Random kmemcheck errors and kernel freeze on 2.6.36-rc*
Date: Sun, 10 Oct 2010 19:38:42 GMT
Message-ID: <201010101938.o9AJcgvC005808@demeter1.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55632 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0JJTin (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Oct 2010 15:38:43 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9AJcgCu005809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 10 Oct 2010 19:38:42 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hpa@zytor.com




--- Comment #19 from Rafael J. Wysocki <rjw@sisk.pl>  2010-10-10 19:38:36 ---
0f477dd0851bdcee82923da66a7fc4a44cb1bc3d is a merge commit, so it surely didn't
introduce the problem by itself, although it's quite probable that one of the
commits in this merge did that.

Adding Peter to the CC list.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
