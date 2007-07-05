From: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH] ext4: fix error handling in ext4_create_journal
Date: Thu, 5 Jul 2007 20:59:27 +0200
Message-ID: <20070705185927.GA4867@gollum.tnic>
References: <20070701221111.GA8627@gollum.tnic> <20070703152543.e58ad39a.akpm@linux-foundation.org> <20070704193024.GA6802@gollum.tnic> <20070704201725.GA5812@martell.zuzino.mipt.ru>
Reply-To: bbpetkov@yahoo.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:28932 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760313AbXGES7h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 14:59:37 -0400
Content-Disposition: inline
In-Reply-To: <20070704201725.GA5812@martell.zuzino.mipt.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 05, 2007 at 12:17:25AM +0400, Alexey Dobriyan wrote:
> On Wed, Jul 04, 2007 at 09:30:24PM +0200, Borislav Petkov wrote:
> > Fix error handling in ext4_create_journal according to kernel conve=
ntions.
>=20
> > --- linux-2.6.22-rc7/fs/ext4/super.c.orig
> > +++ linux-2.6.22-rc7/fs/ext4/super.c
> > @@ -2150,6 +2150,7 @@
> >  			       unsigned int journal_inum)
> >  {
> >  	journal_t *journal;
> > +	int err;
> > =20
> >  	if (sb->s_flags & MS_RDONLY) {
> >  		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
> > @@ -2157,13 +2158,15 @@
> >  		return -EROFS;
> >  	}
> > =20
> > -	if (!(journal =3D ext4_get_journal(sb, journal_inum)))
> > +	journal =3D ext4_get_journal(sb, journal_inum);
> > +	if (!journal)
> >  		return -EINVAL;
>=20
> OK.
>=20
> >  	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
> >  	       journal_inum);
> > =20
> > -	if (jbd2_journal_create(journal)) {
> > +	err =3D jbd2_journal_create(journal);
> > +	if (err) {
> >  		printk(KERN_ERR "EXT4-fs: error creating journal.\n");
> >  		jbd2_journal_destroy(journal);
> >  		return -EIO;
>=20
> Original code is fine.

Hmm, ok but this is not the way error handling is done in the rest of e=
xt3/4.
If you look for error variables declarations of type int in super.c, e.=
g. in
ext4_load_journal(), ext4_clear_journal_err() and ext4_remount() to nam=
e a few,
you'll see how the return value of the called function is assigned to t=
he
error variable and then the last is checked in the if-conditional, whic=
h is the
usual way error handling is done in the kernel, imho. And my patch addr=
esses exactly that.

--=20
Regards/Gru=DF,
    Boris.
