From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2 readdir/lookup/check_page behavior
Date: Tue, 14 Nov 2006 12:21:02 -0700
Message-ID: <20061114192102.GR6012@schatzie.adilger.int>
References: <4559DFDF.30504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53911 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S966276AbWKNTVE
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Nov 2006 14:21:04 -0500
To: Eric Sandeen <sandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <4559DFDF.30504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 14, 2006  09:25 -0600, Eric Sandeen wrote:
> has an image with a corrupt directory inode - despite having only 4 blocks, 
> it has an extremely large i_size.
> 
> It seems odd to me that readdir bails out with an error on the first bad 
> page, while lookup keeps trying.  Shouldn't these be consistent?  And if 
> so, which is the desired behavior?

I'd prefer that readdir _should_ return all of the valid directory blocks
it can find.  Otherwise, it makes on average 1/2 of the files in that dir
inaccessible.

> Or, perhaps a check high up that says if i_size doesn't correlate to 
> i_blocks, this inode is corrupt, and bail out early.

We did that for ext3, no?  It would make sense to fix ext2 in the same way.
I'd suggest bailing out "early" == min(i_size >> blocksize, i_blocks).
The i_blocks count is an upper limit, because it includes the overhead of
indirect blocks.  Directories cannot be sparse.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
