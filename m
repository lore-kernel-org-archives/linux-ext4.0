From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: One more corrupted fs crash in ext4_put_super
Date: Thu, 9 Oct 2014 23:15:41 +0300
Message-ID: <20141009201541.GG27150@sli.dy.fi>
References: <20141005001239.GD27150@sli.dy.fi>
 <20141007205643.GF27150@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:60293 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUPp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 16:15:45 -0400
Received: from sli.dy.fi (a91-156-209-44.elisa-laajakaista.fi [91.156.209.44])
	by gw03.mail.saunalahti.fi (Postfix) with ESMTP id 27B1520015
	for <linux-ext4@vger.kernel.org>; Thu,  9 Oct 2014 23:15:41 +0300 (EEST)
Content-Disposition: inline
In-Reply-To: <20141007205643.GF27150@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 11:56:43PM +0300, Sami Liedes wrote:
> Here's one more filesystem that causes a crash in ext4_put_super on
> 3.17 both with and without the two patches from this thread applied.

Ok, I bisected a bit. FWIW.

No crash on 3.16.4 + these two patches:

1c8944cbe1b ext4: add ext4_iget_normal() which is to be used for dir tree l=
ookups
b65ad45743c ext4: don't orphan or truncate the boot loader inode

Crash on 3.17 + the above two patches.

The first commit that crashes on this test with the above patches:

# first bad commit: [908790fa3b779d37365e6b28e3aa0f6e833020c3] dcache: d_sp=
lice_alias mustn't create directory aliases

commit 908790fa3b779d37365e6b28e3aa0f6e833020c3
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Mon Feb 17 17:58:42 2014 -0500

    dcache: d_splice_alias mustn't create directory aliases

    Currently if d_splice_alias finds a directory with an alias that is not
    IS_ROOT or not DCACHE_DISCONNECTED, it creates a duplicate directory.

    Duplicate directory dentries are unacceptable; it is better just to
    error out.

    (In the case of a local filesystem the most likely case is filesystem
    corruption: for example, perhaps two directories point to the same child
    directory, and the other parent has already been found and cached.)

    Note that distributed filesystems may encounter this case in normal
    operation if a remote host moves a directory to a location different
    from the one we last cached in the dcache.  For that reason, such
    filesystems should instead use d_materialise_unique, which tries to move
    the old directory alias to the right place instead of erroring out.

    Signed-off-by: J. Bruce Fields <bfields@redhat.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

--=20

	Sami

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNuztAAoJEKLT589SE0a0alEP/1HX7hHL3xz4sp1Vik7CJTdH
Z59TxtrE6i+xmylKtlv3arPJFHzRgL3SPRSzG8h3Aoh6acBRgQDd+f9oFFLJJuE6
OV9rpdOg/psNOwUNCM6a8+o7IIFKuBHEE+BfXeu198fOC0Q3a74RReLieNW2EydE
XRw8SaopWYvMGDhI4hTvAHQ6ChblInWSCcjE6rvchmG+yZkhWhyEzYzQLUj6eFpe
KmYGbZmYgtZREIFGTvJ+Z2VC7rW59rAdCVMHXUnkkEmUX3wPNdxxprvGWgwsBYpd
RB8u326F2LLtf2K2k5UEbVU32Cheu0imEl5Nc1pg2L3O2Dk13/zMjZGch/j55A2f
8J+SQttxi7woTAC2rclhglOIJC7q1ZW735P8r/YJ/OuAMAGXp/GhUgLLtcYbEA6x
+9PFiLEP/uzeVupWct5wVvnutit8XOczMoWXTW3Ncc5ab9YIogfRIxii93dE2e3R
0mSnBixLMxbtmpae2q+tufpzBxcq3o1dCa66X91UrXolhvAwNXuhCITeWVNh/TZq
5F6YYbEQi8mJPEUfMvrVQDAcbgGEUH6KMguOM9lDHKaxv9AVI25KfCBHNWE0cVZx
6Csioph15J+RCrX8lIZgEsQGL4tMfmjzwZOdxMgECuPVAnHOGo7m39FkCVoK5iXw
ahiq+tdd84eCWiETN8Rr
=NzfK
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
