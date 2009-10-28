From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 28 Oct 2009 06:44:06 GMT
Message-ID: <200910280644.n9S6i6P7007417@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57144 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbZJ1GoC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2009 02:44:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9S6i6IL007418
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2009 06:44:06 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #138 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-28 06:44:01 ---
(In reply to comment #137)
> This is not a valid test.  Mounting with "-o noload" will discard all of the
> transaction information in the journal, and virtually guarantee the filesystem
> is inconsistent.  It will be no better than ext2, which requires a full e2fsck
> run after each crash.  This is NOT a valid reproducer for this problem.

Grr... i know my english is not good, but is it really hard to understand why i
mean? "noload" is not used to reproduce crash! To crash i use default options
of distribution. 
In this bug i do not trust distribution to run fsck, so i do it manually. I
start in to initrd, so root is not mounted! Then i mount it manually to be sure
it is readonly. Normally i mounted on this stage with option "-o ro". The
result of thees was - we newer so "jurnal corruption", because the kernel
silently "repaired" it.
Now i use "-o ro,noload" to mount root and run fsck (not to reproduce crush).
And now i can see, journal is not corrupted after normal crush. If yournall is
corrupt all fs is corrupt too.
Now is the question: do we use journal to recover fs? if we use broken journal
how this recovery will look like? Do we get this "multiply claimed blocks"
because we get wrong information from journal and this is the reason, why some
times files which was written long time before are corrupt too?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
