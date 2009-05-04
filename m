From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13230] unexplained fsck error with ext4 on software raid 10
Date: Mon, 4 May 2009 07:42:22 GMT
Message-ID: <200905040742.n447gMOE007976@demeter.kernel.org>
References: <bug-13230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37103 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZEDHmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 03:42:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n447gMNO007977
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 07:42:22 GMT
In-Reply-To: <bug-13230-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D13230





--- Comment #2 from Florian Engelhardt <flo@dotbox.org>  2009-05-04 07:=
42:22 ---
I was coping files via NFS from my computer under my desk to that serve=
r.
Something around 380 GB.
The filesystem was serving until reboot ;)
As i don=C2=B4t need the server right now, i can  build a tunnel and gi=
ve you root
access to that machine via ssh.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
