Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49800 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbeJCJIS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 05:08:18 -0400
Date: Tue, 2 Oct 2018 22:21:44 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: adilger.kernel@dilger.ca, darrick.wong@oracle.com, axboe@kernel.dk,
        nborisov@suse.com, ak@linux.intel.com, viro@zeniv.linux.org.uk,
        kemi.wang@intel.com, willy@infradead.org,
        gregkh@linuxfoundation.org, ebiggers@google.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/ext4: Convert fault handler to use vm_fault_t type
Message-ID: <20181003022144.GB18521@thunk.org>
References: <20180910154611.GA20252@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180910154611.GA20252@jordon-HP-15-Notebook-PC>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 10, 2018 at 09:16:12PM +0530, Souptick Joarder wrote:
> Return type of ext4_page_mkwrite and ext4_filemap_fault are
> changed to use vm_fault_t type.
> 
> With this patch all the callers of block_page_mkwrite_return()
> are changed to handle vm_fault_t. So converting the return type
> of block_page_mkwrite_return() to vm_fault_t.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Thanks, applied.

					- Ted
