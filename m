From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12370] kernel BUG at fs/jbd2/journal.c:1108
Date: Tue,  6 Jan 2009 07:13:02 -0800 (PST)
Message-ID: <20090106151302.7A76310800F@picon.linux-foundation.org>
References: <bug-12370-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbZAFPNx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 10:13:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06FDKbQ005923
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 07:13:21 -0800
In-Reply-To: <bug-12370-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12370





------- Comment #4 from jack@suse.cz  2009-01-06 07:13 -------
Created an attachment (id=19677)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19677&action=view)
Patch fixing possible oopses due to failing getblk()


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
