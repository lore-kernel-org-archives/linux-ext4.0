From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix ENOSPC handling in DAX page fault handler
Date: Sun, 7 Jan 2018 16:51:34 -0500
Message-ID: <20180107215134.GF17380@thunk.org>
References: <20180103100844.12787-1-jack@suse.cz>
 <20180103100844.12787-3-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34292 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754557AbeAGVvh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Jan 2018 16:51:37 -0500
Content-Disposition: inline
In-Reply-To: <20180103100844.12787-3-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 03, 2018 at 11:08:44AM +0100, Jan Kara wrote:
> When allocation of underlying block for a page fault fails, we fail the
> fault with SIGBUS. However we may well hit ENOSPC just due to lots of
> free blocks being held by the running / committing transaction. So
> propagate the error from ext4_iomap_begin() and implement do standard
> allocation retry loop in ext4_dax_huge_fault().
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
