From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Wed, 25 May 2011 21:10:52 GMT
Message-ID: <201105252110.p4PLAqhs010409@demeter1.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:33001 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1EYVKx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 17:10:53 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4PLAq6W010410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 21:10:52 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019


Philippe Planchon <philippe.planchon@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |philippe.planchon@gmail.com




--- Comment #46 from Philippe Planchon <philippe.planchon@gmail.com>  2011-05-25 21:10:51 ---
I'm running 2.6.35.13-91.fc14.x86_64 and have the same ext4-fs issue on resume
after hibernate.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
