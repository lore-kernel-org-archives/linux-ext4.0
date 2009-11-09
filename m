From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 9 Nov 2009 14:54:25 GMT
Message-ID: <200911091454.nA9EsPlh013795@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58103 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZKIOyU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2009 09:54:20 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA9EsPC3013796
	for <linux-ext4@vger.kernel.org>; Mon, 9 Nov 2009 14:54:25 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #185 from Chris Mason <chris.mason@oracle.com>  2009-11-09 14:54:13 ---
Good point on the symlink code we must be copying the null already.

There's another strange one I hit at mount time last week but forgot to
include.  It could be noise from earlier debugging runs of the patch that left
readonly pages setting around, but I think if I squint really it makes sense.

During mounts and remounts, ext4 will mess around with the flags on the journal
super.  I don't see exactly where the buffer is logged or prepared...most of
the callers of jbd2_journal_clear_features look like they need a bigger audit
to me.

Does anyone know the perf cost of forcing the page ro/rw?  I'm looking at
integrating it into a CONFIG_DEBUG_CSUMS for btrfs.  For any individual page it
shouldn't happen too often, but we'd be hammering on it pretty good during a
commit.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
