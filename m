From: coly <colyli@gmail.com>
Subject: Re: which tree should I generate the ext4 patch ?
Date: Thu, 24 May 2007 17:02:51 +0800
Message-ID: <1179997371.4353.1.camel@coly-t43.site>
References: <1179910843.4119.33.camel@coly-t43.site>
	 <20070523121723.GC5608@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:4003 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXEXJCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 05:02:08 -0400
Received: by py-out-1112.google.com with SMTP id a73so767792pye
        for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 02:02:07 -0700 (PDT)
In-Reply-To: <20070523121723.GC5608@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore,

I can see all the files, but how can I download the files by cvs ? I
tried pserver, but it seems does not work ..

could you give me some hints ?

Thanks

Coly

=E5=9C=A8 2007-05-23=E4=B8=89=E7=9A=84 08:17 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, May 23, 2007 at 05:00:43PM +0800, coly wrote:
> >=20
> > These days, I am tring to post my patch for inode reservation on
> > linux-ext4. But I am confused on which tree I should generate the p=
atch.
> >=20
> > I worked on mm-tree. But now Thoedore creates a tree for ext4, so s=
hould
> > I generate the patch based on tso-tree ?
>=20
> The mm-tree is fed from the ext4 patch series, so there shouldn't be
> much difference.
>=20
> > Same question to e2fsprogs. I guess maybe I should generate the pat=
ch
> > for e2fsprogs based on e2fsprogs-TEST branch, a.k.a 1.40-WIP-0407. =
Isn't
> > it ?
>=20
> Yes, or if you want to use the very latest, you can use the Mercurial
> repository located at:
>=20
> 	http://thunk.org/hg/e2fsprogs
>=20
> I will be switch to git at some point in the near future, probably
> after the e2fsprogs 1.40 release, but for now that's the place to get
> the very latest. =20
>=20
> In practice, it's not hard to rebase patches, but patches against the
> more recent versions are definitely appreciated.  So if you're not
> familiar with using Mercurial, please feel free to use the
> 1.40-WIP-0407 as the base for your patches. =20
>=20
> Regards,=20
>=20
> 					- Ted
