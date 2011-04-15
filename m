From: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 11:24:19 -0600
Message-ID: <4DA87F43.5040807@redhat.com>
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net>	<20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com>	<20110415000940.GL21395@dastard>
	<87sjtjq4ir.fsf@rho.meyering.net>
	<20110415171629.GA9088@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="------------enigD99D3507C9612B7769610428"
Cc: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, coreutils-mXXj517/zsQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <20110415171629.GA9088-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <http://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD99D3507C9612B7769610428
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/15/2011 11:16 AM, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 10:53:48AM +0200, Jim Meyering wrote:
>> Can you or anyone else point to authoritative documentation
>> (or even a summary of those "discussions") of FIEMAP semantics?
>=20
> A large part of the problem is that there's none and the semantics
> is a hode-podge of random flags that mostly make little sense
> outside of fs developers debugging the layout that we created.  The
> closest to a description is Documentation/filesystems/fiemap.txt
> in the kernel tree, but that doesn't document most of the delicate
> points.

Would it be worth borrowing from Solaris' semantics and adding SEEK_HOLE
and SEEK_DATA to lseek(2), as a higher level (less-detailed, but easier
to define and easier to use) interface for discovering the regions of a
file that only contain NUL bytes?  FIEMAP is a great interface at
exposing everything possible, but coreutils doesn't necessarily need all
that complexity just for determining when it is safe to skip over a
portion of a file that is either unallocated or unchanged from the
initial 0 contents.

--=20
Eric Blake   eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enigD99D3507C9612B7769610428
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNqH9DAAoJEKeha0olJ0Nql8sH/0k7s6dpcKOMaJPWHvPcV4PI
eAHboTT6J6t4Z2zovlFLyO4THFPa6Ib9KA8hENqHPQ4VOAeGeeqp+2ACrJXjwSaG
nxe1u3gDGR/DTC2psJys/cjA+6oaIJubTUHIPMrdTVjwjYysdyHBaromTCHxXN+c
VLn+fjo+O/pPFGDYD37aXzhgTJBvpacUSltfN/sdae4ap+u6LQB53eV8u9Arm7lH
BS8RcV16srDVjR9W+Vw2eEkgmZAG20NtM+SjXz6did8iX5e8KDS8nEdAIbVbOCy4
7Vy0D2B9ak5b3mwFGV+7n/nF35A3LLNlmdP4NGGQLvdwlfMBMxdMgEB8LreVpf8=
=JVjL
-----END PGP SIGNATURE-----

--------------enigD99D3507C9612B7769610428--
