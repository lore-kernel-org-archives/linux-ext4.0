From: Bdale Garbee <bdale@gag.com>
Subject: Re: dump/restore not supported for ext4
Date: Fri, 05 Mar 2010 09:21:31 -0700
Message-ID: <87lje620z8.fsf@gag.com>
References: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
	<4B90A366.9080201@gmail.com>
	<alpine.DEB.2.00.1003050412260.17723@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	stelian@popies.net, Alan Piszcz <ap@solarrain.com>, tytso@mit.edu,
	Eric Sandeen <sandeen@redhat.com>, debian-gcc@lists.debian.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Gertjan van Wingerde
	<gwingerde@gmail.com>
Return-path: <bounce-debian-gcc=debian-gcc=m.gmane.org@lists.debian.org>
In-Reply-To: <alpine.DEB.2.00.1003050412260.17723@p34.internal.lan>
Resent-Message-ID: <tbwltH-USSB.A.eI.r-SkLB@liszt>
List-Post: <mailto:debian-gcc@lists.debian.org>
List-Help: <mailto:debian-gcc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-gcc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-gcc-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Mar 2010 09:27:52 -0500 (EST), Justin Piszcz <jpiszcz@lucidpixels=
.com> wrote:
> I tried the following package in sid:
> http://http.us.debian.org/debian/pool/main/d/dump/dump_0.4b42-2_amd64.deb
>=20
> Why Debian does not include this in testing is beyond me..??

I just looked and it appears that this version of dump has never been
successfully built on mips or mipsel, which blocks it from being
promoted to testing. Checking the autobuilder build logs, it looks like
the root cause may be a toolchain problem, though it's an error message
I've never seen before.=20

https://buildd.debian.org/fetch.cgi?&pkg=3Ddump&ver=3D0.4b42-2&arch=3Dmips&=
stamp=3D1259085131&file=3Dlog

Chasing down that error message, it looks like this is indeed believed
to a toolchain issue, fixed by:

http://gcc.gnu.org/ml/gcc-patches/2009-09/msg02070.html

I don't know, offhand, if this patch is reflected in the current Debian
gcc packages.  If so, then perhaps I just need to request that the mips
and mipsel autobuilders retry the builds?  CC'ing the debian-gcc team
for advice.

> BTW: The man page needs to be fixed in dump as well then (in the new
> version)

Thanks for noticing those!  I've made those changes in my git repo for
the next Debian package upload.  Hopefully Stelian will also fix those
in his next release, I see you've copied him on this.

> Quite nice!

Thanks for testing this so thoroughly.  I myself back up two servers
with ext4 file systems using amanda and dump quite happily.

Bdale

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUBS5EvizqTYZbAldlBAQrByRAAvkqNCuwSbd9tnAtIMK+yRm596DVXNsB6
Vk3g09IhNF/zaR6o970NkRLCypPhJpFDaDiZNsNKYfVD/+dlwe9XCx/d3+2jewyz
bNhsWfZ/9iTPLRQfE/J56NchwAADhWYJfCOil8EJ5m2eUaj/ABcl7Rpc9o/i4Kcr
UEgfwQimbeifheFJce4/7mcscdcggVfGajttRzBVIpm2FlPdGs+o0G2gHNkz124I
MjlF9kQ3rlq7JNp8gWwZQmNIAwzaajsi/a2u3fv7w9XjKJpO6gcqw3js3vI1sQ/W
32yceoBajNuhSbBU1KM3TP5bDr+79w99qkgQfaMu/8cKlXjU+s4TbST1Zu9VtpKi
gPaK6tbYkSmKY58JRe8gZJFoyhA/gRRgIHkR2SZ/iSXWipER3J3lk8cCuNHU8tyV
fjbuwKLRX4MXWeyCBYs4lf59YGiGFSzClzNNFy4DpWbHY7aGuIRK1t+mzpvQ4kqB
U2jzHfMeRb8JXXzMNEkHek/XDHKkmmRejbsQCg+RKrzmrbU/lt8w5DZL2yU5mrq2
3KxrVPtQgD+Tt4kQa5KXZTHDArXrP7QzbMrXKaRHEJZzghaZVHofnIfzsL5W1/pX
S9/9R45A0e3G1skx4SS8fcl17oyp4afFpi4wosFa8z7V2AguHhb3SJ2/XYjz6Kdk
Oqy3ubmPLUM=
=KTOj
-----END PGP SIGNATURE-----
--=-=-=--
