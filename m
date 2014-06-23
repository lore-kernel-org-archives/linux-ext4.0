From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove metadata reservation checks
Date: Mon, 23 Jun 2014 08:59:58 -0400
Message-ID: <20140623125958.GB14887@thunk.org>
References: <1403490981-5457-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1406231140560.2169@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53053 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaFWNAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2014 09:00:00 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406231140560.2169@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 23, 2014 at 11:56:23AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> However I am still on the fence about this patch, because it was not
> designed, at least initially to cover all metadata reservation, but
> mainly those we sometimes can not predict (unwritten extent
> conversion for example), or those when the prediction failed (in
> this case we would see a warning).

I was driven to revisit this because we have a map reduce workload
that triggers the warning fairly consistently, and it's dirtying up
our logs and monitoring systems.  The prediction algorithm we are
using is actually pretty awful, unfortunately, and fixing it to do a
better job is non-trivial.

> I think that if we can be really sure, that the reserved space will
> always have enough space to cover all possible metadata blocks
> needed on writeback time (is there any other time we might need
> metadata block and can not fail with ENOSPC?), then this patch is
> definitely very useful.

The only time we need blocks where we can't fail with ENOSPC is
delayed allocation writeback and the unwritten extent conversion.  And
in both cases, the number of blocks we need are quite small; we can,
after all, fit 340 entries into each extent tree block.

The main worry I might have is the worst case scenario where have a
very small file system.  For example, if you create a file system
which is only 58k, we only have one free block.  But then again, such
a file system only has 4 free blocks, so it's physically impossible to
have any extent tree blocks.  :-)

Here's a potential carefully structured case where 2% of the free
blocks wouldn't be enough.  I'll let folks decide if we think this is
realistic enough that we need to care.  Suppose we have a 4M file
system, using 4k blocks, we would only have 51 reserved blocks.  On
such a file system, there would be 982 free blocks available to be
allocated.  If you then had 200 inodes that had exactly 4 extents
(using 4 blocks written using sparse writes), then there would be 182
free blocks.  If we then posted 100 sparse writes to half of these
inodes, we could end up using 100 data blocks, and also require 100
metadata blocks for the extent tree splits --- and we would then hit
the ENOSPC failure condition.

So this is a "proof" that 2% is quite enough for small file systems.
Do we care?  Eh.  I'm not at all convinced such a worst case scenario
could ever happen in real life, but we could fix this by adding a
"floor" to the 2% calculation so that we reserve at least 128 or 256
blocks.  Or we already have code which disables delayed allocation if
we are close to full, and we could extend that to cover super small
file systems, or simply entirely disable delalloc for super small file
systems in the first case.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
