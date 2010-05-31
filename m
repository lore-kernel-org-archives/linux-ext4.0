From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Mon, 31 May 2010 15:22:28 GMT
Message-ID: <201005311522.o4VFMS1R012179@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36157 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab0EaPW3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 May 2010 11:22:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4VFMSf1012180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 31 May 2010 15:22:28 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2010-05-31 15:22:26 ---
Created an attachment (id=26592)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26592)
lspci -vvv of host

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
