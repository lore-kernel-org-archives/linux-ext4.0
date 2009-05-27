From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Wed, 27 May 2009 19:23:42 GMT
Message-ID: <200905271923.n4RJNgUt031916@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59833 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbZE0TXl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 May 2009 15:23:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4RJNg4V031917
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 19:23:42 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292





--- Comment #6 from Frank Mayhar <fmayhar@google.com>  2009-05-27 19:23:42 ---
Well, I pulled in a bunch of patches from the ext4 stable tree (although not
all of them, unfortunately, since our base is well behind top-of-tree) and was
still unable to reproduce this.  I'll continue to keep an eye on it, however.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
