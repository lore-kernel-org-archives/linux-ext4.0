From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Date: Fri, 28 May 2010 03:45:00 -0400
Message-ID: <20100528074500.GA14151@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-2-git-send-email-david@fromorbit.com> <20100527143233.836b2c47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> > +#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> 
> Could/should be implemented in C.
> 
> > +/*
> > + * We don't actually have pdflush, but this one is exported though /proc...
> > + */
> > +int nr_pdflush_threads;
> 
> So this is always zero now?
> 
> We don't want to keep it forever.  Add a
> printk_once("nr_pdflush_threads is deprecated") when someone reads it,
> remove it in 2014.

These two lines are just moved down a bit by the patch, I think any
cleanups should be left to separate patches.
