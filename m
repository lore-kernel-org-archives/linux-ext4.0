From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Date: Wed, 14 Jan 2009 18:40:23 +0100
Message-ID: <20090114174023.GK19950@duck.suse.cz>
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <496E2276.8050309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, pavel@suse.cz
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46749 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756759AbZANRkY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 12:40:24 -0500
Content-Disposition: inline
In-Reply-To: <496E2276.8050309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-01-09 11:35:50, Eric Sandeen wrote:
> Jan Kara wrote:
> > To be really safe that the data hit the platter, we should also flush drive's
> > writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
> 
> Seems sane, but aren't we getting really divergent behavior here between
> ext2, ext3, and ext4 w.r.t. drive cache flushing for sync paths?
  Well, but ext3/4 should do a barrier on a transaction commit (if the user
really cares about data integrity) and hence it implicitely does the same.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
