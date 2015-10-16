From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: High write latency spikes when writing to EXT4
Date: Fri, 16 Oct 2015 10:58:01 -0600
Message-ID: <DBD0EC66-0B63-4E50-9025-DBA9D20FB0D4@dilger.ca>
References: <loom.20151016T095437-595@post.gmane.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_BAA5C98A-62B7-485B-9072-20053D126B71"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Jean-Paul Smeets <jean-paul.smeets@asml.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34954 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbbJPQ6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2015 12:58:07 -0400
Received: by padcn9 with SMTP id cn9so10631806pad.2
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 09:58:06 -0700 (PDT)
In-Reply-To: <loom.20151016T095437-595@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_BAA5C98A-62B7-485B-9072-20053D126B71
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 16, 2015, at 2:07 AM, Jean-Paul Smeets =
<jean-paul.smeets@asml.com> wrote:
> In our application we are seeing occasional high latency spikes (500ms =
range
> )when writing small amounts of data (a couple MB, a couple of 100 IOs) =
to
> files on an EXT4 volume (data=3Dordered). We are running kernel =
3.10.62.
>=20
> What seems to be happening is that a journal commit takes a long time.
> During that time no write access to the journal is possible.
> So a subsequent vfs.write is blocked until the journal commit is =
finished.
>=20
> We expected the page cache to decouple the vfs.write from this and not =
to
> block the vfs.write.
> This behavior causes large spikes in on average much lower write =
latencies.
>=20
> Small log excerpt (duration in us):
> 16:18:56.966387, PROCA, 20234, __ext4_journal_get_write_access: =
duration: 140412
> 16:18:56.966406, PROCB, 19965, __ext4_journal_get_write_access: =
duration: 461892
> 16:18:56.966422, PROCC, 20387, __ext4_journal_get_write_access: =
duration: 391105
> 16:18:56.966439, PROCD, 20041, __ext4_journal_get_write_access: =
duration: 64256
> 16:18:56.966454, itheex, 19823, __ext4_journal_get_write_access: =
duration:
> 383671
> 16:18:56.966718, jbd2/dm-8-8, 684, jbd2_journal_commit_transaction:
> duration: 468959
> 16:18:56.967426, PROCE, 19867, ext4_file_write: duration: 469431
> 16:18:56.967442, PROCE, 19867, vfs.write: duration: 469452
>=20
> A similar, but less frequent issue is with the =
__ext4_journal_start_sb.
> Small log excerpt:
> 16:17:43.337004, PROCF, 20041, __ext4_journal_start_sb: duration: =
240753
> 16:17:43.337024, PROCG, 19980, __ext4_journal_start_sb: duration: =
269051
> 16:17:43.337498, PROCG, 19980, ext4_file_write: duration: 269531
> 16:17:43.337515, PROCG, 19980, vfs.write: duration: 269554
>=20
> Can anything be done about these very high latency spikes ?

There are a number of options to disconnect the file write operations =
from the journal commits:
- preallocate file blocks with fallocate() so that there are no =
allocations
  during the write
- use data=3Dwriteback so that writes are not ordered with journal =
commits

It is also possible to store the journal on a separate low-latency =
device
like SSD or PCI NVRAM so that the journal commits are very fast and do =
not
cause latency spikes during writes.

Cheers, Andreas






--Apple-Mail=_BAA5C98A-62B7-485B-9072-20053D126B71
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBViEsmnKl2rkXzB/gAQjWuQ/+OUr/NgFgsSUNzLFOjmO47veEhi0mBNYA
Py6KGgId0fuQPYnjzKCBGQRTvvNqkNLlRaKOz39sJX3AyV9LFRryjqq93Vu4Jkp3
OiK4e0ZWnVezx9IwvN5qXpRLTS++Mz3Htu4I2yeUEExH3SWncQvhlXNi80BLJ47t
dEMeDhDI6r5k2mmAXsLQL2Do5/I74Vjif1c4rWgBPHeGALB2+iwGNrYcS5O2mjvG
wRKGx3jCbB4Ds1DpYmJq8mcrxo6tlSPZqiGXtNlsccDuX71GJYgsi+0soFWFSznp
r+ATP91kG8z1JSyGD5vLy3hX6MSCSeaOrMrQDLtvgIDdF3VNZWGxrSl0Un+gh8AA
8V8wQJJ5Ys/p4BtWyFMhEscSyMImGgN9bjX5mVcjGbpfO40PhdY5AJWvs0ZCDsHP
aq++XVoPDXgdNGRdmCz9agsuMe9ZJGKuiWnA6uiT/ZXV98XZVjfrNEHoanXVxP0v
ESvTpH1czgiM9mZUMNT6dpq7wLNez0z0KDQZ5F9hFxdXi/p0I6z2Me8rVZs6lV5X
RzoQ1KaAJMWI/+T+S4BZey0bX1Yv8814N+5w0lAo1Z6u+rAgsvxxKB4lSHb+ZHa5
A+u1lxdQzjswG/9uNGvQyNsg0KwZ3dfVn8pLouyeorrvwrdvWTTcObdynKEg4Qt6
rl3ysKRbx8c=
=58GX
-----END PGP SIGNATURE-----

--Apple-Mail=_BAA5C98A-62B7-485B-9072-20053D126B71--
