From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15806] Kernel Panic or Kernel becomes unstable with encrypted
 drives (TrueCrypt)
Date: Mon, 19 Apr 2010 15:19:43 GMT
Message-ID: <201004191519.o3JFJhAM022477@demeter.kernel.org>
References: <bug-15806-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60284 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0DSPTo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 11:19:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3JFJhSx022478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 15:19:43 GMT
In-Reply-To: <bug-15806-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15806


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-04-19 15:19:40 ---
I don't see anything in the oops that looks at all ext4-specific - unless you
can show otherwise, I'm guessing that this is a bug in another layer...

If this is triggered by doing userspace IO on the block device (i.e. via fsck)
that's another clue that it's a problem in the (crypted) block layer rather
than the filesystem, I think.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
