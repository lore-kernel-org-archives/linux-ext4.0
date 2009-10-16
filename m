From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 16 Oct 2009 14:41:46 GMT
Message-ID: <200910161441.n9GEfkoo029410@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51355 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZJPOmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 10:42:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GEfk1F029411
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 14:41:46 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #62 from Theodore Tso <tytso@mit.edu>  2009-10-16 14:41:45 ---
Alexey, if reinstalling kernel modules is your best reproduction case, are you
seeing actual file system corruption, or simply zero-length files?  And are you
using the "sync" command after re-installing the kernel modules?

If it is actual file system corruption, try mounting the root filesystem with
"auto_da_alloc=0"  That is, add the boot command-line option
"rootflags=auto_da_alloc=0".   This will probably increase the likelihood of
zero-length files if you don't use "sync" after reinstalling the kernel modules
--- this is to be expected, since we are disabling the hueristic used to try to
avoid zero-length files which aren't synced out to disk before an unclean
shutdown.   The goal of this experiment is to see if maybe there's something
about this hueristic which is screwing up the ability to recover the filesystem
free of corruptions after an unclean shutdown.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
