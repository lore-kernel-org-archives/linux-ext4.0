From: coly <colyli@gmail.com>
Subject: Re: confused on different inode size
Date: Mon, 09 Apr 2007 23:58:27 +0800
Message-ID: <1176134307.12630.3.camel@colyT43.site>
References: <1176014343.20429.6.camel@colyT43.site>
	 <20070408175218.GB29180@thunk.org> <1176085993.4101.6.camel@colyT43.site>
	 <20070409152630.GA30658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:59024 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965965AbXDIPy4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Apr 2007 11:54:56 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1557909uga
        for <linux-ext4@vger.kernel.org>; Mon, 09 Apr 2007 08:54:55 -0700 (PDT)
In-Reply-To: <20070409152630.GA30658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore:

Thanks for your explaining. I ignored this detail before, it is more
clear to me now.

Best regards.

Coly

=E5=9C=A8 2007-04-09=E4=B8=80=E7=9A=84 11:26 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Apr 09, 2007 at 10:33:13AM +0800, coly wrote:
> > Theodore:
> >=20
> > Thanks for your replying.=20
> >=20
> > Can I understand this way:
> > * Though sizeof(struct ext4_inode) is 152, the real inode size on d=
isk
> > still depends on mount options.
>=20
> Not mount options, but how the filesystem is formatted.  So substitut=
e
> "mount" with "mke2fs", and that would be correct.
>=20
> > * If use old inode size, the on disk inode will be 128 bytes.
> > * If use new inode size(e.g. extent option in mount), the on disk i=
node
> > will be 256, or more bytes.
>=20
> s/mount/mke2fs/
>=20
> And the on-disk inode size is 256, 512, or some greater power of two,
> up to the filesystem blocksize.
>=20
> > * If on disk inode size is 128 bytes, only first 128 bytes of struc=
t
> > ext4_inode take effects.
>=20
> Well, there's no space to store the fields beyond the first 128, so
> any features that require the extra inode fields can't be used.
>=20
> 						- Ted
