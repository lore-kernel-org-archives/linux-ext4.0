From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  7 Sep 2012 18:03:22 +0000 (UTC)
Message-ID: <20120907180322.2ACFD11FC25@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46734 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2IGSD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Sep 2012 14:03:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 57608203C7
	for <linux-ext4@vger.kernel.org>; Fri,  7 Sep 2012 18:03:27 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B2078203BF
	for <linux-ext4@vger.kernel.org>; Fri,  7 Sep 2012 18:03:22 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #2 from Elmar Stellnberger <estellnb@elstel.org>  2012-09-07 18:03:21 ---
  Perhaps a file system block size of 8KB and higher should only be supported
if the user boots in an adequate paging mode. PAE paging and IA-32e paging f.i.
support a physical page size of 2MB. This may even be more efficient for
certain usage scenarios (especially with a rich memory accouterment) as the
page table will hereby get smaller.
  Another idea would simply be to keep sufficient chunks of 8KB and guarantee
allocation in 8KB chunks if the allocation area or segment size is being kept a
multiple of 8KB starting at an 8KB aligned address (I don`t think it would be
that hard to manage since most segments are bigger than 4KB and 8KB chunks
could also be used for these 4KB chunked and aligned segments.)

btw.: it was filed as enhancement

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
