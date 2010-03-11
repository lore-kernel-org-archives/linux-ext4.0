From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Thu, 11 Mar 2010 17:42:21 GMT
Message-ID: <201003111742.o2BHgLaH010560@demeter.kernel.org>
References: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50686 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab0CKRmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 12:42:22 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2BHgLs1010562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 11 Mar 2010 17:42:21 GMT
In-Reply-To: <bug-15420-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15420





--- Comment #18 from Theodore Tso <tytso@mit.edu>  2010-03-11 17:42:06 ---
On Thu, Mar 11, 2010 at 04:00:27PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> Indeed, the logic in ext4_indirect_calc_metadata_amount seems to be broken.
> Attached patch fixes it for me...

Nice catch.  Yeah, I really screwed that up!

I'll get that into the ext4 patch queue, quickly, and get that pushed
to Linus.

                    - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
