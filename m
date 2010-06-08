From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Tue, 8 Jun 2010 22:38:11 GMT
Message-ID: <201006082238.o58McBIi013382@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35199 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0FHWiM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jun 2010 18:38:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o58McBsA013383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jun 2010 22:38:11 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #4 from Alexander Eichner <Alexander.Eichner@sun.com>  2010-06-08 22:38:10 ---
The 2.6.34 kernel is from the mainline ppa
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.34-lucid/
These kernels don't contain any additional patches according to
https://wiki.ubuntu.com/KernelTeam/MainlineBuilds

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
