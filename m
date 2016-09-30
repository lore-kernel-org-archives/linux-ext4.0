From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Remove plugging from ext4_file_write_iter()
Date: Fri, 30 Sep 2016 01:58:38 -0400
Message-ID: <20160930055838.vis6qroyxwpffv6c@thunk.org>
References: <1474986148-9683-1-git-send-email-jack@suse.cz>
 <1474986148-9683-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47650 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935602AbcI3F6n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Sep 2016 01:58:43 -0400
Content-Disposition: inline
In-Reply-To: <1474986148-9683-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 27, 2016 at 04:22:28PM +0200, Jan Kara wrote:
> do_blockdev_direct_IO() takes care of properly plugging direct IO so
> there's no need to plug again inside ext4_file_write_iter().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
