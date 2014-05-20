From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75621] Permission denied trying to touch a file; happens
 randomly; both ext3 and GPFS
Date: Tue, 20 May 2014 10:49:47 +0000
Message-ID: <bug-75621-13602-NRuiAlsb96@https.bugzilla.kernel.org/>
References: <bug-75621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34455 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaETKtu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 06:49:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F7122035E
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2014 10:49:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C3CC720364
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2014 10:49:47 +0000 (UTC)
In-Reply-To: <bug-75621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75621

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

--- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk> ---
Thanks - given it was with 3rd party stuff loaded and not reproducible I'm not
sure there is anything more we can do

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
