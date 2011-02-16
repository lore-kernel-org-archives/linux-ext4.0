From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29212] noexec on file level (acl)
Date: Wed, 16 Feb 2011 15:02:21 GMT
Message-ID: <201102161502.p1GF2LGA032643@demeter1.kernel.org>
References: <bug-29212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:43736 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1BPPCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 10:02:22 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1GF2LpT032644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 15:02:21 GMT
In-Reply-To: <bug-29212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29212


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2011-02-16 15:02:19 ---
You can already turn off execute permission either using traditional Unix
permissions or via the current, existing ACL facility.

Note that it's actually pretty hard to stop a user from executing a file, since
it only requires one file system that is mounted w/o noexec, and then they can
simply copy the file (assuming they have read access) from its original
location to a location in their home directory, or /tmp perhaps, and execute it
there.

So it would first be useful if you were to describe exactly what your high
level goal is with having more fine-grained noexec capability.  What are you
trying to do?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
