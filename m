From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/6] ext4: extents status tree shrinker improvement
Date: Thu, 13 Nov 2014 18:40:09 -0500
Message-ID: <20141113234009.GE28780@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <20141020144849.GB4499@thunk.org>
 <20141021102228.GC2955@quack.suse.cz>
 <007DCBDA-B924-4B45-887C-5FFFB8749966@alibaba-inc.com>
 <20141103161046.GA17319@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?5YiY5bOlKOaWh+WNvyk=?= <wenqing.lz@alibaba-inc.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	=?utf-8?B?5YiY5bOlKOaWh+WNvyk=?= <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57649 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793AbaKMXkQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 18:40:16 -0500
Content-Disposition: inline
In-Reply-To: <20141103161046.GA17319@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2014 at 05:10:46PM +0100, Jan Kara wrote:
>   Hello,
>=20
> On Tue 21-10-14 23:58:10, =E5=88=98=E5=B3=A5(=E6=96=87=E5=8D=BF) wrot=
e:
> > I deeply sorry for this because of my delay work.  I don=E2=80=99t =
have any objection
> > for Jan=E2=80=99s suggestions.  Until now there are still some work=
s that push me
> > tough, and I can see that I don=E2=80=99t have time to finish it at=
 this merge
> > window.  It=E2=80=99s a shame for me!
> >=20
> > Jan, I really really appreciate if you are willing to push this pat=
ch set
> > to completion.  Thanks!!!
>   OK, I have updated the patches according to the review I and Ted di=
d. It
> survives basic fsstress run. How were you testing your patches? I sho=
uld
> probably also gather some statistics etc...

Hi Jan,

I was wondering how your updated extent status tree shrinker patches
are going?  Are you comfortable sending them out for review/merging?
Sorry for nagging but we're already at 3.18-rc4, and it would be great
if we could get these merged for this merge window.

Thanks!

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
