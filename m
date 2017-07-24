From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] e2fsck: update quota inode accounting for ea_inode
 feature
Date: Sun, 23 Jul 2017 21:25:48 -0400
Message-ID: <20170724012548.up3slw27ghrg34jf@thunk.org>
References: <20170707121246.6159-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52480 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbdGXBZw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 21:25:52 -0400
Content-Disposition: inline
In-Reply-To: <20170707121246.6159-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 05:12:43AM -0700, Tahsin Erdogan wrote:
> Extended attribute inodes are charged to all referencing inodes.
> Update e2fsck so that it can correctly track inode quota charges.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
