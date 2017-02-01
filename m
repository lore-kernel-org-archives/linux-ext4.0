From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Trim allocation requests to group size
Date: Wed, 1 Feb 2017 14:07:02 -0500
Message-ID: <20170201190702.qnkhbhdbs6r6wdja@thunk.org>
References: <20170110093201.1403-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58548 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdBATHF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 1 Feb 2017 14:07:05 -0500
Content-Disposition: inline
In-Reply-To: <20170110093201.1403-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2017 at 10:32:01AM +0100, Jan Kara wrote:
> If filesystem groups are artifically small (using parameter -g to
> mkfs.ext4), ext4_mb_normalize_request() can result in a request that is
> larger than a block group. Trim the request size to not confuse
> allocation code.
> 
> Reported-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
