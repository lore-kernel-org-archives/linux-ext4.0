From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] libext2fs: eliminate empty element holes in
 ext2_xattr_handle->attrs
Date: Sun, 23 Jul 2017 22:53:51 -0400
Message-ID: <20170724025351.seejfxujn2wzplzo@thunk.org>
References: <20170707121246.6159-1-tahsin@google.com>
 <20170707121246.6159-3-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52636 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdGXCxx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 22:53:53 -0400
Content-Disposition: inline
In-Reply-To: <20170707121246.6159-3-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 05:12:45AM -0700, Tahsin Erdogan wrote:
> When an extended attribute is removed, its array element is emptied.
> This creates holes in the array so various places that want to walk
> filled elements have to do an empty element check.
> 
> Have remove operation shift remaining filled elements to the left.
> This allows a simple iteration up to ext2_xattr_handle->count to walk
> all filled entries, and so empty element checks become unnecessary.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

						- Ted
