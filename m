From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Thu, 31 Mar 2011 19:24:10 GMT
Message-ID: <201103311924.p2VJOAkM028050@demeter1.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37407 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019Ab1CaTYL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 15:24:11 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2VJOAHR028051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Mar 2011 19:24:10 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352





--- Comment #17 from Martin Steigerwald <Martin@Lichtvoll.de>  2011-03-31 19:24:08 ---
Well I pretty much think that it was the same resize bug, but then it might as
well have been the BIOS thing (although I doubt it).

FWIW it was one machine, that ThinkPad T42, but different fsck.ext4 runs. When
the fsck.ext4 ran till the out of memory error the filesystem was unmountable
afterwards. When I quitted it before I was able to mount it.

Sorry for not using LANG=C with fsck.ext4, but at that time all I wanted is to
have my data back - nothing else mattered.

Anyway should I face an issue like that again, I will open a reparate bug
report and only hint that it might be the same problem as some other bug. I
also try to remember to use LANG=C.

So leave closed - I believe I hit that resize bug and all is well again.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
