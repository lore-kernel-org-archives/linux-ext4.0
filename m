From: Micah Anderson <micah@riseup.net>
Subject: ext4 corruption
Date: Sun, 05 Jun 2011 23:59:34 -0400
Message-ID: <87pqmrobix.fsf@algae.riseup.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60771 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab1FFD7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2011 23:59:50 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QTQyj-0003T3-2k
	for linux-ext4@vger.kernel.org; Mon, 06 Jun 2011 05:59:49 +0200
Received: from 64.145.66.150 ([64.145.66.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 05:59:49 +0200
Received: from micah by 64.145.66.150 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 05:59:49 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable


I previously wrote about a recent conversion from ext3 to ext4 (on
Debian Squeeze), which went well. However, I seem to be having problems
with the ext4 filesystem.

Yesterday, there was a file in /var/spool/postfix/defer that was giving
an i/o error:

Jun  3 15:00:14 willet postfix/qmgr[29108]: fatal: qmgr_message_alloc:
677AE298316F: remove defer 677AE298316F: Input/output error

If I tried to stat it, it would give the same error. I noticed on the
console, I was getting a lot of these:

[6060479.296658] EXT4-fs error (device dm-4): ext4_lookup: deleted inode re=
ferenced: 169640807
[6060482.776087] JBD: Spotted dirty metadata buffer (dev =3D dm-4, blocknr =
=3D 0). There's a risk of filesystem corruption in case of=20
                  system crash.

The system was clearly acting strange, so I decided it was best to touch
/forcefsk and restart to clean up the filesystem.

I got a couple Multiply-claimed block(s), "(There are 10 inodes
containing multiply-claimed blocks.)", and then I was required to run
fsck again, which I did and it seemed to be fine after the second run
(these fscks took hours).=20

After things seemed clean, I started the system back up and it began to
operate fine. I then began to see the following on the console:

[ 3201.702997] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429952(bit 3456 in group 1722)
[ 3201.714348] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429953(bit 3457 in group 1722)
[ 3201.725665] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429954(bit 3458 in group 1722)
[ 3201.737028] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429955(bit 3459 in group 1722)
[ 3201.748721] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429956(bit 3460 in group 1722)
[ 3201.760021] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429957(bit 3461 in group 1722)
[ 3201.771489] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429958(bit 3462 in group 1722)
[ 3201.782908] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429959(bit 3463 in group 1722)
[ 3201.794281] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429960(bit 3464 in group 1722)
[ 3201.805664] EXT4-fs error (device dm-4): mb_free_blocks: double-free of =
inode 0's block 56429961(bit 3465 in group 1722)
[ 3201.818936] JBD: Spotted dirty metadata buffer (dev =3D dm-4, blocknr =
=3D 0). There's a risk of filesystem corruption in case of system crash.
[ 3202.289345] JBD: Spotted dirty metadata buffer (dev =3D dm-4, blocknr =
=3D 0). There's a risk of filesystem corruption in case of system crash.
[ 3202.328925] JBD: Spotted dirty metadata buffer (dev =3D dm-4, blocknr =
=3D 0). There's a risk of filesystem corruption in case of system crash.

I'm concerned that this happened so quickly after a fsck resolved
issues.

The filesystem is on top of a software raid mirror, so I failed one set
and ran S.M.A.R.T. short/long tests on the device, re-added it to the
array, waited the 8hours for the resync, and then did the same thing
with the other element of the array. All smart tests completed without
error.

I took the machine down to add another disk to the system so I could
have more flexibility to be able to run badblocks tests, and when the
system came back up a fsck of the partition was required. Its been
running for 3 hours now, and so far it has only said "Duplicate or bad
block in use!" so I presume it is scanning the entire device for
duplicate blocks. This is what it did the previous fsck.=20

Last time it took 8 hours to complete the first pass, and then it had to
do another pass after a reboot, which took 1.5-4hrs (i was sleeping when
it finished). So we've out for a number of hours now, which is quite
bad.=20

Its certainly possible that this is not a filesystem issue, and instead
a hardware one, the badblocks tests should give us more conclusive
information. I would love any additional suggestions for what we can do
to conclusively identify what the issue is.

thanks for reading, and any thoughts you might have!

micah

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJN7FCnAAoJEIy/mjIoYaeQTjAP/iLwytACnQh8RVpiXDB5l6Ay
SIYa2ylB/Y8/X3z97StYYOIPBrKnsfFQz3Al1UJ1ku3zlJl2POqsMAyaD1pOxs2p
54Hyt2Orux6WpPXCanQJlprjhNWxgQmAYgXTegF/F4wXvBsqVwnQ6BS5an1AH0JZ
MiCnHC+9I0GtmPEyEVfQI+mE150jMQhdU+n2oy2Sx5WD8FddsOPbcWAElGQjnaaL
HTZ4IzX3GPCi+BOVtKe76n7yzw8EWSquKMiNr6MIz5z7jXEdIOMSrCv5NuRwActx
QojhUoRC9d5hoFnYc7l4Ltax3QjHq2IcKHPXea7uoZ1BcTCSFuoiEgvq2Tz5ZVzV
y67Dxez1rX1nM9/JGNjKJIdpTHqeRjTui2z5bcMLEbMsXk2Co8ydnm8sbJ8pmjjC
KpTQHetoxWR9YzZ6ahnXdelmnR5WrW7Tipg+qggx8xw0jVT+LWBE/qc3T20lmUih
8THI8Anh6eMytmpTHdd8z2TE3IKcVXQTpO/zMpBDGdGZD9i/StORjlkqGIBncHIG
yAkfKe1ekrGM5eoJd9idkHUWeAmULWW1Dea3pLWiQBHfWgMGyNCGg4hFA64ZzeoG
U1jZAb1pGoLk6VkwexvLRnoR2gSPrTGb7TOiFSwLv4OwGtNbvNymb9PSsmFxyq/0
jz5VVYQpyJyrhHdN6S7T
=MZBa
-----END PGP SIGNATURE-----
--=-=-=--

