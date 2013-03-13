From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Metadata reservation for unwritten extent conversion
Date: Wed, 13 Mar 2013 17:09:51 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303131706180.18319@dhcp-1-104.brq.redhat.com>
References: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1399936448-1363190995=:18319"
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab3CMQJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 12:09:56 -0400
In-Reply-To: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1399936448-1363190995=:18319
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 13 Mar 2013, Luká¨ Czerner wrote:

> Date: Wed, 13 Mar 2013 16:48:49 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: Metadata reservation for unwritten extent conversion
> 
> Hi Ted,
> 
> turns out that I've been wrong with my assumption that we can count
> with metadata reservations for the unwritten extent conversion. So
> the patch I've proposed:
> 
>  ext4: Reserve metadata if writing into uninitialized
> 
> which I think you've already merged into the devel branch is not
> particularly useful and it should be reverted. Reverting this will
> not cause any problem to reappear and in fact it should get rid of
> some of the warnings about more metadata blocks being allocated than
> reserved.

Well, we can not actually revert that patch because it introduces
da_reserve_metadata() which is used elsewhere in the commit:

ext4: reserve metadata block for every delayed write


I can resend the patch which uses da_reserve_metadata() so you can use
it instead the old version and just drop the

ext4: Reserve metadata if writing into uninitialized


or I can fix it in separate patch. Which would you prefer ?

-Lukas

> 
> The problem is that even though we're able to reserve the metadata
> for the possible conversion, we can never know when to free the
> metadata reservation. Currently we're freeing the metadata
> reservation (which is usually overestimated because we never know
> for sure how much metadata will actually be needed) when the number
> of reserved data blocks drop to zero. However since we only need to
> reserve metadata (and not data) blocks when writing into unwritten
> extent, this approach does not work and we would free reserved
> metadata even if we might still need it - there is no way to tell
> whether we're going to need it or not in writeback path.
> 
> However even after the revert we're still left with the problem
> with unwrittent extent conversion in dealloc path. I've attempted
> to solved it with similar mechanism which xfs has - block reserve pool.
> 
> Blocks from this reserve pool should be removed from the global pool
> and no one would be able to allocate from it, unless:
> 
> 1. we're in delalloc path and we need space for metadata allocation
>    in unwritten extent conversion,
> 
>    This should solve the problem with not having enough metadata in
>    ENOSPC condition in delayed allocation writeback path.
> 
> 2. we're in punch hole path and we need space for metadata
>    allocation when splitting extents
> 
>    This should solve the problem when we do not have _any_ space at
>    all and we attempt to punch a hole into the file resulting in the
>    need for new extent tree block. Punch hole should succeed even in
>    ENOSPC conditions since we're actually freeing space.
> 
> 3. we're writing into unwritten (preallocated) extent and we're in
>    ENOSPC condition - not having any blocks to allocated metadata
>    for unwritten extent conversion.
> 
>    This should solve the problem when we can return ENOSPC even when
>    writing into preallocated space which is certainly unexpected
>    (xfstest 274).
> 
> 
> I already have a patch which implements that, but it need some
> tweaks and some more testing, so I'll send it probably later this
> week, as well as more metadata reservation fixes (not related to
> unwritten extent conversion).
> 
> 
> 
> Let me know what do you think.
> 
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1399936448-1363190995=:18319--
