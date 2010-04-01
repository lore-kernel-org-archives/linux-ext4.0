From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15666] e2fsck -fD on ext4 breaks
Date: Thu, 1 Apr 2010 11:51:26 GMT
Message-ID: <201004011151.o31BpQc6016440@demeter.kernel.org>
References: <bug-15666-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48608 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab0DALwU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 07:52:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o31BpSH6016447
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 11:51:28 GMT
In-Reply-To: <bug-15666-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15666


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |PATCH_ALREADY_AVAILABLE
         Regression|Yes                         |No




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2010-04-01 11:50:10 ---
This isn't a kernel bug (and this is a bugzilla for tracking kernel problems).

This was a bug in e2fsprogs 1.41.10, which was fixed in e2fsprogs 1.41.11.

I suggest you upgrade, and I apologize for the inconvenience.   In general data
isn't lost, although files and directories do get dropped into the lost+found
directory, and cleaning up can be a bit of a mess.

Best regards,

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
