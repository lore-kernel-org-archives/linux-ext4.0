From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Porting Zfs features to ext2/3
Date: Wed, 30 Jul 2008 00:00:23 -0600
Message-ID: <1217397623.7340.22.camel@telesto>
References: <18674437.post@talk.nabble.com>
	 <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu>
	 <1217218559.28825.12.camel@telesto>  <20080728124055.GD9378@mit.edu>
	 <1217303912.7887.20.camel@telesto>  <488F4965.6080801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Vhi4mbxgMwZTH0htlDKK"
Cc: Theodore Tso <tytso@mit.edu>, postrishi <postrishi@gmail.com>,
	linux-ext4@vger.kernel.org
To: rwheeler@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.249]:4337 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYG3GA3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 02:00:29 -0400
Received: by ag-out-0708.google.com with SMTP id 31so253052agc.10
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 23:00:27 -0700 (PDT)
In-Reply-To: <488F4965.6080801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-Vhi4mbxgMwZTH0htlDKK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 12:46 -0400, Ric Wheeler wrote:
> > I haven't personally tried pulling the plug, but I've tried holding dow=
n
> > the power button on my laptop until it powers off. Everything works fin=
e
> > and scrubs (the closest ZFS gets to fsck) don't report any checksum
> > errors. The filesystem driver updates the on-disk filesystem atomically
> > every five seconds (less time in special circumstances) so there's neve=
r
> > any point at which the filesystem would need recovery. The next time th=
e
> > filesystem is mounted the system sees the state the filesystem was in u=
p
> > to five seconds before the power went out. The FUSEness of the
> > filesystem driver doesn't seem to affect this.
> >
> Does that mean you always lose the last 5 seconds of data before the=20
> power outage?

=EF=BB=BF> The expected behaviour should be that any fsync()'ed=20
> files should be there (regardless of the 5 seconds) and other=20
> non-fsync'ed files might or might not be there,=EF=BB=BF but that all fil=
e
> system integrity is complete.

fsync()s are one of the triggers that cause the filesystem driver to
update the disk more than once every five seconds. This can also happen
when the filesystem is very full and someone is writing to the disk.=20

> We had an earlier thread where Chris had a good test for making a case=20
> for the write barrier code being enabled by default. It would be neat to=20
> try that on ZFS ;-)=20

To my knowledge, write barriers are not available to FUSE filesystems.
Also, the maintainer of ZFS FUSE discovered that calling fsync() on an
open device file just plain does not work on Linux, so currently the
driver requests write cache flushes directly from the hardware.

> It would also be very interesting to try and do a drive hot pull.

I've got some vacation coming up...sounds like fun! Unless someone
specifically asks on here, I'll post the results in the ZFS on FUSE
mailing list.

Cheers,
Eric


--=-Vhi4mbxgMwZTH0htlDKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIkAN3e2L37HVup3ARAuBPAJ9D1AKwRpUVGI6uI+Ce+h5bwOqrUwCbBzZe
VXBKbIviHfB2u7okDgHZkSk=
=nqJ+
-----END PGP SIGNATURE-----

--=-Vhi4mbxgMwZTH0htlDKK--

