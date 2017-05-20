From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Clear lockdep subtype for quota files on quota
 off
Date: Fri, 19 May 2017 22:39:46 -0400
Message-ID: <20170520023946.coy7u5bfsbae35dh@thunk.org>
References: <20170509122247.26345-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44948 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755213AbdETCkq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 May 2017 22:40:46 -0400
Content-Disposition: inline
In-Reply-To: <20170509122247.26345-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 09, 2017 at 02:22:47PM +0200, Jan Kara wrote:
> Quota files have special ranking of i_data_sem lock. We inform lockdep
> about it when turning on quotas however when turning quotas off, we
> don't clear the lockdep subclass from i_data_sem lock and thus when the
> inode gets later reused for a normal file or directory, lockdep gets
> confused and complains about possible deadlocks. Fix the problem by
> resetting lockdep subclass of i_data_sem on quota off.
> 
> Fixes: daf647d2dd58cec59570d7698a45b98e580f2076
> Reported-and-tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
