From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Thu, 13 Dec 2007 09:51:12 -0600
Message-ID: <20071213095112.100b3d9e@gara>
References: <20071206161045.1054bbe7@gara>
	<20071207101428.GE3214@webber.adilger.int>
	<20071207095212.037ca68a@gara>
	<20071211110033.GQ3214@webber.adilger.int>
	<20071211100812.557b923b@gara>
	<20071211231528.GS3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:44157 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbXLMPv0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2007 10:51:26 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBDFpK72004731
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 10:51:20 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBDFpJM6126744
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 08:51:20 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBDFpJcS027350
	for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2007 08:51:19 -0700
In-Reply-To: <20071211231528.GS3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 11 Dec 2007 16:15:28 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Dec 11, 2007  10:08 -0600, Jose R. Santos wrote:
> > > I'd think being able to avoid the divide for every inode allocation is more
> > > important than 8 bits in the superblock.
> > 
> > We already avoid the divide since what we store in the sbi IS the bits
> > which are calculated at mount time for each fs.  Base on the other
> > fields in the super block struct, I decided to put explicit size of the
> > flexbg in the super block.  The kernel code can decide how best to use
> > that number which in this case its used to calculate the number of bits
> > in order to avoid doing divides.
> > 
> > So this is really a styling issue in how to record data in the super
> > block.  The only technical issue with this is whether it's important to
> > save those extra 8 bits in the super block struct.
> 
> Well, if it is stored in the superblock as a non-power-of-two value, then
> there always exists the possibility that it is set incorrectly (maybe by
> a version of mke2fs that doesn't verify this) and the code will not do the
> right thing.  Storing it in bits (as is done with e.g. s_log_block_size and
> s_log_frag_size) ensures there is no possibility of a value that isn't a
> power-of-two.

While I don't necessary buy the mke2fs example (the only patch that
set this already checks for power-of-two), you are right about the
possibility of being set incorrectly.  I will change it to store the
bits in the next release which I'll do after I fix the resize2fs issues
since this will require changes to the e2fsprogs as well.

Now, storing the bits only guaranties that the flexbg size is always a
power-of-two and does not guarantee that the super block flexbg size
represents the actual meta-data grouping on disk.  For this we need to
verify that the bitmap offsets match what the super block reports.  It
may be an unlikely scenario, but it may be worth it to check this as
well at mount time.

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 


-JRS
