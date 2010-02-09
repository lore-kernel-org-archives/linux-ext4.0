From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Tue, 9 Feb 2010 16:02:39 GMT
Message-ID: <201002091602.o19G2dZs004175@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41761 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab0BIQCk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 11:02:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o19G2d6k004177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Feb 2010 16:02:39 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074





--- Comment #5 from Fabio Fantoni <fantonifabio@tiscali.it>  2010-02-09 16:02:15 ---
yes 2.6.33-rc6, the warning on quota active (journaling support on ext4 not
active) not help? if necessary on next install i post details message

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
