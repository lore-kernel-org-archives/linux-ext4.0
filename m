From: Theodore Tso <tytso@mit.edu>
Subject: Re: where is the ext4 git tree ?
Date: Fri, 26 Jan 2007 11:51:19 -0500
Message-ID: <20070126165119.GC14759@thunk.org>
References: <1169805918.32648.14.camel@colyT43.site> <45BA24CB.5060501@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: coly <colyli@gmail.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34158 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030869AbXAZQvb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jan 2007 11:51:31 -0500
Content-Disposition: inline
In-Reply-To: <45BA24CB.5060501@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 26, 2007 at 07:56:59AM -0800, Mingming Cao wrote:
> >
> >I can not find the ext4 git tree (on kernel.org) which Te mentioned =
on
> >the talk. Can anybody give me a point ?  I am new to ext4.
> >
>=20
> That was the plan discussed a few weeks ago. Ted is travelling (I=20
> think=EF=BC=89so he may not get a chance to work on it or annonce it =
yet. Stay=20
> tuned...

The first patch series can be found here:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.20-=
rc5-ext4-1

I've included Alex's latest patches which he sent back in December,
but I haven't gone back before that looking for patches from before.
If you think there is a patch which should be included that hasn't
been, please repost it to linux-ext4. =20

(The reason why I haven't included Takashi-san's patches is that they
were based on an earlier version of Alex's patches, and so they didn't
apply cleanly.  It wouldn't be hard to fix it up, but it would have
met changing the ioctl assignments, and so I decided to let him do
that in order to avoid potential future confusion.)

I haven't had time to rebase to 2.6.20-rc6, or to set up the git tree.
When I do, it people should note that it will be frequently rewound
and rebased, and so it will be useful mainly for people who like to
use it to update their git trees.  Some folks may find it more
convenient to work with the series file and the patches (especially
since I'll probably be keeping notes about the status of patches in
there). =20

						- Ted
