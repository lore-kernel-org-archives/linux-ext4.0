From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Date: Wed, 11 Jul 2007 08:37:58 +0400
Message-ID: <20070711043758.GA5766@martell.zuzino.mipt.ru>
References: <1183275490.4010.134.camel@localhost.localdomain> <20070710193117.a4ef6298.akpm@linux-foundation.org> <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:47641 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXGKEiF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 00:38:05 -0400
Received: by ug-out-1314.google.com with SMTP id j3so34492ugf
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 21:38:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 11:21:49PM -0400, C=E9dric Augonnet wrote:
> 2007/7/10, Andrew Morton <akpm@linux-foundation.org>:
>=20
> Hi all,
>=20
> >> +     size =3D sizeof(struct transaction_stats_s);
> >> +     s->stats =3D kmalloc(size, GFP_KERNEL);
> >> +     if (s =3D=3D NULL) {
	       ^
> >> +             kfree(s);
> >> +             return -EIO;
> >
> >ENOMEM

That, and

	if (s->stats =3D=3D NULL)
		kfree(s);

> I'm sorry if i missed some point, but i just don't see the use of suc=
h
> a kfree here, not sure Andrew meant you should only return ENOMEM
> instead, but why issuing those kfree(NULL), instead of just a if (!s)
> return ENOMEM ?

kfree() is correct, check isn't.
