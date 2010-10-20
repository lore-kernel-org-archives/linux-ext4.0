From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] writeback: sync quota after inodes writeback
Date: Wed, 20 Oct 2010 14:25:52 +0200
Message-ID: <20101020122552.GB3335@quack.suse.cz>
References: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
 <20101008170806.GA23129@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@gmail.com>, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab0JTM0w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Oct 2010 08:26:52 -0400
Content-Disposition: inline
In-Reply-To: <20101008170806.GA23129@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-10-10 13:08:06, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 07:00:26PM +0400, Dmitry Monakhov wrote:
> > inode writeback usually result in quota changes especially
> > on filesystems with delalloc. So quota_sync() before writeback
> > seems pointless. Let's do the job in a natural way.
> 
> Yes, that's one reason why we can't use the quota sync callback for XFS,
> as we need to do it after the actual sync.  Then again I'm not even
> sure we need to bother with a callout from the writeback code.
> Following the model of all other quota code filesystems using quota
> should probably just call it from their ->sync_fs method.  Note that
> this allows allows other optimizations for using the generic quota
> code.  dquot_quota_sync currently calls ->sync_fs by itself which
> could be optimized away by that design.
  Yes, that would make sense but then we have to change quotactl(Q_SYNC,
...) to result in calling ->sync_fs() as it does now. Because we have
to get quota data to disk in response to this call.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
