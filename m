From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Wed, 5 May 2010 07:30:06 GMT
Message-ID: <201005050730.o457U6I1012463@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49619 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab0EEHaG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 03:30:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o457U6iw012466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 5 May 2010 07:30:06 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #14 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-05 07:30:04 ---
Created an attachment (id=26224)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26224)
Patch attached fix original regression

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
