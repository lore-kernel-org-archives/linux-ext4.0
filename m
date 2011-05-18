From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal
 routines to specify if its ok to fail the journal transaction allocation.
Date: Wed, 18 May 2011 14:44:47 +0200
Message-ID: <20110518124447.GH25632@quack.suse.cz>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
 <20110511155447.GH5057@quack.suse.cz>
 <BANLkTikP3axXkZ=v8EbpbzyoeSeARZC_Ew@mail.gmail.com>
 <20110516155138.GI5344@quack.suse.cz>
 <BANLkTinsJeiprc64Q8BE5498osJmm6npsg@mail.gmail.com>
 <20110518080930.GC25632@quack.suse.cz>
 <BANLkTim62Kc8gTjsiJG3Fq=MWW9wFJ8xnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933074Ab1ERMpJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 08:45:09 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTim62Kc8gTjsiJG3Fq=MWW9wFJ8xnQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-05-11 01:36:48, Manish Katiyar wrote:
> On Wed, May 18, 2011 at 1:09 AM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 17-05-11 23:38:05, Manish Katiyar wrote:
> >> On Mon, May 16, 2011 at 8:51 AM, Jan Kara <jack@suse.cz> wrote:
> >> > =A0Hello,
> >> >
> >> > On Thu 12-05-11 23:37:05, Manish Katiyar wrote:
> >> >> On Wed, May 11, 2011 at 8:54 AM, Jan Kara <jack@suse.cz> wrote:
> >> >> > =A0Hi,
> >> >> >
> >> >> > =A0sorry I got to your patches with a delay. One general note=
 - please do
> >> >> > not attach patches. It is enough to have them in the email...
> >> >> >
> >> >> > On Sun 24-04-11 17:10:41, Manish Katiyar wrote:
> >> >> >> Pass extra bool parameter in journal routines to specify if =
its ok to
> >> >> >> fail the journal transaction allocation. If 'true' is passed
> >> >> >> transaction allocation is done through GFP_KERNEL =A0and ENO=
MEM is
> >> >> >> returned else GFP_NOFS is used.
> >> >> > =A0Please, do not mix error handling with gfp masks. Instead =
just rename
> >> >> > jbd2__journal_start() to jbd2_journal_start() and change gfp_=
mask parameter
> >> >> > to "bool errok".
> >> >>
> >> >> ok.
> >> >>
> >> >> > Use GFP_NOFS gfp mask for start_this_handle().
> >> >> I think I didn't completely understand this line. You meant pas=
sing
> >> >> GFP_KERNEL or GFP_NOFS based on errok right ?
> >> > =A0No, I meant passing GFP_NOFS always. Currently, GFP_NOFS is u=
sed in all
> >> > the cases (noone uses GFP_KERNEL variant) and GFP_KERNEL can rea=
lly be used
> >> > only when we do not hold other filesystem locks (as GFP_KERNEL a=
llocation
> >> > can recurse back into filesystem to reclaim memory). So using GF=
P_KERNEL
> >> > would need more auditting and is a separate issue anyway.
> >>
> >> Hi Jan,
> >>
> >> How about this ? As suggested I have removed special handlers for
> >> ocfs2, always pass false as default for allocation and have remove=
d
> >> jbd2__journal_start and collapsed it in jbd2_journal_start.
> >>
> >>
> >> Pass extra bool parameter in journal routines to specify if its ok=
 to
> >> fail the journal transaction allocation. =A0Update ocfs2 and ext4 =
routines to
> >> pass false for the updated journal interface.
> > =A0Yes, now the patch looks good! Thanks. Just one nit below:
>=20
> Thanks a lot. Fixed the newline issue. Here is the updated diff.
>=20
> Pass extra bool parameter in journal routines to specify if its ok to
> fail the journal transaction allocation.  Update ocfs2 and ext4 routi=
nes to
> pass false for the updated journal interface.
  The patch look good now. You can add:
Acked-by: Jan Kara <jack@suse.cz>

									Honza

> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/ext4_jbd2.h   |    2 +-
>  fs/ext4/super.c       |    2 +-
>  fs/jbd2/transaction.c |   24 +++++-------------------
>  fs/ocfs2/journal.c    |    6 +++---
>  include/linux/jbd2.h  |    6 ++----
>  5 files changed, 12 insertions(+), 28 deletions(-)
>=20
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d0f5353..0abee1b 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -225,7 +225,7 @@ static inline int ext4_journal_extend(handle_t
> *handle, int nblocks)
>  static inline int ext4_journal_restart(handle_t *handle, int nblocks=
)
>  {
>  	if (ext4_handle_valid(handle))
> -		return jbd2_journal_restart(handle, nblocks);
> +		return jbd2_journal_restart(handle, nblocks, false);
>  	return 0;
>  }
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8553dfb..4e4c17f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -279,7 +279,7 @@ handle_t *ext4_journal_start_sb(struct super_bloc=
k
> *sb, int nblocks)
>  		ext4_abort(sb, "Detected aborted journal");
>  		return ERR_PTR(-EROFS);
>  	}
> -	return jbd2_journal_start(journal, nblocks);
> +	return jbd2_journal_start(journal, nblocks, false);
>  }
>=20
>  /*
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..b5c2550 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -318,7 +318,7 @@ static handle_t *new_handle(int nblocks)
>   *
>   * Return a pointer to a newly allocated handle, or NULL on failure
>   */
> -handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int g=
fp_mask)
> +handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool e=
rrok)
>  {
>  	handle_t *handle =3D journal_current_handle();
>  	int err;
> @@ -338,7 +338,7 @@ handle_t *jbd2__journal_start(journal_t *journal,
> int nblocks, int gfp_mask)
>=20
>  	current->journal_info =3D handle;
>=20
> -	err =3D start_this_handle(journal, handle, gfp_mask);
> +	err =3D start_this_handle(journal, handle, GFP_NOFS);
>  	if (err < 0) {
>  		jbd2_free_handle(handle);
>  		current->journal_info =3D NULL;
> @@ -346,13 +346,6 @@ handle_t *jbd2__journal_start(journal_t *journal=
,
> int nblocks, int gfp_mask)
>  	}
>  	return handle;
>  }
> -EXPORT_SYMBOL(jbd2__journal_start);
> -
> -
> -handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
> -{
> -	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
> -}
>  EXPORT_SYMBOL(jbd2_journal_start);
>=20
>=20
> @@ -441,7 +434,7 @@ out:
>   * transaction capabable of guaranteeing the requested number of
>   * credits.
>   */
> -int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mas=
k)
> +int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
>  {
>  	transaction_t *transaction =3D handle->h_transaction;
>  	journal_t *journal =3D transaction->t_journal;
> @@ -477,16 +470,9 @@ int jbd2__journal_restart(handle_t *handle, int
> nblocks, int gfp_mask)
>=20
>  	lock_map_release(&handle->h_lockdep_map);
>  	handle->h_buffer_credits =3D nblocks;
> -	ret =3D start_this_handle(journal, handle, gfp_mask);
> +	ret =3D start_this_handle(journal, handle, GFP_NOFS);
>  	return ret;
>  }
> -EXPORT_SYMBOL(jbd2__journal_restart);
> -
> -
> -int jbd2_journal_restart(handle_t *handle, int nblocks)
> -{
> -	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
> -}
>  EXPORT_SYMBOL(jbd2_journal_restart);
>=20
>  /**
> @@ -1436,7 +1422,7 @@ int jbd2_journal_force_commit(journal_t *journa=
l)
>  	handle_t *handle;
>  	int ret;
>=20
> -	handle =3D jbd2_journal_start(journal, 1);
> +	handle =3D jbd2_journal_start(journal, 1, false);
>  	if (IS_ERR(handle)) {
>  		ret =3D PTR_ERR(handle);
>  	} else {
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index b141a44..cca0f76 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -353,11 +353,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super
> *osb, int max_buffs)
>=20
>  	/* Nested transaction? Just return the handle... */
>  	if (journal_current_handle())
> -		return jbd2_journal_start(journal, max_buffs);
> +		return jbd2_journal_start(journal, max_buffs, false);
>=20
>  	down_read(&osb->journal->j_trans_barrier);
>=20
> -	handle =3D jbd2_journal_start(journal, max_buffs);
> +	handle =3D jbd2_journal_start(journal, max_buffs, false);
>  	if (IS_ERR(handle)) {
>  		up_read(&osb->journal->j_trans_barrier);
>=20
> @@ -438,7 +438,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblo=
cks)
>  	if (status > 0) {
>  		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
>  		status =3D jbd2_journal_restart(handle,
> -					      old_nblocks + nblocks);
> +					      old_nblocks + nblocks, false);
>  		if (status < 0) {
>  			mlog_errno(status);
>  			goto bail;
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index a32dcae..67f0f4f 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1103,10 +1103,8 @@ static inline handle_t *journal_current_handle=
(void)
>   * Register buffer modifications against the current transaction.
>   */
>=20
> -extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
> -extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int g=
fp_mask);
> -extern int	 jbd2_journal_restart(handle_t *, int nblocks);
> -extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_m=
ask);
> +extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool e=
rrok);
> +extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok=
);
>  extern int	 jbd2_journal_extend (handle_t *, int nblocks);
>  extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_=
head *);
>  extern int	 jbd2_journal_get_create_access (handle_t *, struct buffe=
r_head *);
> --=20
> 1.7.4.1
>=20
> --=20
> Thanks -
> Manish
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
