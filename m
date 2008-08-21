From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 00:06:44 -0500
Message-ID: <48ACF7E4.6040005@redhat.com>
References: <20080820054339.GB6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYHUFLx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2008 01:11:53 -0400
In-Reply-To: <20080820054339.GB6381@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Hi,
> 
> I am getting this even with the latest patch queue. The test program is
> a modified fsstress with fallocate support.
> 
> mpage_da_map_blocks block allocation failed for inode 377954 at logical
> offset 313 with max blocks 4 with error -28
> mpage_da_map_blocks block allocation failed for inode 336367 at logical
> offset 74 with max blocks 9 with error -28
> mpage_da_map_blocks block allocation failed for inode 345560 at logical
> offset 542 with max blocks 7 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 355317 at logical
> offset 152 with max blocks 10 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 395261 at logical
> offset 462 with max blocks 1 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 323784 at logical
> offset 313 with max blocks 11 with error -28
> This should not happen.!! Data will be lost

So, I really need to un-bury myself and read this thread more carefully,
but:  It may be interesting to look at what XFS did for this sort of
problem a couple of years ago.

-Eric


From: David Chinner <dgc@sgi.com>
Date: Tue, 14 Mar 2006 02:13:09 +0000 (+1100)
Subject: [XFS] On machines with more than 8 cpus, when running parallel I/O
X-Git-Tag: v2.6.17-rc1~1000^2~69
X-Git-Url: X-Git-Url:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=8d280b98cfe3c0b69c37d355218975c1c0279bb0

[XFS] On machines with more than 8 cpus, when running parallel I/O
threads, the incore superblock lock becomes the limiting factor for
buffered write throughput. Make the contended fields in the incore
superblock use per-cpu counters so that there is no global lock to limit
scalability.

SGI-PV: 946630
SGI-Modid: xfs-linux-melb:xfs-kern:25106a

Signed-off-by: David Chinner <dgc@sgi.com>
Signed-off-by: Nathan Scott <nathans@sgi.com>

-Eric
