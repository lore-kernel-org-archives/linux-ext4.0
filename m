From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Wed, 9 Oct 2013 15:10:28 -0700
Message-ID: <20131009221028.GN6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012649.28415.17225.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310031848270.1947@localhost.localdomain>
 <20131003190444.GA14971@birch.djwong.org>
 <20131007130328.GA4540@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23141 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3JIWKg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Oct 2013 18:10:36 -0400
Content-Disposition: inline
In-Reply-To: <20131007130328.GA4540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 09:03:28AM -0400, Theodore Ts'o wrote:
> On Thu, Oct 03, 2013 at 12:04:44PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 03, 2013 at 06:53:38PM +0200, Luk=C3=A1=C5=A1 Czerner w=
rote:
> > > On Mon, 30 Sep 2013, Darrick J. Wong wrote:
> > >=20
> > > > Date: Mon, 30 Sep 2013 18:26:49 -0700
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > > Cc: linux-ext4@vger.kernel.org
> > > > Subject: [PATCH 01/31] tune2fs: Don't convert block # to cluste=
r # when
> > > >     clearing uninit_bg
> > > >=20
> > > > When we're constructing the initial block bitmap as part of rem=
oving the
> > > > gdt_csum (i.e. uninit_bg) feature, we mustn't convert the block=
 numbers to
> > > > cluster numbers because ext2fs_mark_block_bitmap2() does this f=
or us.
> > >=20
> > > I wonder if it's possible to use the old-style bitmap interface (=
the
> > > one which does not understand 64-bit bitmaps). If so, then you al=
so
> > > need to fix ext2fs_mark_generic_bmap() (and others) so that we
> > > convert blocks to clusters if needed.
> >=20
> > It's possible to do this (bad thing) by not specifying EXT2_FLAG_64=
BITS when
> > calling ext2fs_openfs(); see patch 26 for a quick fix.
>=20
> Bigalloc requires the new-style bitmaps, so patch 26 is the right fix
> for this.

Any thoughts on patch #1?  It fixes bugs in the recently-landed patch "=
tune2fs:
zero inode table when removing checksums".

--D
>=20
> 						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
