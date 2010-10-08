From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] writeback: sync quota after inodes writeback
Date: Fri, 8 Oct 2010 13:08:06 -0400
Message-ID: <20101008170806.GA23129@infradead.org>
References: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab0JHRIK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Oct 2010 13:08:10 -0400
Content-Disposition: inline
In-Reply-To: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 08, 2010 at 07:00:26PM +0400, Dmitry Monakhov wrote:
> inode writeback usually result in quota changes especially
> on filesystems with delalloc. So quota_sync() before writeback
> seems pointless. Let's do the job in a natural way.

Yes, that's one reason why we can't use the quota sync callback for XFS,
as we need to do it after the actual sync.  Then again I'm not even
sure we need to bother with a callout from the writeback code.
Following the model of all other quota code filesystems using quota
should probably just call it from their ->sync_fs method.  Note that
this allows allows other optimizations for using the generic quota
code.  dquot_quota_sync currently calls ->sync_fs by itself which
could be optimized away by that design.

