From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16401] 2.6.35-r5 ext3 corruptions
Date: Mon, 19 Jul 2010 23:41:58 GMT
Message-ID: <201007192341.o6JNfwZi012446@demeter.kernel.org>
References: <bug-16401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42883 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0GSXl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jul 2010 19:41:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6JNfwDo012449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jul 2010 23:41:59 GMT
In-Reply-To: <bug-16401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16401





--- Comment #1 from Dave Chinner <david@fromorbit.com>  2010-07-19 23:41:54 ---
The problem appears to have been specific to a single filesystem that was
corrupted in some way that e2fsck did not detect. e2fsck would report the fs as
clean (even with a forced check) but the problem would come back, always on
inodes around the 211,000 number.

The filesystem eventually trashed itself, but I made a fat-fingered mistake and
backed up the wrong image whenthe problem first manifested. Hence I can't
reproduce the problem now because I had to re-image the root drive.

>From this, I'd say this is not a regression, so closing this bug is fine by
me...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
