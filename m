From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: found a scenario for BUG at fs/ext4/super.c:804!
Date: Sat, 01 Jun 2013 17:27:40 +0200
Message-ID: <51AA12EC.6000001@gmx.de>
References: <51A79353.7030604@gmx.de> <51AA0CA1.6080600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58325 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3FAP1n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Jun 2013 11:27:43 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MQ9JV-1UmuK50Zlb-005FZc for
 <linux-ext4@vger.kernel.org>; Sat, 01 Jun 2013 17:27:42 +0200
In-Reply-To: <51AA0CA1.6080600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/01/2013 05:00 PM, Eric Sandeen wrote:
> And therein lies the unknown magic.
>=20
> Again, trinity's job is to try to corrupt the kernel by fuzzing sysca=
lls.  We've had "xfs bug reports" after running trinity as well... and =
all indications are that xfs is the victim, not the root cause.
>=20
> It could be a filesystem bug, or just as easily some other bug in a s=
yscall that allowed trinity to corrupt memory.
>=20
> I do not think these bug reports are actionable until you can figure =
out how to narrow down the trinity operations that cause the problem.

ok, I'm really trying to get a scenario without trinity.

I'm convinced that such a scenario does exist, just because kernel 3.9.=
4
does not run into those issue whereas 3.10 does.


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
