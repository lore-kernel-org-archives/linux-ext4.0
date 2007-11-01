From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Thu, 01 Nov 2007 14:05:40 -0500
Message-ID: <472A2384.2010001@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <bzzz.tomas@gmail.com>,
	Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbXKATFq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2007 15:05:46 -0400
In-Reply-To: <4729EEB2.9090406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Alex Tomas wrote:
>> please, try the patch attached.
> 
> Looks quite a bit better:
> 
> http://people.redhat.com/esandeen/seekwatcher/ext4-alex.png
> http://people.redhat.com/esandeen/seekwatcher/ext4-alex-ext4-dd-write.png
> http://people.redhat.com/esandeen/seekwatcher/ext4-alex-ext4-xfs-dd-write.png
> 
> It is much less fragmented, although still not exactly the nice linear
> allocation I'd expect from a single threaded large write on a fresh fs...

Note, we're still getting out-of-order extents, too:

First block: 122880
Last block: 2694143
Discontinuity: Block 7424 is at 101376 (was 130303)
Discontinuity: Block 28160 is at 133120 (was 122111)
Discontinuity: Block 58368 is at 188416 (was 163327)
Discontinuity: Block 66304 is at 180224 (was 196351)
Discontinuity: Block 73984 is at 172032 (was 187903)
Discontinuity: Block 81664 is at 167936 (was 179711)
Discontinuity: Block 84736 is at 221184 (was 171007)
Discontinuity: Block 92416 is at 212992 (was 228863)
Discontinuity: Block 100096 is at 204800 (was 220671)
Discontinuity: Block 107776 is at 198656 (was 212479)
...

I'm trying to find time to look into this but other things are knocking
at my door so no promises...

-Eric
