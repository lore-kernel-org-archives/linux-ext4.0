From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 14 Mar 2011 04:10:07 GMT
Message-ID: <201103140410.p2E4A7vu004978@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39368 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1CNEKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 00:10:08 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2E4A8gH004979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 04:10:08 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D25832





--- Comment #48 from rocko <rockorequin@hotmail.com>  2011-03-14 04:10:=
06 ---
Unfortunately there are a couple of problems with bisecting this, quite=
 apart
from the time it takes to build and test each kernel...

The first is that it is unsurprisingly easy to crash an rc1 kernel, whi=
ch makes
it even harder to reliably detect the bug. For instance, I managed to c=
rash the
first bisect of 35-36.rc1 with the suspend/resume test eventually (it s=
eems
much more robust than 2.6.38 with respect to this bug) but it isn't cle=
ar that
the problem occurred as a result of the USB removal - the stack trace l=
ooks
like it includes memory allocations and socket receives. Why, the first=
 time I
booted the 36rc1 kernel, it hung completely at the login screen with no=
 human
input whatsoever, clearly as a result of a different bug. I'm not even =
positive
that the log I posted from the 36rc1 kernel crash above is related to t=
his bug,
as it looks different from the 2.6.37/38 logs.

The second problem is that I can't necessarily compile all the bisects!=
 For
instance commit f6cec0ae58c17522a7bc4e2f39dae19f199ab534 (the second bi=
sect I
tried) fails with this error:

drivers/staging/comedi/drivers/das08_cs.c: In function
=E2=80=98das08_pcmcia_config_loop=E2=80=99:
drivers/staging/comedi/drivers/das08_cs.c:225:8: error: =E2=80=98struct=
 pcmcia_device=E2=80=99
has no member named =E2=80=98io

Is there a way to make the kernel handle a bug like this more gracefull=
y? It
seems that there are many great debug tools for extracting information =
about
process states, but they are all useless here because the crash is so
catastrophic.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
