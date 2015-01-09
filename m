From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 09 Jan 2015 21:19:48 +0000
Message-ID: <bug-89511-13602-5BIUZ12lGM@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45638 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbbAIVTy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 16:19:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D16A520642
	for <linux-ext4@vger.kernel.org>; Fri,  9 Jan 2015 21:19:52 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3A4AF20634
	for <linux-ext4@vger.kernel.org>; Fri,  9 Jan 2015 21:19:51 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #46 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 162991
  --> https://bugzilla.kernel.org/attachment.cgi?id=162991&action=edit
As a result of 3.18.2

Even 3.18.2 is the same as 3.2.62.
A disorder occurs when I reset a USB HDD.
> report_20150110_3.18.2_1.txt

When it is a different controller, behavior is different.
> report_20150110_3.18.2_2.txt

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
