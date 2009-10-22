From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 22 Oct 2009 18:43:47 GMT
Message-ID: <200910221843.n9MIhlId006788@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58397 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbZJVSnm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 14:43:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9MIhlob006789
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 18:43:47 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #101 from Eric Sandeen <sandeen@redhat.com>  2009-10-22 18:43:36 ---
(In reply to comment #87)
> (In reply to comment #84)
> 
> Maybe this is a totally stupid suggestion, but is there any chance for this
> code path to be executed during journal replay, when s_journal is still NULL ?

If I'm understanding Alexy's test correctly, he's not even doing journal
replay; he's doing IO, crashing, and then running e2fsck -f -y immediately upon
reboot w/o any fileystem mount (and therefore no journal replay)

Alexy, is that correct?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
