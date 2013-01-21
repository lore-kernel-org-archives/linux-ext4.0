From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix memory leak when quota options are specified
 multiple times
Date: Mon, 21 Jan 2013 12:05:25 +0100
Message-ID: <20130121110524.GG5588@quack.suse.cz>
References: <50FBC2D8.9070807@asianux.com>
 <20130121103138.GB5588@quack.suse.cz>
 <50FD1FA1.8060104@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab3AULF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 06:05:27 -0500
Content-Disposition: inline
In-Reply-To: <50FD1FA1.8060104@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-01-13 18:59:45, Chen Gang wrote:
> =E4=BA=8E 2013=E5=B9=B401=E6=9C=8821=E6=97=A5 18:31, Jan Kara =E5=86=99=
=E9=81=93:
> >   The port looks good. You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
>=20
>   does it mean:
>     if the applier also think this patch is ok, he will add you as
> Reviewed-by (it is also just what my willing) ?
  Yes.

								Honza

--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
