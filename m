From: "Michael B. Trausch" <mbt@zest.trausch.us>
Subject: Re: ext4 undeletion question
Date: Tue, 28 Apr 2009 15:29:08 -0400
Message-ID: <20090428152908.1e98e991@zest.trausch.us>
References: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
	<20090428161106.GB24043@mit.edu>
	<20090428132609.7628940e@zest.trausch.us>
	<87f94c370904281055s630e55adsba1e4968f782a822@mail.gmail.com>
	<20090428185346.GR3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o5Ky0MPd/qYtZbP4eAseWGS";
 protocol="application/pgp-signature"
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mike-mobile@trausch.us
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-15-213-186-BusName-Atlanta.hfc.comcastbusiness.net ([173.15.213.186]:42205
	"EHLO zest.trausch.us" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbZD1T3M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 15:29:12 -0400
In-Reply-To: <20090428185346.GR3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/o5Ky0MPd/qYtZbP4eAseWGS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

(Andreas, sorry for the dup, forgot to hit reply-all the last time.  My
fault.)

On Tue, 28 Apr 2009 12:53:46 -0600
Andreas Dilger <adilger@sun.com> wrote:

> The good news is that ext4 usually allocates file blocks contiguously
> so if you can find the inodes themselves in the journal you can likely
> extract most of the data just by printing the in-inode extents to find
> the block ranges and then dumping the file data with 'dd'.

So, here's what my current situation is:

  * I deleted a .bzr directory which contains files and additional
    directories.  AFAIK, directories are just "files", but exposed
    differently to the operating system, yes?  So I should be able to,
    if I were to find its inode, find all of its descendants, too, to
    bring them back, right?  I don't have a directory listing from
    before the deletion, and I presume that would make all the
    difference in the world.  Also, I'd need to figure out which one
    would be the correct one; I've deleted other .bzr directories (as
    part of their directory trees) repeatedly in the past on this
    filesystem.

  * This filesystem was in fact created as ext4.  I'd attempted an
    upgrade some time ago, but the upgrade took *ages* and so I aborted
    it early, reformatted, and restored my home directory from a
    tarball on the new filesystem.

  * I know where in the directory tree the .bzr directory had a link,
    obviously.  I don't know if that information is helpful or not,
    though, unless having the inode # of the containing directory is
    useful in some way.

  * I don't know _anything_ about how journaling works, but I do know
    that the directory was about a week old (just young enough to not
    be on a backup; since some hardware changes were made I hadn't
    started my hourly rsnapshot back up since I don't currently have a
    drive to rsnapshot to---d'oh!)

I'd be happy to look into options, though as I mentioned in my previous
message, I am not a solid system-level programmer (at least in my own
personal opinion).  I could probably figure it out, given enough time,
but when it comes to C (or C++) I just plain _suck_.  I am trying to
improve that, though.

	--- Mike

--=20
I don't really know that anybody's proven that a random collection of
people doing their own thing actually creates value.
                            --- Steve Ballmer, 2007

--Sig_/o5Ky0MPd/qYtZbP4eAseWGS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn3WQQACgkQ0kE/IBnFmjAL2wCeM739yybTD0r9SiTd5xfRaCF2
/zYAnRLvWbFdQQNtGTGdiACvB8NUjqh5
=Nnb1
-----END PGP SIGNATURE-----

--Sig_/o5Ky0MPd/qYtZbP4eAseWGS--
