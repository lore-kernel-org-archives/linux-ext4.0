From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 14/18] dax: Define DAX lock bit for radix tree
 exceptional entry
Date: Fri, 29 Apr 2016 14:03:45 -0600
Message-ID: <20160429200345.GH5888@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-15-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461015341-20153-15-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 18, 2016 at 11:35:37PM +0200, Jan Kara wrote:
> We will use lowest available bit in the radix tree exceptional entry for
> locking of the entry. Define it. Also clean up definitions of DAX entry
> type bits in DAX exceptional entries to use defined constants instead of
> hardcoding numbers and cleanup checking of these bits to not rely on how
> other bits in the entry are set.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
