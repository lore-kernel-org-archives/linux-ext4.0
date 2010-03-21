From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Sun, 21 Mar 2010 08:33:12 GMT
Message-ID: <201003210833.o2L8XC6F016849@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40226 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0CUIdN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Mar 2010 04:33:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2L8XC4n016853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 21 Mar 2010 08:33:12 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #5 from Alessandro Polverini <alex@nibbles.it>  2010-03-21 08:32:35 ---
The -h option of e2image is not recognised on my tool, sorry, I tried e2image
1.41.10.
The bzip2 compressed output of e2image of my partition is around 200Mb long,
please everybody who is interested in it contact me so I can prepare a download
link for it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
