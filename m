From: "Marcel Partap" <mpartap@gmx.net>
Subject: Re: fsck ate my ext4 home partition, help!?
Date: Wed, 06 May 2009 15:43:15 +0200
Message-ID: <20090506134315.185580@gmx.net>
References: <20090504131128.135100@gmx.net>
 <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de>
 <20090505144436.125410@gmx.net>
 <alpine.DEB.2.01.0905051337140.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751667AbZEFNnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 09:43:17 -0400
In-Reply-To: <alpine.DEB.2.01.0905051337140.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm yeah. First attempt issuing a fsck.ext3 -yv /dev/sdd4 resulted in a=
 lost+found frenzy - everything under the former directory /mnt/sdc4/ho=
medirs/currenthomebase (which was mounted under /home) got relinked int=
o lost+found with sequential numbers... Not bad, the data is there - bu=
t this is quite unusable iykwim..

> Now that you have a backup copy, I'd suggest to get that "but sdd4 is
> mounted" error out of the way and try to e2fsck with a different=20
> superblock.

Uhmm, well. So i again dded the backup image to the partition, ran mkfs=
=2Eext3 -nv /dev/sdd4 to get a list of the FS's backup superblocks, the=
n tried to see if any of them is in a better state than the original on=
e by doing
> for blockpos in 32768 98304 163840 229376 294912 819200 884736 160563=
2
> 2654208 4096000 7962624 11239424 20480000 23887872; do fsck.ext3 -vnb
> $blockpos /dev/sdd4 > fsck-$blockpos.log; done
and then comparing those output files. Unfortunately, all show the same=
 resulting output meaning there is no benefit from using them. A script=
 i found @ http://blog.windfluechter.net/index.php?/archives/307-Automa=
tically-restore-files-from-lost+found-improved.html which can move obje=
cts back in place from lost+found has to backup all filenames BEFORE ru=
nning into this situation so is not of great help at this point..

Oh and this extundelete tool - i couldn't quite put it to the test beca=
use as soon as i let it loose on the partition - well it quickly eats u=
p all memory causing the oom_killer to terminate it.

=46orce-mounting the partition _without_ repairing it just results in a=
n empty mount point.

Ain't there no alternative way to reconstruct the directory structure, =
it surely can't be overwritten completely...??
regards marcel.
--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
