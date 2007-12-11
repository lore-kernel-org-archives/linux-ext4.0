From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Tue, 11 Dec 2007 16:15:28 -0700
Message-ID: <20071211231528.GS3214@webber.adilger.int>
References: <20071206161045.1054bbe7@gara> <20071207101428.GE3214@webber.adilger.int> <20071207095212.037ca68a@gara> <20071211110033.GQ3214@webber.adilger.int> <20071211100812.557b923b@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:45414 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbXLKXPc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2007 18:15:32 -0500
Content-Disposition: inline
In-Reply-To: <20071211100812.557b923b@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 11, 2007  10:08 -0600, Jose R. Santos wrote:
> > I'd think being able to avoid the divide for every inode allocation is more
> > important than 8 bits in the superblock.
> 
> We already avoid the divide since what we store in the sbi IS the bits
> which are calculated at mount time for each fs.  Base on the other
> fields in the super block struct, I decided to put explicit size of the
> flexbg in the super block.  The kernel code can decide how best to use
> that number which in this case its used to calculate the number of bits
> in order to avoid doing divides.
> 
> So this is really a styling issue in how to record data in the super
> block.  The only technical issue with this is whether it's important to
> save those extra 8 bits in the super block struct.

Well, if it is stored in the superblock as a non-power-of-two value, then
there always exists the possibility that it is set incorrectly (maybe by
a version of mke2fs that doesn't verify this) and the code will not do the
right thing.  Storing it in bits (as is done with e.g. s_log_block_size and
s_log_frag_size) ensures there is no possibility of a value that isn't a
power-of-two.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
