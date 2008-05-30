From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Test results for ext4
Date: Fri, 30 May 2008 15:58:37 -0500
Message-ID: <48406A7D.6020300@redhat.com>
References: <48402253.8040407@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYE3U7U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2008 16:59:20 -0400
In-Reply-To: <48402253.8040407@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Clement wrote:
> Hi all,
> 
> Since a couple of weeks, I did batches of tests to have some performance
> numbers for the new ext4 features like uninit_groups, flex_bg or
> journal_checksum on a 5TB filesystem.
> I tried to test allmost all combinations of mkfs and mount options, but
> I put only a subset of them in the result tables, the most significant
> for me.
> 
> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got several
> hangs and crashes occuring randomly outside ext4, sometimes in the slab
> code or in the scsi driver eg., and which were not reproductible.
> Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.
> 
> The first results and the test description are available here:
> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html
> 
> I will complete them in the next days.
> 
> In the first batch of tests, I compare the I/O throughput to create
> 1-GB files on disk in different configurations. The CPU usage is also
> given to show mainly how the delayed allocation feature reduces it.
> The average number of extents per file shows the impact of the
> multiblock allocator and the flex_bg grouping on the file fragmentation.
> At last, the fsck time shows how the uninit_groups feature reduces the
> e2fsck duration.
> 
> In the second batch of tests, the results show improvements in transactions
> -per-second throughput when doing small files writes, reads and creates
> when using the flex_bg grouping.
> The same ffsb test on an XFS filesystem hangs, I will try to have traces.
> 
> If you are interested in other tests, please let me know.

Valerie, would you be interested in any xfs tuning?  :)

I don't know how much tuning is "fair" for the comparison... but I think
in real usage xfs would/should get tuned a bit for a workload like this.

At the 5T range xfs gets into a funny allocation mode...

If you mount with "-o inode64" I bet you see a lot better performance.

Or, you could do sysctl -w fs.xfs.rotorstep=256

which would probably help too.

with a large fs like this, the allocator gets into a funny mode to keep
inodes in the lower part of the fs to keep them under 32 bits, and
scatters the data allocations around the higher portions of the fs.

Either -o inode64 will completely avoid this, or the rotorstep should
stop it from scattering each file, but instead switching AGs only every
256 files.

Could you also include the xfsprogs version on your summary pages, and
maybe even the output of xfs_info /mount/point so we can see the full fs
geometry?  (I'd suggest maybe tune2fs output for the ext[34] filesystems
too, for the same reason)

When future generations look at the results it'll be nice to have as
much specificity about the setup as possible, I think.

Thanks,
-Eric
