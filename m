From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14286] kernel BUG at fs/ext4/extents.c:2863
Date: Thu, 1 Oct 2009 05:47:33 GMT
Message-ID: <200910010547.n915lXY6019577@demeter.kernel.org>
References: <bug-14286-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44068 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZJAFr3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 01:47:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n915lXJk019578
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 05:47:33 GMT
In-Reply-To: <bug-14286-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14286





--- Comment #1 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-10-01 05:47:31 ---
Created an attachment (id=23213)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23213)
fsfuzzer image to recreate the kernel stack trace in tar gzipped format

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
