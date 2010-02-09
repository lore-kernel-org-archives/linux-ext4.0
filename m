From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Tue, 9 Feb 2010 16:57:02 GMT
Message-ID: <201002091657.o19Gv2TU013145@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50660 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0BIQ5E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 11:57:04 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o19Gv2qG013157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Feb 2010 16:57:02 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074





--- Comment #7 from Jan Kara <jack@suse.cz>  2010-02-09 16:56:22 ---
Argh, sorry for that. I've folded that change into your patch implementing
reservation handling but then replaced reservation handling patch with a new
version from you and forgot about this update.

I've readded the patch to my tree now.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
