From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Tue,  3 Mar 2009 21:41:35 -0800 (PST)
Message-ID: <20090304054135.73A0810800D@picon.linux-foundation.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbZCDFli (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 00:41:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n245fZjI002384
	for <linux-ext4@vger.kernel.org>; Tue, 3 Mar 2009 21:41:36 -0800
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151





------- Comment #4 from sandeen@redhat.com  2009-03-03 21:41 -------
If you can try the 2.6.29 kernels out of koji and see if you still hit this
it'd be great.  As I mentioned on IRC I have found another race w/ inode
alloc/free but it's not likely to lead to as much damage as your above fsck
found.

Have you been hitting this reliably?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
