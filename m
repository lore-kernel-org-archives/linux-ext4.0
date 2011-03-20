From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31542] ext4 : "No space left on the device" persists even when
 I deleted more than 40GB of data
Date: Sun, 20 Mar 2011 23:27:12 GMT
Message-ID: <201103202327.p2KNRCxC002966@demeter1.kernel.org>
References: <bug-31542-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:58338 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1CTX1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 19:27:13 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2KNRCLG002967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 23:27:12 GMT
In-Reply-To: <bug-31542-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D31542





--- Comment #1 from Jarom=C3=ADr C=C3=A1p=C3=ADk <tavvva@volny.cz>  201=
1-03-20 23:27:10 ---
NOTE : Unfortunately I was performing the mentioned scenario on Mandriv=
a Linux
with the latest Mandriva desktop kernel [2.6.33-7mnb2] (and I know You =
don't
like non-Vanilla kernels even if they almost don't differ from Vanilla)=
, but I
truly believe, that this problem comes from the mainline and therefore =
it's
present in the mainline too.=20

The issue persists even when I try Vanilla 2.6.37.2 ...

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
