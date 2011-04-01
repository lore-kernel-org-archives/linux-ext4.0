From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Fri, 1 Apr 2011 15:27:22 GMT
Message-ID: <201104011527.p31FRMsF030659@demeter1.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:43087 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab1DAP1X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 11:27:23 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p31FRMpc030660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Apr 2011 15:27:22 GMT
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182





--- Comment #2 from Ramses de Norre <ramses.rommel@gmail.com>  2011-04-01 15:27:22 ---
I don't have to do anything to reproduce it, the errors show up in dmesg while
starting up programs mostly. I also don't think there was a specific trigger
that caused it, just normal fs usage.
I guess there is either some corruption in my file system that fsck does not
fix or that the kernel is reporting errors while it shouldn't.
I can provide you with more debug info, but I'm not that familiar with the
tools to do so, if you could explain what data you need to understand where the
bug sits, I'd be happy to provide it to you.

HTH,
Ramses

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
