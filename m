From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 16 Oct 2009 10:48:06 GMT
Message-ID: <200910161048.n9GAm6c3023629@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38807 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZJPKsm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 06:48:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GAm6Np023630
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 10:48:06 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #60 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-16 10:48:04 ---
seems like i can mostly reproduce this issue on my pc. The system seems to be
normal on reset after fresh start. Usually i lost files on root partition, some
times on home evolution settings. Seems like evolution doing "wrong". My best
reproduction case is reinstall of kernel modules (sudo make modules_install).
The worst thing happened - all modules of this kernel version was lost. To
reproduce i did "make modules_install" three times  with random times between
installs (10min-1h). 
I also use daily e2croncheck and  some  time i run it manually - i newer get
any errors with this script. Today i will test vanilla 2.6.31 and probably
begin to bisect.
      Alexey

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
