From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 03 Dec 2015 23:52:57 +0000
Message-ID: <bug-89511-13602-j35pXe8Zkg@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34133 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbbLCXxC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2015 18:53:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3CCF1205FA
	for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2015 23:53:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E46B0205D1
	for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2015 23:52:58 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #71 from bradhaack@fastmail.us <bradhaack@fastmail.us> ---
Thanks Christian and Alan.  I wasn't aware of the sudo & redirection not
working that way.  

I got my system working with
sudo -s
echo 'temporary write through' >  /sys/block/sdb/device/scsi_disk/*/cache_type 

it seems to be permanent.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
