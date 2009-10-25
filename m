From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 25 Oct 2009 13:59:13 GMT
Message-ID: <200910251359.n9PDxDwF029993@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59337 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZJYN7I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Oct 2009 09:59:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9PDxDGe029994
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2009 13:59:13 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #113 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-25 13:59:12 ---
apt-get update && apt-get upgrade && reboot is really good way to reproduce fs
corruption. After this you need reinstall your system.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
