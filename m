From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 21:13:40 GMT
Message-ID: <200908102113.n7ALDeXo010686@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41105 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZHJVNj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 17:13:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7ALDeKS010687
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 21:13:40 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #23 from Roland Kletzing <devzero@web.de>  2009-08-10 21:13:39 ---
on 2009-02-05 there was a commit of IMA - see
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3323eec921efd815178a23107ab63588c605c0b2

that seems in your codepath and is also enabled in .config:

CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y

as it is not in defconfig, it looks a little bit suspicious to me and i`m
wondering why it is active on your system.

i don`t really have a clue if this really is the culprit, but if this but was
on my system, i would give it at try and disable ima to see if it makes a
difference. don`t know how this can be enabled at runtime/boot. if a runtime
switch doesn`t exist, you may bug the developer for providing one.

ah, and there is
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a62e958fa4aaeeb752311b4f5e16b2a86737b23
that also looks suspicious

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
