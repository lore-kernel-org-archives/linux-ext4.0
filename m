From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38372] unable to handle kernel NULL pointer dereference in ext3
Date: Mon, 27 Jun 2011 23:22:22 GMT
Message-ID: <201106272322.p5RNMMJ5019868@demeter1.kernel.org>
References: <bug-38372-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:49902 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1F0XWX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 19:22:23 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p5RNMMkj019869
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 23:22:22 GMT
In-Reply-To: <bug-38372-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38372





--- Comment #1 from Rob de Wit <rdewit@wise-guys.nl>  2011-06-27 23:22:21 ---
Created an attachment (id=63652)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=63652)
Kernel config

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
