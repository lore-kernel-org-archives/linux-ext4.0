From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 3 Nov 2009 23:43:27 GMT
Message-ID: <200911032343.nA3NhRiO029917@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35694 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZKCXnW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2009 18:43:22 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA3NhRoC029918
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2009 23:43:27 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #175 from Eric Sandeen <sandeen@redhat.com>  2009-11-03 23:43:26 ---
Double-hrm; if it's not the transaction that was right during the power-fail,
maybe this is a hint/clue for the other bug that claims corruption after a
-clean- shutdown.  Probably time to go look for races, buffer re-use, etc in
the checksumming code...?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
