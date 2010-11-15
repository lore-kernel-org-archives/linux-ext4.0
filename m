From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22922] 2.6.36: kernel panic in cascade (Fatal exception in
 interrupt)
Date: Mon, 15 Nov 2010 19:10:23 GMT
Message-ID: <201011151910.oAFJAN2Y011701@demeter2.kernel.org>
References: <bug-22922-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47100 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab0KOTKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Nov 2010 14:10:25 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAFJAN2q011703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Nov 2010 19:10:23 GMT
In-Reply-To: <bug-22922-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22922


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #1 from Maciej Rutecki <maciej.rutecki@gmail.com>  2010-11-15 19:10:21 ---
This was fixed in 2.6.37-rc1 in commit: a1c6c5698d53 (ext4: fix
NULL pointer dereference in print_daily_error_info())

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
