From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31742] got a "kernel BUG at fs/dcache.c:440!"
Date: Wed, 23 Mar 2011 23:45:52 GMT
Message-ID: <201103232345.p2NNjq7h012768@demeter1.kernel.org>
References: <bug-31742-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48441 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab1CWXpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 19:45:55 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2NNjqKX012769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 23:45:52 GMT
In-Reply-To: <bug-31742-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D31742





--- Comment #5 from Mathias R=C3=BCdiger <ruediger@blueboot.org>  2011-=
03-23 23:45:49 ---
Yes i can replicate the problem. Start the script, wait a second and of=
f you
go.

I am using a Thinkpad X61 Tablet
(http://www.thinkwiki.org/wiki/Category:X61_Tablet) with Intels L7300. =
Its a
SMP machine.=20

I also thought that fs/dcache.c isn't ext4 specific, but i didn't know =
where to
put the bugreport.


Mathias

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
