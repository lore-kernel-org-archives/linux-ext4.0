From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/32] ext4: retry storing value in external inode with
 xattr block too
Date: Wed, 21 Jun 2017 22:22:05 -0400
Message-ID: <20170622022205.572ak255z65ledet@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-18-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58016 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751901AbdFVCWR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Jun 2017 22:22:17 -0400
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-18-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 21, 2017 at 02:21:28PM -0700, Tahsin Erdogan wrote:
> When value size is <= EXT4_XATTR_MIN_LARGE_EA_SIZE(), and it
> doesn't fit in either inline or xattr block, a second try is made to
> store it in an external inode while storing the entry itself in inline
> area. There should also be an attempt to store the entry in xattr block.
> 
> This patch adds a retry loop to do that. It also makes the caller the
> sole decider on whether to store a value in an external inode.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

						- Ted
