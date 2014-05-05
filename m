From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
 message
Date: Mon, 5 May 2014 16:08:29 -0700
Message-ID: <20140505230829.GK8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231334.31890.49878.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021445200.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28860 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbaEEXIf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 19:08:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021445200.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 02:46:56PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:13:34 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 11/37] e2fsck: fix the extended attribute checksum =
error
> >     message
> >=20
> > Make the "EA block passes checks but fails checksum" message less
> > strange.
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  e2fsck/problem.c |   12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> >=20
> >=20
> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index 0999399..ec20bd1 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -992,19 +992,17 @@ static struct e2fsck_problem problem_table[] =
=3D {
> >  	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
> >  	  PROMPT_FIX, 0 },
> > =20
> > -	/* Extended attribute block checksum for inode does not match. */
> > +	/* Extended attribute block checksum does not match. */
>=20
> The "for inode" is still there in the message, so I do not think
> there is a reason to remove it from the comment.

Oops.

> >  	{ PR_1_EA_BLOCK_CSUM_INVALID,
> > -	  N_("Extended attribute @a @b %b checksum for @i %i does not "
> > -	     "match.  "),
> > +	  N_("@a @b %b checksum for @i %i does not match.  "),
> >  	  PROMPT_CLEAR, PR_INITIAL_CSUM },
> > =20
> >  	/*
> > -	 * Extended attribute block passes checks, but checksum for inode=
 does
> > -	 * not match.
> > +	 * Extended attribute block passes checks, but checksum does not
> > +	 * match.
> >  	 */
> >  	{ PR_1_EA_BLOCK_ONLY_CSUM_INVALID,
> > -	  N_("Extended attribute @a @b %b passes checks, but checksum for=
 "
> > -	     "@i %i does not match.  "),
> > +	  N_("@a @b %b passes checks, but checksum does not match.  "),
>=20
> Is there a reason to remove the inode number from the message ?

=46or whatever reason, I was confused by this message and thought it wa=
s
referring to a checksum failure in the inode itself.  On the other hand=
, it's
helpful to map an EA block back to an inode, so perhaps the message sho=
uld be
changed to:

"Inode XXX's extended attribute block YYY passes checks, but checksum d=
oes not
match."

Now that I look at the other metadata_csum checks, the failure message =
starts
with "@i %i..." so these two might as well follow the convention.  Sorr=
y that I
seem to have strayed from it.

--D
>=20
> Thanks!
> -Lukas
>=20
> >  	  PROMPT_FIX, 0 },
> > =20
> >  	/*
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
