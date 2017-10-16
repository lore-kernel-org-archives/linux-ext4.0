From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 14/19] dax: Implement dax_finish_sync_fault()
Date: Mon, 16 Oct 2017 17:43:57 +0200
Message-ID: <20171016154357.GK9762@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-15-jack@suse.cz>
 <20171013072101.GE9105@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171013072101.GE9105@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 13-10-17 00:21:01, Christoph Hellwig wrote:
> On Wed, Oct 11, 2017 at 10:05:58PM +0200, Jan Kara wrote:
> > Implement a function that filesystems can call to finish handling of
> > synchronous page faults. It takes care of syncing appropriare file range
> > and insertion of page table entry.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks fine except for a few nitpicks below:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks! Implemented all your comments.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
