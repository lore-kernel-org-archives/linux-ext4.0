From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More testing: 4x parallel 2G writes, sequential reads
Date: Wed, 07 Nov 2007 17:18:31 -0600
Message-ID: <473247C7.4020101@redhat.com>
References: <47323F73.5080708@redhat.com> <20071107230905.GQ3966@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbXKGXSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 18:18:34 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA7NIXLb011930
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 18:18:33 -0500
In-Reply-To: <20071107230905.GQ3966@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> The question is what the "best" result is for this kind of workload?
> In HPC applications the common case is that you will also have the data
> files read back in parallel instead of serially.

Agreed, I'm not trying to argue what's better or worse, I'm just seeing
what it's doing.

The main reason I did sequential reads back is that it more clearly
shows the file layout for each file on the graph.  :)  I'm just getting
a handle on how the allocations are going for various types of writes.

> The test shows ext4 finishing marginally faster in the write case, and
> marginally slower in the read case.  What happens if you have 4 parallel
> readers?

I'll test that a bit later (have to run now); I expect parallel readers
may go faster, since the blocks are interleaved, and it might be able to
suck them up pretty much in order across all 4 files.

I'd also like to test some of this under a single head, rather than on
HW raid...

-Eric
