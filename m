From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Thu, 19 May 2016 08:43:02 +0000
Message-ID: <bug-118401-13602-uSbOuBYAP7@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40357 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbcESInG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2016 04:43:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2931620218
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 08:43:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8B8D02021B
	for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 08:43:02 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #4 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 216701
  --> https://bugzilla.kernel.org/attachment.cgi?id=216701&action=edit
kernel config 4.2.8-040208-generic

kernel config of highest tested *booting* kernel

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
