From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Allow unlocked direct IO when pages are cached
Date: Fri, 30 Sep 2016 01:56:29 -0400
Message-ID: <20160930055629.uu2gt3ykigb24yho@thunk.org>
References: <1474986148-9683-1-git-send-email-jack@suse.cz>
 <1474986148-9683-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47634 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935602AbcI3F4m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Sep 2016 01:56:42 -0400
Content-Disposition: inline
In-Reply-To: <1474986148-9683-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 27, 2016 at 04:22:27PM +0200, Jan Kara wrote:
> Currently we do not allow unlocked (meaning without inode_lock) direct
> IO when the file has any pages cached. This check is not needed anymore
> as we keep inode lock until ext4_direct_IO_write() and thus can happily
> writeback and evict any pages conflicting with current direct IO write.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
