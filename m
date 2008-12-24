From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: Re: Problems with the max value for create directory
Date: Wed, 24 Dec 2008 09:18:53 +0800
Message-ID: <49518DFD.8090507@cn.fujitsu.com>
References: <495054DE.9030405@cn.fujitsu.com> <495062D1.6010805@jp.fujitsu.com> <20081223201247.GU23723@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYLXBSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2008 20:18:09 -0500
In-Reply-To: <20081223201247.GU23723@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso =E5=86=99=E9=81=93:

>=20
> So that's not it.  The problem is that indexed diretories have a limi=
t
> that only allows the trees to be two levels deep.  The fanout is
> normally big enough that this is effectively not a problem, but if yo=
u
> use very long filenames, and a 1k blocksize, you will run into this
> limit much more quickly.  So the problem is not the number of sub
> directories, but the maximum depth of the htree allowed in Daniel
> Phillips' relatively restricted implementation.  Note that with a 4k
> block filesystem, the limits get expanded by a factor of 4 cubed, or
> 64.  And most of the time users aren't maximal length named directory
> entries, which further pushes the limit out in the normal case.
>=20
> It in theory would be possible to relax this restriction, using a mor=
e
> advanced htree implementation and a feature flag to allow backwards
> compatibility with older kernels that only support the maximal depth.
> Andreas has a prototype kernel implementation which in theory could b=
e
> added to ext4.  It hasn't been high on my priority list to complete,
> but if someone else really finds this limit to be annoying, it is a
> project they might try to complete.
>=20
> Were you writing this test program because this is a realistic
> situation for your application, or just to explore the limits of ext4=
?
>=20

Thanks for explanation.

I see the limit of ext4 subdirectory. The test program originally tests=
 it.
But I fail and find the limit of the htree.
=20
I think it may be annoying. Somebody may be puzzled for the two limits.
The limit of the htree should be greater than the limit of ext4 subdire=
ctory.

--=20
Regards
Zhang Xiliang

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
