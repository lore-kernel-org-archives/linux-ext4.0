From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27912] Set 'err' in ext4_init_fs() if kset_create_and_add()
 fails
Date: Tue, 1 Feb 2011 03:06:29 GMT
Message-ID: <201102010306.p1136T3Q019382@demeter1.kernel.org>
References: <bug-27912-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48820 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1BADGd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Jan 2011 22:06:33 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1136Vcv019383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 1 Feb 2011 03:06:31 GMT
In-Reply-To: <bug-27912-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27912


Tao Ma <tm@tao.ma> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tm@tao.ma




--- Comment #1 from Tao Ma <tm@tao.ma>  2011-02-01 03:04:48 ---
Hi Eugene,
This is already fixed by Eric.
http://marc.info/?l=linux-ext4&m=129527644524410&w=2

If you can test it, that would be great.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
