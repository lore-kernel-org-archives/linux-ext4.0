From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Thu, 10 Sep 2009 16:57:38 -0500
Message-ID: <4AA97652.4010802@redhat.com>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com> <20090910215158.GI9372@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbZIJV5g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 17:57:36 -0400
In-Reply-To: <20090910215158.GI9372@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 10, 2009  16:16 -0500, Eric Sandeen wrote:
>> Any suggestions on the naming issues?  (what's the official name for a
>> "not-extent-based-file?")
> 
> I've always used "block mapped" (i.e. mapped block-by-block) vs.
> "extent mapped".
> 
>> However, Ric just ran a massive fs_mark test on a 60T filesystem that he
>> created with "mke2fs" (no extents and no journal - accidentally) and we
>> got no corruption even without this patch.
>>
>> I need to see if a filesystem w/o the extents feature (at all, vs. some
>> old-format files on an extents fs) never even tries to allocate past
>> 2^32; I didn't think so, but now not so sure.
> 
> Well, it may depend a lot on which inodes are in use.  That will set the
> goal block, and may prevent any above-16TB allocations.  Either you could

yep, though I had many, many inodes in the high groups ...

Problem is I don't quite trust debugfs etc to get it right, so when I
see < 32 bits, I'm not sure if it's really there, or if the
reporting/debug tool wrapped it ;)

-Eric
