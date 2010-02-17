From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Wed, 17 Feb 2010 00:21:44 GMT
Message-ID: <201002170021.o1H0LiGw012106@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46505 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588Ab0BQAVp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Feb 2010 19:21:45 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1H0LicC012108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 00:21:44 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025





--- Comment #10 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2010-02-17 00:21:40 ---
On Tue, Feb 16, 2010 at 02:08:33PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> The issue was fixed by following commit
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=1db913823c0f8360fccbd24ca67eb073966a5ffd

This cannot be, as I don't use quota.

/* Steinar */

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
