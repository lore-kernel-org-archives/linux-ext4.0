From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] dax: Pass detailed error code from dax_iomap_fault()
Date: Sun, 7 Jan 2018 16:51:24 -0500
Message-ID: <20180107215124.GE17380@thunk.org>
References: <20180103100844.12787-1-jack@suse.cz>
 <20180103100844.12787-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180103100844.12787-2-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 03, 2018 at 11:08:43AM +0100, Jan Kara wrote:
> Ext4 needs to pass through error from its iomap handler to the page
> fault handler so that it can properly detect ENOSPC and force
> transaction commit and retry the fault (and block allocation). Add
> argument to dax_iomap_fault() for passing such error.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
