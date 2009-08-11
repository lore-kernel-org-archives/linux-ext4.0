From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] ext4: panic causes lost data in git
Date: Tue, 11 Aug 2009 19:02:48 GMT
Message-ID: <200908111902.n7BJ2muw008148@demeter.kernel.org>
References: <bug-13964-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43585 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZHKTCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 15:02:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7BJ2m9u008149
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 19:02:48 GMT
In-Reply-To: <bug-13964-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13964





--- Comment #1 from Jesse Brandeburg <jesse.brandeburg@intel.com>  2009-08-11 19:02:48 ---
related info, I'll try the alloc_on_commit option
http://www.h-online.com/open/Ext4-data-loss-explanations-and-workarounds--/news/112892

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
