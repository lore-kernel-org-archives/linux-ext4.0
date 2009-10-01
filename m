From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14286] kernel BUG at fs/ext4/extents.c:2863
Date: Thu, 1 Oct 2009 05:50:51 GMT
Message-ID: <200910010550.n915op5l019984@demeter.kernel.org>
References: <bug-14286-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58810 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZJAFur (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 01:50:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n915opiT019986
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 05:50:51 GMT
In-Reply-To: <bug-14286-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14286





--- Comment #2 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-10-01 05:50:50 ---
Created an attachment (id=23214)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23214)
fsfuzzer ext4 base image

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
