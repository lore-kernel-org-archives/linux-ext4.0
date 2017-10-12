From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/5] ext4: prevent data corruption with inline data +
 DAX
Date: Thu, 12 Oct 2017 11:52:27 -0400
Message-ID: <20171012155227.o3dql7teq6gkghfo@thunk.org>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-2-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        linux-nvdimm@lists.01.org, stable@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-2-ross.zwisler@linux.intel.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 11, 2017 at 11:05:22PM -0600, Ross Zwisler wrote:
> If an inode has inline data it is currently prevented from using DAX by a
> check in ext4_set_inode_flags().  When the inode grows inline data via
> ext4_create_inline_data() or removes its inline data via
> ext4_destroy_inline_data_nolock(), the value of S_DAX can change.
> 
> Currently these changes are unsafe because we don't hold off page faults
> and I/O, write back dirty radix tree entries and invalidate all mappings.
> There are also issues with mm-level races when changing the value of S_DAX,
> as well as issues with the VM_MIXEDMAP flag:
> 
> https://www.spinics.net/lists/linux-xfs/msg09859.html
> 
> The unsafe transition of S_DAX can reliably cause data corruption, as shown
> by the following fstest:
> 
> https://patchwork.kernel.org/patch/9948381/
> 
> Fix this issue by preventing the DAX mount option from being used on
> filesystems that were created to support inline data.  Inline data is an
> option given to mkfs.ext4.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> CC: stable@vger.kernel.org

Thanks, applied.

					- Ted
