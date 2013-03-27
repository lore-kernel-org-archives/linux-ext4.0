From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55651] Non-atomic short write problem with O_APPEND
Date: Wed, 27 Mar 2013 18:40:35 +0000 (UTC)
Message-ID: <20130327184035.BC2A611FB5D@bugzilla.kernel.org>
References: <bug-55651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45347 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab3C0Skj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 14:40:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CEF8920311
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 18:40:37 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BD064202D2
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 18:40:35 +0000 (UTC)
In-Reply-To: <bug-55651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55651


Quentin Barnes <qbarnes@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #96041|0                           |1
        is obsolete|                            |




--- Comment #2 from Quentin Barnes <qbarnes@gmail.com>  2013-03-27 18:40:35 ---
Created an attachment (id=96411)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=96411)
Fully automatic C test for demostrating problem

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
