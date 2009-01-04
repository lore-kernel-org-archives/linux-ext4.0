From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12354] Advisory: Debian's current initramdisk scripts break with an ext4 root
Date: Sun,  4 Jan 2009 11:16:10 -0800 (PST)
Message-ID: <20090104191610.6FE9310800E@picon.linux-foundation.org>
References: <bug-12354-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbZADTQN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 14:16:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n04JGAdX020987
	for <linux-ext4@vger.kernel.org>; Sun, 4 Jan 2009 11:16:11 -0800
In-Reply-To: <bug-12354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12354





------- Comment #3 from tytso@mit.edu  2009-01-04 11:16 -------
Created an attachment (id=19648)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19648&action=view)
Patch to klibc to allow it to properly probe ext4/ext4dev filesystems


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
