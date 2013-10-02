From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of directory inodes
Date: Wed, 2 Oct 2013 13:02:37 -0400
Message-ID: <20131002170237.GB16076@kvack.org>
References: <20131001160817.GA2295@kvack.org> <20131002144759.GB32181@quack.suse.cz> <524C3574.7020106@redhat.com> <20131002162323.GB31579@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:58054 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab3JBRCi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 13:02:38 -0400
Content-Disposition: inline
In-Reply-To: <20131002162323.GB31579@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 02, 2013 at 12:23:23PM -0400, Theodore Ts'o wrote:
> Ext3 used an orlov style allocator as well.  The main difference
> between ext4 and ext3 is the orlov allocator is now done on a
> per-flexbg basis instead of per-blockgroup basis.
> 
> That is, we do the statistics based on a flex-bg basis instead of the
> blockgroup basis.  As a result, I suspect Ben would see the inode
> allocation behavior equivalent to ext3 if he creates the file system
> using "mke2fs -t ext4 -G 1" to force the flex_bg size to 1.
> 
> Can you let me know what the size of the file system was, and mke2fs
> parameters you were using for ext3 and ext4?  I have a feeling that
> inode allocations weren't optimal for your use case even with ext3,
> but because we now spread the inodes based on flex_bg's instead of
> block groups, that's why you saw the performance degredation.

This may have been a bit misleading -- other parts of the system changed 
between the version running on ext3 vs ext4.  Subdirectories weren't used 
as much on ext3 as on ext4, so the effect wasn't nearly as pronounced.  
It was on further investigation that showed that the spreading of inodes 
for directories was resulting in the files being laid out in different 
block groups, which made the operation of reading/writing files to disk 
much less sequential.

The other big change in allocation between ext3 and ext4 is mballoc.  
Without fallocate() on the files, the allocator in ext4 was preferentially 
aligning files to power-of-2 block numbers.  This lead to one of our 
tests where ~9MB files were used to have gaps of ~1800 blocks between 
files (even in the same directory), which degraded transfer rates to/from 
disk thanks to the extra seeks.  But this aspect of tweaking the allocator 
was easily fixed by doing an fallocate() for the size of the file before 
writing to it.

		-ben
-- 
"Thought is the essence of where you are now."
