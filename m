From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14300] BUG_ON crash w/ ext4
Date: Thu, 1 Oct 2009 22:20:46 GMT
Message-ID: <200910012220.n91MKkwT012708@demeter.kernel.org>
References: <bug-14300-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34241 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZJAWUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 18:20:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n91MKkfR012709
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 22:20:46 GMT
In-Reply-To: <bug-14300-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14300


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-10-01 22:20:45 ---
References : http://marc.info/?l=linux-kernel&m=125436568504914&w=4

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
