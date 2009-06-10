From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13230] unexplained fsck error with ext4 on software raid 10
Date: Wed, 10 Jun 2009 06:47:43 GMT
Message-ID: <200906100647.n5A6lhas028446@demeter.kernel.org>
References: <bug-13230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48401 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZFJGrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 02:47:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5A6lhwF028447
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 06:47:43 GMT
In-Reply-To: <bug-13230-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D13230


=46lorian Engelhardt <flo@dotbox.org> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABL=
E




--- Comment #5 from Florian Engelhardt <flo@dotbox.org>  2009-06-10 06:=
47:42 ---
I applied that patch to the 2.6.29.4 kernel and recreated the filesyste=
m. It=C2=B4s
up and running since four days now. I was not able to reproduce this bu=
g. Good
work, thanks so far. Is this patch also in the 2.6.30 mainline? This wi=
ll allow
me to switch back to the official kernel of my distribution.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
