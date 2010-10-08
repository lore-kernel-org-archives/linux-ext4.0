From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] writeback: skip useless data integrity tricks for
 sync_filesystem
Date: Fri, 8 Oct 2010 13:09:31 -0400
Message-ID: <20101008170931.GB23129@infradead.org>
References: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
 <1286550027-9684-2-git-send-email-dmonakhov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab0JHRJe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Oct 2010 13:09:34 -0400
Content-Disposition: inline
In-Reply-To: <1286550027-9684-2-git-send-email-dmonakhov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 08, 2010 at 07:00:27PM +0400, Dmitry Monakhov wrote:
> If we about to write many inodes at the time, even in for
> data integrity sync, it is reasonable to skip data integrity
> logic for each inode, but perform all necessary steps at the end.
> 
> The frozen sync() issue:
> If we try to call sync() then other process dirties inodes in
> parallels we end up with writing inodes in sync mode, which
> usually result in io_barriers spam. Which result in almost 100 times
> performance degradation.

Please don't add even more flags for that.  The only ->write_inode
call that actually needs this is the one from nfsd, and filesystems
can just implement the commit_metadata inode operation to force
out transactions there.  That's what we've been doing in XFS for
a while now.

