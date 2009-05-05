From: "Marcel Partap" <mpartap@gmx.net>
Subject: Re: fsck ate my ext4 home partition, help!?
Date: Tue, 05 May 2009 17:06:25 +0200
Message-ID: <20090505150625.137720@gmx.net>
References: <20090504131128.135100@gmx.net>
 <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43155 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751424AbZEEPG3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2009 11:06:29 -0400
In-Reply-To: <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok, i see more clearly now the vast extents of my stupidity, and the ga=
p between perception and reality:
- the partition is and has been ext3 all the way (sorry linux-ext4 for =
misspamming!)
- i treated /proc/mounts with ignorance
- it seems out of lazyness i did not actually check lsof/ mount point t=
he way i should have (ouch! what i did was as good indeed as not doing =
anything.. looking/grepping for the WRONG mount path eew)
- the BOINC daemon was running and holding locks on its working directo=
ry, even still until i just shut it down. SHEESH! Sometimes it just nee=
ds a couple more iterations of rereconsidering the actual situation.

So people, treat your filesystems with the respect and attention they d=
eserve. And TRUST warning messages spit out by highly adept file system=
 tools MORE than your intuition. These tools *do* work as advertised.
Well and the point about backing up precious stuff -=3D[before]=3D- kno=
cking out your FS structures already has been made before i guess.

regards marcel.
--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
