From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Fri, 20 Mar 2009 00:23:57 -0700 (PDT)
Message-ID: <20090320072358.57D68108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbZCTHZH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Mar 2009 03:25:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2K7Nwju030051
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2009 00:24:34 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #23 from andy-kernelbugzilla@splashground.de  2009-03-20 00:23 -------
Just commenting out the Archlinux patch, results in ext3 not being able to load
anymore:
ext3: Unknown symbol __grab_cache_page


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
