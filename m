From: Christian Kujau <lists@nerdbynature.de>
Subject: bh_count undeclared
Date: Sun, 25 May 2008 17:35:12 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0805251727040.4890@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:64376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbYEYPfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 May 2008 11:35:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

while trying to build the current e2fsprogs.pu git tree, I got:

# CFLAGS=3D"-g" ./configure --prefix=3D/opt/e2fsprogs --enable-htree
# make
[....]
making all in e2fsck
make[2]: Entering directory `/data/Scratch/scm/e2fsprogs-git/e2fsck'
 	CC journal.c
journal.c: In function =E2=80=98getblk=E2=80=99:
journal.c:76: error: =E2=80=98bh_count=E2=80=99 undeclared (first use i=
n this function)
journal.c:76: error: (Each undeclared identifier is reported only once
journal.c:76: error: for each function it appears in.)
make[2]: *** [journal.o] Error 1
make[2]: Leaving directory `/data/Scratch/scm/e2fsprogs-git/e2fsck'
make[1]: *** [all-progs-recursive] Error 1
make[1]: Leaving directory `/data/Scratch/scm/e2fsprogs-git'
make: *** [all] Error 2

When looking at journal.c I see 'bh_count' declared within an #ifdef, b=
ut=20
even when compiling with --enable-jfs-debug the error persists. Right n=
ow=20
I just removed the #ifdef so that the build succeeds.

But, what's the real issue here?

Thanks,
Christian.
--=20
BOFH excuse #331:

those damn raccoons!
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
