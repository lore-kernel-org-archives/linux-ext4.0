From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16538] lvm hangs when creating snapshots of the root partition
 with 2.6.35
Date: Thu, 26 Aug 2010 21:00:28 GMT
Message-ID: <201008262100.o7QL0SUF005900@demeter1.kernel.org>
References: <bug-16538-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34596 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0HZVAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 17:00:30 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7QL0StG005901
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 21:00:28 GMT
In-Reply-To: <bug-16538-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D16538


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
             Status|NEW                         |RESOLVED
                 CC|                            |akpm@linux-foundation.=
org
         Resolution|                            |CODE_FIX




--- Comment #8 from Fran=C3=A7ois Valenduc <francois.valenduc@tvcablene=
t.be>  2010-08-11 21:34:47 ---
This problem is in fact fixed by the following commit:

commit d2aa412a7e270bc679a586dda415344f2b8ad01e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Aug 1 17:33:29 2010 -0400

    ext4: fix freeze deadlock under IO

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
