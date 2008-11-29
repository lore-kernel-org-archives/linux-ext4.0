From: Andres Freund <andres@anarazel.de>
Subject: EXT4 ENOSPC Bug
Date: Sat, 29 Nov 2008 14:18:19 +0100
Message-ID: <200811291418.24672.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1407002.fgaMV5Av2x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:58655 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYK2NS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Nov 2008 08:18:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1407002.fgaMV5Av2x
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ted, Hi Andreas, hi all,

On a testsystem (spare laptop) with ext4 as root filesystem sometimes the=20
system starts to return ENOSPC to all write/create syscalls.
Sometimes the system runs without problems, at other times it starts having=
=20
problems soon after boot.
A reboot resolves the problem temporarily.

I don't see  a specific usage triggering the problem.

Deleting some files sometimes allows the creation (just touch $unused_filen=
ame)=20
of some files, but not many.

Anything I can do to help you to debug the problem?

Andres

Kernel is: 2.6.28-rc6-andres-00007-ged31348

# df /
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/root_crypt
                     302855628 110032848 192822780  37% /

# df -i /
=46ilesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/root_crypt
                     19234816  786691 18448125    5% /


# tune2fs -l /dev/mapper/root_crypt=20
tune2fs 1.41.3 (12-Oct-2008)
=46ilesystem volume name:   root
Last mounted on:          <not available>
=46ilesystem UUID:          b81f5bab-9544-45a9-8f15-aa7012ae2522
=46ilesystem magic number:  0xEF53
=46ilesystem revision #:    1 (dynamic)
=46ilesystem features:      has_journal ext_attr resize_inode dir_index fil=
etype=20
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg=20
dir_nlink extra_isize
=46ilesystem flags:         signed_directory_hash=20
Default mount options:    (none)
=46ilesystem state:         clean
Errors behavior:          Continue
=46ilesystem OS type:       Linux
Inode count:              19234816
Block count:              76921099
Reserved block count:     0
=46ree blocks:              48205695
=46ree inodes:              18448125
=46irst block:              0
Block size:               4096
=46ragment size:            4096
Reserved GDT blocks:      1005
Blocks per group:         32768
=46ragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
=46lex block group size:    16
=46ilesystem created:       Tue Sep 30 11:57:33 2008
Last mount time:          Thu Nov 27 14:30:58 2008
Last write time:          Thu Nov 27 14:30:58 2008
Mount count:              116
Maximum mount count:      200
Last checked:             Mon Oct  6 13:54:09 2008
Check interval:           31104000 (12 months)
Next check after:         Thu Oct  1 13:54:09 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
=46irst inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
=46irst orphan inode:       288694
Default directory hash:   tea
Directory Hash Seed:      d0501622-2c99-4b0d-9a0c-d6b6705ff4f2
Journal backup:           inode blocks


--nextPart1407002.fgaMV5Av2x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkxQRwACgkQporPraT14igvWwCgmdJyI8Mj+2GKYwyVwYMD87XX
HuIAn05uRydfxH5Q2HjGrujGS+FeX1Ci
=NcrG
-----END PGP SIGNATURE-----

--nextPart1407002.fgaMV5Av2x--
