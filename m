From: Rudolf Zran <rudolfzran@yahoo.com>
Subject: Restoring filenames from partly damaged ext4-filesystem
Date: Thu, 9 Feb 2012 16:29:53 +0000 (GMT)
Message-ID: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Reply-To: Rudolf Zran <rudolfzran@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ird.yahoo.com ([77.238.189.63]:23799 "HELO
	nm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752059Ab2BIQ3z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Feb 2012 11:29:55 -0500
References: 
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everybody!

I recently damaged an ext4 partition by accident (mistakenly forced
a RAID sync with another partition onto it, which I realized after
about 3% completion). As a result the beginning of the ext4 partition
seems to be overwritten with garbage and refuses to mount.

As you might guess, I'd now like to get as most of my data back (from
the part which hasn't been overwritten, of course :)).

Maybe somebody knows a good method to just "repair" the ext4-structure
from the remaining part of the partition?


Background information:

Operation system:=A0=A0 Debian GNU/Linux 6.0.4 (Squeeze)
Kernel:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Linux 2.6.32-5
Architecture:=A0=A0=A0=A0=A0=A0 x86-amd64
e2fsprogs:=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.41.12
=46ilesystem type:=A0=A0=A0 ext4, with default settings (mkfs.ext4 /dev=
/xyz)
=46ilesystem size:=A0=A0=A0 Around 1TB, filled with around 800GB of dat=
a.
=46ilesystem content: From a lot of ASCII stuff up to files with severa=
l
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GB in size an=
d arbitrary non-standard type.


What I've tried so far:

* First of all, though the source drive is physically fine, I work on
=A0 images of the partition on a spare drive, to experiment with. Every=
time
=A0 I make unrecoverable errors to that image, I recopy the original.

* "dumpe2fs -b $SBERR /dev/loop0" does NOT work, for SBERR=3D{32768, 98=
304,
=A0 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 4096000,
=A0 7962624} ( see https://pzt.me/1l55 )

* "dumpe2fs -b $SBOK /dev/loop0" DOES (partly) work, for SBOK=3D{112394=
24,
=A0 20480000, 23887872, 71663616, 78675968, 214990848} ( see https://pz=
t.me/6txz )

* "mkfs.ext4 -S /dev/loop0" results in a completely empty filesystem

* "fsck.ext4 -b $SBOK -B 4096 -v -n /dev/loop0" shows a lot of errors.
=A0 Filesystem isn't mountable afterwards ( see https://pzt.me/42yk and
=A0 https://pzt.me/3frg )

* "fsck.ext4 -b $SBOK -B 4096 -v -y /dev/loop0" recoveres after a long =
time.
=A0 Filesystem is mountable. Root is empty besides lost+found folder, w=
hich
=A0 contains about 300GB mostly useless data: Millions of files with wr=
ong
=A0 permissions, useless names and some random content.

* photorec from the testdisk package recoveres, luckily!, about 500GB o=
f
=A0 data. Though the content seems to be pretty reasonable, no filename=
s
=A0 are recovered, since photorec operates without using filesystem kno=
wledge.

Do you see any chances (besides consulting professional recovery compan=
ies)
getting the filenames back? I looked into the ext4 specs a bit to figur=
e out
where this information is stored on disk, but before I step with hexedi=
t
through a terabyte of data, I'd rather try some solutions which are may=
be
already out there.

Any help is appretiated.

Thanks in advance, Rudolf.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
