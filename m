From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: convert swap_inode_data() over to use swap() on
 most of the fields
Date: Mon, 31 Jul 2017 00:56:22 -0400
Message-ID: <20170731045622.ez4tjhuvmjrpvizc@thunk.org>
References: <20170705163207.1263-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47492 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751800AbdGaFlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 31 Jul 2017 01:41:00 -0400
Content-Disposition: inline
In-Reply-To: <20170705163207.1263-1-jlayton@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 05, 2017 at 12:32:07PM -0400, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> For some odd reason, it forces a byte-by-byte copy of each field. A
> plain old swap() on most of these fields would be more efficient. We
> do need to retain the memswap of i_data however as that field is an array.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
