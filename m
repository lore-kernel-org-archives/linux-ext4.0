From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ext4: Pass DIO_SKIP_DIO_COUNT to dax_do_io
Date: Thu, 9 Jun 2016 02:02:26 -0700
Message-ID: <20160609090226.GB16921@infradead.org>
References: <1464992897-34063-1-git-send-email-Waiman.Long@hpe.com>
 <1464992897-34063-4-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464992897-34063-4-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 03, 2016 at 06:28:17PM -0400, Waiman Long wrote:
> Since all the DAX I/Os are synchronous, there is no need to update
> the DIO count in dax_do_io() when the count has already been updated
> or the i_rwsem lock (read or write) has or will be taken.
> 
> This patch passes in the DIO_SKIP_DIO_COUNT flag to dax_do_io() to
> disable two unneeded atomic operations that can slow thing down in
> fast storages like NVDIMM.
> 
> With a 38-threads fio I/O test with 2 shared files (on DAX-mount ext4
> formatted NVDIMM) running on a 4-socket Haswell-EX server with 4.6-rc1
> kernel, the aggregated bandwidths before and after the patch were:

Please do the right thing and remove the code to call inode_dio_begin /
inode_dio_end entirely.  There is nothing ext4 specific about the dax
code being synchronous.  Together with my previous suggestion
that also allows dropping the flags argument.

Then as a next step remove the end_io argument and just call it in
the callers which is perfectly safe again as dax is synchronous.
