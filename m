From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Sat, 21 Feb 2009 09:35:17 -0800 (PST)
Message-ID: <20090221173517.26D01108042@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbZBURfs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Feb 2009 12:35:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1LHZHeZ022593
	for <linux-ext4@vger.kernel.org>; Sat, 21 Feb 2009 09:35:18 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #16 from tytso@mit.edu  2009-02-21 09:35 -------
This patch has been merged into mainline.  I will work on getting this pushed
into a stable kernel.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
