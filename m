From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 1/2] dax: Don't touch i_dio_count in dax_do_io()
Date: Thu, 5 May 2016 07:27:48 -0700
Message-ID: <20160505142748.GA10157@infradead.org>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <1461947276-25988-2-git-send-email-Waiman.Long@hpe.com>
 <20160505141637.GJ1970@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Waiman Long <Waiman.Long@hpe.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160505141637.GJ1970@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 05, 2016 at 04:16:37PM +0200, Jan Kara wrote:
> We cannot easily do this currently - the reason is that in several places we
> wait for i_dio_count to drop to 0 (look for inode_dio_wait()) while
> holding i_mutex to wait for all outstanding DIO / DAX IO. You'd break this
> logic with this patch.
> 
> If we indeed put all writes under i_mutex, this problem would go away but
> as Dave explains in his email, we consciously do as much IO as we can
> without i_mutex to allow reasonable scalability of multiple writers into
> the same file.

So the above should be fine for xfs, but you're telling me that ext4
is doing DAX I/O without any inode lock at all?  In that case it's
indeed not going to work.

> The downside of that is that overwrites and writes vs reads are not atomic
> wrt each other as POSIX requires. It has been that way for direct IO in XFS
> case for a long time, with DAX this non-conforming behavior is proliferating
> more. I agree that's not ideal but serializing all writes on a file is
> rather harsh for persistent memory as well...

For non-O_DIRECT I/O it's simply required..
