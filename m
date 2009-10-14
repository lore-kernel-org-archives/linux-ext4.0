From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 03:17:22 GMT
Message-ID: <200910140317.n9E3HMTp003252@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33596 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZJNDR6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 23:17:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9E3HMUO003253
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 03:17:22 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #44 from Holger Freyther <zecke@selfish.org>  2009-10-14 03:17:21 ---
(In reply to comment #43)
> Hmm.... what were you doing right before the crash?   It looks like you were
> doing a kernel compile in /home/ich/source/linux/linux-2.6, since there were
> files with a modtime of  Tue Oct 13 16:25:55 2009.   What's a funny is that
> when these files were allocated, they used blocks that were apparently already
> in use by other object files in that some source directory with a mod-time of
> Sat Oct 10 13:51:14 2009.   Did you do a "make clean" at any time between
> Saturday and Tuesday that should have deleted these files?

Not a make clean but a "rm -rf *; git checkout ." after the previous corruption
in the source/linux/linux-2.6 directory.

Is it feasible to come up with a self test patch to ext4 to compare the
allocated block bitmap with the bitmap in memory?

I will do a fsck on every boot now and will setup a testsystem in the evening
to try to reproduce this (without dm/lvm inbetween).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
