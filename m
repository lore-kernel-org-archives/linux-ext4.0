From: Andreas Dilger <adilger@sun.com>
Subject: Re: Problems with the max value for create directory
Date: Mon, 05 Jan 2009 20:16:25 -0700
Message-ID: <20090106031625.GB3932@webber.adilger.int>
References: <495054DE.9030405@cn.fujitsu.com> <495062D1.6010805@jp.fujitsu.com>
 <20081223201247.GU23723@mit.edu> <49518DFD.8090507@cn.fujitsu.com>
 <6149e97b0812290547r6e487caap46c0ec77ccc28709@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>,
	Theodore Tso <tytso@mit.edu>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Peng tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57834 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZAFDQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 22:16:32 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n063GSKx009323
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jan 2009 19:16:29 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KD100J0152V9Z00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 05 Jan 2009 19:16:28 -0800 (PST)
In-reply-to: <6149e97b0812290547r6e487caap46c0ec77ccc28709@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 29, 2008  21:47 +0800, Peng tao wrote:
> I got a question about this.
> Since htree is a potential limitation for subdirectories. Is there a
> reason why EXT4_LINK_MAX is applied when fs hasn't dir_index but
> ignored when fs has dir_index(by the following code)?
>=20
> #define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
> 				      EXT4_FEATURE_COMPAT_DIR_INDEX) && \
> 		      (EXT4_I(dir)->i_flags & EXT4_INDEX_FL))
> #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >=3D EX=
T4_LINK_MAX)

Because without the dir_index feature the largest usable directory size
is only about 10k-20k files before the O(n^2) insertion performance is
so bad that the directory is useless.

> On Wed, Dec 24, 2008 at 9:18 AM, Zhang Xiliang
> <zhangxiliang@cn.fujitsu.com> wrote:
> > Theodore Tso =E5=86=99=E9=81=93:
> >
> >>
> >> So that's not it.  The problem is that indexed diretories have a l=
imit
> >> that only allows the trees to be two levels deep.  The fanout is
> >> normally big enough that this is effectively not a problem, but if=
 you
> >> use very long filenames, and a 1k blocksize, you will run into thi=
s
> >> limit much more quickly.  So the problem is not the number of sub
> >> directories, but the maximum depth of the htree allowed in Daniel
> >> Phillips' relatively restricted implementation.  Note that with a =
4k
> >> block filesystem, the limits get expanded by a factor of 4 cubed, =
or
> >> 64.  And most of the time users aren't maximal length named direct=
ory
> >> entries, which further pushes the limit out in the normal case.
> >>
> >> It in theory would be possible to relax this restriction, using a =
more
> >> advanced htree implementation and a feature flag to allow backward=
s
> >> compatibility with older kernels that only support the maximal dep=
th.
> >> Andreas has a prototype kernel implementation which in theory coul=
d be
> >> added to ext4.  It hasn't been high on my priority list to complet=
e,
> >> but if someone else really finds this limit to be annoying, it is =
a
> >> project they might try to complete.
> >>
> >> Were you writing this test program because this is a realistic
> >> situation for your application, or just to explore the limits of e=
xt4?
> >>
> >
> > Thanks for explanation.
> >
> > I see the limit of ext4 subdirectory. The test program originally t=
ests it.
> > But I fail and find the limit of the htree.
> >
> > I think it may be annoying. Somebody may be puzzled for the two lim=
its.
> > The limit of the htree should be greater than the limit of ext4
> > subdirectory.
> >
> > --
> > Regards
> > Zhang Xiliang
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
>=20
> --=20
> Cheers,
>=20
> Bergwolf
>=20
> ................
> Rodney Dangerfield  - "The way my luck is running, if I was a
> politician I would be honest."
> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{?{=1Bx?{ay?=1D=CA=87=DA=
=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2=
j"??!

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
