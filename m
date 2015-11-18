From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Wed, 18 Nov 2015 20:48:49 +0000
Message-ID: <bug-107301-13602-QDfwkg9EHc@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58232 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbbKRUsw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2015 15:48:52 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 81D4F20452
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2015 20:48:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F0D7B203DA
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2015 20:48:49 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #18 from Laurent GUERBY <laurent@guerby.net> ---
Should I formally submit the mbcache removal patch?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
