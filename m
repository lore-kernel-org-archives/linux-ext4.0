From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Wed, 31 Oct 2007 16:01:47 -0500
Message-ID: <4728ED3B.1060407@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex.tomas@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955AbXJaVBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Oct 2007 17:01:52 -0400
In-Reply-To: <20071026221938.GV3042@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> One of the issues is that w/o delalloc the mballoc code only gets 
> single-block allocations, so there might be a problem with the interface
> to mballoc.  That might be caused by the fact the patches were changed
> at one point from delalloc-atop-mballoc to mballoc-atop-delalloc, and
> something was missed in that conversion.

I've been testing this with a 16x1MB buffered dd to a fresh filesystem;
it gets 7 extents, and out of order.  :(

First block: 37120
Last block: 63427
Discontinuity: Block 1024 is at 38400 (was 38143)
Discontinuity: Block 1036 is at 57344 (was 38411)
Discontinuity: Block 2048 is at 38412 (was 58355)
Discontinuity: Block 2072 is at 61440 (was 38435)
Discontinuity: Block 3072 is at 38436 (was 62439)
Discontinuity: Block 3108 is at 62440 (was 38471)
/mnt/test/testfile: 7 extents found

One thing that seems to be happening is that thanks to delalloc, a nice
big request is coming in (only 1036 blocks of the 4096, not quite sure
why), but then it gets into ext4_mb_normalize_request(), which finds the
most blocks it can "preallocate" is 256, and chops down the request to
256 blocks.  Shouldn't this preallocation be over & above what was asked
for, vs. reducing the request?

Ok, so, we get allocations in 256-block chunks...  Why they don't all
come out contiguous, I don't know yet...

-Eric
