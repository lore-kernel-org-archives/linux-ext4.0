From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Unmap metadata when zeroing blocks
Date: Fri, 30 Sep 2016 02:03:58 -0400
Message-ID: <20160930060358.onzfpefx7xb3fw7q@thunk.org>
References: <1474992918-20488-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47664 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934757AbcI3GEE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Sep 2016 02:04:04 -0400
Content-Disposition: inline
In-Reply-To: <1474992918-20488-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 27, 2016 at 06:15:18PM +0200, Jan Kara wrote:
> When zeroing blocks for DAX allocations, we also have to unmap aliases
> in the block device mappings. Otherwise writeback can overwrite zeros
> with stale data from block device page cache.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
