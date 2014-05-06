From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/37] debugfs: force logdump to display (old) journal
 contents
Date: Mon, 5 May 2014 17:24:53 -0700
Message-ID: <20140506002453.GN8434@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231302.31890.45397.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021346570.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49457 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbaEFAZG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 20:25:06 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021346570.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 01:49:37PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:13:02 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 06/37] debugfs: force logdump to display (old) jour=
nal
> >     contents
> >=20
> > If the user passes -a more than once to logdump, try to dump old lo=
g
> > contents.  This can be used to try to track down journal problems e=
ven
> > after recovery.
>=20
> You need to update man page as well for this. Also I wonder what's
> the behaviour if '-a' and '-b' or '-c' are specified simultaneously
> and '-a' is specified multiple times ?

I'll update the manpage.  -c seems to hexdump the contents of any block=
 that we
find while iterating the journal.  -b would seem to allow you to dump a=
n
arbitrary block #, but I could never get it to do that.

In any case, specifying -a even once will make logdump dump every block=
 and
ignore -b.

--D
>=20
> Thanks!
> -Lukas
>=20
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  debugfs/logdump.c |   11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> >=20
> > diff --git a/debugfs/logdump.c b/debugfs/logdump.c
> > index 8b9dc5b..bf4bef5 100644
> > --- a/debugfs/logdump.c
> > +++ b/debugfs/logdump.c
> > @@ -393,9 +393,13 @@ static void dump_journal(char *cmdname, FILE *=
out_file,
> >  	fprintf(out_file, "Journal starts at block %u, transaction %u\n",
> >  		blocknr, transaction);
> > =20
> > -	if (!blocknr)
> > +	if (!blocknr) {
> >  		/* Empty journal, nothing to do. */
> > -		return;
> > +		if (dump_all < 2)
> > +			return;
> > +		else
> > +			blocknr =3D 1;
> > +	}
> > =20
> >  	while (1) {
> >  		retval =3D read_journal_block(cmdname, source,
> > @@ -420,7 +424,8 @@ static void dump_journal(char *cmdname, FILE *o=
ut_file,
> >  			fprintf (out_file, "Found sequence %u (not %u) at "
> >  				 "block %u: end of journal.\n",
> >  				 sequence, transaction, blocknr);
> > -			return;
> > +			if (dump_all < 2)
> > +				return;
> >  		}
> > =20
> >  		if (dump_descriptors) {
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
