From: "Marcel Partap" <mpartap@gmx.net>
Subject: fsck ate my ext4 home partition, help!?
Date: Mon, 04 May 2009 15:11:28 +0200
Message-ID: <20090504131128.135100@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43526 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752264AbZEDNLc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 09:11:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear fs hackers,
some days ago, out of a sudden i was missing some two hundred pics from=
 my digicam, so when i rebooted my comp (which, mysteriously enough, ha=
d hung up to the point where even SYSRQ+B would not work) yesterday and=
 X was just starting (i.e. the home partition was already mounted) i de=
cided to stop xdm service and unmount the filesystem to run a quick che=
ck over it. Unmounting went successful, however fsck complained about /=
dev/sdd4 still being mounted. After confirming (lsof, mtab, empty mount=
 point) that that was not actually the case, i ran fsck -p -v /dev/sdd4=
 and continued (beyond the fake still-mounted warning).. whereas the pr=
evious run of e2fsck with the -n was showing a bunch of stuff to fix, i=
t now instantly bailed out complaining about broken superblock and so o=
n. After that, fsck -n still showed a bunch of (the same?) errors to fi=
x, but remounting the filesystem (already with a bad hunch of course) r=
evealed the havoc that was done: ls -laR showed abundant I/O errors, fi=
le names AND attributes consisting of umlauts and question marks, and d=
f reported the size of the fs suddenly at 64 ZETTABYTE! Doom. Remounted=
 ro, root directory looked kinda fine, some stuff was still accessible,=
 but especially the home directory on there not even showed . and .. en=
tries! Obviously this is quite bad, and after having dded the partition=
 to a backup image, i am still unsure on how to approach a recovery of =
this situation. For sure the data is still there, but how to get at it?=
 It's quite an old volume aswell so probably fragmented heavily...
As i am in uni right now i don't have access to the complete screen buf=
fer log but i can provide to anyone who has any idea how to fix this. I=
f someone can actually help me to get it back in the state it was befor=
e invoking e2fsk, i'd be overly thankful and would show my appreciation=
 through a 50$ paypal donation. Please, someone help me unscrew this me=
ss *g
=46or the record, i am running kernel 2.6.30 RC3 with gentoo's e2fsprog=
s-1.41.3.. and i have not rebooted the system since the incident so may=
be some guerilla forensics can work on my 8GB of RAM?
thx & regards, marcel..
--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
