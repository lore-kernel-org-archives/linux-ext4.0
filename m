From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12354] Advisory: Debian's current initramdisk scripts break with an ext4 root
Date: Sun,  4 Jan 2009 11:14:09 -0800 (PST)
Message-ID: <20090104191409.C28DD10800E@picon.linux-foundation.org>
References: <bug-12354-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755901AbZADTOn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 14:14:43 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n04JE9QI020838
	for <linux-ext4@vger.kernel.org>; Sun, 4 Jan 2009 11:14:10 -0800
In-Reply-To: <bug-12354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12354


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hpa@zytor.com




------- Comment #2 from tytso@mit.edu  2009-01-04 11:14 -------
I submitted a patch to klibc@zytor.com mailing list on Sat, 11 Oct 2008
10:54:44 -0400.  (Subject line: [PATCH] fstype: Fix ext4/ext4dev probing).

No one ever got back to me.  hpa?   Do you need me to resend?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
