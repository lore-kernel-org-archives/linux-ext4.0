From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Thu, 6 Aug 2009 16:04:01 -0400
Message-ID: <20090806200400.GC1800@shell>
References: <28623.1249307676@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbZHFUEC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Aug 2009 16:04:02 -0400
Content-Disposition: inline
In-Reply-To: <28623.1249307676@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 03, 2009 at 09:54:36AM -0400, Nick Dokos wrote:
> Just a heads-up for now. I ran ll_ver_fs on a 96TB fs - the write phase
> finished without problems, but the read phase encountered a problem:
> 
> ...
> read File name: /mnt/dir00373/file026
> 
> liverfs: verify /mnt/dir00373/file026 failed offset/timestamp/inode 3244298240/1248819541/1096796: found 3243249664/1248819541/1096796 instead
> 
> liverfs: Data verification failed
> 770.45user 218639.65system 67:38:18elapsed 90%CPU (0avgtext+0avgdata 0maxresident)k
> 100357573552inputs+195522668184outputs (1major+414minor)pagefaults 0swaps
> make: *** [llver] Error 2
> 
> 
> The offset difference is exactly 1M, and it occurs about 3GB into the file.

Interesting - exactly 1M off.  Does this correspond to anything
interesting in extent layout or block allocation boundaries?

Any chance you can patch ll_ver_fs to continue after the first error?
I'd be happy to write the patch for you.

> In total, there are 726 directories, each with 32 4GB files (except the last,
> which only has 12 files). So directory 373 is roughly half-way. I'll take a look
> at the block allocation of both the directory and the file and see if they are
> straddling the 16TB boundary (or other such).

Did you have a chance to look at what falls before and after the 16TB
boundary?

Thanks,

-VAL
