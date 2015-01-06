From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Tue, 06 Jan 2015 01:08:04 +0000
Message-ID: <bug-89511-13602-Nw3PrBWl9z@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbbAFBIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2015 20:08:10 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 23A7D2034E
	for <linux-ext4@vger.kernel.org>; Tue,  6 Jan 2015 01:08:07 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1B5EF2025B
	for <linux-ext4@vger.kernel.org>; Tue,  6 Jan 2015 01:08:06 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Joel Rees <joel.rees@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joel.rees@gmail.com

--- Comment #38 from Joel Rees <joel.rees@gmail.com> ---
(I do not have experience with these, just took a break, looked them up, and
did a little translating this morning after reading Jun's post to debian-user:

https://lists.debian.org/debian-user/2015/01/msg00121.html  
)

GLANTANK is a gigabit version of LANTANK. IO-DATA's child company
Chousensha (Challenger) produced these in response to the Kurobako
(with which some here may be familiar).

http://ja.wikipedia.org/wiki/GLAN_Tank
http://translate.google.co.jp/translate?hl=en&sl=ja&u=http://ja.wikipedia.org/wiki/GLAN_Tank&prev=search

http://ja.wikipedia.org/wiki/LAN_Tank
http://translate.google.co.jp/translate?hl=en&sl=ja&u=http://ja.wikipedia.org/wiki/GLAN_Tank&prev=search

These are customizable NAS units, apparently running a customized
debian (MAKAI -- MAKe Again ISO Image) internally.

http://makai.sourceforge.jp/wiki/index.php?FrontPage
http://translate.google.co.jp/translate?hl=en&sl=ja&u=http://ja.wikipedia.org/wiki/GLAN_Tank&prev=search

LANTANK had an SH4 cpu, but the GLANTANK has an ARM (XScale).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
