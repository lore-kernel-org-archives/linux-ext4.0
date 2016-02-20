From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Sat, 20 Feb 2016 18:46:50 +0000
Message-ID: <bug-112631-13602-ZWKAdCtfT0@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbcBTSqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Feb 2016 13:46:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EED6E2051F
	for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 18:46:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A670F204FC
	for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 18:46:50 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D112631

Henrique de Moraes Holschuh <hmh@hmh.eng.br> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |hmh@hmh.eng.br

--- Comment #5 from Henrique de Moraes Holschuh <hmh@hmh.eng.br> ---
=46rom https://lwn.net/Articles/676552/

Posted Feb 20, 2016 16:33 UTC (Sat) by alonz (subscriber, #815)
Interesting... the code in cryptsetup indeed breaks the assumptions enf=
orced by
this commit (it closed the "tfmfd" before the "opfd", while the code al=
ways
assumed the opposite and now enforces it). So it has always been "buggy=
 but
working" =E2=80=93 which is no excuse for breaking userspace.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
