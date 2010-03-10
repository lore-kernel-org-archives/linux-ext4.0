From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Wed, 10 Mar 2010 15:28:18 GMT
Message-ID: <201003101528.o2AFSII9018879@demeter.kernel.org>
References: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57597 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0CJP2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 10:28:18 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2AFSI8h018880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 15:28:18 GMT
In-Reply-To: <bug-15420-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15420





--- Comment #12 from Theodore Tso <tytso@mit.edu>  2010-03-10 15:28:12 ---
Well, let's figure out what actually broke, and why.   The vast majority of
files are not appended to after they are first written, I suspect the migration
story still works.   And this issue with over-aggressive estimation for space
needed for indirect blocks is probably something recent in 2.6.33, and I think
we can fix it --- and even if it isn't, I'd really like to know what
applications are checking statfs and aborting as a result, and under what
situations this is happening.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
