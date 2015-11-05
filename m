From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104571] ext4_mb_generate_buddy block bitmap and bg descriptor
 inconsistent
Date: Thu, 05 Nov 2015 07:38:32 +0000
Message-ID: <bug-104571-13602-NolSOdWkHA@https.bugzilla.kernel.org/>
References: <bug-104571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35139 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161154AbbKEHie (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2015 02:38:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 35C9A20829
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 07:38:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 67C7920824
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 07:38:32 +0000 (UTC)
In-Reply-To: <bug-104571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104571

--- Comment #4 from Sander Smeenk <linux-ext4@freshdot.net> ---
And again it went RO. libvirt/kvm Cache Mode / IO Mode is not related, it
seems, was worth a shot...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
