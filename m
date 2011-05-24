From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] ext4 : Update low level ext4 journal routines to
 specify gfp_mask for transaction allocation.
Date: Tue, 24 May 2011 12:13:46 +0200
Message-ID: <20110524101346.GA5390@quack.suse.cz>
References: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com>
 <20110511160447.GJ5057@quack.suse.cz>
 <BANLkTimEpNq5L3p2UsByTMEYG2G2ORA0dw@mail.gmail.com>
 <20110523164123.GF4716@quack.suse.cz>
 <BANLkTimNK8RWxz7699EdUdbWxYJvjhmerQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1EXKNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 06:13:49 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTimNK8RWxz7699EdUdbWxYJvjhmerQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-05-11 01:08:44, Manish Katiyar wrote:
> >> @@ -449,7 +448,8 @@ ext4_xattr_set_acl(struct dentry *dentry, cons=
t
> >> char *name, const void *value,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;
> >>
> >> =A0retry:
> >> - =A0 =A0 handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLO=
CKS(inode->i_sb));
> >> + =A0 =A0 handle =3D ext4_journal_start_failok(inode,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> >> =A0 =A0 =A0 if (IS_ERR(handle))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
> >> =A0 =A0 =A0 error =3D ext4_set_acl(handle, inode, type, acl);
> > =A0This change is OK. But looking at the code there, we should rath=
er do
> > if (IS_ERR(handle)) {
> > =A0 =A0 =A0 =A0error =3D PTR_ERR(handle);
> > =A0 =A0 =A0 =A0goto release_and_out;
> > }
> > =A0Can you please include this change in your other patch fixing AC=
L error
> > handling? Thanks.
>=20
> I already had fixed this as part of the earlier ACL patch that I
> posted, so didn't fix it here.
  I see but you should base this patch on top of all previous ones in t=
he
series.

> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index f2fa5e8..f7b2d4d 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -3523,7 +3523,7 @@ retry:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Credits for sb + inode write */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 2);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start_failok(ino=
de, 2);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is really bad =
luck. We've written the data
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but cannot extend=
 i_size. Bail out and pretend
> > =A0Here we shouldn't fail because that will leave blocks outside EO=
=46
> > allocated. So just leave there original ext4_journal_start().
>=20
> ohh okie... Actually for one of the similar patches earlier, you had
> suggested that it can fail, so I followed the same. Will change it to
> nofail version.
  Hmm, maybe I was wrong back then. Or wasn't it a different place?

> >> @@ -338,7 +340,7 @@ handle_t *jbd2_journal_start(journal_t *journa=
l,
> >> int nblocks, bool errok)
> >>
> >> =A0 =A0 =A0 current->journal_info =3D handle;
> >>
> >> - =A0 =A0 err =3D start_this_handle(journal, handle, GFP_NOFS);
> >> + =A0 =A0 err =3D start_this_handle(journal, handle, errok ? GFP_K=
ERNEL : GFP_NOFS);
> >> =A0 =A0 =A0 if (err < 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_handle(handle);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 current->journal_info =3D NULL;
> > =A0This is probably just a leftover from some previous version?
>=20
> Actually no. I added this as part of this patch. So do I actually
> switch the gfp_mask in the last patch of the series ?
  I guess we still misunderstand about the gfp_mask :) No misuse of gfp
mask to mean whether an allocation can fail or not in any layer! If we =
need
to pass that information, use a separate parameter. Change all transact=
ion
/ handle allocation gfp masks to GFP_NOFS if they are different (thus
there's no real need to pass the gfp mask). Clear now?

If something of the above is not yet done, do it in the patch where you
remove jbd2__journal_start().

									Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
