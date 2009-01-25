From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12533] with extents, ext4 block count wrong
Date: Sat, 24 Jan 2009 21:38:12 -0800 (PST)
Message-ID: <20090125053812.92DD510800C@picon.linux-foundation.org>
References: <bug-12533-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbZAYFiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Jan 2009 00:38:15 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0P5cC41024753
	for <linux-ext4@vger.kernel.org>; Sat, 24 Jan 2009 21:38:14 -0800
In-Reply-To: <bug-12533-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12533





------- Comment #2 from tytso@mit.edu  2009-01-24 21:38 -------
Yup.   I suggest that you use debugfs, and that you look at some valid
filesystems before you start filing more bugs in the future....


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
