From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14287] ext4: fixpoint divide exception at ext4_fill_super
Date: Thu, 1 Oct 2009 05:59:39 GMT
Message-ID: <200910010559.n915xdOm020934@demeter.kernel.org>
References: <bug-14287-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37261 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZJAF7f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 01:59:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n915xdp4020935
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 05:59:39 GMT
In-Reply-To: <bug-14287-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14287





--- Comment #1 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-10-01 05:59:38 ---
Created an attachment (id=23215)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23215)
fsfuzzer image to recreate the kernel stack trace in tar gzipped format

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
