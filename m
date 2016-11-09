From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/11 v2] ext4: Convert ext4 DAX IO to iomap framework
Date: Thu, 10 Nov 2016 10:22:29 +1100
Message-ID: <20161109232229.GU28177@dastard>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <20161108231739.GQ28177@dastard>
 <20161109150235.GA11757@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161109150235.GA11757@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 09, 2016 at 07:02:35AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 09, 2016 at 10:17:39AM +1100, Dave Chinner wrote:
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git dax-4.10-iomap-pmd
> 
> Can you add Jan's patch to add IOMAP_FAULT from the series we're
> replying to to the branch quickly as well?  That way I can use it as
> the base for the next spin of the direct I/O series without creating
> conflicts.

Ok, I'll add that now, and push out later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
