From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35162] Kernel BUG when syncing ext2 if USB stick is removed
Date: Sun, 15 May 2011 17:36:44 GMT
Message-ID: <201105151736.p4FHaiLI028449@demeter2.kernel.org>
References: <bug-35162-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42372 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1EORgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 May 2011 13:36:45 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4FHaiqH028450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 17:36:44 GMT
In-Reply-To: <bug-35162-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=35162


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |32012




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
