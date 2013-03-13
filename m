From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Metadata reservation for unwritten extent conversion
Date: Wed, 13 Mar 2013 16:48:49 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab3CMPsx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 11:48:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

turns out that I've been wrong with my assumption that we can count
with metadata reservations for the unwritten extent conversion. So
the patch I've proposed:

 ext4: Reserve metadata if writing into uninitialized

which I think you've already merged into the devel branch is not
particularly useful and it should be reverted. Reverting this will
not cause any problem to reappear and in fact it should get rid of
some of the warnings about more metadata blocks being allocated than
reserved.

The problem is that even though we're able to reserve the metadata
for the possible conversion, we can never know when to free the
metadata reservation. Currently we're freeing the metadata
reservation (which is usually overestimated because we never know
for sure how much metadata will actually be needed) when the number
of reserved data blocks drop to zero. However since we only need to
reserve metadata (and not data) blocks when writing into unwritten
extent, this approach does not work and we would free reserved
metadata even if we might still need it - there is no way to tell
whether we're going to need it or not in writeback path.

However even after the revert we're still left with the problem
with unwrittent extent conversion in dealloc path. I've attempted
to solved it with similar mechanism which xfs has - block reserve pool.

Blocks from this reserve pool should be removed from the global pool
and no one would be able to allocate from it, unless:

1. we're in delalloc path and we need space for metadata allocation
   in unwritten extent conversion,

   This should solve the problem with not having enough metadata in
   ENOSPC condition in delayed allocation writeback path.

2. we're in punch hole path and we need space for metadata
   allocation when splitting extents

   This should solve the problem when we do not have _any_ space at
   all and we attempt to punch a hole into the file resulting in the
   need for new extent tree block. Punch hole should succeed even in
   ENOSPC conditions since we're actually freeing space.

3. we're writing into unwritten (preallocated) extent and we're in
   ENOSPC condition - not having any blocks to allocated metadata
   for unwritten extent conversion.

   This should solve the problem when we can return ENOSPC even when
   writing into preallocated space which is certainly unexpected
   (xfstest 274).


I already have a patch which implements that, but it need some
tweaks and some more testing, so I'll send it probably later this
week, as well as more metadata reservation fixes (not related to
unwritten extent conversion).



Let me know what do you think.

Thanks!
-Lukas
