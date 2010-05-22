From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Sat, 22 May 2010 17:03:08 GMT
Message-ID: <201005221703.o4MH38lB011685@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50621 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0EVRDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 May 2010 13:03:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4MH38VA011686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 22 May 2010 17:03:08 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #14 from David Lowe <lowe@brown.edu>  2010-05-22 10:11:37 ---
(In reply to comment #13)
> David, that's not an oops just a warning, and it's unrelated to this problem
> (fixed in fedora now, too, FWIW, kernel -102 or so).
> 
> see https://bugzilla.kernel.org/show_bug.cgi?id=15906#c26 & subsequent
> comments.
> 
> -Eric

I tried kernel 2.6.33.4-106.fc13.x86_64 and no longer get the warning.

However the ext4 errors are back with a vengeance -- auto fsck on reboot now
fails and a manual fsck is needed to repair the disk.

--- Comment #15 from Eric Sandeen <sandeen@redhat.com>  2010-05-22 17:03:03 ---
Testing on F13 in an x86 guest with pm-hibernate from runlevel 3 doesn't trip
up the error, so it's not something blindingly stupid/obvious/reproducible ...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
