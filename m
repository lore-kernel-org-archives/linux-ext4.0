From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] ext4: Update EXT4_USE_FOR_EXT2 description
Date: Thu, 24 Sep 2015 15:14:30 +0200
Message-ID: <1443100470.4919.1.camel@chaos.site>
References: <20150924123822.1a0917bf@endymion.delvare>
	 <20150924112829.GA27066@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbbIXNOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Sep 2015 09:14:33 -0400
In-Reply-To: <20150924112829.GA27066@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le Thursday 24 September 2015 =C3=A0 13:28 +0200, Jan Kara a =C3=A9crit=
 :
> On Thu 24-09-15 12:38:22, Jean Delvare wrote:
> > Configuration option EXT4_USE_FOR_EXT2 has no effect on ext3 suppor=
t.
> > Support for ext3 is always included now.
> >=20
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > Fixes: c290ea01ab ("fs: Remove ext3 filesystem driver")
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>=20
> Thanks. I've merged the patch to my tree.
>=20
> 								Honza
>=20
> > ---
> >  fs/ext4/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > --- linux-4.3-rc2.orig/fs/ext4/Kconfig	2015-09-20 23:32:34.00000000=
0 +0200
> > +++ linux-4.3-rc2/fs/ext4/Kconfig	2015-09-24 11:45:21.911961421 +02=
00
> > @@ -63,7 +63,7 @@ config EXT4_FS
> >  	  If unsure, say N.
> > =20
> >  config EXT4_USE_FOR_EXT2
> > -	bool "Use ext4 for ext2/ext3 file systems"
> > +	bool "Use ext4 for ext2 file systems"

On second thought I'm not sure if the use of plural is still desired.
You decide ;-)

> >  	depends on EXT4_FS
> >  	depends on EXT2_FS=3Dn
> >  	default y
> >=20

Thanks,
--=20
Jean Delvare
SUSE L3 Support

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
