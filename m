From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Mon, 09 Nov 2015 10:11:07 +0000
Message-ID: <bug-107301-13602-KrGwbRdeOi@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45706 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbbKIKLL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 05:11:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 18663203B1
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 10:11:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 827232040F
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 10:11:07 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #9 from Laurent GUERBY <laurent@guerby.net> ---
Note: ceph files are all big in our use case since we use it for rbd, about 4
Mbyte each, so two or three additional xattr blocks per file won't change disk
usage in volume for us. For people using ceph as object store and with their
own use of xattr the situation could be different.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
