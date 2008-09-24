From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Wed, 24 Sep 2008 12:23:39 -0400
Message-ID: <20080924162339.GH9929@mit.edu>
References: <1221481007.6733.32.camel@frecb007923.frec.bull.fr> <20080915133604.GA6548@skywalker> <1221489026.6733.36.camel@frecb007923.frec.bull.fr> <1221745514.3550.83.camel@frecb007923.frec.bull.fr> <20080921004451.GA15402@mit.edu> <1222070998.3581.25.camel@frecb007923.frec.bull.fr> <20080922084721.GA6691@skywalker> <1222075960.3581.33.camel@frecb007923.frec.bull.fr> <20080923231346.GT10950@webber.adilger.int> <1222261048.3511.23.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35639 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751899AbYIXQYQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Sep 2008 12:24:16 -0400
Content-Disposition: inline
In-Reply-To: <1222261048.3511.23.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 24, 2008 at 02:57:28PM +0200, Fr=E9d=E9ric Boh=E9 wrote:
>=20
> You are right ext4_group_info structure was not as big as I thought.
> Do you mean that making ext4_group_info generic for both mballoc and
> oldalloc will reduce the code complexity ?

Long-term, we want to do this, yes.  There's a lot of stuff in mballoc
that we probably need to move out into generic code.  I'll sending
patches shortly that move the /proc handling code into the generic
code, and also saving 2k of compiled object code in the process.

Here, I think main argument is since mballoc is on by default, and the
benefits of this are huge, is that we would save memory by using an
unused bit in ext4_group_info.

A related question is at what point should we remove the oldalloc code
altogehter?

> > Also, if you are considering this approach (to initialize the in-me=
mory
> > bitmaps at mount time) they should be written to disk even if unuse=
d.
> > Please also consider doing the inode table zeroing at the same time=
=2E
> > This would allow uninit_bg to avoid doing it at mke2fs time.
>=20
> In fact, I was not considering doing this at mount time, but it could=
 be
> a good approach.
> Anyway, I don't understand why we should write bitmaps to disk after
> that, and why we should zeroing the inode table.  Don't we end up wit=
h a
> fast mkfs and a slow mount doing all the stuff older mkfs was doing ?
> The UNINIT feature would become less interesting.

It would be an absolute disaster to do this at mount time, especially
if it included zeroing the inode table.  Zeroing the inode table must
be done in a background kernel thread, with appropriate locks to avoid
races with the block allocation code (this is one of the places where
eliminating the old allocation code would make life easier).

I don't think we should worry about initializing the bitmaps in
advance.  There's just no advantage in doing that for the bitmaps.
=46or the inode table we want to do this for safety's sake, but that's
not a concern for the bitmaps.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
