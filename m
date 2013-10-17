From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't cache out of order extents
Date: Thu, 17 Oct 2013 10:40:44 -0400
Message-ID: <20131017144044.GA3605@thunk.org>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47292 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab3JQOkr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 10:40:47 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 03:44:35PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> So what will happen with the file system with this patch when
> presented with such corruption ?
>=20
> It seems to me that ext4_es_cache_extent() will happily skip this
> extent because it will find that this particular offset is already
> in the tree. Hence we'll have a gap in the status tree which really
> should not be there and I suspect that something bad will happen.

Ah, I see what's going wrong.  __read_extent_tree_block() calls
__ext4_ext_check() which is supposed to validate that extent tree
block is valid.  The __ext4_ext_check() function calls
ext4_valid_extent_entries() which is supposed to validate the
individual entries in the extent.  However, it is not checking to make
sure there are no overlapping extents.  We should add that check to
ext4_valid_extent_entries(); that way, we will call ext4_error_inode()
to mark the file system as corrupted.

Eryu's patch, or something like it, will still be needed so that in
the case of errors=3Dcountinue, we don't end up calling BUG_ON().

Thanks for finding this!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
