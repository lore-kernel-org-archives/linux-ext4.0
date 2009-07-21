From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: A tree to pull into linux-next
Date: Tue, 21 Jul 2009 16:08:52 +1000
Message-ID: <20090721160852.65038f6c.sfr@canb.auug.org.au>
References: <20090715193742.GA18583@duck.suse.cz>
	<20090716164826.f4edbd42.sfr@canb.auug.org.au>
	<20090716114751.GE21267@mit.edu>
	<20090716115221.GA24875@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Jul_2009_16_08_52_+1000_6RLpPKsWj/mxvhZy"
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:34997 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZGUGJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 02:09:07 -0400
In-Reply-To: <20090716115221.GA24875@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Signature=_Tue__21_Jul_2009_16_08_52_+1000_6RLpPKsWj/mxvhZy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 16 Jul 2009 13:52:21 +0200 Jan Kara <jack@suse.cz> wrote:
>
> > On Thu, Jul 16, 2009 at 04:48:26PM +1000, Stephen Rothwell wrote:
> > >=20
> > > I am happy to include this, but (no offense) I would like to hear from
> > > the ext3 and jbd maintainers (cc'd) about it.
> > >=20
> >=20
> > The main isssue would be that akpm often has ext3 changes stashed in
> > -mm.  Having a separate ext3 tree makes sense, and if Jan wants to
> > maintain it, that makes good sense to me, but we should get Andrew's
> > sign off, and Jan should make sure he has any ext3/jbd patches that
> > might be in -mm, to avoid any potential patch conflicts.
>   Yeah. It's upto Andrew. I think he pulls linux-next so he should notice
> conflicts. Anyway, I don't mind pushing the changes through him if he
> likes it more that way but I've felt that he's rather busy and this
> hopefully helps him a bit...

Any comments?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Jul_2009_16_08_52_+1000_6RLpPKsWj/mxvhZy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkplW3QACgkQjjKRsyhoI8xb8wCgmSobJkeDAWqWFwN56YcmNbfJ
Yn8AoL21M9x7rpNcgOp7b/AZ2c0sco7J
=+J+J
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jul_2009_16_08_52_+1000_6RLpPKsWj/mxvhZy--
