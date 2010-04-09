From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15742] Fallocated extents handled incorrectly if beyond i_size
Date: Fri, 9 Apr 2010 17:24:04 GMT
Message-ID: <201004091724.o39HO4Fs012364@demeter.kernel.org>
References: <bug-15742-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44233 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0DIRYG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 13:24:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o39HO4sX012365
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Apr 2010 17:24:04 GMT
In-Reply-To: <bug-15742-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15742





--- Comment #2 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-09 17:24:00 ---
Proposed patch:
http://patchwork.ozlabs.org/patch/49856/

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
