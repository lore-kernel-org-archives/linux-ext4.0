From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] ext4: check for overlapping extents in
 ext4_valid_extent_entries()
Date: Mon, 21 Oct 2013 19:59:54 +0800
Message-ID: <20131021115954.GA2708@dhcp-13-216.nay.redhat.com>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36780 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3JUL77 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 07:59:59 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so6937872pbb.27
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 04:59:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 20, 2013 at 09:27:27PM +0800, Eryu Guan wrote:
> A corrupted ext4 may have out of order leaf extents, i.e.
>=20
> extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
> extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
>              ^^^^ overlap with previous extent
>=20
> Reading such extent could hit BUG_ON() in ext4_es_cache_extent().
>=20
> 	BUG_ON(end < lblk);
>=20
> The problem is that __read_extent_tree_block() tries to cache holes a=
s
> well but assumes 'lblk' is greater than 'prev' and passes underflowed
> length to ext4_es_cache_extent(). Fix it by checking for overlapping
> extents in ext4_valid_extent_entries().
>=20
> I hit this when fuzz testing ext4, and am able to reproduce it by
> modifying the on-disk extent by hand.
>=20
> Ran xfstests on patched ext4 and no regression.
>=20
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Self NAK, I found problems in tests, will think about it more.

Thanks,
Eryu
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
