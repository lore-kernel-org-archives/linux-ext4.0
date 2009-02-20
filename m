From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 19 Feb 2009 18:31:49 -0800 (PST)
Message-ID: <20090220023149.C0CB1108040@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbZBTCby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2009 21:31:54 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1K2VoJR008998
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2009 18:31:51 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #15 from fedux@lugmen.org.ar  2009-02-19 18:31 -------
There is another bug reported about the deadlock (
http://bugzilla.kernel.org/show_bug.cgi?id=12610 ) happening on 2.6.28.2 and
later.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
