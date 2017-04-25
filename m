From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: API for Vectorising IO
Date: Mon, 24 Apr 2017 21:27:22 -0600
Message-ID: <49AAE741-FE98-4DB0-8E3A-7D94C8C2E54F@dilger.ca>
References: <CAAMvbhFmbLtMizB3KBPhUnvhN3iFeJkg06=O7utwyTtFxLDd6g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DC081B9D-BF3F-4D80-83AB-038930C373FF";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: James Courtier-Dutton <james.dutton@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36156 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980274AbdDYD11 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Apr 2017 23:27:27 -0400
Received: by mail-io0-f169.google.com with SMTP id p80so89228036iop.3
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 20:27:26 -0700 (PDT)
In-Reply-To: <CAAMvbhFmbLtMizB3KBPhUnvhN3iFeJkg06=O7utwyTtFxLDd6g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DC081B9D-BF3F-4D80-83AB-038930C373FF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 22, 2017, at 4:39 AM, James Courtier-Dutton =
<james.dutton@gmail.com> wrote:
>=20
> Hi,
>=20
> I recently read this, which talks about vectorised IO for NFS.
> https://www.fsl.cs.sunysb.edu/docs/nfs4perf/vnfs-fast17.pdf
>=20
> Are there any ways to do this for ext4?
> For example:
> A single syscall() that would list all the files in a directory.
> I.e. A sort of list_all_files() all as a single syscall().
> Also, having the API as async and partial results:
> I.e. send list_all_files() message.
> receive a request_id.
> send get_next_1000_files(request_id)
> receive the next 1000 files in that directory.
>=20
> So, a sort of partial results, but with batching, in this case batch
> 1000 files at a time.
>=20
> similarly for a read_all_files(list_of_files).
> would then send back all the file's contents.
>=20
> Surely, if the file system knows the full picture, earlier, it can
> better optimise the results.  So, this lets the application request
> a list of many different file operations ahead of time. gets a
> "request_id" back. And can then gather the results later.
>=20
> The important point here, is finding ways to limit the round-trip time
> and amount of requests/responses.  The returning of a "request_id"
> means that the request is returned without even needing to access the
> disk, thereby limiting round-trip time to a minimum.
>=20
> A similar approach could be used to optimise file find operations, but
> I suspect this sort of operation is still better optimised with an
> index in user space. E.g. Apache Lucene.
>=20
> While vectorised IO work improve file access over the network
> considerably, if local file systems also used the same API,
> applications could be written, using a single API, and work
> efficiently on both local and remote filesystems.

One thing that has been discussed a bit in the past is to provide a
generic interface for doing bulk stat operations for multiple files.

One proposal is to make this similar to "readdirplus" for NFS, which
returns directory and stat information for all files in a directory.
This is useful if you are accessing all files in the directory.

Another proposal is to submit a list of inodes (file handles?) to the
kernel and then get the stat information back in an array for all
of the inodes at once.  This is about the same as readdirplus if
you are accessing all of the inodes, but is potentially much better
if you are only accessing a subset of files (e.g. "ls -l *.txt" or
"find . -type d" or similar).

I don't know if there was ever a discussion to allow reading of
multiple files at once, though this could potentially help when there
are lots of smaller files being accessed from high-latency storage
(e.g. network and/or disk) since it would allow the storage to better
optimize the IO pattern.

Cheers, Andreas






--Apple-Mail=_DC081B9D-BF3F-4D80-83AB-038930C373FF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY/sIapIg59Q01vtYRAj12AJ9HWoUKDyvQuhPwOZnLbSoEgLITHwCgjWgC
C3wF8dEBwq++lapqzyDXhcc=
=wxnq
-----END PGP SIGNATURE-----

--Apple-Mail=_DC081B9D-BF3F-4D80-83AB-038930C373FF--
