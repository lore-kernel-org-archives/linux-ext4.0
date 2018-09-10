From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs/ext4: Convert fault handler to use vm_fault_t type
Date: Mon, 10 Sep 2018 14:21:13 -0700
Message-ID: <20180910212113.GB21965@bombadil.infradead.org>
References: <20180910154611.GA20252@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com,
        axboe@kernel.dk, nborisov@suse.com, ak@linux.intel.com,
        viro@zeniv.linux.org.uk, kemi.wang@intel.com,
        gregkh@linuxfoundation.org, ebiggers@google.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180910154611.GA20252@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 10, 2018 at 09:16:12PM +0530, Souptick Joarder wrote:
> Return type of ext4_page_mkwrite and ext4_filemap_fault are
> changed to use vm_fault_t type.
> 
> With this patch all the callers of block_page_mkwrite_return()
> are changed to handle vm_fault_t. So converting the return type
> of block_page_mkwrite_return() to vm_fault_t.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

This looks like the straight-forward conversion I was hoping to see.

Reviewed-by: Matthew Wilcox <willy@infradead.org>
