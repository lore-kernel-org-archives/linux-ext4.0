From: coly <colyli@gmail.com>
Subject: Re: where is the ext4 git tree ?
Date: Sat, 27 Jan 2007 21:26:27 +0800
Message-ID: <1169904387.10553.4.camel@colyT43.site>
References: <1169805918.32648.14.camel@colyT43.site>
	 <45BA24CB.5060501@us.ibm.com>  <20070126165119.GC14759@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:23922 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXA0N2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Jan 2007 08:28:18 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1460456nfa
        for <linux-ext4@vger.kernel.org>; Sat, 27 Jan 2007 05:28:17 -0800 (PST)
In-Reply-To: <20070126165119.GC14759@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore:

It seems the patch file is based on stable kernel tree, not -mm tree.
Isn't it ?

Thanks.

Coly

=E5=9C=A8 2007-01-26=E4=BA=94=E7=9A=84 11:51 -0500=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Fri, Jan 26, 2007 at 07:56:59AM -0800, Mingming Cao wrote:
> > >
> > >I can not find the ext4 git tree (on kernel.org) which Te mentione=
d on
> > >the talk. Can anybody give me a point ?  I am new to ext4.
> > >
> >=20
> > That was the plan discussed a few weeks ago. Ted is travelling (I=20
> > think=EF=BC=89so he may not get a chance to work on it or annonce i=
t yet. Stay=20
> > tuned...
>=20
> The first patch series can be found here:
>=20
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.2=
0-rc5-ext4-1
>=20
> I've included Alex's latest patches which he sent back in December,
> but I haven't gone back before that looking for patches from before.
> If you think there is a patch which should be included that hasn't
> been, please repost it to linux-ext4. =20
>=20
> (The reason why I haven't included Takashi-san's patches is that they
> were based on an earlier version of Alex's patches, and so they didn'=
t
> apply cleanly.  It wouldn't be hard to fix it up, but it would have
> met changing the ioctl assignments, and so I decided to let him do
> that in order to avoid potential future confusion.)
>=20
> I haven't had time to rebase to 2.6.20-rc6, or to set up the git tree=
=2E
> When I do, it people should note that it will be frequently rewound
> and rebased, and so it will be useful mainly for people who like to
> use it to update their git trees.  Some folks may find it more
> convenient to work with the series file and the patches (especially
> since I'll probably be keeping notes about the status of patches in
> there). =20
>=20
> 						- Ted
