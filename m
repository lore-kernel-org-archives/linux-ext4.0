From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix __ext4_xattr_set_credits()
Date: Tue, 4 Jul 2017 00:22:09 -0400
Message-ID: <20170704042209.7ahxiwakxzg4qcqf@thunk.org>
References: <20170628214750.31548-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44706 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbdGDEWP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Jul 2017 00:22:15 -0400
Content-Disposition: inline
In-Reply-To: <20170628214750.31548-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 28, 2017 at 02:47:50PM -0700, Tahsin Erdogan wrote:
> __ext4_xattr_set_credits() calculates journal credits needed for a
> set xattr operation. Currently, credits needed for quota updates are
> added only if ea_inode feature is enabled which is wrong. Fix this by
> moving quota related additions to above ea_inode feature check.
> 
> Fixes: 74c5bfa651af ("ext4: xattr inode deduplication")
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, I've folded this into the xattr_inode_deduplication patch.

	     	    	      	  - Ted
