From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Tue, 08 Jul 2014 13:43:46 +0000
Message-ID: <bug-78651-13602-8ucl78z6op@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43487 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbaGHNns (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 09:43:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 25825202FF
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:43:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 665EE2015A
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:43:46 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #13 from Joseph D. Wagner <joe@josephdwagner.info> ---
Created attachment 142491
  --> https://bugzilla.kernel.org/attachment.cgi?id=142491&action=edit
memstats 256mb journal

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
