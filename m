From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: reopen the file system with saved flags after a
 journal replay
Date: Tue, 8 Jul 2014 07:58:27 -0400
Message-ID: <20140708115827.GB27440@thunk.org>
References: <1404616198-315-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1407080947580.2180@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	=?utf-8?B?0JDQvdC00YDQtdC5INCS0LDRgdC40LvQuNGI0LjQvQ==?=
	<a.vasilishin@kpi.ua>, Jon Severinsson <jon@severinsson.net>,
	744953@bugs.debian.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51030 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaGHL64 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 07:58:56 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407080947580.2180@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 08, 2014 at 11:03:53AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	ctx->openfs_flags =3D flags;
> >  	retval =3D try_open_fs(ctx, flags, io_ptr, &fs);
>=20
> Maybe we can get rid of 'flags' argument since it's not needed
> anymore ?

Yeah, I thought of that, but I was trying to keep the patch small,
since I thought this was one that distros might want to cherry pick.

> Otherwise the patch looks good, however for some reason I can not
> reproduce the problem in the big file system (without bigalloc) even
> though looking at bitmap.c it looks like we really should get that
> error.

Ah, yes, in the big file system case we don't hit it because we don't
actually load the bitmaps before we close and reopen the file system
again.  But in the bigalloc case, we check and fail at openfs time,
which aborts the fsck run.

So we could work around this by moving the bigalloc check to when we
open the file system, but you want get the other openfs flags right,
especially the EXT2_FLAG_SKIP_MMP flags.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
