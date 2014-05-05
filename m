From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/37] e2fsck: verify checksums after checking everything
 else
Date: Mon, 5 May 2014 15:56:47 -0700
Message-ID: <20140505225647.GJ8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231328.31890.34436.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021422080.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24669 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaEEW4y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 18:56:54 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021422080.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 02:32:11PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:13:28 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 10/37] e2fsck: verify checksums after checking ever=
ything else
> >=20
> > There's a particular problem with e2fsck's user interface where
> > checksum errors are concerned:  Fixing the first complaint about
> > a checksum problem results in the inode being cleared even if e2fsc=
k
> > could otherwise have recovered it.  While this mode is useful for
> > cleaning the remaining broken crud off the filesystem, we could at
> > least default to checking everything /else/ and only complaining ab=
out
> > the incorrect checksum if fsck finds nothing else wrong.
> >=20
> > So, plumb in a config option.  We default to "verify and checksum"
> > unless the user tell us otherwise.
>=20
> I wonder whether it would not be better to always check the checksum
> of an object because it might yield additional information.
>=20
> If the checksum is good and the object is somewhat broken that it's
> highly likely that we have a problem within a kernel (or possibly
> e2fsprogs if some other operations were performed)
>=20
> If the checksum is bad and the object is bad, then it's likely that
> the corruption happened outside of the file system code, in memory,
> on disk or in transfer.
>=20
> If checksum is bad and the object is good then it's trickier since it
> can be kernel metadata csum bug, unlucky silent corruption, or
> intentional change of the metadata.
>=20
> It's not huge amount of information we can get from it, but I think
> that it might be useful when dealing with corrupted file system.

Hm.  So right now, the object verification code works roughly like this=
:

A) Verify checksum, offer to zero object if strict_csums and csum failu=
re.
B) Check everything else and offer to fix broken things.
C) Verify checksum again; if !strict_csums and csum failure, offer to z=
ero the
   object.

Do you think that it would be helpful to users if e2fsck warned of chec=
ksum
verification failures during step (A) if strict_csums is set?  I think =
that
would help users (or us developers) to distinguish those three scenario=
s.
It wouldn't be difficult to make fix_problem() spit out the message.

--D
>=20
> Thanks!
> -Lukas
>=20
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  e2fsck/e2fsck.8.in      |   12 ++++++++++++
> >  e2fsck/e2fsck.conf.5.in |   20 ++++++++++++++++++++
> >  e2fsck/e2fsck.h         |    1 +
> >  e2fsck/problem.c        |   18 ++++++++++++++----
> >  e2fsck/problemP.h       |    1 +
> >  e2fsck/unix.c           |   11 +++++++++++
> >  6 files changed, 59 insertions(+), 4 deletions(-)
> >=20
> >=20
> > diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
> > index f5ed758..43ee063 100644
> > --- a/e2fsck/e2fsck.8.in
> > +++ b/e2fsck/e2fsck.8.in
> > @@ -207,6 +207,18 @@ option may prevent you from further manual dat=
a recovery.
> >  .BI nodiscard
> >  Do not attempt to discard free blocks and unused inode blocks. Thi=
s option is
> >  exactly the opposite of discard option. This is set as default.
> > +.TP
> > +.BI strict_csums
> > +Verify each metadata object's checksum before checking anything ot=
her fields
> > +in the metadata object.  If the verification fails, offer to clear=
 the item,
> > +also before checking any of the other fields.  This option causes =
e2fsck to
> > +favor throwing away broken objects over trying to salvage them.
> > +.TP
> > +.BI no_strict_csums
> > +Perform all regular checks of a metadata object and only verify th=
e checksum if
> > +no problems were found.  This option causes e2fsck to try to salva=
ge slightly
> > +damaged metadata objects, at the cost of spending processing time =
on recovering
> > +data.  This is set as the default.
> >  .RE
> >  .TP
> >  .B \-f
> > diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
> > index 9ebfbbf..a8219a8 100644
> > --- a/e2fsck/e2fsck.conf.5.in
> > +++ b/e2fsck/e2fsck.conf.5.in
> > @@ -222,6 +222,26 @@ If this boolean relation is true, e2fsck will =
run as if the option
> >  .B -v
> >  is always specified.  This will cause e2fsck to print some additio=
nal
> >  information at the end of each full file system check.
> > +.TP
> > +.I strict_csums
> > +If this boolean relation is true, e2fsck will run as if
> > +.B -E strict_csums
> > +is set.  This causes e2fsck to verify each metadata object's check=
sum before
> > +checking anything other fields in the metadata object.  If the ver=
ification
> > +fails, offer to clear the item, also before checking any of the ot=
her fields.
> > +This option causes e2fsck to favor throwing away broken objects ov=
er trying to
> > +salvage them.
> > +.IP
> > +If the boolean relation is false, e2fsck will run as if
> > +.B -E no_strict_csums
> > +is set.  In this case, e2fsck will perform all regular checks of a=
 metadata
> > +object and only verify the checksum if no problems were found.  Th=
is option
> > +causes e2fsck to try to salvage slightly damaged metadata objects,=
 at the cost
> > +of spending processing time on recovering data.
> > +.IP
> > +The default is for e2fsck to behave as if
> > +.B -E no_strict_csums
> > +is set.
> >  .SH THE [problems] STANZA
> >  Each tag in the
> >  .I [problems]=20
> > diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> > index dbd6ea8..d7a7be9 100644
> > --- a/e2fsck/e2fsck.h
> > +++ b/e2fsck/e2fsck.h
> > @@ -167,6 +167,7 @@ struct resource_track {
> >  #define E2F_OPT_FRAGCHECK	0x0800
> >  #define E2F_OPT_JOURNAL_ONLY	0x1000 /* only replay the journal */
> >  #define E2F_OPT_DISCARD		0x2000
> > +#define E2F_OPT_CSUM_FIRST	0x4000
> > =20
> >  /*
> >   * E2fsck flags
> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index 7f0ad6c..0999399 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -970,7 +970,7 @@ static struct e2fsck_problem problem_table[] =3D=
 {
> >  	/* inode checksum does not match inode */
> >  	{ PR_1_INODE_CSUM_INVALID,
> >  	  N_("@i %i checksum does not match @i.  "),
> > -	  PROMPT_CLEAR, PR_PREEN_OK },
> > +	  PROMPT_CLEAR, PR_PREEN_OK | PR_INITIAL_CSUM },
> > =20
> >  	/* inode passes checks, but checksum does not match inode */
> >  	{ PR_1_INODE_ONLY_CSUM_INVALID,
> > @@ -981,7 +981,7 @@ static struct e2fsck_problem problem_table[] =3D=
 {
> >  	{ PR_1_EXTENT_CSUM_INVALID,
> >  	  N_("@i %i extent block checksum does not match extent\n\t(logic=
al @b "
> >  	     "%c, @n physical @b %b, len %N)\n"),
> > -	  PROMPT_CLEAR, 0 },
> > +	  PROMPT_CLEAR, PR_INITIAL_CSUM },
> > =20
> >  	/*
> >  	 * Inode extent block passes checks, but checksum does not match
> > @@ -996,7 +996,7 @@ static struct e2fsck_problem problem_table[] =3D=
 {
> >  	{ PR_1_EA_BLOCK_CSUM_INVALID,
> >  	  N_("Extended attribute @a @b %b checksum for @i %i does not "
> >  	     "match.  "),
> > -	  PROMPT_CLEAR, 0 },
> > +	  PROMPT_CLEAR, PR_INITIAL_CSUM },
> > =20
> >  	/*
> >  	 * Extended attribute block passes checks, but checksum for inode=
 does
> > @@ -1470,7 +1470,7 @@ static struct e2fsck_problem problem_table[] =
=3D {
> >  	/* leaf node fails checksum */
> >  	{ PR_2_LEAF_NODE_CSUM_INVALID,
> >  	  N_("@d @i %i, %B, offset %N: @d fails checksum\n"),
> > -	  PROMPT_SALVAGE, PR_PREEN_OK },
> > +	  PROMPT_SALVAGE, PR_PREEN_OK | PR_INITIAL_CSUM },
> > =20
> >  	/* leaf node has no checksum */
> >  	{ PR_2_LEAF_NODE_MISSING_CSUM,
> > @@ -1944,6 +1944,16 @@ int fix_problem(e2fsck_t ctx, problem_t code=
, struct problem_context *pctx)
> >  		printf(_("Unhandled error code (0x%x)!\n"), code);
> >  		return 0;
> >  	}
> > +
> > +	/*
> > +	 * If there is a problem with the initial csum verification and t=
he
> > +	 * user told e2fsck to verify csums /after/ checking everything e=
lse,
> > +	 * then don't "fix" anything.
> > +	 */
> > +	if ((ptr->flags & PR_INITIAL_CSUM) &&
> > +	    !(ctx->options & E2F_OPT_CSUM_FIRST))
> > +		return 0;
> > +
> >  	if (!(ptr->flags & PR_CONFIG)) {
> >  		char	key[9], *new_desc =3D NULL;
> > =20
> > diff --git a/e2fsck/problemP.h b/e2fsck/problemP.h
> > index 7944cd6..a983598 100644
> > --- a/e2fsck/problemP.h
> > +++ b/e2fsck/problemP.h
> > @@ -44,3 +44,4 @@ struct latch_descr {
> >  #define PR_CONFIG	0x080000 /* This problem has been customized
> >  				    from the config file */
> >  #define PR_FORCE_NO	0x100000 /* Force the answer to be no */
> > +#define PR_INITIAL_CSUM	0x200000 /* User can ignore initial csum c=
heck */
> > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > index b39383d..c6cdb49 100644
> > --- a/e2fsck/unix.c
> > +++ b/e2fsck/unix.c
> > @@ -692,6 +692,10 @@ static void parse_extended_opts(e2fsck_t ctx, =
const char *opts)
> >  			else
> >  				ctx->log_fn =3D string_copy(ctx, arg, 0);
> >  			continue;
> > +		} else if (strcmp(token, "strict_csums") =3D=3D 0) {
> > +			ctx->options |=3D E2F_OPT_CSUM_FIRST;
> > +		} else if (strcmp(token, "no_strict_csums") =3D=3D 0) {
> > +			ctx->options &=3D ~E2F_OPT_CSUM_FIRST;
> >  		} else {
> >  			fprintf(stderr, _("Unknown extended option: %s\n"),
> >  				token);
> > @@ -710,6 +714,8 @@ static void parse_extended_opts(e2fsck_t ctx, c=
onst char *opts)
> >  		fputs(("\tjournal_only\n"), stderr);
> >  		fputs(("\tdiscard\n"), stderr);
> >  		fputs(("\tnodiscard\n"), stderr);
> > +		fputs(("\tstrict_csums\n"), stderr);
> > +		fputs(("\tno_strict_csums\n"), stderr);
> >  		fputc('\n', stderr);
> >  		exit(1);
> >  	}
> > @@ -945,6 +951,11 @@ static errcode_t PRS(int argc, char *argv[], e=
2fsck_t *ret_ctx)
> >  	profile_set_syntax_err_cb(syntax_err_report);
> >  	profile_init(config_fn, &ctx->profile);
> > =20
> > +	profile_get_boolean(ctx->profile, "options", "strict_csums", NULL=
,
> > +			    0, &c);
> > +	if (c)
> > +		ctx->options |=3D E2F_OPT_CSUM_FIRST;
> > +
> >  	profile_get_boolean(ctx->profile, "options", "report_time", 0, 0,
> >  			    &c);
> >  	if (c)
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
