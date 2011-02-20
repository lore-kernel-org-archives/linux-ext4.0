From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29492] [173348.989645] kernel BUG at
 /home/kernel-ppa/COD/linux/fs/inode.c:1421!
Date: Sun, 20 Feb 2011 00:10:23 GMT
Message-ID: <201102200010.p1K0ANGx027182@demeter1.kernel.org>
References: <bug-29492-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50681 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1BTAKY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 19:10:24 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1K0ANtx027184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Feb 2011 00:10:23 GMT
In-Reply-To: <bug-29492-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29492





--- Comment #1 from Cristian Aravena Romero <caravena@gmail.com>  2011-02-20 00:10:23 ---
Created an attachment (id=48462)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48462)
lspci -vvnn

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
