From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12697] ext4_journal_start() spews errors on readonly filesystem
Date: Thu, 12 Feb 2009 11:50:15 -0800 (PST)
Message-ID: <20090212195015.6EFC8108048@picon.linux-foundation.org>
References: <bug-12697-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbZBLTvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 14:51:00 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CJoR7n025206
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 11:50:28 -0800
In-Reply-To: <bug-12697-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12697


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|sandeen@redhat.com          |fs_ext4@kernel-bugs.osdl.org
             Status|ASSIGNED                    |NEW
            Summary|MAINLINE                    |ext4_journal_start() spews
                   |                            |errors on readonly
                   |                            |filesystem




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
