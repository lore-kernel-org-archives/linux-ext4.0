From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12433] Oops while resizing an ext4 LVM2 volume
Date: Tue,  3 Feb 2009 11:18:51 -0800 (PST)
Message-ID: <20090203191851.E6E5411D109@picon.linux-foundation.org>
References: <bug-12433-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882AbZBCTTX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 14:19:23 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n13JIp2S008283
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 11:18:52 -0800
In-Reply-To: <bug-12433-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12433


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #4 from tytso@mit.edu  2009-02-03 11:18 -------
This patch has been merged into the Linux mainline and should be in 2.6.29-rc4
(and newer) releases.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
