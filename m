From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] dax: Don't touch i_dio_count in dax_do_io()
Date: Thu, 5 May 2016 16:16:37 +0200
Message-ID: <20160505141637.GJ1970@quack2.suse.cz>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <1461947276-25988-2-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461947276-25988-2-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 29-04-16 12:27:55, Waiman Long wrote:
> The purpose of the i_dio_count is to protect against truncation while
> the I/O operation is in progress. As dax_do_io() only does synchronous
> I/O, the locking performed by the caller or within dax_do_io() for
> read should be enough to protect it against truncation. There is no
> need to touch the i_dio_count.
> 
> Eliminating two atomic operations can sometimes give a noticeable
> improvement in I/O performance as NVDIMM is much faster than other
> disk devices.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Waiman Long <Waiman.Long@hpe.com>

We cannot easily do this currently - the reason is that in several places we
wait for i_dio_count to drop to 0 (look for inode_dio_wait()) while
holding i_mutex to wait for all outstanding DIO / DAX IO. You'd break this
logic with this patch.

If we indeed put all writes under i_mutex, this problem would go away but
as Dave explains in his email, we consciously do as much IO as we can
without i_mutex to allow reasonable scalability of multiple writers into
the same file.

The downside of that is that overwrites and writes vs reads are not atomic
wrt each other as POSIX requires. It has been that way for direct IO in XFS
case for a long time, with DAX this non-conforming behavior is proliferating
more. I agree that's not ideal but serializing all writes on a file is
rather harsh for persistent memory as well...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
