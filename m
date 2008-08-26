From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Large EAs in ext4
Date: Mon, 25 Aug 2008 17:12:25 -0700
Message-ID: <1219709545.6394.45.camel@mingming-laptop>
References: <1219680023.31999.30.camel@localhost>
	 <20080825224736.GZ3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kalpak Shah <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35754 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbYHZAMr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2008 20:12:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7Q0FA1b028531
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 20:15:10 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7Q0CPXY212520
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 20:12:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7Q0COeH009515
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 20:12:24 -0400
In-Reply-To: <20080825224736.GZ3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-25=E4=B8=80=E7=9A=84 16:47 -0600=EF=BC=8CAndreas Dilg=
er=E5=86=99=E9=81=93=EF=BC=9A
> On Aug 25, 2008  21:30 +0530, Kalpak Shah wrote:
> > This is the implementation for large EA support in ext4. Note that =
this
> > also helps to have a larger number of EAs since large EAs get writt=
en
> > out to a new inode instead of the EA block.
> >=20
> > If value of an attribute is greater than 2048 bytes the value is no=
t
> > saved in the external EA block, instead it is saved in an inode.
>=20
> I just realized that this needs to be (blocksize / 2) instead of 2048=
,
> or we will never get the EA inodes in case of 1kB/2kB block filesyste=
m
> where we need it the most.
>=20
> > +struct  inode *ext4_xattr_inode_iget(struct inode *parent, int ea_=
ino, int *err)
>          ^^ extra space here
>=20
> > +	if (ea_inode->i_mtime.tv_sec !=3D parent->i_ino ||
>=20
> Do you think it makes sense to "#define i_xattr_inode_parent i_mtime.=
tv_sec"
> in case there is a decision to change which field is used?  Or do peo=
ple
> think that is more confusing than helpful?
>=20
> Note to readers that this is a new patch, and Lustre doesn't use it y=
et,
> but we'd like to in the relatively near future so feedback that affec=
ts
> the on disk format is preferred sooner than later.
>=20
> > +ext4_xattr_inode_set(handle_t *handle, struct inode *inode, int *e=
a_ino,
> > +		     const void *value, size_t value_len)
> > +{
> > +	/*
> > +	 * Make sure that enough buffer credits are available else extend=
 the
> > +	 * transaction.
> > +	 */
> > +	req_buffer_credits =3D (value_len / inode->i_sb->s_blocksize) + 4=
;
>=20
> Can you please explain in the comment what the "+ 4" blocks are?
> I suspect this will not be enough if the xattr is large, it should ju=
st
> use one of the standard "transaction size" helper functions to determ=
ine
> metadata size.
>=20

ext4_meta_trans_blocks() will gives the metadata size, which also
account for block group bitmap and block group descriptor blocks,
superblock, inode block.

also here

> @@ -1059,10 +1352,23 @@ ext4_xattr_set(struct inode *inode, int=20
>                const void *value, size_t value_len, int flags)
>  {
>         handle_t *handle;
> +       int buffer_credits;
>         int error, retries =3D 0;

> +       buffer_credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> +       if ((value_len >=3D EXT4_XATTR_MIN_LARGE_EA_SIZE) &&
> +           (EXT4_SB(inode->i_sb)->s_es->s_feature_incompat &
> +            EXT4_FEATURE_INCOMPAT_EA_INODE)) {
> +               /* For new inode */
> +               buffer_credits +=3D  > > >EXT4_SINGLEDATA_TRANS_BLOCK=
S(inode->i_sb) +3;
> +
> +               /* For the blocks to be written in the EA inode */
> +               buffer_credits +=3D (value_len + inode->i_sb->s_block=
size - 1) /
> +                                  inode->i_sb->s_blocksize;
> +       }
> +
 > retry:
> -       handle =3D ext4_journal_start(inode, > EXT4_DATA_TRANS_BLOCKS=
(inode->i_sb));
> +       handle =3D ext4_journal_start(inode, buffer_credits);
>         if (IS_ERR(handle)) {
>                 error =3D PTR_ERR(handle);
>         } else {


the credits calculation could be replaced with something like this:

nrblocks =3D (value_len + inode->i_sb->s_blocksize - 1) / inode->i_sb->=
s_blocksize;
buffer_credits =3D  ext4_meta_trans_blocks(inode,  nrblocks,  1) + nrbl=
ocks;



BTW, I  think we should update the xttars credits micro in ext4_jbd2.h,
that is based on 1 xattr block assumption...

/* Extended attribute operations touch at most two data buffers,
 * two bitmap buffers, and two group summaries, in addition to the inod=
e
 * and the superblock, which are already accounted for. */

#define EXT4_XATTR_TRANS_BLOCKS         6U



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
