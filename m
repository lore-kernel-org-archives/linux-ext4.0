From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 10/18] dax: Remove pointless writeback from dax_do_io()
Date: Fri, 29 Apr 2016 13:00:35 -0600
Message-ID: <20160429190035.GE5888@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461015341-20153-11-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 18, 2016 at 11:35:33PM +0200, Jan Kara wrote:
> dax_do_io() is calling filemap_write_and_wait() if DIO_LOCKING flags is
> set. Presumably this was copied over from direct IO code. However DAX
> inodes have no pagecache pages to write so the call is pointless. Remove
> it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
