From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65341] file is not opened when double click
Date: Fri, 22 Nov 2013 00:45:50 +0000
Message-ID: <bug-65341-13602-CxKSkLkTmb@https.bugzilla.kernel.org/>
References: <bug-65341-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab3KVApx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Nov 2013 19:45:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 78B40204EA
	for <linux-ext4@vger.kernel.org>; Fri, 22 Nov 2013 00:45:52 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1F0D120760
	for <linux-ext4@vger.kernel.org>; Fri, 22 Nov 2013 00:45:51 +0000 (UTC)
In-Reply-To: <bug-65341-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65341

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |INVALID

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
This is not a kernel bug.  Opening a file when you double click it is a
function of the desktop software (i.e., Gnome, KDE, Unity, etc.)

The file you've sent is a Excel Spreadsheet, so it could be that you haven't
installed software such as LibreOffice which is capable of interpreting and
displaying/editing proprietary spreadsheets.

I suggest you try finding a local Linux User's Group to help you out.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
