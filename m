From: Ivan Shmakov <ivan@main.uusia.org>
Subject: Re: [PATCH] libblkid: support for GUID Partition Table (GPT), please?
Date: Mon, 17 May 2010 20:45:10 +0700
Message-ID: <87hbm6k5g9.fsf@violet.siamics.net>
References: <87632ql0pg.fsf@violet.siamics.net> <87vdapkgnk.fsf@violet.siamics.net> <20100517094753.GK2209@nb.net.home>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33438 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0EQNpi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 May 2010 09:45:38 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1OE0dO-0005ha-ML
	for linux-ext4@vger.kernel.org; Mon, 17 May 2010 15:45:30 +0200
Received: from 81.201.254.124 ([81.201.254.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 17 May 2010 15:45:30 +0200
Received: from oneingray by 81.201.254.124 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 17 May 2010 15:45:30 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>>>>> Karel Zak <kzak@redhat.com> writes:
>>>>> Ivan Shmakov <ivan@main.uusia.org> writes:

 >>> GPT contains a supposed to be unique =E2=80=9CDisk GUID=E2=80=9D field=
, which allows
 >>> for the media bearing such a partition table to be identified.

 > The devel version of libblkid from util-linux-ng supports partition
 > tables parsing, and the partition name (GPT nad Mac) and partition
 > UUID (only GPT) are exported to udev.

	I don't quite understand how udev is tied here, but please note
	that the UUID I was talking above is the one associated with the
	partition table as a whole, not with a particular partition.

	(Huh?  util-linux-ng has its own libblkid?  And, BTW, any chance
	of having the changes accepted into e2fsprogs?)

	Such a UUID allows for removable media to be identified, which,
	in turn, allows for automated backups for such media.
	(Consider, e. g., that one has a bunch of bootable USB flash
	drives.  From time to time, the OS'es are upgraded; and there
	may be problems with newer versions.  The possibility of
	restoring the bootable image to the state it had at a certain
	time could then become extremly handy.)

	(Actually, I've just finished with the design of such a backup
	scheme, and it relies on the media =E2=80=94 or partition table =E2=80=94
	UUID's, Sleuthkit and, to preserve disk space, Jigdo.  Hopefully
	I'd be able to describe it at my =E2=80=9Chacks collection=E2=80=9D [1] so=
on.)

[1] http://lhc.am-1.org/lhc/users/ivan_shmakov/

 > For example:

 > # blkid -p -o udev /dev/sdb1
 > ID_PART_ENTRY_SCHEME=3Dgpt
 > ID_PART_ENTRY_NAME=3DThisIsName
 > ID_PART_ENTRY_UUID=3Dbc10cf1d-7e63-524c-8203-087ae10a820b
 > ID_PART_ENTRY_TYPE=3Da2a0d0eb-e5b9-3344-87c0-68b6b72699c7
 > ID_PART_ENTRY_NUMBER=3D1

 > In my TODO list is to support partition identifiers for standard
 > operations like mount/fsck, something like:

 > # mount PARTUUID=3Dbc10cf1d-7e63-524c-8203-087ae10a820b /mnt
 > or
 > # mount PARTLABEL=3DThisIsName /mnt

 > Comments?

	Well, to my mind, allowing UUID's that are stored in the
	partition table could be useful in two cases:

	=E2=80=A2 the filesystem contained on a partition doesn't allow for a
	  UUID;

	=E2=80=A2 the filesystem is ought to be re-initialized (either to the
	  same filesystem type or any other one) from time to time.

	Although I consider both of the above somewhat unlikely in my
	current practice, I don't see any harm of having such a feature
	=E2=80=9Cjust for a case=E2=80=9D.

	The labels are a bit useless, to my mind, since when one does
	mount(8) or fsck(8) by hand, it's usually when one does it with
	the medium attached to a host other than it was usually attached
	to.  There, a name clash is quite likely.

=2D-=20
FSF associate member #7257

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvxSGgACgkQ+MvqjYjLOAwlbwCg4EpEv4zn09GBdNLwpPu4bL5h
bTIAoK/wNWGBXlrKC08dJZQE+lhYxjjs
=Ap0v
-----END PGP SIGNATURE-----
--=-=-=--

