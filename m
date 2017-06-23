From: Christian Hesse <list@eworm.de>
Subject: Re: Possible regression in e2fsprogs-1.43.4
Date: Fri, 23 Jun 2017 23:29:35 +0200
Message-ID: <20170623232935.13fa4688@leda>
References: <B2DFC17F-1CFC-410E-9449-2393D51C700B@illumenos.com>
	<20170623195318.cfs4ftpmy5nhcccy@thunk.org>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3243122920482670248=="
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
	linux-ext4@vger.kernel.org, Felipe A Rodriguez <far@illumenos.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
In-Reply-To: <20170623195318.cfs4ftpmy5nhcccy@thunk.org>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel/>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Sender: "Grub-devel" <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
List-Id: linux-ext4.vger.kernel.org

--===============3243122920482670248==
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tJB+jJylythW1WuMesgVeQY"; protocol="application/pgp-signature"

--Sig_/tJB+jJylythW1WuMesgVeQY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> on Fri, 2017/06/23 15:53:
> +grub-devel
>=20
> On Sat, Jun 10, 2017 at 04:00:20PM +0200, Felipe A Rodriguez wrote:
> > Upgrading from e2fsprogs-1.42.13 to e2fsprogs-1.43.4 causes the boot
> > loader to fail (unknown filesystem error) on the x86_64 VM I use for
> > initial testing.  I traced the problem to changes in the e2fsprogs
> > configuration file which now sets 64 bit flags.  I tried upgrading
> > to GRUB 2.02 but that did not resolve the problem.  Reverting the
> > changes per the patch below fixes the problem. =20
>=20
> Hmm, my laptop has been using a file system with the 64-bit feature
> enabled for quite some time, and my Debian Stretch system has been
> using Grub 2.02 to boot my system without any difficulties.
>=20
> I've done a quick check of the Debian patches and none of them seem to
> modify Grub's ext2/ext4 file system implementation.  So I don't know
> what to tell you.  Are you sure you properly reinstalled grub on the
> boot device after you upgraded to grub 2.02?

Grub should be fine, however syslinux still suffers issues with 64-bit
feature. Possibly you use a chain to load syslinux first, grub second?
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);}

--Sig_/tJB+jJylythW1WuMesgVeQY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAllNiD8ACgkQiUUh18yA
9HZPoQf/fCmuNrhZLkr0V7I7eUzOUlXRrc+KsoQOaTNFOGe9KFPzv0l6BUkLmtig
3BytLkFUTIQLEj0SGpgQjbPKV5Bc5yF+SBV3XAYZyRcMPSbKjLy0JDK56lq1U5dE
SbctF/d8PSC082QBjAwyJ+zHGAvlsFLJ5dL/cWQeezRKad3RRPJnO0LP4mHKMYAh
BTbpA3UKncuMQiG8d/m1+HyB1lT0PX9eiUwTgSV6C/hL8WhHuuPd2RA+YV3YqiFL
ZpJ5k65CCqlP0dz4RmELapZxcJ7OMDgsNK3cjOCYyh9i1ZzLlhtQXZO60lmWk8OU
5c5cGEHUZBQ3isVWLJsuPbVaD4MitQ==
=qBQF
-----END PGP SIGNATURE-----

--Sig_/tJB+jJylythW1WuMesgVeQY--


--===============3243122920482670248==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Grub-devel mailing list
Grub-devel@gnu.org
https://lists.gnu.org/mailman/listinfo/grub-devel

--===============3243122920482670248==--
