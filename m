From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Thu, 10 Sep 2009 16:16:32 -0500
Message-ID: <4AA96CB0.3090309@redhat.com>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910211006.GF9372@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZIJVQa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 17:16:30 -0400
In-Reply-To: <20090910211006.GF9372@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 10, 2009  11:02 -0500, Eric Sandeen wrote:
>> This patch limits such allocations to < 232, and adds
>> WARN_ONs (maybe should be BUG_ONs) if we do get blocks
>> larger than that.
> 
> Given that this may corrupt the filesystem (e.g. block
> 2^32 turning into block 0 and overwriting the superblock)
> I think a BUG_ON() is probably more appropriate.  This
> should only happen with software bugs, so it is more
> appropriate than ext4_error() I think.

Ok, fine by me.  I can send an update.

Any suggestions on the naming issues?  (what's the official name for a
"not-extent-based-file?")

I ran it a lot through a mkfs/mount/fsstress/unmount/fsck cycle, and all
seemed well.  mkfs was without extents, so I was thinking we were in
good shape.

However, Ric just ran a massive fs_mark test on a 60T filesystem that he
created with "mke2fs" (no extents and no journal - accidentally) and we
got no corruption even without this patch.

I need to see if a filesystem w/o the extents feature (at all, vs. some
old-format files on an extents fs) never even tries to allocate past
2^32; I didn't think so, but now not so sure.

I probably need to do more testing ...

-Eric
