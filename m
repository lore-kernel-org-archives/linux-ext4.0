From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14287] ext4: fixpoint divide exception at ext4_fill_super
Date: Wed, 4 Nov 2009 12:54:09 GMT
Message-ID: <200911041254.nA4Cs9Ri029079@demeter.kernel.org>
References: <bug-14287-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42019 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbZKDMyE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 07:54:04 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA4Cs99p029080
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 12:54:09 GMT
In-Reply-To: <bug-14287-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14287





--- Comment #5 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-11-04 12:54:07 ---
Created an attachment (id=23647)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23647)
Patch which solves this fixpoint division exception

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
