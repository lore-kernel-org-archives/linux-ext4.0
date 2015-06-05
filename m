From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: Re-2: Strange problems with lseek in qemu-img map
Date: Fri, 5 Jun 2015 15:05:15 +0100
Message-ID: <20150605140515.GB30104@stefanha-thinkpad.redhat.com>
References: <00056481.556F34D3@pegasus.munzinger.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	qemu-devel@nongnu.org
To: David Weber <wb@munzinger.de>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <00056481.556F34D3@pegasus.munzinger.de>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
List-Id: linux-ext4.vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 03, 2015 at 03:09:40PM +0000, David Weber wrote:
> > > I then startet a fedora 22 live system and I saw the same problem. It=
=20
> > > happens=20
> > > on both the ramdisk and a ext4 filesystem.
> >=20
> > "it" =3D=3D qemu-img map hangs or takes a very long time?
> I never waited for it to complete but I guess it just takes very long.
>=20
> >=20
> > Can you post a shell script that reproduces this with a ramdisk?  That
> > seems like the easiest way to get people debugging it.
>=20
> You can use the following commands.
>=20
> mkfs.ext4 /dev/ram0
> mkdir -p /mnt/tmp
> mount /dev/ram0 /mnt/tmp
> cd /mnt/tmp
> qemu-img create test 500G
> time qemu-img map test
>=20
> This takes foreover on all my systems.

I experience the same thing on Linux 4.1.0-rc5 with ext4 (4 KB file
system block size, 512B device sector size).

The lseek() calls take *seconds* to complete on a completely empty
(sparse) 500G file.

Here is the perf-top(1) output:

  34.08%  [kernel]                         [k] _raw_read_lock
  21.11%  [kernel]                         [k] ext4_es_lookup_extent
  20.67%  [kernel]                         [k] ext4_es_find_delayed_extent_=
range
   8.68%  [kernel]                         [k] ext4_map_blocks
   4.99%  [kernel]                         [k] ext4_llseek
   1.90%  [kernel]                         [k] rb_next
   0.14%  [kernel]                         [k] __fget

Yikes!

The syscall causing this is just:

lseek(7, 0, SEEK_DATA)

Lukas: I've CCed you because you have helped with ext4 issues in the
past.  Not sure if you have time or if this is your area.

Stefan

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJVcaybAAoJEJykq7OBq3PIQOYIAMnb0Yf4eX/OLXMusRh3N84N
++ofTdjNQw4Li8GnnWMF7+ugkIaCChkL43UGPZGuTqiI6yUbHVxKZB9l1SUzv2ef
WZ5W6azIkjvtYtvDcu41YJRPxegSzZw8eQ+KUe739u9XAMfhq714k3yS3pfe1Snn
bvmVEdut7pyUbkQ4rB8YpNN79Bokccn+O4/4OjVm4wt7I8hIohkAbwraH75YMEW+
gdSoWSvrQL2K/H+VjnIe1D5WRnp7hl91TBHZgsXPPFvS+ft6rPySCWsPATquImWE
Gfw7ZL0KRpVQxM2dhg20/2ndkjx/8EhvbcqNq6h5qu4kaGMIVYEQJqenqfj0HYg=
=DCN1
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
