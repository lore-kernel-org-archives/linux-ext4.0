From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13874] kenal panic on addition of xfx nvidia gts250 512mb on
 946giz motherboard
Date: Wed, 5 Aug 2009 17:06:47 GMT
Message-ID: <200908051706.n75H6lAa006838@demeter.kernel.org>
References: <bug-13874-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50663 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934247AbZHERGq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Aug 2009 13:06:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n75H6lhi006839
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 17:06:47 GMT
In-Reply-To: <bug-13874-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13874





--- Comment #7 from Jan Kara <jack@suse.cz>  2009-08-05 17:06:45 ---
Hmm, I've looked at those videos. The first just confirms its some really
lowlevel problem - we oopsed quite early while trying to get a free page. I
didn't find any suspicious message in the second one... There's just something
about "stolen memory". Probably someone with lowlevel HW/BIOS knowledge should
look into this memory corruption. It's definitely not fs related... Andrew,
could you please reassign? I don't seem to have enough rights.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
