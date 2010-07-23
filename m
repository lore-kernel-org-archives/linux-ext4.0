From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
 in ext2_xattr_get
Date: Fri, 23 Jul 2010 10:37:59 +0200
Message-ID: <20100723083759.GA3305@quack.suse.cz>
References: <201007122229025316610@gmail.com>
 <20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
 <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: shenghui <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0GWIi1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 04:38:27 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-07-10 08:03:18, shenghui wrote:
> 2010/7/22 Jan Kara <jack@suse.cz>:
> >> Hi,
> >> =A0 =A0 =A0 =A0I walked through ext2_xattr_get, and felt that we c=
an
> >> do some optimization on it. For name_len check, it's done
> >> after down xattr_sem and sb_read, both of which are time
> >> consuming operation compared with strlen:
> >> =A0 =A0 =A0 =A0 =A0down_read(&EXT2_I(inode)->xattr_sem);
> >> =A0...
> >> =A0 =A0 =A0 =A0 =A0bh =3D sb_bread(inode->i_sb, EXT2_I(inode)->i_f=
ile_acl);
> >> =A0...
> >> =A0 =A0 =A0 =A0 =A0/* find named attribute */
> >> =A0 =A0 =A0 =A0 =A0name_len =3D strlen(name);
> >>
> >> =A0 =A0 =A0 =A0 =A0error =3D -ERANGE;
> >> =A0 =A0 =A0 =A0 =A0if (name_len > 255)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
> >>
> >> =A0 =A0 =A0 =A0Most of the case, you'll get one valid block, but i=
f the
> >> name len > 255, then the xattr_sem down and sb_bread operation
> >> can be seen as a waste of time. So I think we'd better do
> >> name len check as early as possible.
> >> =A0 =A0 =A0 =A0Following is my patch, and it's against 2.6.35-rc4.
> >> Please check it.
> >>
> >> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> >> ---
> >> =A0fs/ext2/xattr.c | =A0 12 +++++++-----
> >> =A01 files changed, 7 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> >> index 7c39157..0b94d61 100644
> >> --- a/fs/ext2/xattr.c
> >> +++ b/fs/ext2/xattr.c
> >> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_=
index, const char *name,
> >>
> >> =A0 =A0 =A0 if (name =3D=3D NULL)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> >> +
> >> + =A0 =A0 /* find named attribute */
> >> + =A0 =A0 name_len =3D strlen(name);
> >> + =A0 =A0 error =3D -ERANGE;
> >> + =A0 =A0 if (name_len > 255)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
> > =A0But you cannot go to cleanup here because you don't hold xattr_s=
em...
> >
>=20
> Sorry, I'm a little confused by your words.
> The patch just checks name_len, and it
> doesn't need xattr_sem.
  Checking of name_len is fine as you did it. But I wanted to point out
that if name_len is greater than 255, you then go to 'cleanup' label wh=
ich
tries to do up_read(&EXT2_I(inode)->xattr_sem). But that's a bug becaus=
e
after you moved the code, we don't hold xattr_sem at the moment we chec=
k
name_len.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
