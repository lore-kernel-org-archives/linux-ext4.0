From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Sat, 27 Feb 2010 18:29:39 GMT
Message-ID: <201002271829.o1RITdvR006761@demeter.kernel.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39532 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab0B0S3k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Feb 2010 13:29:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1RITd1j006762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 27 Feb 2010 18:29:39 GMT
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579


Jayson R. King <dev@jaysonking.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dev@jaysonking.org




--- Comment #17 from Jayson R. King <dev@jaysonking.org>  2010-02-27 18:28:56 ---
I sent mail a few hours ago about this bug occurring on a 2.6.27.y kernel. The
patch which fixed the bug on mainline also fixes 2.6.27.y, but it depends on
several other patches being merged in before it (mostly other ext4 fixes).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
