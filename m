From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] ext4: check for overlapping extents in
 ext4_valid_extent_entries()
Date: Mon, 21 Oct 2013 20:47:31 +0800
Message-ID: <20131021124731.GB2708@dhcp-13-216.nay.redhat.com>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
 <20131021115954.GA2708@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45532 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3JUMrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 08:47:36 -0400
Received: by mail-pa0-f42.google.com with SMTP id kx10so8011588pab.15
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 05:47:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131021115954.GA2708@dhcp-13-216.nay.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 21, 2013 at 07:59:54PM +0800, Eryu Guan wrote:
> On Sun, Oct 20, 2013 at 09:27:27PM +0800, Eryu Guan wrote:
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
> > length to ext4_es_cache_extent(). Fix it by checking for overlappin=
g
> > extents in ext4_valid_extent_entries().
> >=20
> > I hit this when fuzz testing ext4, and am able to reproduce it by
> > modifying the on-disk extent by hand.
> >=20
> > Ran xfstests on patched ext4 and no regression.
> >=20
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>=20
> Self NAK, I found problems in tests, will think about it more.

Ah, the error messages in dmesg I've seen are from previous tests, so
there're no problems. Withdraw the self NAK.

Sorry for the noise..

Thanks,
Eryu
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
