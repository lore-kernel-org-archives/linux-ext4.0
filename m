From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3 (was Ext2)
Date: Thu, 24 Apr 2008 16:10:33 -0500
Message-ID: <4810F749.7000802@redhat.com>
References: <d9885f0f0710261658p218050d9mdf64714ddb8d47f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Abhishek Rai <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYDXVKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 17:10:36 -0400
In-Reply-To: <d9885f0f0710261658p218050d9mdf64714ddb8d47f1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Abhishek Rai wrote:
> This patch modifies the block allocation strategy in ext3 in order to
> improve fsck performance. This was initially sent out as a patch for
> ext2, but given the lack of ongoing development on ext2, I have
> crossported it to ext3 instead. Slow fsck is not a serious problem on
> ext3 due to journaling, but once in a while users do need to run full
> fsck on their ext3 file systems. This can be due to several reasons:
> (1) bad disk, bad crash, etc, (2) bug in jbd/ext3, and (3) every few
> reboots, it's good to run fsck anyway. This patch will help reduce
> full fsck time for ext3. I've seen 50-65% reduction in fsck time when
> using this patch on a near-full file system. With some fsck
> optimizations, this figure becomes 80%.

For what it's worth, this speeds large file removals, too:

http://people.redhat.com/esandeen/rm_test/ext3_metacluster_rm.png
http://people.redhat.com/esandeen/rm_test/ext3_rm.png

That's 22s vs. 73s for a 56G file on a fresh 100G filesystem, removed
after a fresh remount (cold cache).

If I actually preload all of the indirect blocks (I used filefrag):

http://people.redhat.com/esandeen/rm_test/ext3_preload_rm.png

it comes in at 6 seconds...

For comparison, stock ext4 from 2.6.25 clocks in at 6s, and xfs is
basically instantaneous.  (btrfs default is 6s, and btrfs with no data
checksumming is on par with xfs).

-Eric
