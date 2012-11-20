From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/4][RFC] remove duplicated check from ext4, xfs, btrfs,
 and ocfs2
Date: Tue, 20 Nov 2012 18:46:46 +0800
Message-ID: <20121120104646.GA3726@gmail.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
 <20121120101452.GA692@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, yan@linux.vnet.ibm.com,
	Zheng Liu <wenqing.lz@taobao.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:33166 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2KTKeE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 05:34:04 -0500
Content-Disposition: inline
In-Reply-To: <20121120101452.GA692@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 20, 2012 at 05:14:53AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 20, 2012 at 05:29:41PM +0800, Zheng Liu wrote:
> > Hi all,
> > 
> > This patch series tries to remove a sanity check in fallocate from specific
> > filesystems because vfs has already checked it.
> > 
> > I am not very familiar with why we need to do this duplicated check.  Please let
> > me know if I miss something.
> 
> Each filesystem driver checks to see if a flag that it doesn't support
> gets passed down.  This was done with the intention that we can add new
> flags to the VFS without having to update every filesystem.

Thanks for your explanation.

Regards,
                                                - Zheng
