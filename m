From: NeilBrown <neilb@suse.de>
Subject: Re: Sync does not flush to disk!?
Date: Fri, 8 Jun 2012 22:33:32 +1000
Message-ID: <20120608223332.5fe49193@notabene.brown>
References: <4FD1CB8A.9080805@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4gW/7MDUsqT3XwXYKIPGLrn"; protocol="application/pgp-signature"
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2FHMdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 08:33:44 -0400
In-Reply-To: <4FD1CB8A.9080805@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/4gW/7MDUsqT3XwXYKIPGLrn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Jun 2012 11:53:14 +0200 Asdo <asdo@shiftmail.org> wrote:

> Hello all
> I don't exactly know where to ask this question...
>=20
> I have a situation of
>=20
> sda1 + sdb1 --> MD raid1
> Above that is an ext4 filesystem. No LVM.
>=20
> I am making changes to that filesystem (vi a file) and then i am doing
> sync
> sync
> (twice)
>=20
> then I am starting KVM in snapshot mode on the sda and sdb disks so to=20
> virtualize the same system on which I am operating.
>=20
> kvm -m 1024 -hda /dev/sda -hdb /dev/sdb -snapshot
>=20
> The strange thing is that the virtual machine is NOT seeing the latest=20
> changes to that file!
>=20
> Then I tried to do :
>=20
> for i in /dev/md? /dev/sda /dev/sdb ; do blockdev --flushbufs $i ; done
>=20
> and restart KVM,
> and NOW it is seeing the changes.
>=20
> In the past I had similar problems, and not knowing about blockdev=20
> --flushbufs I ended up dismounting the filesystems and stopping the=20
> RAIDs. That also appeared to actually commit stuff to disk.
>=20
> So sync is not enough? Would somebody explain to me better?

There is a cache associated with /dev/sda and /dev/sdb which md does not ma=
ke
any use of.  The filesystem doesn't use it either.  It is only used from
user-space reads from /dev/sda or /dev/sdb.
When you "sync" the filesystem, the new data is written out, but the cache =
it
not changes.  When you then read from /dev/sda, you might get cached data,
which is stale.

blockdev --flushbufs
clears that cache so that subsequent reads come from the device, not from t=
he
cache.

i.e. it is read caching that is causing the confusion you see, not write
caching.

NeilBrown

--Sig_/4gW/7MDUsqT3XwXYKIPGLrn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9HxHDnsnt1WYoG5AQKMRhAAvT1ASNnmEFULhyCzXGaAhbNJQvlmx4Wl
Wg/ZXdmKfDg8DFC4siMMmOgnpOvJPirTKBlyQ7C5+n0WXVhdHotAUGkZhVfccAsV
IbD+AZl/9LwpKDSFqCGFSHZ5agU4rAutfNp9Ih1i4M3vQoLSkOtaDFgOh4Msf6DM
HA4DieWZsYBZGy+H6elx5z8701ICslbvEIosITqquN/y5xJUf6rI9tntOd+vPkwh
4VirVyMQEOBSSfIcE0IGKIpSKBESr++F97UEs2vnvwwb+wiPY5iUsb/cPas0J2fQ
VGk/qrJcZ6mZRmhunWt6813ZkOQiTOuBVbjdS2QcfaxzoayL/8q9cK9gAMQOGSZK
rp7xiUYKSZilwQ891FDhwilkjLzdhm+dvc2Ya5CDcngtCAhtnDgQB1LJ6YZ150Ir
l9xwulnoqY/L2TvX1v4GcbFGsyBM8D/szas4Z7+5yk6HNRvEcb+YhaRzY0XSESTy
eH+I7UnFEmQmjR3sv4GUf2hGF7DPScGYKX590dhHSxM2HypEF8pFLXAS5R06Pvjv
mAElsYUyIyfU1SJTKOANVMUHCRBMC9qAhPtqA4A02OQ3pcbPwip1iNkqZDvmixIb
KuCb6Elek/DN6KOrWLC+ropBbBgowStnF10y+eNtAnnr0f50/9ttANy3e0IpK7OZ
0ymt2feV2pQ=
=wXvY
-----END PGP SIGNATURE-----

--Sig_/4gW/7MDUsqT3XwXYKIPGLrn--
