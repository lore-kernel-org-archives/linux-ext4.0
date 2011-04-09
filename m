From: Roman Mamedov <rm@romanrm.ru>
Subject: tune2fs can't be used on a mounted ext4, or...?
Date: Sun, 10 Apr 2011 00:39:54 +0600
Message-ID: <20110410003954.4108b9c9@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/20QR6bhndDEHP=MfT3rK8_J"; protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/20QR6bhndDEHP=MfT3rK8_J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Here's what happened. I reshaped my RAID5 to a RAID6 and a larger disk coun=
t.
Then I ran "resize2fs /dev/md0". It successfully enlarged the filesystem
online (that took a couple of hours, I think).

Since my count of disks changed, I thought I should change the array stripe
width. Then, while still not unmounting the filesystem, I did:

  tune2fs -E stripe_width=3D48 /dev/md0

Then I started copying files from another array to the one on which the abo=
ve
operations were conducted. I did:

  cp -Rp /mnt/array1/data/* /mnt/array2/new-data/

This completed successfully. No errors on the console, silence in dmesg.

Then I thought I'd verify the destination, just to be sure. Luckily, I have
checksums stored in almost every directory as .SFV files (created with "cfv=
").

And some checksums did not match. On a closer investigation, it appears like
some files deep down in the directory tree (and with a rare occurence,
something like one file in a thousand) were truncated during copying. E.g.
they'd have size of 188 MB instead of 349 MB, or 128 MB instead of 170 MB.
Some files (originally less than 1 MB in size) just had zero-length on the
destination.

Other than these truncations, there is NO corruption of data inside any of =
the
files. Which kinda rules out CRC-style errors in controller/disk/cable.

So.. this is completely puzzling to me, and I suspect either a kernel bug, =
or
my mistake, and tune2fs cannot modify a mounted FS (however it did NOT show=
 any
warning that the FS was mounted, and if this is the case, it should've
absolutely refused to operate on a mounted FS).

Any ideas? :)

--=20
With respect,
Roman

--Sig_/20QR6bhndDEHP=MfT3rK8_J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2gp/oACgkQTLKSvz+PZwi0cwCZAQVIwhKZl9xvAJLUCQ+KG2rR
yD0An1erUfoNpowHnfeFndh4xgmCYr5f
=fd30
-----END PGP SIGNATURE-----

--Sig_/20QR6bhndDEHP=MfT3rK8_J--
