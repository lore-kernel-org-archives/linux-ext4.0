From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] libext2fs: optimize rb_test_bit
Date: Mon, 8 Oct 2012 14:17:53 -0400
Message-ID: <20121008181753.GA20682@thunk.org>
References: <1349408695-11661-1-git-send-email-tytso@mit.edu>
 <1349408695-11661-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1210080952390.25096@localhost>
 <alpine.LFD.2.00.1210081016160.25096@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54441 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab2JHSSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 14:18:01 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210081016160.25096@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2012 at 10:25:19AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > the patch and the idea behind it look fine, especially when we're
> > walking the bitmap sequentially not modifying it simultaneously, bu=
t
> > I have one question/suggestion below.
>=20
> Also for this kind of usage it might actually make sense to have
> something like:
>=20
> get_next_zero_bit
> get_next_set_bit
>=20
> which would be much more effective than testing single bits, but it
> would require actually using this in e2fsprogs tools.

Yes, I thought about that, and in fact we already have find_first_zero
(which takes a starting offset, so works for both find_first and
find_next).  When we introduced this, though, we accidentally
introduced a bug at first.

At some point I agree it would be good to implement find_first_set(),
and writing new unit tests, and then modify e2freefrag, e2fsck, and
dumpe2fs to use it.  But in the applications is actually pretty
tricky, and I didn't have the time I figured would be necessary to
really do the changes right, and validate/test them properly.

So yes, I agree this would be much more effective, and ultimately
would result in further speedups in e2fsck and e2freefrag in
particular.  It would also allow us to take out the test_bit
optimizations which do have a slight cost for random access reads ---
and this is measurable when looking at the results of the CPU time for
e2fsck pass 4 in particular.  It's just that the performance hit for
the random access test_bit case is very tiny compared with the huge
wins in the sequential scan case.

> > what about using the next_ext once we're holding it to check the bi=
t
> > ? On sequential walk this shout make sense to do so since we
> > actually should hit this if we're not in rcursor nor between rcurso=
r
> > and next_ext.

Yes, I implemented that in the 2/3 commit in the follow-on patch
series.

Cheers!

						 - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
