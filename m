From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Random kmemcheck errors and kernel freeze on 2.6.36-rc*
Date: Sun, 10 Oct 2010 19:19:33 GMT
Message-ID: <201010101919.o9AJJXsC006356@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:41062 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0JJTTd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Oct 2010 15:19:33 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9AJJXFp006357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 10 Oct 2010 19:19:33 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #16 from Christian Casteyde <casteyde.christian@free.fr>  2010-10-10 19:19:29 ---
I also append .config file for my laptop, since it also has the problem as my
main computer.
I've tried to git bisect the problem on this laptop:

0f477dd0851bdcee82923da66a7fc4a44cb1bc3d is the first bad commit

However, I don't know if this is the same bug as described here, as I said I
cannot be sure.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
