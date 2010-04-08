From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative metadata blocks
Date: Thu, 08 Apr 2010 12:20:34 +0400
Message-ID: <87sk76tkx9.fsf@openvz.org>
References: <4BBCFD10.3030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:46227 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab0DHIVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 04:21:00 -0400
In-Reply-To: <4BBCFD10.3030504@redhat.com> (Eric Sandeen's message of "Wed, 07
	Apr 2010 16:45:52 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> Because we can badly over-reserve metadata when we
> calculate worst-case, it complicates things for quota, since
> we must reserve and then claim later, retry on EDQUOT, etc.
> Quota is also a generally smaller pool than fs free blocks,
> so this over-reservation hurts more, and more often.
>
> I'm of the opinion that it's not the worst thing to allow
> metadata to push a user slightly over quota.  This simplifies
> the code and avoids the false quota rejections that result
> from worst-case speculation.
Hm.. Totally agree with issue description. And seem there is no another
solution except yours.
ASAIU alloc_nofail is called from places where it is impossible to fail
an allocation even if something goes wrong.
I ask because currently i'm working on EIO handling in alloc/free calls.
I've found that it is useless to fail claim/free procedures because
caller is unable to handle it properly.
It is impossible to fail following operation
->writepage
 ->dquot_claim_space (what to do if EIO happens?)
Seems that your nofail operations has same semantics because it is just
an equivalent of claim, but without reservation.
>
> This patch series stops the speculative quota-charging for
> worst-case metadata requirements, and just charges quota
> when the blocks are allocated at writeout.  It also is
> able to remove the try-again loop on EDQUOT.
>
> The first 2 patches are quota infrastructure changes,
> to change __dquot_alloc/free_space to take a flags argument,
> and then add a NOFAIL option, so that metadata writes which
> tip us over quota can proceed.
>
> The last patch makes the ext4 changes.  The whole batch
> has been tested indirectly by running the xfstests suite
> with a hack to mount & enable quota prior to the test.
>
> I also did a more specific test of fragmenting freespace
> and then doing a large delalloc write under quota; quota
> stopped me at the right amount of file IO, and then the
> writeout generated enough metadata (due to the fragmentation)
> that it put me slightly over quota, as expected.
>
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
