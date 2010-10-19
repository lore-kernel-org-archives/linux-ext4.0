From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Check return value of sb_getblk()
Date: Tue, 19 Oct 2010 22:41:28 +0200
Message-ID: <20101019204127.GB3487@quack.suse.cz>
References: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
 <1287475049.1705.2.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0JSUm1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Oct 2010 16:42:27 -0400
Content-Disposition: inline
In-Reply-To: <1287475049.1705.2.camel@leonhard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 19-10-10 16:57:29, Namhyung Kim wrote:
> 2010-10-19 (=ED=99=94), 15:34 +0900, Namhyung Kim:
> > Check return value of sb_getblk() is NULL. unlikely is addded here
> > since it is called from a loop and we've been OK without the check
> > until now.
> >=20
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  fs/ext3/inode.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index ef1c23a..a7ac778 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -655,6 +655,12 @@ static int ext3_alloc_branch(handle_t *handle,=
 struct inode *inode,
> >  		 * parent to disk.
> >  		 */
> >  		bh =3D sb_getblk(inode->i_sb, new_blocks[n-1]);
> > +		if (unlikely(!bh)) {
> > +			n--;
> > +			err =3D -ENOMEM;
> > +			goto failed;
> > +		}
> > +
> >  		branch[n].bh =3D bh;
> >  		lock_buffer(bh);
> >  		BUFFER_TRACE(bh, "call get_create_access");
>=20
> Maybe EIO would be more proper error code, I guess.
  Hmm, for ext3, sb_getblk() cannot really realistically fail. Block
numbers are 32-bit so they can never be big enough to overflow pagecach=
e
index and grow_buffers() loops indefinitely if it cannot allocate buffe=
rs.
But OK, EIO might be a reasonable return value and we can have the chec=
k
there just in case sb_getblk() grows some other possiblility to fail.

								Honza

--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
