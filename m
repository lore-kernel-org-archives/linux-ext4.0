From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Date: Tue, 10 Jul 2007 23:21:49 -0400
Message-ID: <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
References: <1183275490.4010.134.camel@localhost.localdomain>
	 <20070710193117.a4ef6298.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:43625 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXGKDVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 23:21:50 -0400
Received: by an-out-0708.google.com with SMTP id d31so311331and
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 20:21:49 -0700 (PDT)
In-Reply-To: <20070710193117.a4ef6298.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2007/7/10, Andrew Morton <akpm@linux-foundation.org>:

Hi all,

> > +     size =3D sizeof(struct transaction_stats_s);
> > +     s->stats =3D kmalloc(size, GFP_KERNEL);
> > +     if (s =3D=3D NULL) {
> > +             kfree(s);
> > +             return -EIO;
>
> ENOMEM

I'm sorry if i missed some point, but i just don't see the use of such
a kfree here, not sure Andrew meant you should only return ENOMEM
instead, but why issuing those kfree(NULL), instead of just a if (!s)
return ENOMEM ?

Regards,
C=E9dric
