From: Micah Anderson <micah@riseup.net>
Subject: new ext4 filesystem vs. converted ext3
Date: Fri, 03 Jun 2011 17:49:17 -0400
Message-ID: <87tyc6pov6.fsf@algae.riseup.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36805 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1FDBpH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2011 21:45:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QSfvD-0004GX-Mg
	for linux-ext4@vger.kernel.org; Sat, 04 Jun 2011 03:45:03 +0200
Received: from seattle210.riseup.net ([198.252.153.210])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 04 Jun 2011 03:45:03 +0200
Received: from micah by seattle210.riseup.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 04 Jun 2011 03:45:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable


Hello,

I recently ran into the subdirectory scalability issue of ext3 on our
listserver. Thankfully, ext4 exists, so it was finally time to move to
it. I followed the published process to convert the ext3 filesystem to
ext4[0] and things worked well, I'm no longer hitting the 32000 limit on
subdirectories.

However, ever since I did that change, I've noticed an increase in I/O
wait state on the CPUs. I've been trying to determine why, and if there
were some things I should tune on this ext4 filesystem.

First thing I found was that the Filesystem Features of an ext4
filesystem that were converted from ext3 are different than those that
are set on a filesystem that was created as ext4 (on Debian Squeeze),
From=20tune2fs -l:

a newly created ext4 has:
Filesystem features:      has_journal ext_attr resize_inode dir_index filet=
ype needs_recovery extent flex_bg sparse_super huge_file  uninit_bg dir_nli=
nk extra_isize

my migrated one has:=20
Filesystem features:      has_journal ext_attr resize_inode dir_index filet=
ype needs_recovery extent sparse_super large_file uninit_bg

The difference being new filesystems have 'flex_bg', 'huge_file' and
'extra_isize' set, and the converted filesystem has 'large_file' and
'uninit_bg'. I'm not sure I understand why the difference and wonder if
someone can explain to me why? Or if I should be changing these?

Currently the filesystem is mounted with just rw,relatime set, and I
wonder if there is a combination of some tune2fs changes, and mount
options that we would benefit from.

Basically this filesystem has a lot of small files, there is a set of
spool directories where there are a lot of small writes, small reads and
deletes. There is also an archive of list postings, which is a fairly
large set of small files, which is mostly small writes, reads every once
and a while. There is also a series of stats that happen on a large
number of subdirectories.

Thank you for any suggestions!
micah


0. https://ext4.wiki.kernel.org/index.php/Ext4_Howto#Converting_an_ext3_fil=
esystem_to_ext4

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJN6VbdAAoJEIy/mjIoYaeQJhQQAKCMcxHIeLsq8ua+vCB/v/ni
h1QvrycjM5NW64X011dWt0FyJQthTb2uaamsuA39MenmOqqCK/f9nPPQWDwIFPo5
pclMHFmXfdjEs8qFs8YQoFAj7K6BbA+ofjaP4YHlVhUD1UJZwcMzjrbd6976eQBs
wsx2woUJ5N18blcYljpTFqFc65YGglTkCVhIL5jbC0qxW7wypATWGGSiji4O54of
Hk8FCsMkXT7sE+sIfchas834/ZXAAho1FZG1GcKuKvilXofyDrPB7pGcED22lTYq
ojQRZtstCEWZETMqYLMvKBsMiJWb5JUA32u7Sbf0JSqRGXXyRPAD/xGuS0NPKvqo
URzfpf+/PSXNeHNZGby1Fhe5ZuWIjXe3Xp/fXdQ5xy/UAiPmjv06W0QG+2BLccGO
PyJTr8W9Pww/MCwOimd30betvu2gVxf0KKKCmSgxGVgh2hNOwWtL3iWJ4vko168C
CozMeX4oBkvJDVk9Qp+5dklABgnPLIuWaqmIaBE407apinafsftpzNGkm0QEcJdl
Zu8z0x/mgMW3ovz6RS40SAWR1/Rqun0Z6wWl+rOpYMxUdIEtAPPXkfQq5lQ7HZoe
Ncmp9C27RaxCXyR63lceQBPizXKy4e0kj3bfgJaJYsvsSaQ6Rw05upLhqP0+wurF
NoMP036MyW6iD5yN4WF5
=IlQg
-----END PGP SIGNATURE-----
--=-=-=--

