From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118041] My tricky script involving zram and device mapper hangs
 on "mount"
Date: Tue, 17 May 2016 17:55:34 +0000
Message-ID: <bug-118041-13602-KpNTEpFQnb@https.bugzilla.kernel.org/>
References: <bug-118041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbcEQRzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 13:55:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6E848201C0
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 17:55:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C34B2201FE
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 17:55:34 +0000 (UTC)
In-Reply-To: <bug-118041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118041

--- Comment #3 from _Vi <vi0oss@gmail.com> ---
Created attachment 216451
  --> https://bugzilla.kernel.org/attachment.cgi?id=216451&action=edit
Stand-alone version of the script which crashes my system

Added the script

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
