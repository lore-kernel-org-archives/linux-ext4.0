From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v3] ext4: check for overlapping extents in
 ext4_valid_extent_entries()
Date: Tue, 3 Dec 2013 21:36:00 -0500
Message-ID: <20131204023600.GB15658@thunk.org>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
 <alpine.LFD.2.00.1310211751370.1983@localhost.localdomain>
 <20131022184030.GC2708@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36242 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab3LDCgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 21:36:06 -0500
Content-Disposition: inline
In-Reply-To: <20131022184030.GC2708@dhcp-13-216.nay.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 23, 2013 at 02:40:30AM +0800, Eryu Guan wrote:
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
> Also add the check for (ee_block + len - 1) in ext4_valid_extent() to
> make sure the value is not overflow.
>=20
> Ran xfstests on patched ext4 and no regression.
>=20
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, applied.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
