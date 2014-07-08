From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: clarify ext4_error message in
 ext4_mb_generate_buddy_error()
Date: Tue, 8 Jul 2014 08:54:54 -0400
Message-ID: <20140708125454.GA22156@thunk.org>
References: <1404602162-16730-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1407080855520.2180@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51172 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbaGHMy5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 08:54:57 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407080855520.2180@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 08, 2014 at 09:03:48AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> It is a bit better, even though strictly speaking it's not
> right, because it is not block bitmap alone, but rather aggregation
> of block bitmap and preallocations. But for the user this is really
> an implementation detail they do not need to worry about I guess.

Actually, no, because the preallocations aren't reflected in the
in-block bitmap.

And, oh sh*t, I wonder if that's the cause of the
ext4_mb_generate_buddy().  We don't need the buddy bitmaps to allocate
out of the preallocations, and it's not needed by
ext4_mb_mark_diskspace_used().  If the buddy bitmaps have been pushed
out of the page cache between when the blocks were originally
preallocated and when we try to use some preallocated blocks, and then
we have a race between ext4_mb_mark_diskspace_used() and
ext4_mb_buddy_generate(), that could explain the discrepancy between
the block group descriptors and the loaded buddy bitmap.

If this is what's going on, it doesn't explain why we hacen't been
seeing this until post 3.15, though....

				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
