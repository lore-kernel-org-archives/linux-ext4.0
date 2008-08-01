From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 1 Aug 2008 15:10:15 -0400
Message-ID: <20080801191015.GH8654@mit.edu>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1217383118.27664.14.camel@mingming-laptop> <1217417361.3373.15.camel@localhost> <1217527631.6317.6.camel@mingming-laptop> <20080801054932.GF8736@mit.edu> <1217613795.12413.15.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44021 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752363AbYHATKy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 15:10:54 -0400
Content-Disposition: inline
In-Reply-To: <1217613795.12413.15.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2008 at 11:03:15AM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-08-01=E4=BA=94=E7=9A=84 01:49 -0400=EF=BC=8CTheodore T=
so=E5=86=99=E9=81=93=EF=BC=9A

Playing with the Chinese I18N support, I see?  :-)

Hmm....

> =E5=9C=A8 2008-08-01=E4=BA=94=E7=9A=84 01:49 -0400=EF=BC=8C=E6=9B=B9=E5=
=AD=90=E5=BE=B7  =E5=86=99=E9=81=93=EF=BC=9A

> But, ext4_delete_inode()'s transaction and ext4_truncate()'s transact=
ion
> are different,  ext4_truncate() transaction is nested inside
> ext4_delete_inode.

Yes, the way transaction nesting works is that the amount of credits
requested in the nested transactions is completely ignored.  The only
thing that matters is the amount of credits requested in the top-level
transaction handl, which in the case of ext4_delete_inode(), is in the
start_transaction(inode) call of ext4_delete_inode.  This amount is
blocks_for_truncate(inode).

> Currently ext4_delete_inode() uses blocks_for_truncate(inode) to
> calculate credits, by the time ext4_delete_inode() is called, i_block=
s
> seems to 0 (I need to double check this).=20

No, i_blocks will not be 0, because the inode will not have been
truncated yet.  That happens later; ext4_delete_inode() calls
ext4_truncate().  The problem is that blocks_for_truncate() caps the
number of credits at EXT4_MAX_TRANS_DATA, which is 64 credits.  So for
a very big, fragmented file, the number of credits will be
EXT4_DATA_TRANS_BLOCK + EXT4_DATA_TRANS_BLOCKS(sb).

If more credits are needed the truncate code is supposed to request
more.  This is true both for the extents and non-extents case.  The
difference is that in the non-extents case, the amount which is
requested to extend the transaction is determined by another call to
blocks_for_truncate(), which will be smaller because i_blocks will
decrease as part of the truncate operation.  In the extents case, the
amount needed is calculated precisely each time a leaf is removed.

That is I think the problem.  In practice it doesn't happen because
most of the time, the massive over-estimation of blocks_for_truncate()
of 64 credits is more than enough.  But bonnie++ creates some very
highly fragmented files, apparently.  (We later may want to see if we
can improve on its block layout).  At least, that's what I think is
happening...

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
