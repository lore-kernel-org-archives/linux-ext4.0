From: NeilBrown <neilb@suse.de>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Thu, 15 Dec 2011 12:27:59 +1100
Message-ID: <20111215122759.7ce0b7b5@notabene.brown>
References: <20111214133400.GA18565@localhost>
	<20111214143014.GB18080@thunk.org>
	<1323910977.22361.423.camel@sli10-conroe>
	<20111215010010.GA14805@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MfDZWGYxaGBuVM/q+09VgFP"; protocol="application/pgp-signature"
Cc: "Li, Shaohua" <shaohua.li@intel.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1LOB2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Dec 2011 20:28:12 -0500
In-Reply-To: <20111215010010.GA14805@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/MfDZWGYxaGBuVM/q+09VgFP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 09:00:10 +0800 Wu Fengguang <fengguang.wu@intel.com>
wrote:

> > I found sometimes one disk hasn't any request inflight, but we can't
> > send request to the disk, because the scsi host's resource (the queue
> > depth) is used out, looks we send too many requests from other disks and
> > leave some disks starved. The resource imbalance in scsi isn't a new
> > problem, even 3.1 has such issue, so I'd think writeback introduces new
> > imbalance between the 12 disks. In fact, if I limit disk's queue depth
> > to 10, in this way the 12 disks will not impact each other in scsi
> > layer, the performance regression fully disappears for both writeback
> > and order mode.
>=20
> I observe similar issue in MD. The default
>=20
>         q->nr_requests =3D BLKDEV_MAX_RQ;
>=20
> is too small for large arrays, and I end up doing
>=20
>         echo 1280 > /sys/block/md0/queue/nr_requests
>=20
> in my tests.

And you find this makes a difference?

That is very surprising because md devices don't use requests (and really u=
se
the 'queue' at all) and definitely don't make use of nr_requests.

NeilBrown

--Sig_/MfDZWGYxaGBuVM/q+09VgFP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTulNHznsnt1WYoG5AQLbyBAAtW8Rn9dPiEXM1bZBiXPQHKOCv7+FPg7r
+nfsel7yni3MxUgBEUJWE5X6D9lI/BZWS4LAi54PtCoDJgIiKMNxfdfPJ8/5eIGu
s0QEzDbol1q8bHXLnzHw0Xy/6LkSo8LtSXhB4IHOfH9SggqRke6HaJ5Tjv3huDZ/
DzRMNP92+JH4DALtNXnYJL+bcOFd2224mdcROGoK6SZ+Hz6iauwj7f1QM/2UWxAd
+1ZZwv+svWCtN9MmXo6kaj5wBIuWZh2g4Rn5GR2EwnoRUg/Oyasq23+D+StB+0Yr
Oa9DhXFwc/EzsYqUZaTzr8dvP2iR2iLT/bDn8fLMzENDJQcnyo6iKLwH9rc2cpnE
AYjIiL47svfY6vi6VRptxq2oD4BOisVfDOeoJeR35YJ4vyIgXiI2PTg9yK7q8tUM
ioPXrhuy/0c6dfyPvndO3/JFhYCpGHARk109gAX4ANk9jkztg5y5VOR1IEtYxQBR
G1s6cPXozypRtaASN10XJ9SZHnvjsDcPYYH90eh8omdywWXZv7y6L8yYsJJVtJBn
qQOnHKFXzheWMGHnVkTWiM27iyzLzgOcKlYmJ/bnAbDnwFjvsdafNOjrGM2quUNt
2bgxtOA6/ZpHt43Q2BctalVcs86br8AUOw5GteUgVoDaL3wtg87n6Qm+cunTp2Uu
UH1O5jx/fWw=
=QER/
-----END PGP SIGNATURE-----

--Sig_/MfDZWGYxaGBuVM/q+09VgFP--
