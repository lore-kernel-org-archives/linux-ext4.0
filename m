From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Mon, 5 Sep 2011 11:55:24 -0700
Message-ID: <20110905185524.GR12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com> <20110902182214.GC12086@tux1.beaverton.ibm.com> <yq1d3fgwn5c.fsf@sermon.lab.mkp.net> <6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org> <yq14o0scjmg.fsf@sermon.lab.mkp.net> <88f8907569619968aa7b4a8c669d5aba.squirrel@www.firstfloor.org> <yq139gcymqj.fsf@sermon.lab.mkp.net>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37452 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1IESz2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 14:55:28 -0400
Content-Disposition: inline
In-Reply-To: <yq139gcymqj.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 04, 2011 at 06:19:16PM -0400, Martin K. Petersen wrote:
> >>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:
> 
> Andi> Doesn't have any performance numbers.
> 
> It's been a while since I read them. I thought they had some compelling
> numbers. Anyway, made a big difference in real life testing here. For
> sustained I/O we're talking an order of magnitude.
> 
> 
> Andi> You need to keep in mind that PCLMULQDQ uses FPU state, so any
> Andi> speedup for the kernel must be large enough to amortize the cost
> Andi> of saving the FPU state.
> 
> Yeah, my test cases were for bulk database I/O, not for writing a
> handful of fs metadata blocks. Plus for the DB tests the CRC was
> generated in userland.
> 
> I seem to recall Joel picking something other than the hw-accelerated
> CRC32C for ocfs2 metadata and that didn't cause any problems.

Yes, he picked regular CRC32, which has a reasonably fast slice-by-4
software implementation.  For ext4, my original choices were hw acceleration or
the slower single-byte lookup table.  With hw acceleration the overhead of
adding the checksums is about ~10% (for just the metadata operations); with the
single-byte table it was about 50%; and with the proposed slice-by-8 patch it's
about 20%.  Hopefully I can optimize this even more in the future.

> That said, I do see a difference between IP checksum and CRC on normal
> FS workloads with DIX enabled here.

I would hope so, since the IP checksum is much simpler than any CRC...

--D

> Andi> Typically that only works out for quite large buffers, but kernel
> Andi> buffers are relatively small.
> 
> *nod*
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
