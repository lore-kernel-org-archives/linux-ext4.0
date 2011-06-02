From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36262] ext3 umount: BUG: unable to handle kernel paging request
Date: Thu, 2 Jun 2011 10:23:12 GMT
Message-ID: <201106021023.p52ANCP7001604@demeter2.kernel.org>
References: <bug-36262-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36102 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab1FBKXN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 06:23:13 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p52ANDFi001605
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jun 2011 10:23:13 GMT
In-Reply-To: <bug-36262-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36262


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |axboe@kernel.dk




--- Comment #3 from Jan Kara <jack@suse.cz>  2011-06-02 10:23:12 ---
Hmm, by any chance, was the USB disk pulled before the umount actually run?

Jens, it seems we have destroyed the BDI before the filesystem was properly
unmounted (the oops is just NULL pointer dereference hidden by new percpu code)
because fbc->counters == NULL for the BDI_RECLAIMABLE stats counter.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
