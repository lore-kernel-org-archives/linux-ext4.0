From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 08:37:04 -0800 (PST)
Message-ID: <20090212163704.3CADE108047@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757623AbZBLQhq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 11:37:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CGbDKZ010259
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 08:37:14 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #2 from aneesh.kumar@linux.vnet.ibm.com  2009-02-12 08:37 -------
Two commits which are already in the mainline which fixed some changes
after .28 are

89e1219004b3657cc014521663eeef0744f1c99d
dcf6a79dda5cc2a2bec183e50d829030c0972aaa


Both changes have implication wrt ext4. I would suggest try with the
above two commits and see if the problem still exist.

-aneesh


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
