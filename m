From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Fri, 2 Sep 2011 14:23:59 GMT
Message-ID: <201109021423.p82ENxlV002388@demeter1.kernel.org>
References: <bug-14562-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41448 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1IBOYA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 10:24:00 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p82EO0WA002389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Sep 2011 14:24:00 GMT
In-Reply-To: <bug-14562-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14562


sanjeev mk <sanjeevmk4890@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sanjeevmk4890@gmail.com




--- Comment #6 from sanjeev mk <sanjeevmk4890@gmail.com>  2011-09-02 14:23:55 ---
Not reproduced on 2.6.39.4 and 2.6.38.8. Mounted my 200 GB ext4 filesystem with
auto_da_alloc option. No warnings. Relevant dmesg output after mounting:

[  309.283335] EXT4-fs (sdb8): mounted filesystem with ordered data mode. Opts:
auto_da_alloc

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
