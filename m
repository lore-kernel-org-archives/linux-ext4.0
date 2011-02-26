From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Sat, 26 Feb 2011 10:48:45 GMT
Message-ID: <201102261048.p1QAmjSD004257@demeter1.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47467 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1BZKsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 05:48:46 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1QAmjoM004259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 10:48:45 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #11 from Lukas Czerner <lczerner@redhat.com>  2011-02-26 10:48:42 ---
Hi Eric,

thanks for the patch. I have almost the same one, except you do not
really need "done" variable, but instead just do:

    while (issued--)

Also, there is no need for bio_end_io_t in struct bio_batch, but it does
not affect the results, obviously. Finally, I was able to reproduce the
problem so I'll give it a try as well.

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
