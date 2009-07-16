From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: A tree to pull into linux-next
Date: Thu, 16 Jul 2009 16:48:26 +1000
Message-ID: <20090716164826.f4edbd42.sfr@canb.auug.org.au>
References: <20090715193742.GA18583@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Jul_2009_16_48_26_+1000_WJD5AXfGAF+WgyAc"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:52640 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZGPGsg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 02:48:36 -0400
In-Reply-To: <20090715193742.GA18583@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Signature=_Thu__16_Jul_2009_16_48_26_+1000_WJD5AXfGAF+WgyAc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Wed, 15 Jul 2009 21:37:42 +0200 Jan Kara <jack@suse.cz> wrote:
>
>   I've decided to create a tree through which I can occasionally merge
> mainly ext3/JBD fixes (and possibly also fixes to filesystems which
> don't have a maintainer). Hopefully this reduces chances that some patches
> get lost on the way... Could you please start pulling the tree below to
> linux-next? Thanks.
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_n=
ext

I am happy to include this, but (no offense) I would like to hear from
the ext3 and jbd maintainers (cc'd) about it.

For reference:

What I tell everyone: all patches/commits in the tree/series must
have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Jul_2009_16_48_26_+1000_WJD5AXfGAF+WgyAc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpezToACgkQjjKRsyhoI8zvygCgmILBjA9tc14WujZ5jg20ikR1
EQAAoKXEOx6dvOZX3UcWGwVas3QWY6Ni
=3CIu
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jul_2009_16_48_26_+1000_WJD5AXfGAF+WgyAc--
