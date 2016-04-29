From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 09/18] dax: Remove zeroing from dax_io()
Date: Fri, 29 Apr 2016 12:56:08 -0600
Message-ID: <20160429185608.GD5888@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-10-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org,
	Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1461015341-20153-10-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 18, 2016 at 11:35:32PM +0200, Jan Kara wrote:
> All the filesystems are now zeroing blocks themselves for DAX IO to avoid
> races between dax_io() and dax_fault(). Remove the zeroing code from
> dax_io() and add warning to catch the case when somebody unexpectedly
> returns new or unwritten buffer.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
