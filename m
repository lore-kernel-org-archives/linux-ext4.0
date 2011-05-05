From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: fix error msg when mounting fs with too-large
 blocksize
Date: Thu, 5 May 2011 13:23:21 +0200
Message-ID: <20110505112321.GB5323@quack.suse.cz>
References: <1304563444-4842-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
	Jan Kara <jack@suse.cz>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1EELXY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 07:23:24 -0400
Content-Disposition: inline
In-Reply-To: <1304563444-4842-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-05-11 10:44:04, Robin Dong wrote:
> When ext2 mounts a filesystem, it attempts to set the block device
> blocksize with a call to sb_set_blocksize, which can fail for
> several reasons.  The current failure message in ext2 prints:
> 
>   EXT2-fs (loop1): error: blocksize is too small
> 
> which is not correct in all cases.  This can be demonstrated
> by creating a filesystem with
> 
>   # mkfs.ext2 -b 8192
> 
> on a 4k page system, and attempting to mount it.
> 
> Change the error message to a more generic:
> 
>   EXT2-fs (loop1): bad blocksize 8192
> 
> to match the error message in ext3.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Reviewed-by: Coly Li <bosong.ly@taobao.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
  Thanks. Merged into my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
