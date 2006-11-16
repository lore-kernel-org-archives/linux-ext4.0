From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext3: htree entry integrity checking
Date: Thu, 16 Nov 2006 15:27:47 -0700
Message-ID: <20061116222747.GT6012@schatzie.adilger.int>
References: <455C96DC.4060907@jeffreymahoney.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:61622 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1754857AbWKPW1t
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Nov 2006 17:27:49 -0500
To: Jeff Mahoney <jeffm@jeffreymahoney.com>
Content-Disposition: inline
In-Reply-To: <455C96DC.4060907@jeffreymahoney.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 16, 2006  11:50 -0500, Jeff Mahoney wrote:
>  Currently, if a corrupted directory entry with rec_len=0 is encountered,
>  we still trust that the data is valid. This can cause an infinite loop
>  in htree_dirblock_to_tree() since the iteration loop will never make any
>  progress.

Actually, I think Eric Sandeen was working on similar fixes already, and
instead of doing a per-item check each time we look at the entry it does
a full-block check the first time it is read (as ext2 does).

>  This fixes the problem described at:
>  http://projects.info-pull.com/mokb/MOKB-10-11-2006.html

Would also be good to CC linux-ext4, where the ext3 maintainers live.
Hmm, maybe we need to update MAINTAINERS with the new list address?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
