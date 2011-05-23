From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] ext4 : Update low level ext4 journal routines to
 specify gfp_mask for transaction allocation.
Date: Mon, 23 May 2011 18:41:23 +0200
Message-ID: <20110523164123.GF4716@quack.suse.cz>
References: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com>
 <20110511160447.GJ5057@quack.suse.cz>
 <BANLkTimEpNq5L3p2UsByTMEYG2G2ORA0dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1EWQlZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 12:41:25 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTimEpNq5L3p2UsByTMEYG2G2ORA0dw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 21-05-11 19:43:10, Manish Katiyar wrote:
> On Wed, May 11, 2011 at 9:04 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sun 24-04-11 17:13:18, Manish Katiyar wrote:
> >> Update low level ext4 journal routines to pass an extra parameter
> >> to journal allocation routines to specify whether transaction allo=
cation
> >> can fail or not. With this patch ext4_journal_start() can fail due=
 to
> >> ENOMEM. Added a new interface ext4_journal_start_tryhard() which i=
sn't
> >> supposed to fail and keep retrying till the allocation succeeds.
> > =A0As I wrote in a comment in the comment to the first patch, first=
 just
> > make ext4_journal_start_sb() and similar functions pass false as a =
part of
> > the first patch.
> >
> > Then it would be better to create a new function that passes true -=
 the
> > name does not really matter since it will be removed later in the s=
eries
> > but it will help the review process. You can call it
> > ext4_journal_start_sb_enomem() or whatever. This way we keep backwa=
rd
> > compatibility because currently all call sites really expect the re=
try
> > behavior.
>=20
> Hi Jan,
>=20
> Here is the updated patch incorporating your comments. This adds a ne=
w
> function ext4_journal_start_failok and updates the ext4 code where we
> can fail.
>=20
> This patch adds a new wrapper ext4_journal_start_failok() which
> can fail with -ENOMEM. Update the ext4 code with this, where callers
> are ok failing the transaction start.
  Thanks. My comments are below.

> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/acl.c         |    6 +++---
>  fs/ext4/ext4_jbd2.h   |   10 +++++++++-
>  fs/ext4/extents.c     |    2 +-
>  fs/ext4/inode.c       |   19 +++++++++++--------
>  fs/ext4/ioctl.c       |    4 ++--
>  fs/ext4/migrate.c     |    4 ++--
>  fs/ext4/move_extent.c |    2 +-
>  fs/ext4/namei.c       |   23 +++++++++++++++--------
>  fs/ext4/super.c       |   17 ++++++++++++++---
>  fs/ext4/xattr.c       |    3 ++-
>  fs/jbd2/transaction.c |    4 +++-
>  11 files changed, 63 insertions(+), 31 deletions(-)
>=20
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 21eacd7..cdb1f51 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -350,11 +350,10 @@ ext4_acl_chmod(struct inode *inode)
>  		int retries =3D 0;
>=20
>  	retry:
> -		handle =3D ext4_journal_start(inode,
> +		handle =3D ext4_journal_start_failok(inode,
>  				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
>  		if (IS_ERR(handle)) {
>  			error =3D PTR_ERR(handle);
> -			ext4_std_error(inode->i_sb, error);
  Here, you should rather do
if (error !=3D ENOMEM)
	ext4_std_error(inode->i_sb, error);
  We probably want to know about EIO (which is the other realistic erro=
r).

> @@ -449,7 +448,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const
> char *name, const void *value,
>  		acl =3D NULL;
>=20
>  retry:
> -	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->=
i_sb));
> +	handle =3D ext4_journal_start_failok(inode,
> +					   EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  	error =3D ext4_set_acl(handle, inode, type, acl);
  This change is OK. But looking at the code there, we should rather do
if (IS_ERR(handle)) {
	error =3D PTR_ERR(handle);
	goto release_and_out;
}
  Can you please include this change in your other patch fixing ACL err=
or
handling? Thanks.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f2fa5e8..f7b2d4d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3523,7 +3523,7 @@ retry:
>  		int err;
>=20
>  		/* Credits for sb + inode write */
> -		handle =3D ext4_journal_start(inode, 2);
> +		handle =3D ext4_journal_start_failok(inode, 2);
>  		if (IS_ERR(handle)) {
>  			/* This is really bad luck. We've written the data
>  			 * but cannot extend i_size. Bail out and pretend
  Here we shouldn't fail because that will leave blocks outside EOF
allocated. So just leave there original ext4_journal_start().

> @@ -5371,7 +5372,9 @@ int ext4_setattr(struct dentry *dentry, struct
> iattr *attr)
>  		rc =3D ext4_acl_chmod(inode);
>=20
>  err_out:
> -	ext4_std_error(inode->i_sb, error);
> +	if (error !=3D -ENOMEM) {
> +		ext4_std_error(inode->i_sb, error);
> +	}
  No need for braces here...

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 92816b4..8870746 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -533,7 +533,7 @@ int ext4_ext_migrate(struct inode *inode)
>  	ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
>  	up_read((&EXT4_I(inode)->i_data_sem));
>=20
> -	handle =3D ext4_journal_start(inode, 1);
> +	handle =3D ext4_journal_start_failok(inode, 1);
>  	if (IS_ERR(handle)) {
>  		/*
>  		 * It is impossible to update on-disk structures without
  Here we should better not fail because we have inode on orphan list a=
nd
need to eventually remove it. So just keep old ext4_journal_start().

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4e4c17f..2d57a57 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
>   * ext4 prevents a new handle from being started by s_frozen, which
>   * is in an upper layer.
>   */
> -handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> +static handle_t *ext4_journal_start_sb_int(struct super_block *sb,
> +				    	   int nblocks, bool errok)
  Maybe __ext4_journal_start_sb() would be a more usual name...

> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index b5c2550..3453c29 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -308,6 +308,8 @@ static handle_t *new_handle(int nblocks)
>   * handle_t *jbd2_journal_start() - Obtain a new handle.
>   * @journal: Journal to start transaction on.
>   * @nblocks: number of block buffer we might modify
> + * @errok : True if the transaction allocation can fail
> + *          with ENOMEM.
>   *
>   * We make sure that the transaction can guarantee at least nblocks =
of
>   * modified buffers in the log.  We block until the log can guarante=
e
  Move this to the patch adding the parameter...

> @@ -338,7 +340,7 @@ handle_t *jbd2_journal_start(journal_t *journal,
> int nblocks, bool errok)
>=20
>  	current->journal_info =3D handle;
>=20
> -	err =3D start_this_handle(journal, handle, GFP_NOFS);
> +	err =3D start_this_handle(journal, handle, errok ? GFP_KERNEL : GFP=
_NOFS);
>  	if (err < 0) {
>  		jbd2_free_handle(handle);
>  		current->journal_info =3D NULL;
  This is probably just a leftover from some previous version?

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
