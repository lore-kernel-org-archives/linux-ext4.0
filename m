From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory permissions for
 ext2/ext3/ext4 file systems
Date: Fri, 7 May 2010 07:09:13 GMT
Message-ID: <201005070709.o4779DYi019136@demeter.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52490 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0EGHJP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 03:09:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4779EAg019137
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 7 May 2010 07:09:14 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875





--- Comment #7 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-05-07 07:09:07 ---
Whatever fits you, however don't forget that there are immutable and appendable
only flags for ext2/3/4 and they should probably dismissed too.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
