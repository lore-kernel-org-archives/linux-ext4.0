From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31742] got a "kernel BUG at fs/dcache.c:440!"
Date: Wed, 23 Mar 2011 19:31:22 GMT
Message-ID: <201103231931.p2NJVM6r031948@demeter1.kernel.org>
References: <bug-31742-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:55332 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab1CWTbW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 15:31:22 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2NJVMQJ031949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 19:31:22 GMT
In-Reply-To: <bug-31742-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=31742


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
     Kernel Version|2.6.28                      |2.6.38




--- Comment #4 from Theodore Tso <tytso@mit.edu>  2011-03-23 19:31:19 ---
Can you replicate the problem, or was this a once-off?

Can you say more about your hardware configuration?  Was this on an SMP
machine?

Looking at the stack trace, this looks more like a VFS level issue than
something within ext4. 

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
