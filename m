From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Thu, 10 Sep 2009 23:51:58 +0200
Message-ID: <20090910215158.GI9372@webber.adilger.int>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com>
 <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com>
 <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41383 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZIJVwC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 17:52:02 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8ALq2aY008681
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:52:02 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPR00200YVGPU00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 10 Sep 2009 14:52:02 -0700 (PDT)
In-reply-to: <4AA96CB0.3090309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 10, 2009  16:16 -0500, Eric Sandeen wrote:
> Any suggestions on the naming issues?  (what's the official name for a
> "not-extent-based-file?")

I've always used "block mapped" (i.e. mapped block-by-block) vs.
"extent mapped".

> However, Ric just ran a massive fs_mark test on a 60T filesystem that he
> created with "mke2fs" (no extents and no journal - accidentally) and we
> got no corruption even without this patch.
> 
> I need to see if a filesystem w/o the extents feature (at all, vs. some
> old-format files on an extents fs) never even tries to allocate past
> 2^32; I didn't think so, but now not so sure.

Well, it may depend a lot on which inodes are in use.  That will set the
goal block, and may prevent any above-16TB allocations.  Either you could
fill the bitmaps with 0xff (and zero the free blocks counters, to avoid
problems with mballoc), or actually fill the first 16TB of the filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

