From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Tue, 6 Sep 2011 05:56:55 GMT
Message-ID: <201109060556.p865utcL032648@demeter1.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56624 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1IFF44 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Sep 2011 01:56:56 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p865utIt032649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 6 Sep 2011 05:56:55 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #12 from Shaun Ruffell <sruffell@sruffell.net>  2011-09-06 05:56:45 ---
Probably this comment isn't needed, but I too have applied the patch and
haven't had any other strange behavior on 3.1-rc4.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
