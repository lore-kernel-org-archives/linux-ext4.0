From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/7] dax: Make huge page handling depend of CONFIG_BROKEN
Date: Thu, 12 May 2016 12:59:58 -0600
Message-ID: <20160512185958.GA32376@linux.intel.com>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nvdimm@lists.01.org, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463070560-1979-3-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 12, 2016 at 06:29:15PM +0200, Jan Kara wrote:
> Currently the handling of huge pages for DAX is racy. For example the
> following can happen:
> 
> CPU0 (THP write fault)			CPU1 (normal read fault)
> 
> __dax_pmd_fault()			__dax_fault()
>   get_block(inode, block, &bh, 0) -> not mapped
> 					get_block(inode, block, &bh, 0)
> 					  -> not mapped
>   if (!buffer_mapped(&bh) && write)
>     get_block(inode, block, &bh, 1) -> allocates blocks
>   truncate_pagecache_range(inode, lstart, lend);
> 					dax_load_hole();
> 
> This results in data corruption since process on CPU1 won't see changes
> into the file done by CPU0.
> 
> The race can happen even if two normal faults race however with THP the
> situation is even worse because the two faults don't operate on the same
> entries in the radix tree and we want to use these entries for
> serialization. So make THP support in DAX code depend on CONFIG_BROKEN
> for now.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
