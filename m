From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 12 Oct 2009 18:15:16 GMT
Message-ID: <200910121815.n9CIFGXi020499@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43425 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbZJLSPw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 14:15:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9CIFG8t020500
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 18:15:16 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #25 from Theodore Tso <tytso@mit.edu>  2009-10-12 18:15:15 ---
Hi, I'm trying to track down a problem relating to ext4 problems, in
kernel bugzilla 14354.  Originally it was thought this was a regression
2.6.31->2.6.32-rc1 regression, but the Aneesh Kumar's report shows a
very similar fsck transcript using a 2.6.30-1 kernel (which makes makes
it unclear whether this is really a regression or not), and all three
reports are tied together by the use of device-mapper.  

The fsck logs are consistent barriers being disabled.  As I recall under
some circumstances device mapper silently drops barrier requests --- I
thought this was fixed for device mapper in some cases.  What's the
current status of barrier requests in device mapper?  Are they
faithfully passed for standard (non-RAID) LVM2 volumes?  When was this
changed?   What about dm-crypto volumes?  (One of the reports was with a
dm-crypt volume from what I can tell.)

Thanks,

                        - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
