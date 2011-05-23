From: Lee Davis <l.davis37@ymail.com>
Subject: Re: EXT4 partition changes every time it's mounted. (How to stop this?)
Date: Sun, 22 May 2011 21:39:04 -0700 (PDT)
Message-ID: <195291.47304.qm@web125204.mail.ne1.yahoo.com>
References: <476510.14310.qm@web125206.mail.ne1.yahoo.com> <A129F9FD-E914-408C-8997-FD145AA2A697@mit.edu>
Reply-To: Lee Davis <l.davis37@ymail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm16-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.47]:38346 "HELO
	nm16-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750857Ab1EWEjH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 00:39:07 -0400
In-Reply-To: <A129F9FD-E914-408C-8997-FD145AA2A697@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I've checked again, and despite being mounted read-only, the filesystem=
 is definitely changing every time I reboot.

The mount options are: ro,relatime,commit=3D0

I've taken three images of the filesystem (rebooting between each image=
), and with a bit of research I've managed to discover which fields in =
the superblock are being changed. They are: s_wtime and s_kbytes_writte=
n.=20

Here's how they're being changed:

0x430 (s_wtime): 06C8D94D -> 68D0D94D -> B9D7D94D

0x578 (s_kbytes_written): 42C8000000000000 -> 45C8000000000000 -> 48C80=
00000000000

These two fields are the only things that are changing in the entire fi=
lesystem.


Any ideas on what might be causing this and/or how to disable it?

Much appreciated,
Lee

P.S. I just thought to test it after unmounting/re-mounting, and nothin=
g was changed. So it appears to only get changed when I boot the system=
=2E

It's a fresh Ubuntu Natty installation, with GRUB on the MBR, an ext4 b=
oot partition, and an encrypted ext4 root partition (which I set up thr=
ough the installer). I can't think what might be writing to the boot pa=
rtition.





----- Original Message -----
=46rom: Theodore Tso <tytso@MIT.EDU>
To: Lee Davis <l.davis37@ymail.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Sent: Sunday, 22 May 2011 9:47 PM
Subject: Re: EXT4 partition changes every time it's mounted. (How to st=
op this?)


On May 21, 2011, at 3:45 PM, Lee Davis wrote:

> I'm setting up a Linux system with full disk encryption. I've written=
 a script (to run on every boot) which will verify that neither the MBR=
 or /boot partition (ext4) has been modified.
>=20
> Problem is that every time I boot up the system, my /boot partition h=
ashes differently.
>=20
> I'm guessing there is something behind the scenes which is changed/up=
dated each time the filesystem is mounted? If so, can it be disabled?

Yes, there is a last mounted time in the superblock.=A0  If you mount t=
he file system read-only, then not only will that field not be changed,=
 but you can guarantee that nothing else will change...

-- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
