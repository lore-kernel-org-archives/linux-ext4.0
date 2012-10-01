From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Mon,  1 Oct 2012 14:50:13 +0000 (UTC)
Message-ID: <20121001145013.1200F11FC25@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36880 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2JAOuP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2012 10:50:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 905432023D
	for <linux-ext4@vger.kernel.org>; Mon,  1 Oct 2012 14:50:14 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A682420216
	for <linux-ext4@vger.kernel.org>; Mon,  1 Oct 2012 14:50:13 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2012-10-01 14:50:12 ---
Ok, at this point we have no evidence that larger fs block sizes will be
required for this SSD.  That email from sandisk doesn't really tell us a whole
lot, simply saying "8k alignment" isn't terribly informative.  Is that the
minimum alignment, the physical alignment, etc.  I think someone will need to
get their hands on a device to see what it really advertises.  Scouting around
the web I've not seen any indication that this device has an 8k logical
blocksize; if it did there would surely be some noisy reviews out there about
how it doesn't work on x86 linux today, I think.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
