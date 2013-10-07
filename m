From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Mon, 7 Oct 2013 09:03:28 -0400
Message-ID: <20131007130328.GA4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012649.28415.17225.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310031848270.1947@localhost.localdomain>
 <20131003190444.GA14971@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43059 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab3JGNDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:03:33 -0400
Content-Disposition: inline
In-Reply-To: <20131003190444.GA14971@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 03, 2013 at 12:04:44PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 03, 2013 at 06:53:38PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > On Mon, 30 Sep 2013, Darrick J. Wong wrote:
> >=20
> > > Date: Mon, 30 Sep 2013 18:26:49 -0700
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: [PATCH 01/31] tune2fs: Don't convert block # to cluster =
# when
> > >     clearing uninit_bg
> > >=20
> > > When we're constructing the initial block bitmap as part of remov=
ing the
> > > gdt_csum (i.e. uninit_bg) feature, we mustn't convert the block n=
umbers to
> > > cluster numbers because ext2fs_mark_block_bitmap2() does this for=
 us.
> >=20
> > I wonder if it's possible to use the old-style bitmap interface (th=
e
> > one which does not understand 64-bit bitmaps). If so, then you also
> > need to fix ext2fs_mark_generic_bmap() (and others) so that we
> > convert blocks to clusters if needed.
>=20
> It's possible to do this (bad thing) by not specifying EXT2_FLAG_64BI=
TS when
> calling ext2fs_openfs(); see patch 26 for a quick fix.

Bigalloc requires the new-style bitmaps, so patch 26 is the right fix
for this.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
