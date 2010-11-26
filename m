From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Fri, 26 Nov 2010 02:57:10 GMT
Message-ID: <201011260257.oAQ2vA7H000405@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:54724 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0KZC5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 21:57:11 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAQ2vAZH000406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Nov 2010 02:57:10 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2010-11-26 02:57:06 ---
Hmm.... is this panic repeatable?

And can you send me the first 4k of the filesystem?  i.e., do a "dd
if=/dev/dsk/by-label/MyBook of=/tmp/sb.img bs=4k count=1" and then attach
/tmp/sb.img to this bug?

Thanks,

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
