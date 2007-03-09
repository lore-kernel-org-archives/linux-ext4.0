From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Fri, 9 Mar 2007 10:36:10 +0100
Message-ID: <20070309093610.GE4252@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070306203952.471218df.akpm@linux-foundation.org> <20070307170955.GA4252@skl-net.de> <20070307114525.08265c33.akpm@linux-foundation.org> <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	James Bottomley <James.Bottomley@SteelEye.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Alasdair G Kergon <agk@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:05, Mingming Cao wrote:
> > > BTW: Are ext3 filesystem sizes greater than 8T now officially
> > > supported?
> >=20
> > I think so, but I don't know how much 16TB testing developers and
> > distros are doing - perhaps the linux-ext4 denizens can tell us?
> > -
>=20
> IBM has done some testing (dbench, fsstress, fsx, tiobench, iozone etc)
> on 10TB ext3, I think RedHat and BULL have done similar test on >8TB
> ext3 too.

Thanks. I'm asking because some days ago I tried to create a 10T ext3
filesytem on a linear software raid over two hardware raids, and it
failed horribly. mke2fs from e2fsprogs-1.39 refused to create such a
large filesystem but did it with -F, and I could mount it afterwards.
But writing data immediately produced zillions of errors and only
power-cycling the box helped.

We're now using a 7.9T filesystem on the same hardware. That seems
to work fine on 2.6.21-rc2, so I think this is an ext3 problem. I
cannot completely rule out other reasons though as the underlying
qla2xxx driver also had some problems on earlier kernels.

We'd much rather have a 10T filesystem if possible. So if you have
time to look into the issue I would be willing to recreate the 10T
filesystem and send details.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF8SqKWto1QDEAkw8RAqWDAJ9OXQZs1bDAgFoBmq9VYRtZMFpWMgCfRFQn
Jv2+/8tA8+1bTwJdgeVfZWg=
=Majh
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
