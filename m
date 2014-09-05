From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv4 3/3] jbd/jbd2: use non-movable memory for the jbd
 superblock
Date: Thu, 4 Sep 2014 22:37:45 -0400
Message-ID: <20140905023745.GC1971@thunk.org>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <1409815781-28011-4-git-send-email-gioh.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, js1304@gmail.com,
	gunho.lee@lge.com
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaIEChx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Sep 2014 22:37:53 -0400
Content-Disposition: inline
In-Reply-To: <1409815781-28011-4-git-send-email-gioh.kim@lge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 04:29:41PM +0900, Gioh Kim wrote:
> A long-lasting buffer-cache can distrub page migration so that
> it must be allocated from non-movable area.
> 
> The journal_init_inode is creating a buffer-cache for superblock journaling.
> The superblock exists until system shutdown so that the buffer-cache
> for the superblock would also exist for a long time
> and it can distrub page migration.
> 
> This patch make the buffer-cache be allocated from non-movable area
> not to distrub page migration.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, I've applied this to the ext4 git tree with a slightly
rewritten commit description (for clarity).

						- Ted
