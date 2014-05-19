From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75621] Permission denied trying to touch a file; happens
 randomly; both ext3 and GPFS
Date: Mon, 19 May 2014 11:08:06 +0000
Message-ID: <bug-75621-13602-pbGhT9Hycp@https.bugzilla.kernel.org/>
References: <bug-75621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbaESLIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 07:08:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 83592201F4
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 11:08:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2B1BC2028D
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 11:08:07 +0000 (UTC)
In-Reply-To: <bug-75621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75621

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk

--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk> ---
Can you reproduce this on an upstream Linux system without GPFS, or does it
need GPFS added ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
