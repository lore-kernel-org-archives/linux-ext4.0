From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] ext4: Cleanup ext4_sync_parent()
Date: Mon, 5 Sep 2016 23:22:32 -0400
Message-ID: <20160906032232.ofcyyy6albwhdh5s@thunk.org>
References: <1470821145-14586-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46674 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752818AbcIFDWl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:22:41 -0400
Content-Disposition: inline
In-Reply-To: <1470821145-14586-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:25:45AM +0200, Jan Kara wrote:
> A condition !hlist_empty(&inode->i_dentry) is always true for open file.
> Just remove it. Also ext4_sync_parent() could use some explanation why
> races with rmdir() are not an issue - add a comment explaining that.
> 
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
