From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32972] EXT4 causes corrupt BitTorrent downloads
Date: Mon, 11 Apr 2011 23:10:42 GMT
Message-ID: <201104112310.p3BNAgaI021616@demeter1.kernel.org>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36323 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1DKXKn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Apr 2011 19:10:43 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3BNAgml021617
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2011 23:10:42 GMT
In-Reply-To: <bug-32972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32972


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org,
                   |                            |maciej.rutecki@gmail.com,
                   |                            |rjw@sisk.pl
             Blocks|                            |32012




--- Comment #6 from Rafael J. Wysocki <rjw@sisk.pl>  2011-04-11 23:10:40 ---
First-Bad-Commit : 6de9843dab3f2a1d4d66d80aa9e5782f80977d20

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
