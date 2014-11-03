From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 0/6] ext4: extents status tree shrinker improvement
Date: Mon, 3 Nov 2014 17:10:46 +0100
Message-ID: <20141103161046.GA17319@quack.suse.cz>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <20141020144849.GB4499@thunk.org>
 <20141021102228.GC2955@quack.suse.cz>
 <007DCBDA-B924-4B45-887C-5FFFB8749966@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	=?utf-8?B?5YiY5bOlKOaWh+WNvyk=?= <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: =?utf-8?B?5YiY5bOlKOaWh+WNvyk=?= <wenqing.lz@alibaba-inc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaKCQKw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Nov 2014 11:10:52 -0500
Content-Disposition: inline
In-Reply-To: <007DCBDA-B924-4B45-887C-5FFFB8749966@alibaba-inc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 21-10-14 23:58:10, =E5=88=98=E5=B3=A5(=E6=96=87=E5=8D=BF) wrote:
> I deeply sorry for this because of my delay work.  I don=E2=80=99t ha=
ve any objection
> for Jan=E2=80=99s suggestions.  Until now there are still some works =
that push me
> tough, and I can see that I don=E2=80=99t have time to finish it at t=
his merge
> window.  It=E2=80=99s a shame for me!
>=20
> Jan, I really really appreciate if you are willing to push this patch=
 set
> to completion.  Thanks!!!
  OK, I have updated the patches according to the review I and Ted did.=
 It
survives basic fsstress run. How were you testing your patches? I shoul=
d
probably also gather some statistics etc...

								Honza

> > On Oct 21, 2014, at 6:22 PM, Jan Kara <jack@suse.cz> wrote:
> >=20
> >  Hello,
> >=20
> > On Mon 20-10-14 10:48:49, Ted Tso wrote:
> >> It's been a while since you've posted a revised version of this pa=
tch
> >> series.  I believe Jan had suggested some changes which you said y=
ou
> >> would fix in the next set of patches.  Do you know when you might =
be
> >> able that might be done?
> >  Yeah, actually if you don't have time just say so. I can push it t=
o
> > completion somehow (there wasn't that much work left). I need the t=
hing
> > completed reasonably quickly since I already have some user reports=
 for
> > openSUSE and I'm somewhat afraid reports for SLES will come pretty =
soon and
> > I cannot leave those unresolved for long...
> >=20
> > 								Honza
> > --=20
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
>=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
