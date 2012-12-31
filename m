From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext3: set pointer = NULL, after kfree it
Date: Mon, 31 Dec 2012 16:19:53 +0100
Message-ID: <20121231151953.GE7564@quack.suse.cz>
References: <50D7EEF6.4070005@asianux.com>
 <20121225185155.GE5318@thunk.org>
 <50DA61E8.5090009@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, jack@suse.cz,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2LaPT4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 10:19:56 -0500
Content-Disposition: inline
In-Reply-To: <50DA61E8.5090009@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 26-12-12 10:33:12, Chen Gang wrote:
> =E4=BA=8E 2012=E5=B9=B412=E6=9C=8826=E6=97=A5 02:51, Theodore Ts'o =E5=
=86=99=E9=81=93:
> > On Mon, Dec 24, 2012 at 01:58:14PM +0800, Chen Gang wrote:
> >>
> >>   set s->base =3D NULL, after kfree it.
> >>
> >> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> >=20
> > Was this to fix something flagged by some static code checker?  The
> > only caller of ext3_xattr_block_set() is ext3_xattr_set_handle(), a=
nd
> > s->base is stored on the stack, and as soon as ext3_xattr_block_set=
()
> > returns, the object will disappear.  So it seems pretty hard to see
> > how this could lead to a use-after-free bug.
> >=20
> >     	       	       	 		- Ted
> >=20
> >=20
>=20
>   this patch is not for a bug
>=20
>   it is only for coding habit:
>     it is better to set is to NULL, after kfree it.
>     in the future, if another functions need call ext3_xattr_block_se=
t, too.
>       it will avoid another members to make mistake.
  Well, we set pointers to NULL after kfree() only if there's a good ch=
ance
we ever look at the pointer again. This is not the case so I don't thin=
k
this change makes the code any more safer / easier to read.

									Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
