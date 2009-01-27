From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12543] ext4_da_writepages error in 2.6.28.1 after a disk error
Date: Tue, 27 Jan 2009 10:19:16 -0800 (PST)
Message-ID: <20090127181916.46B33108040@picon.linux-foundation.org>
References: <bug-12543-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbZA0STs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 13:19:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0RIJGFn006006
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 10:19:17 -0800
In-Reply-To: <bug-12543-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12543


DiegoCG@teleline.es changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |DiegoCG@teleline.es




------- Comment #1 from DiegoCG@teleline.es  2009-01-27 10:19 -------
IMHO I'd say there's a broken sector, have you passed a badblocks test? (but
ext4 should have handled the failure gracefully)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
