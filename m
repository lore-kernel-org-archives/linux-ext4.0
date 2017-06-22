From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/32] ext4: eliminate xattr entry e_hash recalculation
 for removes
Date: Thu, 22 Jun 2017 11:52:36 -0400
Message-ID: <20170622155236.ncjwgdhlhwd5mssg@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-7-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60672 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbdFVPwo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Jun 2017 11:52:44 -0400
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-7-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 21, 2017 at 06:49:37PM -0700, Tahsin Erdogan wrote:
> When an extended attribute block is modified, ext4_xattr_hash_entry()
> recalculates e_hash for the entry that is pointed by s->here. This is
> unnecessary if the modification is to remove an entry.
> 
> Currently, if the removed entry is the last one and there are other
> entries remaining, hash calculation targets the just erased entry which
> has been filled with zeroes and effectively does nothing. If the removed
> entry is not the last one and there are more entries, this time it will
> recalculate hash on the next entry which is totally unnecessary.
> 
> Fix these by moving the decision on when to recalculate hash to
> ext4_xattr_set_entry().
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
