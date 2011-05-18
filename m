From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal
 routines to specify if its ok to fail the journal transaction allocation.
Date: Wed, 18 May 2011 10:09:30 +0200
Message-ID: <20110518080930.GC25632@quack.suse.cz>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
 <20110511155447.GH5057@quack.suse.cz>
 <BANLkTikP3axXkZ=v8EbpbzyoeSeARZC_Ew@mail.gmail.com>
 <20110516155138.GI5344@quack.suse.cz>
 <BANLkTinsJeiprc64Q8BE5498osJmm6npsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1ERIJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 04:09:52 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinsJeiprc64Q8BE5498osJmm6npsg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 17-05-11 23:38:05, Manish Katiyar wrote:
> On Mon, May 16, 2011 at 8:51 AM, Jan Kara <jack@suse.cz> wrote:
> > =A0Hello,
> >
> > On Thu 12-05-11 23:37:05, Manish Katiyar wrote:
> >> On Wed, May 11, 2011 at 8:54 AM, Jan Kara <jack@suse.cz> wrote:
> >> > =A0Hi,
> >> >
> >> > =A0sorry I got to your patches with a delay. One general note - =
please do
> >> > not attach patches. It is enough to have them in the email...
> >> >
> >> > On Sun 24-04-11 17:10:41, Manish Katiyar wrote:
> >> >> Pass extra bool parameter in journal routines to specify if its=
 ok to
> >> >> fail the journal transaction allocation. If 'true' is passed
> >> >> transaction allocation is done through GFP_KERNEL =A0and ENOMEM=
 is
> >> >> returned else GFP_NOFS is used.
> >> > =A0Please, do not mix error handling with gfp masks. Instead jus=
t rename
> >> > jbd2__journal_start() to jbd2_journal_start() and change gfp_mas=
k parameter
> >> > to "bool errok".
> >>
> >> ok.
> >>
> >> > Use GFP_NOFS gfp mask for start_this_handle().
> >> I think I didn't completely understand this line. You meant passin=
g
> >> GFP_KERNEL or GFP_NOFS based on errok right ?
> > =A0No, I meant passing GFP_NOFS always. Currently, GFP_NOFS is used=
 in all
> > the cases (noone uses GFP_KERNEL variant) and GFP_KERNEL can really=
 be used
> > only when we do not hold other filesystem locks (as GFP_KERNEL allo=
cation
> > can recurse back into filesystem to reclaim memory). So using GFP_K=
ERNEL
> > would need more auditting and is a separate issue anyway.
>=20
> Hi Jan,
>=20
> How about this ? As suggested I have removed special handlers for
> ocfs2, always pass false as default for allocation and have removed
> jbd2__journal_start and collapsed it in jbd2_journal_start.
>=20
>=20
> Pass extra bool parameter in journal routines to specify if its ok to
> fail the journal transaction allocation.  Update ocfs2 and ext4 routi=
nes to
> pass false for the updated journal interface.
  Yes, now the patch looks good! Thanks. Just one nit below:

>=20
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/ext4_jbd2.h   |    2 +-
>  fs/ext4/super.c       |    3 ++-
>  fs/jbd2/transaction.c |   24 +++++-------------------
>  fs/ocfs2/journal.c    |    6 +++---
>  include/linux/jbd2.h  |    6 ++----
>  5 files changed, 13 insertions(+), 28 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..c165ffe 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -279,9 +279,10 @@ handle_t *ext4_journal_start_sb(struct
> super_block *sb, int nblocks)
>  		ext4_abort(sb, "Detected aborted journal");
>  		return ERR_PTR(-EROFS);
>  	}
> -	return jbd2_journal_start(journal, nblocks);
> +	return jbd2_journal_start(journal, nblocks, false);
>  }
>=20
> +
  This empty line was added by accident.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
