From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 11 Jun 2015 18:46:04 +0000
Message-ID: <bug-89511-13602-ADyboOOq9p@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53517 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbbFKSqI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jun 2015 14:46:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 198552064E
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 18:46:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F23CC2060E
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 18:46:04 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Alan Stern <stern@rowland.harvard.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #179321|0                           |1
        is obsolete|                            |

--- Comment #60 from Alan Stern <stern@rowland.harvard.edu> ---
Created attachment 179661
  --> https://bugzilla.kernel.org/attachment.cgi?id=179661&action=edit
Add NO_SYNCHRONIZE_CACHE flag for usb-storage

Here's an updated version of the patch, with entries for Markus's and matt's
devices.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
