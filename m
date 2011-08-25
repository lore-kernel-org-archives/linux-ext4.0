From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Thu, 25 Aug 2011 10:34:41 GMT
Message-ID: <201108251034.p7PAYfM3013926@demeter1.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59277 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1HYKem (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 06:34:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7PAYf49013927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 10:34:42 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #6 from Witold Baryluk <baryluk@smp.if.uj.edu.pl>  2011-08-25 10:34:40 ---
Hmm. Sorry, last one probably have nothing to do with ext4. But, may help.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
