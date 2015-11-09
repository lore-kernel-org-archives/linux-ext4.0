From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Mon, 09 Nov 2015 09:24:04 +0000
Message-ID: <bug-107301-13602-S4sY15ehWj@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42782 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbKIJYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 04:24:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3BD58207A1
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 09:24:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 858672078B
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 09:24:04 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #8 from Laurent GUERBY <laurent@guerby.net> ---
Created attachment 192491
  --> https://bugzilla.kernel.org/attachment.cgi?id=192491&action=edit
xattr -l on random ceph files

I ran xattr on various ceph files on our cluster and there are small ones that
look mostly constant (or small value set), but the big ones "user.ceph._" are
clearly all differents (beginning common but there's probably hash or something
inside near the end).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
