From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: Remarks regarding sparse_super2 feature
Date: Wed, 11 May 2016 20:50:32 +0200
Message-ID: <57337EF8.5090008@partition-saving.com>
References: <5724CE0E.6030407@partition-saving.com> <20160510232845.GC30312@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:61492 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcEKStV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 14:49:21 -0400
Received: from [192.168.103.118] (unknown [82.230.26.21])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 4C95219F3E9
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2016 18:56:38 +0200 (CEST)
In-Reply-To: <20160510232845.GC30312@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> On Sat, Apr 30, 2016 at 05:23:58PM +0200, Damien Guibouret wrote:
> 
[...]
> 
> 
>>For the other case (shrinking the fs) at line 856:
>>			if (last_bg > 1 &&
>>			    old_fs->super->s_backup_bgs[1] == old_last_bg)
>>				fs->super->s_backup_bgs[1] = last_bg;
>>what ensures the location where the new super block backup will be set is a
>>free block?
> 
> 
> This is handled by reserve_sparse2_last_group().  We have to deal this
> sort of thing whenever we need to do things like grow the group
> descriptors, and we will relocate data blocks as necessary to make
> room for blocks that have to be at specific locations.  (This means we
> have allocate new blocks for the blocks we are moving, copy the data
> blocks, and then update the inode(s) to point the new block
> locations.)
> 
> Cheers,
> 
> 						- Ted

Hello,

Thanks for the feedback.
For the last point, you're right, I did not look deep enough in the remaining 
part of the code (and it looks obvious that when shrinking the fs, there is some 
need to reallocate blocks).

Regards,

Damien
