From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jbd2: avoid the concurrent data writeback
Date: Mon, 15 Nov 2010 06:27:32 -0500
Message-ID: <20101115112732.GA15953@infradead.org>
References: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
 <20101115055420.GA21785@localhost>
 <20101115175943.490d3469@feng-i7>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Feng Tang <feng.tang@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101115175943.490d3469@feng-i7>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 15, 2010 at 05:59:43PM +0800, Feng Tang wrote:
> + *
> + * Sometimes when this get called, the host inode may be under data
> + * syncing initiated by flush thread(especially for a large file), and 
> + * in such situation, we should skip this path of writeback
>   */
>  static int journal_submit_inode_data_buffers(struct address_space *mapping)
>  {
> @@ -181,6 +185,13 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
>  		.range_end = i_size_read(mapping->host),
>  	};
>  
> +	spin_lock(&inode_lock);
> +	if (mapping->host->i_state & I_SYNC) {
> +		spin_unlock(&inode_lock);
> +		return 0;
> +	}
> +	spin_unlock(&inode_lock);
> +

inode_lock is not exported to modules, and that's for a pretty good
reason.  I think you want to change this code at a higher level to not
compete with the flusher threads at all.

