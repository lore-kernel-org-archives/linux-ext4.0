From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: ext4 lazytime: ctime of some files changed
Date: Sat, 23 May 2015 15:24:15 +0200
Message-ID: <55607F7F.1050106@web.de>
References: <55531AE3.7030704@web.de> <mivtkj$fhi$1@ger.gmane.org> <20150514222044.GA3901@thunk.org> <55560D42.2060402@web.de> <20150515231107.GF3901@thunk.org> <555C4A65.5030100@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49906 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757736AbbEWNY2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 09:24:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Yw9Pe-00039G-Ar
	for linux-ext4@vger.kernel.org; Sat, 23 May 2015 15:24:26 +0200
Received: from p5b0a06df.dip0.t-ipconnect.de ([91.10.6.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 23 May 2015 15:24:26 +0200
Received: from jvpeetz by p5b0a06df.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 23 May 2015 15:24:26 +0200
In-Reply-To: <555C4A65.5030100@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J=F6rg-Volker Peetz wrote on 05/20/2015 10:48:
<snip>
> after a few days of running the patch, I seem to have again two files=
 with
> changed mtime without touching them (only reading by rsync).
>=20
<snip>
I can affirm this error, but am not sure where to hunt.
I'm using several USB drives in a cycle for backup.
I have a directory with a file originally older than a few years.
Mount options are

$ grep sda /proc/mounts
/dev/sda2 /home ext4 rw,lazytime,relatime,nobarrier,errors=3Dremount-ro=
 0 0

(using lazytime with relatime).
As reported, while I started using lazytime, this file's mtime got chan=
ged.
I reset the mtime with the "touch -r <intact_copy> <file>" command.
After a backup to one of the USB drives with something like

$ rsync -acv --exclude-from=3D<file> --delete-excluded <SRC> <DEST_ON_U=
SB_DRIVE>

the namely file had its mtime changed  on the *source* device (the USB =
drive has
an ext4 fs mounted without the lazytime option).
I reset that again on the source SSD using "touch". Another file in the=
 same was
also modified.

Next backup on another USB drive, same thing.
I took a look into the file list on the backup medium before the backup=
=2E
There the file also had a different mtime, but not the same mtime the f=
ile got
after the backup.

I'm confused.
Any idea?
--=20
Regards,
J=F6rg.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
