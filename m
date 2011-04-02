From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Sat, 2 Apr 2011 07:58:10 GMT
Message-ID: <201104020758.p327wAMh010746@demeter1.kernel.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:44939 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DBH6L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 03:58:11 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p327wAf7010748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 2 Apr 2011 07:58:10 GMT
In-Reply-To: <bug-32482-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482





--- Comment #6 from Tom <egokillsall@gmail.com>  2011-04-02 07:58:08 ---
Thanks for your input Eric; yes, fsck is happy all the time (also with -fcc
flags). Find -xdev -inum 260099 shows nothing either, but in the past there was
possibly something there, so it makes sense regarding 'past stuff reminder'.
Anyway it would be *a bit more helpful* if it would tell us something about
it's *cool* behaviour, or at least some hint about some action I'd be able to
pop to clean things up.
De ja vu in the aspect of SMART, because n-2 of my n drives suffer from lovely
errors like 'uncorrectable' (because of bad cabling what got solved of course)
and 'write_dma' (right after I pulled the laptop out of the factory sealed box)
and such.
However this drive is one out of the ones without any error, and the long
self-test ran on it shows zero faults.
Memtest also passes all the time. At night.

Anything I can do to 'reset' this thing, or maybe some other recommendation I
should give a go?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
