From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] libext2fs: rename ext2_xattr_handle->length to
 capacity
Date: Sun, 23 Jul 2017 22:46:35 -0400
Message-ID: <20170724024635.punakan2bxkvpvcb@thunk.org>
References: <20170707121246.6159-1-tahsin@google.com>
 <20170707121246.6159-2-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52610 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdGXCqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 22:46:38 -0400
Content-Disposition: inline
In-Reply-To: <20170707121246.6159-2-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 05:12:44AM -0700, Tahsin Erdogan wrote:
> ext2_xattr_handle has two fields 'count' and 'length' which
> represent number of filled elements vs total element count.
> They have close meanings so are easy to confuse, thus make code less
> readable. Rename length to capacity.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Applied, thanks.

						- Ted
