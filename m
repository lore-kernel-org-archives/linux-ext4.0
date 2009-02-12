From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 08:44:36 -0800 (PST)
Message-ID: <20090212164436.A3579108042@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756980AbZBLQpa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 11:45:30 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CGia5g011144
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 08:44:37 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
      KernelVersion|2.6.29-rc2-git1             |2.6.29-rc4




------- Comment #3 from sandeen@redhat.com  2009-02-12 08:44 -------
Aneesh, thanks.  I tried both of those last night, and the problem persists.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
