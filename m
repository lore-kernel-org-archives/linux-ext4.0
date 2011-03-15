From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Why do we initialize block bitmaps in ext4_new_inode()
Date: Mon, 14 Mar 2011 19:15:29 -0700
Message-ID: <79B42851-940F-4A2A-A860-363867AF1C50@dilger.ca>
References: <E1PzBop-0007a0-BN@tytso-glaptop>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mea1b5e42.tmodns.net ([66.94.27.234]:47158 "EHLO mail.tmail.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754028Ab1COFDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 01:03:03 -0400
In-Reply-To: <E1PzBop-0007a0-BN@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-14, at 10:44 AM, Theodore Ts'o wrote:
> Is there some subtle reason why ext4_new_inode() checked for
> uninitialized block bitmaps and initialized the block bitmaps in
> ext4_new_inode().  It's not immediately needed in that function, and I
> don't see any reason why initializing the inode table or inode
> allocation bitmap requires initializing the block bitmap.
> 
> Am I missing something?

The assumption when this was coded is that if the inode bitmap was in use, then the block bitmap must also be initialized in order to mark the inode bitmap block in use also.

If we think that the block allocator isn't in any danger of reallocating the inode bitmap block, or inode table blocks because the block bitmap is uninitialized, then it isn't strictly needed.  I think the added checks for blocks being allocated from system zones was added after the uninit_bg feature was written.

The correlation between block and inode bitmaps is also different due to flex_bg, which didn't exist when flex_bg was written.  If inodes are allocated from a group, it was formerly (w/o flex_bg) very likely that blocks will also be allocated from this group.  Any blocks that are allocated to inodes from that group will have that group as the goal block.  With flex_bg the correlation is less strong, but I'd be surprised if more inodes are allocated than blocks (i.e. initialized inode bitmap, but no need to initialize block bitmap), even in a flex_bg filesystem.

Cheers, Andreas





