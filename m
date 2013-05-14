From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: v3.10: unmount won't work
Date: Tue, 14 May 2013 22:09:58 +0200
Message-ID: <51929A16.8050306@gmx.de>
References: <51928CB5.2050406@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59513 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab3ENUKF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 May 2013 16:10:05 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LqoQe-1Ty2i82yqQ-00eMce for
 <linux-ext4@vger.kernel.org>; Tue, 14 May 2013 22:10:02 +0200
In-Reply-To: <51928CB5.2050406@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/14/2013 09:12 PM, Toralf F=C3=B6rster wrote:
> At a stable 32 bit stable Gentoo with kernel v3.10-rc1-113-ga2c7a54 I=
 cannot umount an (EXT4) fs
> which was created in a file located in a tmpfs partition and loop mou=
nted  :
>=20
> That file system was used to hold victims files shared via NFSv4 to a=
n user mode linux=20
> on which trinity was used to fuzz testing a patched UML guest kernel.

=46WIW the numbers are really wrong for /mnt/trinity

# df -m /mnt/trinity/
=46ilesystem     1M-blocks  Used Available Use% Mounted on
/dev/loop0        183851 31165    143325  18% /mnt/trinity

b/c 257 MB were specified for the file in which the EXT4FS was created:

# ls -lh /mnt/ramdisk/disk0
-rw-r--r-- 1 tfoerste users 257M May 14 20:56 /mnt/ramdisk/disk0

here is the corresponding code snippet :
	FS=3D"ext4"
        dd if=3D/dev/zero of=3D/mnt/ramdisk/disk0 bs=3D1M count=3D257 2=
>/dev/null || return 2
        yes | /sbin/mkfs.$FS /mnt/ramdisk/disk0 1>/dev/null || return 3
        sudo su -c "mount -o loop /mnt/ramdisk/disk0 /mnt/trinity/; chm=
od 777 /mnt/trinity" || return 4

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
