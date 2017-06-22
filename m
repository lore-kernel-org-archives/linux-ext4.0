From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/32] ext4: extended attribute value size limit is
 enforced by vfs
Date: Wed, 21 Jun 2017 21:42:39 -0400
Message-ID: <20170622014239.riyf5f4wlqoef6kd@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-9-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57618 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752589AbdFVBmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Jun 2017 21:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-9-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 21, 2017 at 02:21:19PM -0700, Tahsin Erdogan wrote:
> EXT4_XATTR_MAX_LARGE_EA_SIZE definition in ext4 is currently unused.
> Besides, vfs enforces its own 64k limit which makes the 1MB limit in
> ext4 redundant. Remove it.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

	      	     	  	- Ted
