From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 05/18] ext2: Avoid DAX zeroing to corrupt data
Date: Fri, 29 Apr 2016 10:30:48 -0600
Message-ID: <20160429163048.GA5888@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461015341-20153-6-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 18, 2016 at 11:35:28PM +0200, Jan Kara wrote:
> Currently ext2 zeroes any data blocks allocated for DAX inode however it
> still returns them as BH_New. Thus DAX code zeroes them again in
> dax_insert_mapping() which can possibly overwrite the data that has been
> already stored to those blocks by a racing dax_io(). Avoid marking
> pre-zeroed buffers as new.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
