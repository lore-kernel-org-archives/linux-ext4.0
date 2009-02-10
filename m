From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12672] lockdep warning when using ext4 on x86_64
Date: Mon,  9 Feb 2009 19:04:03 -0800 (PST)
Message-ID: <20090210030404.06C70108041@picon.linux-foundation.org>
References: <bug-12672-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZBJDEI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 22:04:08 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1A344rn022604
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 19:04:05 -0800
In-Reply-To: <bug-12672-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12672


miaox@cn.fujitsu.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |miaox@cn.fujitsu.com
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #3 from miaox@cn.fujitsu.com  2009-02-09 19:04 -------
This patch is available.

Tested-by: Miao Xie <miaox@cn.fujitsu.com>


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
