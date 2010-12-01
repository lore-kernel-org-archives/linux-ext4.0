From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Wed, 1 Dec 2010 14:58:52 GMT
Message-ID: <201012011458.oB1EwqFa015258@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:45856 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0LAO6w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 09:58:52 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oB1EwqXn015259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 1 Dec 2010 14:58:52 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #20 from Eric Sandeen <sandeen@redhat.com>  2010-12-01 14:58:43 ---
(In reply to comment #18)


> > Your dd above should have zeroed this out, though, which makes me wonder how
> > you got 1's back in here.  It could be anything, though I wonder if it's
> > possible that it's a stray bitmap....
> 
> No, my "dd" command only zeroed out the second half of the superblock (starting
> at 0x600, the s_mount_opts field.  It didn't touch the "error" parts of the
> superblock, for simplicity/safety.

Oh, sorry, I just assumed.  Thanks for the clarification.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
