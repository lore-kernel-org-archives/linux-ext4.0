From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: don't cache out of order extents
Date: Thu, 17 Oct 2013 23:06:30 +0800
Message-ID: <20131017150630.GC11404@dhcp-13-216.nay.redhat.com>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37536 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3JQPGf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Oct 2013 11:06:35 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so2446421pbb.0
        for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 08:06:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 03:44:35PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 17 Oct 2013, Eryu Guan wrote:
>=20
> > Date: Thu, 17 Oct 2013 17:27:53 +0800
> > From: Eryu Guan <guaneryu@gmail.com>
> > To: linux-ext4@vger.kernel.org
> > Cc: Eryu Guan <guaneryu@gmail.com>, Theodore Ts'o <tytso@mit.edu>
> > Subject: [PATCH] ext4: don't cache out of order extents
> >=20
> > A corrupted ext4 may have out of order leaf extents, i.e.
> >=20
> > extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
> > extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
> >              ^^^^ overlap with previous extent
> >=20
> > Reading such extent could hit BUG_ON() in ext4_es_cache_extent().
> >=20
> > 	BUG_ON(end < lblk);
> >=20
> > The problem is that __read_extent_tree_block() tries to cache holes=
 as
> > well but assumes 'lblk' is greater than 'prev' and passes underflow=
ed
> > length to ext4_es_cache_extent().
> >=20
> > I hit this when fuzz testing ext4, and am able to reproduce it by
> > modifying the on-disk extent by hand.
> >=20
> > Ran xfstests on patched ext4 and no regression.
>=20
> So what will happen with the file system with this patch when
> presented with such corruption ?
>=20
> It seems to me that ext4_es_cache_extent() will happily skip this
> extent because it will find that this particular offset is already
> in the tree. Hence we'll have a gap in the status tree which really
> should not be there and I suspect that something bad will happen.
>=20
> I think that we should deal with this corruption immediately when we
> spot it there, not just hide it.

Yes, agreed, we should validate the extent not cover the corruption as
Ted pointed out. Don't know why I didn't think about it more in the
first place..

Thanks!

Eryu Guan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
