From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3 (was Ext2)
Date: Sun, 4 May 2008 16:09:55 -0400
Message-ID: <170fa0d20805041309p144782ddm82233bb046d3130e@mail.gmail.com>
References: <d9885f0f0710261658p218050d9mdf64714ddb8d47f1@mail.gmail.com>
	 <4810F749.7000802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Eric Sandeen" <sandeen@redhat.com>,
	"Andreas Dilger" <adilger@sun.com>, linux-ext4@vger.kernel.org
To: "Abhishek Rai" <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:56317 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbYEDUJ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 May 2008 16:09:56 -0400
Received: by wf-out-1314.google.com with SMTP id 27so846765wfd.4
        for <linux-ext4@vger.kernel.org>; Sun, 04 May 2008 13:09:55 -0700 (PDT)
In-Reply-To: <4810F749.7000802@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 24, 2008 at 5:10 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> Abhishek Rai wrote:
>  > This patch modifies the block allocation strategy in ext3 in order to
>  > improve fsck performance. This was initially sent out as a patch for
>  > ext2, but given the lack of ongoing development on ext2, I have
>  > crossported it to ext3 instead. Slow fsck is not a serious problem on
>  > ext3 due to journaling, but once in a while users do need to run full
>  > fsck on their ext3 file systems. This can be due to several reasons:
>  > (1) bad disk, bad crash, etc, (2) bug in jbd/ext3, and (3) every few
>  > reboots, it's good to run fsck anyway. This patch will help reduce
>  > full fsck time for ext3. I've seen 50-65% reduction in fsck time when
>  > using this patch on a near-full file system. With some fsck
>  > optimizations, this figure becomes 80%.
>
>  For what it's worth, this speeds large file removals, too:
>
>  http://people.redhat.com/esandeen/rm_test/ext3_metacluster_rm.png
>  http://people.redhat.com/esandeen/rm_test/ext3_rm.png
>
>  That's 22s vs. 73s for a 56G file on a fresh 100G filesystem, removed
>  after a fresh remount (cold cache).
>
>  If I actually preload all of the indirect blocks (I used filefrag):
>
>  http://people.redhat.com/esandeen/rm_test/ext3_preload_rm.png
>
>  it comes in at 6 seconds...
>
>  For comparison, stock ext4 from 2.6.25 clocks in at 6s, and xfs is
>  basically instantaneous.  (btrfs default is 6s, and btrfs with no data
>  checksumming is on par with xfs).

Abhishek,

Given the favorable results Eric posted and the prospect for
significantly reduced fsck times with your patch; what is the status
of your patch?

Do you have an updated version of your patch for ext3 that should get
further testing?

please advise, thanks.
Mike
