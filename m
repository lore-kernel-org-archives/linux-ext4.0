From: "Michael B. Trausch" <mbt@zest.trausch.us>
Subject: Well, I wasn't fast enough on the snapshot...
Date: Tue, 28 Apr 2009 22:51:11 -0400
Message-ID: <20090428225111.3bc7fb70@zest.trausch.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cHoISI6FGFQnhfEKeLLctD.";
 protocol="application/pgp-signature"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-15-213-186-BusName-Atlanta.hfc.comcastbusiness.net ([173.15.213.186]:49105
	"EHLO zest.trausch.us" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZD2CvW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 22:51:22 -0400
Received: from zest.trausch.us (unknown [IPv6:::1])
	by zest.trausch.us (Postfix) with ESMTPS id 8E137362B
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 22:51:19 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/cHoISI6FGFQnhfEKeLLctD.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I had sent something and forgot to send it to the list, and then before
I went to re-send it, I thought I'd take a look at an idea that I had.
As best as I can tell, I either didn't yank the filesystem offline
quickly enough, or I must have let some other activity I didn't
anticipate (maybe a journal replay) occur.

Whatever the cause, it would appear that at least the =C3=BCber-important
files that I needed (the history database packs) to make the recovery
possible in the first are more than slightly overwritten with totally
unrelated garbage.  Without them being completely intact, of course,
they are useless, so I did in fact lose a week of work.

Ugh.

All of this said, I remember reading about an undelete mode being
proposed for ext4.  Are there still plans to implement that in ext4 (or
an extension to it) at some point in the future?  It would be kind of
nice to be able to have an assurance that you'd be able to recover
something you _just_ deleted (FSVO "just", of course).  Maybe not quite
freeing up blocks until a certain amount of time has passed or some
other constraint, like space, is hit.  I don't know if that is at all
plausible or not, just my uneducated attempt at an idea---but in any
case, something like that would be kind of nice to have.  I haven't
shot myself in the foot like this in years... but as I recall, last
time I did, I lost more work than this time.

At least I have the current state of the working trees.  Their history
is just gone.  Oh, well.

Thanks for all the comments and ideas!

	--- Mike

--=20
Don't wait until you have a bug to step through your code.
                            --- Steve Maguire

--Sig_/cHoISI6FGFQnhfEKeLLctD.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn3wKAACgkQ0kE/IBnFmjByjgCbBlgsJb2BUmjlJPv1wU7mpUfa
pncAn2tF3bBtNjFKsCzVLR565OuN1eLb
=/yis
-----END PGP SIGNATURE-----

--Sig_/cHoISI6FGFQnhfEKeLLctD.--
