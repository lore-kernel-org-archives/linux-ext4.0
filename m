From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Mon, 4 Apr 2011 14:14:38 GMT
Message-ID: <201104041414.p34EEcv1012760@demeter2.kernel.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:38662 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1DDOOj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 10:14:39 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p34EEcu2012761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 4 Apr 2011 14:14:38 GMT
In-Reply-To: <bug-32482-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
                 CC|                            |tytso@mit.edu
         Resolution|PATCH_ALREADY_AVAILABLE     |UNREPRODUCIBLE




--- Comment #10 from Theodore Tso <tytso@mit.edu>  2011-04-04 14:14:37 ---
OK, so I'll close this bug as a hardware error.  If you can get something
reproducible that you think points this at being a file system bug, please
reopen this bug.  Thanks!!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
